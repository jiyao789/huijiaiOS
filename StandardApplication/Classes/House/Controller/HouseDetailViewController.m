//
//  HouseDetailViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HouseDetailViewController.h"
#import "MacroDefine.h"
#import "HouseDetailHeaderView.h"
#import "HouseDetailConfigTableViewCell.h"
#import "HouseDetailIntroduceTableViewCell.h"
#import "AppointSeeHouseViewController.h"
#import "ReserveHouseViewController.h"
#import "HouseDetailModel.h"
#import "PlayPhoneView.h"
#import "AppointSeeHouseView.h"
#import "PhoneInfoModel.h"
#import "CommitReserveViewController.h"
#import "WaitNumberViewController.h"
#import "SecondConfirmView.h"
#import "WaitingDetailModel.h"
#import "MyWaitViewController.h"
#import "BigHouseModel.h"

@interface HouseDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *houseDetailTableView;
@property (weak, nonatomic) IBOutlet QMUIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *appointWaitBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *playPhoneBtn;
@property (weak, nonatomic) IBOutlet BaseShadowView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutHeight;
@property (weak, nonatomic) IBOutlet UIButton *reserveBtn;
@property (weak, nonatomic) IBOutlet UIButton *bigHousePlayPhoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *bigHouseAppointBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneTimeLab;

@property (strong, nonatomic) HouseDetailHeaderView *houseDetailHeaderView;
@property (strong, nonatomic) HouseDetailModel *houseDetailModel;
@property (strong, nonatomic) NSMutableArray *phoneArr;
@property (strong, nonatomic) WaitingDetailModel *waitingDetailModel;

@property (strong, nonatomic) BigHouseModel *bigHouseModel;
@end

@implementation HouseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navBackgroundColor = [UIColor clearColor];
    self.hideNavLine = YES;
    self.statusBarStyle = UIStatusBarStyleLightContent;
    adjustsScrollViewInsets_NO(_houseDetailTableView, self);
    [self setupBarButtomItemWithImageName:@"white_back_icon" highLightImageName:@"white_back_icon" selectedImageName:@"white_back_icon" target:self action:@selector(backEvent) leftOrRight:YES];
    
    _collectionBtn.imagePosition = QMUIButtonImagePositionTop;
    _collectionBtn.spacingBetweenImageAndTitle = 3;
    _playPhoneBtn.imagePosition = QMUIButtonImagePositionTop;
    _playPhoneBtn.spacingBetweenImageAndTitle = 3;
    _houseDetailTableView.tableHeaderView = self.houseDetailHeaderView;
    
    _bottomView.hidden = _isWaitHouse;
    _bottomViewLayoutHeight.constant = _isWaitHouse ? 0 : 90;
}

- (void)backEvent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!IsStrEmpty(_bigHouseId) && !IsNilOrNull(_bigHouseId)) {
        [self getBigHouseDetailDate];
    } else {
        [self getUnitDetailDate];
        [self getUnitGethousekeeperDate];
    }
}

- (void)getBigHouseDetailDate
{
    if (IsStrEmpty(_bigHouseId) || IsNilOrNull(_bigHouseId)) {
        return;
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:house_detailURL parameters:@{@"house_id":NONullString(_bigHouseId)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.bigHouseModel = [BigHouseModel mj_objectWithKeyValues:dic];
            self.bigHouseModel.desc = IsNilOrNull([dic valueForKey:@"description"]) ? @" " : NONullString([dic valueForKey:@"description"]);
            self.houseDetailHeaderView.bigHouseModel = self.bigHouseModel;
            PhoneInfoModel *phoneInfoModel = [PhoneInfoModel new];
            phoneInfoModel.name = self.bigHouseModel.landlord_name;
            phoneInfoModel.phone = self.bigHouseModel.landlord_phone;
            [self.phoneArr addObject:phoneInfoModel];
            self.collectionBtn.hidden = YES;
            self.playPhoneBtn.hidden = YES;
            self.appointWaitBtn.hidden = YES;
            self.reserveBtn.hidden = YES;
            self.bigHousePlayPhoneBtn.hidden = NO;
            self.bigHouseAppointBtn.hidden = NO;
            self.phoneTimeLab.hidden = NO;
            [self.houseDetailTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)getUnitDetailDate
{
    if (_unit_id <= 0) {
        return;
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:unit_detailURL parameters:@{@"unit_id":@(_unit_id),@"platform":@"2"} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.houseDetailModel = [HouseDetailModel mj_objectWithKeyValues:dic];
            self.houseDetailHeaderView.model = self.houseDetailModel;
            NSString *imageStr = self.houseDetailModel.collect ? @"house_collection_img" : @"house_uncollection_img";
//            [self.appointWaitBtn setTitle:self.houseDetailModel.nature == 1 ? @"房源轮候" : @"预约看房" forState:UIControlStateNormal];
            [self.appointWaitBtn setTitle: @"预约看房" forState:UIControlStateNormal];
            [self.collectionBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            [self.houseDetailTableView reloadData];
//            [self getUnitWaitingDate];
            
//            SAFE_BLOCK(self.houseIsCollectBlock,self.houseDetailModel.collect);
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)getUnitWaitingDate
{
    [HttpRequest requestUrlPath:BaseURL urlPath:unitWaiting_infoURL parameters:@{} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            self.waitingDetailModel = [WaitingDetailModel mj_objectWithKeyValues:dic];
            if (_unit_id == self.waitingDetailModel.unit_id) {
                [self.appointWaitBtn setTitle:@"取消轮候" forState:UIControlStateNormal];
            }
        }
    }];
}

- (void)getUnitGethousekeeperDate
{
    if (_unit_id <= 0) {
        return;
    }
    [HttpRequest requestArrUrlPath:ReleaseBaseURL urlPath:unit_gethousekeeperURL parameters:@{@"unit_id":@(_unit_id)} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            if (self.phoneArr.count > 0) {
                [self.phoneArr removeAllObjects];
            }
            [self.phoneArr addObjectsFromArray:[PhoneInfoModel mj_objectArrayWithKeyValuesArray:arr]];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat houseConfigHeight = 0;
    if (!IsStrEmpty(_bigHouseId) && !IsNilOrNull(_bigHouseId)) {
        NSArray *components = [_bigHouseModel.facilities componentsSeparatedByString:@"|"];
        if (components.count > 0) {
            NSInteger furnitureCount = components.count % 5 == 0 ? (components.count / 5) : (components.count / 5 + 1);
            houseConfigHeight = (80 * furnitureCount) - 10;
        }
    } else {
        if (_houseDetailModel.furniture.count > 0) {
            NSInteger furnitureCount = _houseDetailModel.furniture.count % 5 == 0 ? (_houseDetailModel.furniture.count / 5) : (_houseDetailModel.furniture.count / 5 + 1);
            houseConfigHeight = (80 * furnitureCount) - 10;
        }
    }
    
    return indexPath.section == 0 ? houseConfigHeight : UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [bgView addSubview: sectionView];
    
    UILabel *headerSectionLab = [[UILabel alloc]initWithFrame:CGRectMake(17, 5, SCREEN_WIDTH - 17, 45)];
    headerSectionLab.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
    headerSectionLab.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
    headerSectionLab.textAlignment = NSTextAlignmentLeft;
    headerSectionLab.text = section == 0 ? @"设施配置" : @"房源介绍";
    
    [bgView addSubview:headerSectionLab];
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"HouseDetailConfigTableViewCell";
        HouseDetailConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (HouseDetailConfigTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (!IsStrEmpty(_bigHouseId) && !IsNilOrNull(_bigHouseId)) {
            cell.facilities = _bigHouseModel.facilities;
        } else {
            cell.furnitureArr = _houseDetailModel.furniture;
        }
        return cell;
    }
    static NSString *cellID = @"HouseDetailIntroduceTableViewCell";
    HouseDetailIntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (HouseDetailIntroduceTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (!IsStrEmpty(_bigHouseId) && !IsNilOrNull(_bigHouseId)) {
        cell.introLab.text = NONullString(_bigHouseModel.desc);
    } else {
        cell.introLab.text = NONullString(_houseDetailModel.intro);
    }
    return cell;
}

- (IBAction)buttonClickEvent:(UIButton *)sender
{
    KWeakSelf
    [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentNavgationController:self.navigationController loginSuccessed:^(NSString *authorization, BOOL performLogin) {
        switch (sender.tag) {
            case 0:
            {
                [weakSelf unitCollectDate];
                break;
            }
            case 1:
            {
                [weakSelf showPlayPhoneView];
                break;
            }
            case 2:
            {
//                if (self.houseDetailModel.nature == 1) {
//                    if (IsNilOrNull(weakSelf.waitingDetailModel)) {
//                        [MBProgressHUD showMessag:@"请先进行房源轮候取号" toView:self.view];
//                        return;
//                    }
//                    if (!IsNilOrNull(weakSelf.waitingDetailModel) && weakSelf.unit_id == weakSelf.waitingDetailModel.unit_id) {
//                        [weakSelf showCancelWaitView];
//                        return;
//                    }
//                    [weakSelf unitWaitingInfo];
//                    return;
//                }
                [weakSelf showAppointSeeHouseView:1 unit:_houseDetailModel.unit_id];
                break;
            }
            case 3:
            {
                ReserveHouseViewController *vc = [ReserveHouseViewController new];
                vc.houseDetailModel = _houseDetailModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 4:
            {
                [weakSelf showPlayPhoneView];
                break;
            }
            case 5:
            {
                [weakSelf showAppointSeeHouseView:2 unit:[_bigHouseId integerValue]];
            }
            default:
                break;
        }
    }];
}

- (void)showCancelWaitView
{
    SecondConfirmView *secondConfirmView = [SecondConfirmView createViewFromNib];
    secondConfirmView.titleLab.text = @"确认取消此房源轮候？\n注：取消房源轮候不会取消轮候排队";
    secondConfirmView.titleLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    secondConfirmView.titleLab.textColor = [UIColor colorWithHexString:@"#52595E"];
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:secondConfirmView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    KWeakSelf
    secondConfirmView.didConfirmBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
        [weakSelf getCancelUnitWaitDate];
    };
    secondConfirmView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getCancelUnitWaitDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:unitWaiting_cancelURL parameters:@{} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        [MBProgressHUD showMessag: (status == 1 || status == 2) ? @"取消成功" :msg toView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)unitCollectDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    NSString *urlStr = _houseDetailModel.collect ? unit_cancelcollectURL : unit_collectURL;
    [HttpRequest requestUrlPath:BaseURL urlPath:urlStr parameters:@{@"unit_id":@(_unit_id)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            self.houseDetailModel.collect = !self.houseDetailModel.collect;
            NSString *imageStr = self.houseDetailModel.collect ? @"house_collection_img" : @"house_uncollection_img";
            [self.collectionBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            NSString *showMsg = self.houseDetailModel.collect ? @"收藏成功" : @"取消收藏";
            [MBProgressHUD showMessag:showMsg toView:self.view];
            
//            SAFE_BLOCK(self.houseIsCollectBlock,self.houseDetailModel.collect);
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)unitWaitingInfo
{
    SecondConfirmView *secondConfirmView = [SecondConfirmView createViewFromNib];
    secondConfirmView.titleLab.text = @"我已知晓轮候房源申请条件并同意,\n确认轮候？";
    secondConfirmView.titleLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    secondConfirmView.titleLab.textColor = [UIColor colorWithHexString:@"#52595E"];
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:secondConfirmView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    KWeakSelf
    secondConfirmView.didConfirmBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
        [weakSelf getUnitWaitingData];
    };
    secondConfirmView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getUnitWaitingData
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:unitWaiting_waitingURL parameters:@{@"unit_id":@(_unit_id)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            MyWaitViewController *vc = [MyWaitViewController new];
            vc.backType = @"previous";
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)showPlayPhoneView
{
    PlayPhoneView *playPhoneView = [PlayPhoneView createViewFromNib];
    playPhoneView.phoneArr = self.phoneArr;
    playPhoneView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 40, 75 + self.phoneArr.count * 50);
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:playPhoneView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    playPhoneView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAppointSeeHouseView:(NSInteger)houseClass unit:(NSInteger)unit_id
{
    AppointSeeHouseView *appointSeeHouseView = [AppointSeeHouseView createViewFromNib];
    appointSeeHouseView.phoneArr = self.phoneArr;
    appointSeeHouseView.houseClass = houseClass;
    appointSeeHouseView.unit_id = unit_id;
    appointSeeHouseView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 40, 390 + self.phoneArr.count * 30);
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:appointSeeHouseView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    KWeakSelf
    appointSeeHouseView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
        CommitReserveViewController *vc = [CommitReserveViewController new];
        vc.successType = ReserrveSuccessType;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (HouseDetailHeaderView *)houseDetailHeaderView
{
    if (!_houseDetailHeaderView) {
        _houseDetailHeaderView = [HouseDetailHeaderView viewFromXib];
    }
    return _houseDetailHeaderView;
}

- (NSMutableArray *)phoneArr
{
    if (!_phoneArr) {
        _phoneArr = [NSMutableArray array];
    }
    return _phoneArr;
}

@end
