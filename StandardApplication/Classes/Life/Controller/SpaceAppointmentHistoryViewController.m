//
//  SpaceAppointmentHistoryViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SpaceAppointmentHistoryViewController.h"
#import "MacroDefine.h"
#import "SpaceAppointmentListTableViewCell.h"
#import "SpaceAppointmentDetailViewController.h"
#import "MyActivityListModel.h"

@interface SpaceAppointmentHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;

@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *spaceListArr;
@end

@implementation SpaceAppointmentHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = [_type isEqualToString:@"life"] ? @"我的预约" : @"活动预约";
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT + 5;
    
    if ([_type isEqualToString:@"life"]) {
        _pageIndex = 1;
        [self setupRefreshWithTableView:_historyTableView];
        [self getSpaceIndexDateInfo];
    } else if ([_type isEqualToString:@"my"]) {
        [self setupHeaderRefresh:_historyTableView];
        [self getMyActivityDate];
    }
}

- (void)getSpaceIndexDateInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:BaseURL urlPath:space_my_appointmentURL parameters:@{@"u_id":NONullString([User shareUser].getUserId)} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            if (_pageIndex == 1 && self.spaceListArr.count > 0) {
                [self.spaceListArr removeAllObjects];
            }
            [self.spaceListArr addObjectsFromArray:[SpaceIndexModel mj_objectArrayWithKeyValuesArray:arr]];
            if (arr.count < 10) {
                [self.historyTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.historyTableView.mj_footer endRefreshing];
            }
            if (self.spaceListArr.count == 0) {
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

- (void)getMyActivityDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:BaseURL urlPath:activity_my_applyURL parameters:@{} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            self.spaceListArr = [MyActivityListModel mj_objectArrayWithKeyValuesArray:arr];
            if (self.spaceListArr.count == 0) {
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
    if ([_type isEqualToString:@"life"]) {
        _pageIndex = 1;
        [self getSpaceIndexDateInfo];
    } else if ([_type isEqualToString:@"my"]) {
        [self getMyActivityDate];
    }
    [_historyTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getSpaceIndexDateInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _spaceListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SpaceAppointmentListTableViewCell";
    SpaceAppointmentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (SpaceAppointmentListTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.isMyAppointment = YES;
    cell.type = _type;
    if ([_type isEqualToString:@"life"]) {
        cell.spaceModel = _spaceListArr[indexPath.row];
    } else if ([_type isEqualToString:@"my"]) {
        cell.myActivityListModel = _spaceListArr[indexPath.row];
    }
    return cell;
}

- (NSMutableArray *)spaceListArr
{
    if (!_spaceListArr) {
        _spaceListArr = [NSMutableArray array];
    }
    return _spaceListArr;
}
@end
