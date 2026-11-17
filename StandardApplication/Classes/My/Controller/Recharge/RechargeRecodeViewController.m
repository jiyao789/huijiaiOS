//
//  RechargeRecodeViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "RechargeRecodeViewController.h"
#import "MacroDefine.h"
#import "RechargeRecodeTableViewCell.h"
#import "RechargeRecodeTitleTableViewCell.h"
#import "RechargeRecodeModel.h"

@interface RechargeRecodeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *recodeScrollView;
@property (weak, nonatomic) IBOutlet UITableView *recodeTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewlayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *titleTableView;
@property (weak, nonatomic) IBOutlet BaseShadowView *bgView;

@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *recodeArr;
@end

@implementation RechargeRecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"充值记录";
    _pageIndex = 1;
    self.viewlayoutTop.constant = NAVBAR_HEIGHT + 20;
    [self setupRefreshWithTableView:_recodeScrollView];
    [self getRechargeRecodeInfoDate];
}

- (void)getRechargeRecodeInfoDate
{
    NSArray *device_idArr = @[_device_id];
    NSString *urlStr = _meter_type == 0 ? event_record_ele_meter_recharge_recordURL : event_record_water_meter_recharge_recordURL;
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:HardwareBaseURL urlPath:urlStr parameters:@{@"device_ids":[device_idArr mj_JSONString],@"page":@(_pageIndex),@"limit":@"10",@"app_key":NONullString([User shareUser].getApp_key),@"provider":NONullString(_provider)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            if (_pageIndex == 1 && self.recodeArr.count > 0) {
                [self.recodeArr removeAllObjects];
            }
            NSArray *listArr = dic[@"records"];
            [self.recodeArr addObjectsFromArray:[RechargeRecodeModel mj_objectArrayWithKeyValuesArray:listArr]];
            if (listArr.count < 10) {
                [self.recodeScrollView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.recodeScrollView.mj_footer endRefreshing];
            }
            if (self.recodeArr.count == 0) {
                [self.bgView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.titleTableView reloadData];
            [self.recodeTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getRechargeRecodeInfoDate];
    [_recodeScrollView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getRechargeRecodeInfoDate];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recodeArr.count > 0 ? (_recodeArr.count + 5) : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        static NSString *cellID = @"RechargeRecodeTitleTableViewCell";
        RechargeRecodeTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (RechargeRecodeTitleTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.index = indexPath.row;
        cell.rechargeRecodeModel = (indexPath.row == 0 || indexPath.row > _recodeArr.count) ? nil : _recodeArr[indexPath.row - 1];
        return cell;
    }
    static NSString *cellID = @"RechargeRecodeTableViewCell";
    RechargeRecodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (RechargeRecodeTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.index = indexPath.row;
    cell.allIndex = _recodeArr.count + 5;
    cell.meter_type = _meter_type;
    cell.rechargeRecodeModel = (indexPath.row == 0 || indexPath.row > _recodeArr.count) ? nil : _recodeArr[indexPath.row - 1];
    return cell;
}

- (NSMutableArray *)recodeArr
{
    if (!_recodeArr) {
        _recodeArr = [NSMutableArray array];
    }
    return _recodeArr;
}

@end
