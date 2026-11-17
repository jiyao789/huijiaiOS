//
//  ContractMessageViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ContractMessageViewController.h"
#import "MacroDefine.h"
#import "ContractMessageTableViewCell.h"

@interface ContractMessageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *contractTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;

@property (strong, nonatomic) NSMutableArray *contractArr;
@property (assign, nonatomic) NSInteger pageIndex;
@end

@implementation ContractMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"合同消息";
    _tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    _pageIndex = 1;
    
    [self getAppMessageIndexDate];
}

- (void)getAppMessageIndexDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:appMessage_indexURL parameters:@{@"page":@(_pageIndex),@"page_rows":@"10",@"message_type":@(4)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            if (_pageIndex == 1 && self.contractArr.count > 0) {
                [self.contractArr removeAllObjects];
            }
            MessageIndexModel *messageIndexModel = [MessageIndexModel mj_objectWithKeyValues:dic[@"list"]];
            [self.contractArr addObjectsFromArray:messageIndexModel.contract_message];
            if (messageIndexModel.contract_message.count < 10) {
                [self.contractTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.contractTableView.mj_footer endRefreshing];
            }
            if (self.contractArr.count == 0) {
                [self.contractTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.contractTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getAppMessageIndexDate];
    [_contractTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getAppMessageIndexDate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contractArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 202;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ContractMessageTableViewCell";
    ContractMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (ContractMessageTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.messageModel = _contractArr[indexPath.row];
    return cell;
}

- (NSMutableArray *)contractArr
{
    if (!_contractArr) {
        _contractArr = [NSMutableArray array];
    }
    return _contractArr;
}
@end
