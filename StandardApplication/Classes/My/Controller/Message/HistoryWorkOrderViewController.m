//
//  HistoryWorkOrderViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HistoryWorkOrderViewController.h"
#import "MacroDefine.h"
#import "WorkOrderMessageTableViewCell.h"

@interface HistoryWorkOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;

@property (strong, nonatomic) NSMutableArray *workOrderListArr;
@property (assign, nonatomic) NSInteger pageIndex;
@end

@implementation HistoryWorkOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"历史工单";
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    
    [self setupRefreshWithTableView:_historyTableView];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _pageIndex = 1;
    [self getWordOrderIndexDate];
}

- (void)getWordOrderIndexDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:workOrder_indexURL parameters:@{@"page":@(_pageIndex),@"page_rows":@"10",@"type":@"1"} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            if (_pageIndex == 1 && self.workOrderListArr.count > 0) {
                [self.workOrderListArr removeAllObjects];
            }
            NSArray *listArr = dic[@"list"];
            [self.workOrderListArr addObjectsFromArray:[WorkOrderIndexModel mj_objectArrayWithKeyValuesArray:listArr]];
            if (listArr.count < 10) {
                [self.historyTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.historyTableView.mj_footer endRefreshing];
            }
            if (self.workOrderListArr.count == 0) {
                [self.historyTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.historyTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getWordOrderIndexDate];
    [_historyTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getWordOrderIndexDate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _workOrderListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"WorkOrderMessageTableViewCell";
    WorkOrderMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (WorkOrderMessageTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.workOrderIndexModel = _workOrderListArr[indexPath.row];
    return cell;
}

- (NSMutableArray *)workOrderListArr
{
    if (!_workOrderListArr) {
        _workOrderListArr = [NSMutableArray array];
    }
    return _workOrderListArr;
}
@end
