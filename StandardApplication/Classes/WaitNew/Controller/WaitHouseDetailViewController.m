//
//  WaitHouseDetailViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2023/12/9.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "WaitHouseDetailViewController.h"
#import "MacroDefine.h"
#import "HouseBannerTableViewCell.h"
#import "PlayPhoneView.h"
#import "WaitNumberViewController.h"
#import "WaitHouseProductTableViewCell.h"
#import "WaitHouseInfoTableViewCell.h"
#import "HomeHouseTableViewCell.h"
#import "WaitHouseStatusTableViewCell.h"
#import "NewWaitProjctListModel.h"
#import "WaitExistModel.h"
#import "SecondConfirmView.h"
#import "HouseDetailViewController.h"

@interface WaitHouseDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *waitHouseDetailTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutHeight;
@property (weak, nonatomic) IBOutlet UIButton *waitBtn;

@property (strong, nonatomic) NewWaitProjctListModel *waitProjctListModel;
@property (strong, nonatomic) WaitExistModel *queueExistModel;
@property (assign, nonatomic) NSInteger waitCount;

@end

@implementation WaitHouseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self leftBarItem];
    self.navTitle = @"户型详情";
    
    _tableViewLayoutTop.constant = NAVBAR_HEIGHT + 10;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F9FE"];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getWaitHouseDetailInfo];
    
    // 轮候次数
    [self getWaitCountInfo];
        
    // 轮候信息
    [self getWaitQueueExistInfo];
}

- (void)getWaitHouseDetailInfo
{
    [MBProgressHUD showStatus:nil toView:nil];
    [HttpRequest requestUrlPath:BaseURL urlPath:cityWaiting_house_detailURL parameters:@{@"id":@(_unitId)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:nil];
        if (status == 1) {
            self.waitProjctListModel = [NewWaitProjctListModel mj_objectWithKeyValues:dic];
            self.waitProjctListModel.desc = IsNilOrNull([dic valueForKey:@"description"]) ? @" " : NONullString([dic valueForKey:@"description"]);
            
            [self.waitHouseDetailTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)getWaitCountInfo
{
    [HttpRequest requestUrlPath:BaseURL urlPath:cityWaiting_countURL parameters:@{} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            if ([dic isKindOfClass:[NSNumber class]]) {
                self.waitCount = [(NSNumber *)dic intValue];
                if (IsNilOrNull(_queueExistModel)) {
                    [self.waitBtn setTitle: @"参与轮候" forState:UIControlStateNormal];
                    self.waitBtn.userInteractionEnabled = self.waitCount < 3;
                    self.waitBtn.backgroundColor = self.waitCount < 3 ? [UIColor colorWithHexString:@"#2A629A"] : [UIColor colorWithHexString:@"#7F7F7F"];
                }
            }
        }
    }];
}

- (void)getWaitQueueExistInfo
{
    [HttpRequest requestUrlPath:BaseURL urlPath:cityWaiting_existURL parameters:@{@"queue_id":@(_unitId)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            self.queueExistModel = [WaitExistModel mj_objectWithKeyValues:dic];
            self.queueExistModel.before = self.before;
            self.waitBtn.userInteractionEnabled = YES;
            self.waitBtn.backgroundColor = [UIColor colorWithHexString:@"#2A629A"];
            [self.waitBtn setTitle:self.queueExistModel.status == 1 ? @"取消轮候" : @"参与轮候" forState:UIControlStateNormal];
            self.bottomView.hidden = self.queueExistModel.status > 1;
            self.bottomViewLayoutHeight.constant = self.queueExistModel.status > 1 ? 0 : 78;
            
            [self.waitHouseDetailTableView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (IsNilOrNull(_queueExistModel)) {
        return 2;
    } else if (_queueExistModel.status == 1) {
        return 3;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
        static NSString *cellID = @"WaitHouseProductTableViewCell";
        WaitHouseProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (WaitHouseProductTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _waitProjctListModel;
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *cellID = @"WaitHouseInfoTableViewCell";
        WaitHouseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (WaitHouseInfoTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.queueExistModel = _queueExistModel;
        return cell;
    } else if (indexPath.section == 3) {
        static NSString *cellID = @"HomeHouseTableViewCell";
        HomeHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (HomeHouseTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor colorWithHexString:@"#F8F9FE"];
        cell.isWaitHouse = YES;
        cell.unitModel = _queueExistModel.unit;
        return cell;
    }
    static NSString *cellID = @"WaitHouseStatusTableViewCell";
    WaitHouseStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (WaitHouseStatusTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.queueExistModel = _queueExistModel;
    KWeakSelf
    cell.ReloadWaitHouseDetailBlock = ^{
        [weakSelf getWaitQueueExistInfo];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        HouseDetailViewController *vc = [HouseDetailViewController new];
        vc.isWaitHouse = YES;
        vc.unit_id = _queueExistModel.unit_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)phoneBtnClick:(id)sender 
{
    if (IsStrEmpty(_waitProjctListModel.phone)) {
        return;
    }
    NSString * phone = [NSString stringWithFormat:@"telprompt://%@",_waitProjctListModel.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:nil];
}

- (IBAction)waitBtnClick:(id)sender 
{
    if (IsNilOrNull(_queueExistModel)) {
        WaitNumberViewController *vc = [WaitNumberViewController new];
        vc.waiting_project_id = _projectId;
        vc.waiting_queue_id = _unitId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_queueExistModel.status == 1) {
        [self cancelWaitInfo];
    }
}

- (void)cancelWaitInfo
{
    SecondConfirmView *secondConfirmView = [SecondConfirmView createViewFromNib];
    secondConfirmView.titleLab.text = @"您将取消此房源轮候?";
    secondConfirmView.titleLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    secondConfirmView.titleLab.textColor = [UIColor colorWithHexString:@"#52595E"];
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:secondConfirmView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    KWeakSelf
    secondConfirmView.didConfirmBlock = ^{
        [weakSelf getCancelWaitDate];
        [alertController dismissViewControllerAnimated:YES];
    };
    secondConfirmView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [self  presentViewController:alertController animated:YES completion:nil];
}

- (void)getCancelWaitDate
{
    [MBProgressHUD showStatus:nil toView:nil];
    [HttpRequest requestUrlPath:BaseURL urlPath:cityWaiting_cancelURL parameters:@{@"id":@(_queueExistModel.id)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:nil];
        if (status == 1 || status == 2) {
            [MBProgressHUD showMessag:@"取消成功" toView:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:nil];
        }
    }];
}

@end
