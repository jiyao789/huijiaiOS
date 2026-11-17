//
//  MessageViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MessageViewController.h"
#import "MacroDefine.h"
#import "MessageTableViewCell.h"
#import "SystemPayFeesViewController.h"
#import "ContractMessageViewController.h"
#import "WorkOrderMessageViewController.h"
#import "MessageIndexModel.h"
#import "WorkOrderIndexModel.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@property (strong, nonatomic) NSArray *messageImageArr;
@property (strong, nonatomic) NSArray *messageTitleArr;

@property (strong, nonatomic) MessageIndexModel *messageIndexModel;
@property (strong, nonatomic) NSArray *contractArr;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"消息";
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    
    _messageImageArr = @[@"sys_message_img",@"work_order_img",@"payFees_message_img",@"contract_message_img",@"push_message_img"];
    _messageTitleArr = @[@"系统消息",@"工单助手",@"缴费消息",@"合同消息",@"推送消息"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getAppMessageIndexDate];
}

- (void)getAppMessageIndexDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:appMessage_indexURL parameters:@{@"page":@(1),@"page_rows":@"1"} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.messageIndexModel = [MessageIndexModel mj_objectWithKeyValues:dic[@"list"]];
            [self.messageTableView reloadData];
            
            [self createNotificationCenterInfo:self.messageIndexModel.mark];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messageImageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MessageTableViewCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (MessageTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.messageImageView.image = [UIImage imageNamed:_messageImageArr[indexPath.row]];
    cell.messageTitleLab.text = _messageTitleArr[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            if (_messageIndexModel.system_message.count > 0) {
                MessageModel *model = _messageIndexModel.system_message[0];
                cell.messageSummyLab.text = NONullString(model.title);
                cell.messageTimeLab.text = NONullString(model.created_time);
            }
            cell.messageNoreadLab.hidden = !_messageIndexModel.isSystem;
            break;
        }
        case 1:
        {
            cell.workOrderIndexModel = _messageIndexModel.work_order;
            cell.messageNoreadLab.hidden = !_messageIndexModel.isWorkOrder;
            break;
        }
        case 2:
        {
            if (_messageIndexModel.pay_message.count > 0) {
                MessageModel *model = _messageIndexModel.pay_message[0];
                cell.messageSummyLab.text = NONullString(model.title);
                cell.messageTimeLab.text = NONullString(model.content[@"pay_time"]);
            }
            cell.messageNoreadLab.hidden = !_messageIndexModel.isPay;
            break;
        }
        case 3:
        {
            if (_messageIndexModel.contract_message.count > 0) {
                MessageModel *model = _messageIndexModel.contract_message[0];
                cell.messageSummyLab.text = NONullString(model.title);
                cell.messageTimeLab.text = NONullString(model.created_time);
            }
            cell.messageNoreadLab.hidden = !_messageIndexModel.isContract;
            break;
        }
        case 4:
        {
            if (_messageIndexModel.internal_message.count > 0) {
                MessageModel *model = _messageIndexModel.internal_message[0];
                cell.messageSummyLab.text = NONullString(model.content[@"push_content"]);
                cell.messageTimeLab.text = NONullString(model.content[@"push_time"]);
            }
            cell.messageNoreadLab.hidden = !_messageIndexModel.isPush;
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            SystemPayFeesViewController *vc = [SystemPayFeesViewController new];
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            WorkOrderMessageViewController *vc = [WorkOrderMessageViewController new];
            vc.type = @"message";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            SystemPayFeesViewController *vc = [SystemPayFeesViewController new];
            vc.type = 3;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            [self.navigationController pushViewController:[ContractMessageViewController new] animated:YES];
            break;
        }
        case 4:
        {
            SystemPayFeesViewController *vc = [SystemPayFeesViewController new];
            vc.type = 5;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)createNotificationCenterInfo:(NSInteger)mark
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageMarkNotification" object:nil userInfo:@{@"mark":@(mark)}];
}

- (MessageIndexModel *)messageIndexModel
{
    if (!_messageIndexModel) {
        _messageIndexModel = [MessageIndexModel new];
    }
    return _messageIndexModel;
}

- (NSArray *)contractArr
{
    if (!_contractArr) {
        _contractArr = [NSArray array];
    }
    return _contractArr;
}

@end
