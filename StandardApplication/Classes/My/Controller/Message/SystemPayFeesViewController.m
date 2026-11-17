//
//  SystemPayFeesViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SystemPayFeesViewController.h"
#import "MacroDefine.h"
#import "SystemPayFeesTableViewCell.h"
#import "MessageIndexModel.h"

@interface SystemPayFeesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *messageArr;
@property (assign, nonatomic) NSInteger pageIndex;
@end

// 系统消息&缴费消息
@implementation SystemPayFeesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = (_type == 1) ? @"系统消息" : (_type == 3) ? @"缴费消息" : @"推送消息";
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    [self setupRefreshWithTableView:_tableView];
    _pageIndex = 1;

    [self getAppMessageIndexDate];
}

- (void)getAppMessageIndexDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:appMessage_indexURL parameters:@{@"page":@(_pageIndex),@"page_rows":@"10",@"message_type":@(_type)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            if (_pageIndex == 1 && self.messageArr.count > 0) {
                [self.messageArr removeAllObjects];
            }
            MessageIndexModel *messageIndexModel = [MessageIndexModel mj_objectWithKeyValues:dic[@"list"]];
            NSArray *modelArr = [NSArray array];
            if (_type == 1) {
                modelArr = messageIndexModel.system_message;
            } else if (_type == 3) {
                modelArr = messageIndexModel.pay_message;
            } else if (_type == 5) {
                modelArr = messageIndexModel.internal_message;
            }
            [self.messageArr addObjectsFromArray:modelArr];
            if (modelArr.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.messageArr.count == 0) {
                [self.tableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getAppMessageIndexDate];
    [_tableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getAppMessageIndexDate];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _type == 5 ? 150 : 202;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SystemPayFeesTableViewCell";
    SystemPayFeesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (SystemPayFeesTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.messageModel = _messageArr[indexPath.row];
    cell.seeDetailBtn.hidden = _type == 5 ? YES : NO;
    return cell;
}

- (NSMutableArray *)messageArr
{
    if (!_messageArr) {
        _messageArr = [NSMutableArray array];
    }
    return _messageArr;
}
@end
