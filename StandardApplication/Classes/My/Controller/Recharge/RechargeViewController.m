//
//  RechargeViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "RechargeViewController.h"
#import "MacroDefine.h"
#import "CommitReserveViewController.h"
#import <AlipaySDK/AlipaySDK.h>
@import WechatOpenSDK;
#import "WXApiManager.h"
#import "ElectricDetailModel.h"
#import "RechargeRecodeViewController.h"

@interface RechargeViewController ()<WXApiManagerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLayoutTop;
@property (weak, nonatomic) IBOutlet UITextField *rechargeTextField;
@property (weak, nonatomic) IBOutlet UIView *alipayView;
@property (weak, nonatomic) IBOutlet UIView *wxpayView;
@property (weak, nonatomic) IBOutlet UILabel *remainingPowerLab;
@property (weak, nonatomic) IBOutlet UILabel *showLab;
@property (weak, nonatomic) IBOutlet UILabel *showTextLab;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *rechargePowerLab;

@property (strong, nonatomic) NSString *selectPayMethod;  // alipay支付宝 wechat微信
@property (assign, nonatomic) NSInteger isCloudPayment;   // 云缴费支付切换 1 关闭 2 打开
@property (strong, nonatomic) NSString *merOrderDate;    // 拉起收银台时间
@property (strong, nonatomic) NSString *pay_sn;    // 支付编号
@property (strong, nonatomic) ElectricDetailModel *electricDetailModel;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"充值";
    _selectPayMethod = @"alipay";
    _isCloudPayment = 0;
    _merOrderDate = @"";
    _pay_sn = @"";
    
    self.labelLayoutTop.constant = NAVBAR_HEIGHT + 28;
    [self setupInfo];
    [self setupOtherBarButtomItemWithTitle:@"充值记录" target:self action:@selector(recodeBtnEvent) leftOrRight:NO];
    
    [WXApiManager sharedManager].delegate = self;
    
    // 支付切换
    [self switchPaymentInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayStatusMethod) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    _showTextLab.text = _meter_type == 0 ? @"当前剩余电量" : @"当前剩余水费";
    _showLab.text = _meter_type == 0 ? @"度" : @"元";
    [self getDeviceMeterInfoDate];
    if (_meter_type != 0) {
        [self getWaterMeterAmountWithFeesDate];
    }
}

- (void)recodeBtnEvent
{
    RechargeRecodeViewController *vc = [RechargeRecodeViewController new];
    vc.meter_type = _meter_type;
    vc.device_id = _device_id;
    vc.provider = _provider;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getWaterMeterAmountWithFeesDate
{
    [HttpRequest requestUrlPath:HardwareBaseURL urlPath:water_meter_amount_with_feesURL parameters:@{@"device_id":NONullString(_device_id),@"app_key":NONullString([User shareUser].getApp_key)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            _remainingPowerLab.text = [NSString stringWithFormat:@"%.2f",[[dic valueForKey:@"left_amount"] floatValue]];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)getDeviceMeterInfoDate
{
    NSString *urlStr = _meter_type == 0 ? electric_meter_infoURL : water_meter_infoURL;
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:HardwareBaseURL urlPath:urlStr parameters:@{@"device_id":NONullString(_device_id),@"app_key":NONullString([User shareUser].getApp_key)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.electricDetailModel = [ElectricDetailModel mj_objectWithKeyValues:dic];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)setElectricDetailModel:(ElectricDetailModel *)electricDetailModel
{
    _electricDetailModel = electricDetailModel;
    if (_meter_type == 0) {
        _remainingPowerLab.text = [NSString stringWithFormat:@"%.2f",_electricDetailModel.remaining_power];
    }
    _unitPriceLab.text = [NSString stringWithFormat:@"充值（%.2f元/%@）",_electricDetailModel.unit_price, (_meter_type == 0 ? @"度" : @"吨")];
}

- (IBAction)textFieldEditingChanged:(id)sender
{
    float recharge = (float)[_rechargeTextField.text integerValue] / _electricDetailModel.unit_price;
    _rechargePowerLab.text = [NSString stringWithFormat:@"额度%.2f%@",recharge, (_meter_type == 0 ? @"度" : @"吨")];
}


- (void)switchPaymentInfo
{
    [HttpRequest requestUrlPath:BaseURL urlPath:setting_switching_paymentURL parameters:@{} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            if (!IsNilOrNull([dic valueForKey:@"switch"])) {
                self.isCloudPayment = [[dic valueForKey:@"switch"] integerValue];
            }
        }
    }];
}

- (void)setupInfo
{
    KWeakSelf
    [_alipayView whenTapped:^{
        weakSelf.alipayView.backgroundColor = [UIColor colorWithHexString:@"#040000" alpha:0.1];
        weakSelf.wxpayView.backgroundColor = [UIColor clearColor];
        weakSelf.selectPayMethod = @"alipay";
    }];
    
    [_wxpayView whenTapped:^{
        weakSelf.alipayView.backgroundColor = [UIColor clearColor];
        weakSelf.wxpayView.backgroundColor = [UIColor colorWithHexString:@"#040000" alpha:0.1];
        weakSelf.selectPayMethod = @"wechat";
    }];
}

- (IBAction)nextBtnClick:(id)sender
{
    if (IsStrEmpty(_rechargeTextField.text)) {
        [MBProgressHUD showMessag:@"请输入正确的金额" toView:self.view];
        return;
    }
    if (_isCloudPayment == 2) {
        [self getPayWaterElectricityInfo];
        return;
    }
    NSDictionary *param = @{@"app_key":NONullString([User shareUser].getApp_key),
                            @"type": _meter_type == 0 ? @"electric" : @"water",
                            @"device_id":NONullString(_device_id),
                            @"unit_price":@(_electricDetailModel.unit_price),
                            @"unit_id":@(_unit_id),
                            @"provider":NONullString(_provider)};
    NSInteger price = [_rechargeTextField.text integerValue] * 100;
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:payment_initURL parameters:@{@"pay_way":NONullString(_selectPayMethod),@"price":@(price),@"param":[param mj_JSONString]} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            if ([_selectPayMethod isEqualToString:@"wechat"]) {
                [self wxpayDateInfo:dic];
            } else if ([_selectPayMethod isEqualToString:@"alipay"]) {
                [self alipayDateInfo:dic];
            }
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)getPayWaterElectricityInfo
{
    NSDictionary *param = @{@"app_key":NONullString([User shareUser].getApp_key),
                            @"type": _meter_type == 0 ? @"electric" : @"water",
                            @"device_id":NONullString(_device_id),
                            @"unit_price":@(_electricDetailModel.unit_price),
                            @"unit_id":@(_unit_id),
                            @"provider":NONullString(_provider)};
    NSInteger price = [_rechargeTextField.text integerValue] * 100;
    NSDictionary *postParams = @{
        @"device_type":[_selectPayMethod isEqualToString:@"alipay"] ? @(8) : @(5),
        @"price":@(price),
        @"param":[param mj_JSONString],
        @"u_id":[User shareUser].getUserId};
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseApiURL urlPath:cloudPayCost_Recharge_payURL parameters:postParams type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.merOrderDate = [NSDate getNowDateNOXianStr];
            self.pay_sn = NONullString([dic valueForKey:@"pay_sn"]);
            NSLog(@"======%@",self.merOrderDate);
            if ([_selectPayMethod isEqualToString:@"alipay"]) {
                if (!IsStrEmpty([dic valueForKey:@"path"])) {
                    NSArray *pathQueryArr = [[dic valueForKey:@"path"] componentsSeparatedByString:@"?"];
                    if (pathQueryArr.count > 0) {
                        NSString *urlStr = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=%@&page=%@&query=%@",NONullString([dic valueForKey:@"appId"]),NONullString(pathQueryArr[0]),NONullString([dic valueForKey:@"query"])];
                        NSLog(@"======%@",urlStr);
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
                    }
                }
//                NSString *urlStr = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=%@&page=%@&query=%@",NONullString([dic valueForKey:@"appId"]),NONullString([dic valueForKey:@"path"]),NONullString([dic valueForKey:@"query"])];
//                NSLog(@"======%@",urlStr);
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
            } else if ([_selectPayMethod isEqualToString:@"wechat"]) {
                // 需要判断是否安装微信
                BOOL wxIsInstalled = [WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi];
                if (!wxIsInstalled) {
                    [MBProgressHUD showMessag:@"请安装微信" toView:nil];
                    return;
                }
                WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
                launchMiniProgramReq.userName = NONullString([dic valueForKey:@"original_id"]);
                launchMiniProgramReq.path = NONullString([dic valueForKey:@"path"]);
                launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease;
                return [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
            
                }];
            }
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)alipayDateInfo:(NSDictionary *)dic
{
    NSString *orderString = dic[@"order_string"];
    [[AlipaySDK  defaultService] payOrder:NONullString(orderString) fromScheme:@"huijia" callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] integerValue] == 9000 ) {
            CommitReserveViewController *vc = [CommitReserveViewController new];
            vc.successType = RechargeSuccessType;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:@"支付失败" toView:self.view];
        }
    }];
}

- (void)wxpayDateInfo:(NSDictionary *)dic
{
    // 需要判断是否安装微信
    BOOL wxIsInstalled = [WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi];
    if (!wxIsInstalled) {
        [MBProgressHUD showMessag:@"请安装微信" toView:self.view];
        return;
    }
    PayReq *req = [[PayReq alloc] init];
    req.openID = dic[@"appid"];
    req.partnerId = dic[@"partnerid"];
    if (![dic[@"prepayid"] isKindOfClass:[NSNull class]]) {
        req.prepayId = dic[@"prepayid"];
    } else {
        req.prepayId = @"";
    }
    req.nonceStr = dic[@"noncestr"];
    req.package = dic[@"package"];
    req.sign = dic[@"sign"];
    req.timeStamp = [dic[@"timestamp"] intValue];
    [WXApi sendReq:req completion:^(BOOL success) {
        if (!success) {
            [MBProgressHUD showMessag:@"支付失败" toView:self.view];
        }
    }];
}

// 微信支付回调结果delegate
- (void)weiXinPayNotification:(NSInteger)errCode message:(NSString *)info
{
    if (errCode == 0) {
        CommitReserveViewController *vc = [CommitReserveViewController new];
        vc.successType = RechargeSuccessType;
        [self.navigationController pushViewController:vc animated:YES];
    }  else if (errCode == 600) {
        [self getPayStatusMethod];
    }  else {
        [MBProgressHUD showMessag:@"支付失败" toView:self.view];
    }
}

// 支付宝走客户端回调
- (void)alipayNotificationAction:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    if ([dic[@"resultStatus"] integerValue] == 9000) {
        CommitReserveViewController *vc = [CommitReserveViewController new];
        vc.successType = RechargeSuccessType;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [MBProgressHUD showMessag:@"支付失败" toView:self.view];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayNotificationAction:) name:@"AliPayNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AliPayNotification" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getPayStatusMethod
{
    [MBProgressHUD showStatus:nil toView:self.view];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD dismissHUDForView:strongSelf.view];
        [strongSelf getPay];
    });
    
}

- (void)getPay
{
    if (!IsStrEmpty(_merOrderDate)) {
        [self getPaymentStatusInfo:_pay_sn merOrderDate:_merOrderDate];
        _merOrderDate = @"";
        _pay_sn = @"";
    }
}

- (void)getPaymentStatusInfo:(NSString *)pay_sn merOrderDate:(NSString *)merOrderDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseApiURL urlPath:cloudPayCost_cloudPay_getPaymentStatusURL parameters:@{@"pay_sn":NONullString(pay_sn),@"merOrderDate":NONullString(merOrderDate)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            if ([[dic valueForKey:@"order_status"] integerValue] == 1 || [[dic valueForKey:@"order_status"] integerValue] == 3) {
                CommitReserveViewController *vc = [CommitReserveViewController new];
                vc.successType = RechargeSuccessType;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [MBProgressHUD showMessag:@"支付失败" toView:self.view];
            }
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

@end
