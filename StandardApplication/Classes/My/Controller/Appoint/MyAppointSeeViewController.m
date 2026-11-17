//
//  MyAppointSeeViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyAppointSeeViewController.h"
#import "MacroDefine.h"
#import "MyAppointSeeTableViewCell.h"
#import "SubscribeListModel.h"
#import "AppointListModel.h"

@interface MyAppointSeeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myAppointSeeTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;

@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *appointSeeArr;
@property (strong, nonatomic) NSArray *reserverListArr;
@end

@implementation MyAppointSeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.hideNaviBar = YES;
}

// 约看
- (void)getAppointSeeDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:operate_logURL parameters:@{@"page":@(_pageIndex),@"page_rows":@"10"} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            if (_pageIndex == 1 && self.appointSeeArr.count > 0) {
                [self.appointSeeArr removeAllObjects];
            }
            NSArray *listArray = dic[@"list"];
            for (NSDictionary *listDic in listArray) {
                SubscribeListModel *model = [SubscribeListModel mj_objectWithKeyValues:listDic];
                model.classInt = [[listDic valueForKey:@"class"] intValue];
                [self.appointSeeArr addObject:model];
            }
            if (listArray.count < 10) {
                [self.myAppointSeeTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.myAppointSeeTableView.mj_footer endRefreshing];
            }
            if (self.appointSeeArr.count == 0) {
                [self.myAppointSeeTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.myAppointSeeTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    if (_type == 0) {
        _pageIndex = 1;
        [self getAppointSeeDate];
    } else if (_type == 1) {
        [self getReserverListDate];
    }
    [_myAppointSeeTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getAppointSeeDate];
}

// 预定
- (void)getReserverListDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:BaseURL urlPath:reserve_listURL parameters:@{@"payed":@"1"} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            self.reserverListArr = [AppointListModel mj_objectArrayWithKeyValuesArray:arr];
            if (self.reserverListArr.count == 0) {
                [self.myAppointSeeTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.myAppointSeeTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _type == 0 ? _appointSeeArr.count : _reserverListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyAppointSeeTableViewCell";
    MyAppointSeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (MyAppointSeeTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.type = _type;
    if (_type == 0) {
        cell.subscribeListModel = _appointSeeArr[indexPath.row];
    } else if (_type == 1) {
        cell.appointListModel = _reserverListArr[indexPath.row];
    }
    return cell;
}

- (NSMutableArray *)appointSeeArr
{
    if (!_appointSeeArr) {
        _appointSeeArr = [NSMutableArray array];
    }
    return _appointSeeArr;
}

- (NSArray *)reserverListArr
{
    if (!_reserverListArr) {
        _reserverListArr = [NSArray array];
    }
    return _reserverListArr;
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear
{
    if (_type == 0) {
        _pageIndex = 1;
        [self getAppointSeeDate];
        [self setupRefreshWithTableView:_myAppointSeeTableView];
    } else if (_type == 1) {
        [self getReserverListDate];
        [self setupHeaderRefresh:_myAppointSeeTableView];
    }
}

@end
