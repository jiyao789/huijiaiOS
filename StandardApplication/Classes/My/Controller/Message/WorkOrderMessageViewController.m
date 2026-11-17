//
//  WorkOrderMessageViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "WorkOrderMessageViewController.h"
#import "MacroDefine.h"
#import "WorkOrderMessageTableViewCell.h"
#import "HistoryWorkOrderViewController.h"
#import "WorkOrderDetailViewController.h"
#import "WorkOrderIndexModel.h"

@interface WorkOrderMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *workOrderTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutHeight;

@property (strong, nonatomic) NSMutableArray *workOrderListArr;
@property (assign, nonatomic) NSInteger pageIndex;
@end

@implementation WorkOrderMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"工单助手";
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    _pageIndex = 1;
    [self setupRefreshWithTableView:_workOrderTableView];
    [self setupOtherBarButtomItemWithTitle:@"历史工单" target:self action:@selector(historyOrderEvent) leftOrRight:NO];
    
    if ([_type isEqualToString:@"message"]) {
        _bottomViewLayoutHeight.constant = 0;
    } else if ([_type isEqualToString:@"my"]) {
        _bottomViewLayoutHeight.constant = 83;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getWordOrderIndexDate];
}

- (void)getWordOrderIndexDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:workOrder_indexURL parameters:@{@"page":@(_pageIndex),@"page_rows":@"10",@"type":@"0"} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            if (_pageIndex == 1 && self.workOrderListArr.count > 0) {
                [self.workOrderListArr removeAllObjects];
            }
            NSArray *listArr = dic[@"list"];
            [self.workOrderListArr addObjectsFromArray:[WorkOrderIndexModel mj_objectArrayWithKeyValuesArray:listArr]];
            if (listArr.count < 10) {
                [self.workOrderTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.workOrderTableView.mj_footer endRefreshing];
            }
            if (self.workOrderListArr.count == 0) {
                [self.workOrderTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.workOrderTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getWordOrderIndexDate];
    [_workOrderTableView.mj_header endRefreshing];
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

- (void)historyOrderEvent
{
    [self.navigationController pushViewController:[HistoryWorkOrderViewController new] animated:YES];
}

- (IBAction)commitWorkOrderBtnClick:(id)sender
{
    WorkOrderDetailViewController *vc = [WorkOrderDetailViewController new];
    vc.isCommitWork = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)workOrderListArr
{
    if (!_workOrderListArr) {
        _workOrderListArr = [NSMutableArray array];
    }
    return _workOrderListArr;
}
@end
