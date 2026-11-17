//
//  LiveChargeViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "LiveChargeViewController.h"
#import "MacroDefine.h"
#import "SubscribeListModel.h"
#import "JXTAlertManagerHeader.h"
#import "ElectricDetailModel.h"
#import "RechargeViewController.h"

@interface LiveChargeViewController ()
@property (weak, nonatomic) IBOutlet BaseShadowView *elecView;
@property (weak, nonatomic) IBOutlet BaseShadowView *hotWaterView;
@property (weak, nonatomic) IBOutlet BaseShadowView *lengWaterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lengWaterViewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *elecViewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotWaterViewLayoutHieght;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewLayoutTop;
@property (weak, nonatomic) IBOutlet UILabel *lengScaleLab;
@property (weak, nonatomic) IBOutlet UILabel *elecScaleLab;
@property (weak, nonatomic) IBOutlet UILabel *hotScaleLab;

@property (assign, nonatomic) NSInteger unit_id;
@property (strong, nonatomic) NSArray *unitArr;
@property (strong, nonatomic) NSString *elecDeviceIdStr;
@property (strong, nonatomic) NSString *elecProvider;
@property (strong, nonatomic) NSString *lengDeviceIdStr;
@property (strong, nonatomic) NSString *lengProvider;
@property (strong, nonatomic) NSString *hotDeviceIdStr;
@property (strong, nonatomic) NSString *hotProvider;
@end

@implementation LiveChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"生活费用";
    
    _unit_id = -1;
    self.bgViewLayoutTop.constant = NAVBAR_HEIGHT + 10;
    
    KWeakSelf
    [_elecView whenTapped:^{
        RechargeViewController *vc = [RechargeViewController new];
        vc.unit_id = weakSelf.unit_id;
        vc.meter_type = 0;
        vc.device_id = _elecDeviceIdStr;
        vc.provider = _elecProvider;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [_lengWaterView whenTapped:^{
        RechargeViewController *vc = [RechargeViewController new];
        vc.unit_id = weakSelf.unit_id;
        vc.meter_type = 1;
        vc.device_id = _lengDeviceIdStr;
        vc.provider = _lengProvider;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [_hotWaterView whenTapped:^{
        RechargeViewController *vc = [RechargeViewController new];
        vc.unit_id = weakSelf.unit_id;
        vc.meter_type = 2;
        vc.device_id = _hotDeviceIdStr;
        vc.provider = _hotProvider;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [_houseNameLab whenTapped:^{
        KStrongSelf(weakSelf)
        [strongSelf jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            for (UnitModel *model in strongSelf.unitArr) {
                alertMaker.
                addActionDefaultTitle(model.contractWorkHouseString);
            }
            alertMaker.
            addActionCancelTitle(@"取消");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if ([action.title isEqualToString:@"取消"]) {
                NSLog(@"按钮2");
            } else {
                UnitModel *model = strongSelf.unitArr[buttonIndex];
                strongSelf.houseNameLab.text = NONullString(model.contractWorkHouseString);
                strongSelf.unit_id = model.unit_id;
                [strongSelf getDeviceCommonGetDevicesInfoDate];
            }
        }];
    }];
        
    [self getContractWorksDate];
}

- (void)getContractWorksDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:BaseURL urlPath:contract_worksURL parameters:@{} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.unitArr = [UnitModel mj_objectArrayWithKeyValuesArray:arr];
            self.bgView.hidden = NO;
            UnitModel *firstModel = self.unitArr.firstObject;
            self.houseNameLab.text = NONullString(firstModel.contractWorkHouseString);
            self.unit_id = firstModel.unit_id;
            [self getDeviceCommonGetDevicesInfoDate];
        } else {
            self.noMsgView.originY = NAVBAR_HEIGHT;
            [self.view addSubview:self.noMsgView];
        }
    }];
}

- (void)getDeviceCommonGetDevicesInfoDate
{
    self.lengWaterView.hidden = YES;
    self.lengWaterViewLayoutHeight.constant = 0;
    self.elecView.hidden = YES;
    self.elecViewLayoutHeight.constant = 0;
    self.hotWaterView.hidden = YES;
    self.hotWaterViewLayoutHieght.constant = 0;
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:HardwareBaseURL urlPath:device_common_get_devices_infoURL parameters:@{@"bind_id":@(_unit_id),@"bind_module":@"room", @"app_key":NONullString([User shareUser].getApp_key)} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            for (NSDictionary *dic in arr) {
                if ([[dic valueForKey:@"type"] isEqualToString:@"electric"]) {
                    self.elecView.hidden = NO;
                    self.elecViewLayoutHeight.constant = 94;
                    self.elecDeviceIdStr = NONullString([dic valueForKey:@"device_id"]);
                    self.elecProvider = NONullString([dic valueForKey:@"provider"]);
                } else if ([[dic valueForKey:@"type"] isEqualToString:@"water"]) {
                    if ([[dic valueForKey:@"meter_type"] integerValue] == 1) {
                        self.lengWaterView.hidden = NO;
                        self.lengWaterViewLayoutHeight.constant = 94;
                        self.lengDeviceIdStr = NONullString([dic valueForKey:@"device_id"]);
                        self.lengProvider = NONullString([dic valueForKey:@"provider"]);
                    } else if ([[dic valueForKey:@"meter_type"] integerValue] == 2) {
                        self.hotWaterView.hidden = NO;
                        self.hotWaterViewLayoutHieght.constant = 94;
                        self.hotDeviceIdStr = NONullString([dic valueForKey:@"device_id"]);
                        self.hotProvider = NONullString([dic valueForKey:@"provider"]);
                    }
                }
            }
        } else {
            [MBProgressHUD showMessag:@"暂无绑定设备" toView:self.view];
        }
    }];
}

- (NSArray *)unitArr
{
    if (!_unitArr) {
        _unitArr = [NSArray array];
    }
    return _unitArr;
}

@end
