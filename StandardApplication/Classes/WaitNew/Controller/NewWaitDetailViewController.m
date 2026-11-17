//
//  NewWaitDetailViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2023/12/9.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "NewWaitDetailViewController.h"
#import "MacroDefine.h"
#import "HouseBannerTableViewCell.h"
#import "WaitProductTableViewCell.h"
#import "WaitInfoTableViewCell.h"
#import "WaitHouseDetailViewController.h"
#import "NewWaitProjctListModel.h"
#import "WaitUnitQueueModel.h"

@interface NewWaitDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *waitDetailTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;

@property (strong, nonatomic) NewWaitProjctListModel *waitProjctListModel;
@property (strong, nonatomic) NSMutableArray* unitListArr;
@end

@implementation NewWaitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self leftBarItem];
    self.navTitle = @"项目详情";
    
    _tableViewLayoutTop.constant = NAVBAR_HEIGHT + 10;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F9FE"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getWaitProjectDetailInfo];
    
    [self getWaitQueueIndexInfo];
}

- (void)getWaitProjectDetailInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:cityWaiting_project_detailURL parameters:@{@"id":@(_id)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.waitProjctListModel = [NewWaitProjctListModel mj_objectWithKeyValues:dic];
            self.waitProjctListModel.desc = IsNilOrNull([dic valueForKey:@"description"]) ? @" " : NONullString([dic valueForKey:@"description"]);
            
            [self.waitDetailTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)getWaitQueueIndexInfo
{
    [HttpRequest requestArrUrlPath:BaseURL urlPath:cityWaiting_queue_indexURL parameters:@{@"project_id":@(_id)} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1 || status == 2) {
            if (self.unitListArr.count > 0) {
                [self.unitListArr removeAllObjects];
            }
            [self.unitListArr addObjectsFromArray:[WaitUnitQueueModel mj_objectArrayWithKeyValuesArray:arr]];
            [self.waitDetailTableView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 2 ? _unitListArr.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"HouseBannerTableViewCell";
        HouseBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (HouseBannerTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _waitProjctListModel;
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *cellID = @"WaitProductTableViewCell";
        WaitProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (WaitProductTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _waitProjctListModel;
        return cell;
    }
    static NSString *cellID = @"WaitInfoTableViewCell";
    WaitInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (WaitInfoTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.row == 0) {
        [CommonUtils addCorner:cell.bgView rect:cell.bgView.bounds rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    }
    if ((indexPath.row + 1) == _unitListArr.count) {
        [CommonUtils addCorner:cell.bgView rect:cell.bgView.bounds rectCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    }
    WaitUnitQueueModel *unitModel = _unitListArr[indexPath.row];
    cell.unitModel = unitModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        WaitUnitQueueModel *unitModel = _unitListArr[indexPath.row];
        WaitHouseDetailViewController *vc = [WaitHouseDetailViewController new];
        vc.unitId = unitModel.id;
        vc.projectId = _id;
        vc.before = unitModel.waiting.before;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSMutableArray *)unitListArr
{
    if (!_unitListArr) {
        _unitListArr = [NSMutableArray array];
    }
    return _unitListArr;
}

@end
