//
//  BillHistoryViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BillHistoryViewController.h"
#import "MacroDefine.h"
#import "BillHistoryTableViewCell.h"
#import "BillListModel.h"

@interface BillHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayooutTop;
@property (weak, nonatomic) IBOutlet UITableView *billTableView;

@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *billListArr;
@end

@implementation BillHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"账单历史";
    _pageIndex = 1;
    [self setupRefreshWithTableView:_billTableView];
    self.tableViewLayooutTop.constant = NAVBAR_HEIGHT;

    [self getBillAllDate];
}

- (void)getBillAllDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:BaseURL urlPath:bill_allURL parameters:@{@"page":@(_pageIndex),@"page_rows":@"10",@"payed":@(1)} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            if (_pageIndex == 1 && self.billListArr.count > 0) {
                [self.billListArr removeAllObjects];
            }
            [self.billListArr addObjectsFromArray:[BillListModel mj_objectArrayWithKeyValuesArray:arr]];
            if (arr.count < 10) {
                [self.billTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.billTableView.mj_footer endRefreshing];
            }
            if (self.billListArr.count == 0) {
                [self.billTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.billTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getBillAllDate];
    [_billTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getBillAllDate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _billListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BillHistoryTableViewCell";
        BillHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (BillHistoryTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.billListModel = _billListArr[indexPath.row];
    return cell;
}

- (NSMutableArray *)billListArr
{
    if (!_billListArr) {
        _billListArr = [NSMutableArray array];
    }
    return _billListArr;
}

@end
