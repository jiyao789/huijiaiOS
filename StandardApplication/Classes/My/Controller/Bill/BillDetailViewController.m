//
//  BillDetailViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/24.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BillDetailViewController.h"
#import "MacroDefine.h"
#import "HomeHouseTableViewCell.h"
#import "BillDetailAmountTableViewCell.h"
#import "BillAmountDetailTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
@import WechatOpenSDK;
#import "WXApiManager.h"
#import "BillDetailModel.h"
#import "CommitReserveViewController.h"

@interface BillDetailViewController ()<UITableViewDelegate,UITableViewDataSource,WXApiManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *billDetailTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *headerBgView;
@property (weak, nonatomic) IBOutlet UIView *alipayView;
@property (weak, nonatomic) IBOutlet UIView *wxpayView;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;

@property (strong, nonatomic) BillDetailModel *billDetailModel;
@property (assign, nonatomic) NSInteger selectPayMethod;  // 1支付宝 2微信
@property (assign, nonatomic) NSInteger isCloudPayment;   // 云缴费支付切换 1 关闭 2 打开
@property (strong, nonatomic) NSString *merOrderDate;    // 拉起收银台时间
@property (strong, nonatomic) NSString *pay_sn;    // 支付编号
@end

@implementation BillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"账单详情";
    _selectPayMethod = 1;
    _isCloudPayment = 0;
    _merOrderDate = @"";
    _pay_sn = @"";
    
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    self.billDetailTableView.tableHeaderView = _headerView;
    self.billDetailTableView.tableFooterView = _footerView;
    
    [self setupInfo];
    
    [WXApiManager sharedManager].delegate = self;
    
    if (_b_id > 0) {
        [self getBillDetailDate];
    } else if (_bookId > 0) {
        float price = _reserveAmount / 100;
        _amountLab.text = [NSString stringWithFormat:@"¥%.2f",price];
    }
    
    // 支付切换
    [self switchPaymentInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayStatusMethod) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)getBillDetailDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:bill_detailURL parameters:@{@"b_id":@(_b_id)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.billDetailModel = [BillDetailModel mj_objectWithKeyValues:dic];
            [self.billDetailTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
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

- (void)setBillDetailModel:(BillDetailModel *)billDetailModel
{
    _billDetailModel = billDetailModel;
    if (!IsNilOrNull(_billDetailModel.book_data)) {
        float total = (_billDetailModel.total - _billDetailModel.income - _billDetailModel.book_data.income_price) / 100;
        _amountLab.text = [NSString stringWithFormat:@"¥%.2f",total];
    } else {
        float total = (_billDetailModel.total - _billDetailModel.income) / 100;
        _amountLab.text = [NSString stringWithFormat:@"¥%.2f",total];
    }
}

- (void)setupInfo
{
    UIImage *statusImage = [UIImage setupBackgroundColor:YES fromColor:[UIColor colorWithHexString:@"#BD9E66"] toColor:[UIColor colorWithHexString:@"#F2F2F2"] view:_headerBgView];
    _headerBgView.backgroundColor = [UIColor colorWithPatternImage:statusImage];
    
    KWeakSelf
    [_alipayView whenTapped:^{
        weakSelf.alipayView.backgroundColor = [UIColor colorWithHexString:@"#040000" alpha:0.25];
        weakSelf.wxpayView.backgroundColor = [UIColor clearColor];
        weakSelf.selectPayMethod = 1;
    }];
    
    [_wxpayView whenTapped:^{
        weakSelf.alipayView.backgroundColor = [UIColor clearColor];
        weakSelf.wxpayView.backgroundColor = [UIColor colorWithHexString:@"#040000" alpha:0.25];
        weakSelf.selectPayMethod = 2;
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
    return indexPath.section == 0 ? 128 : UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UILabel *headerSectionLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 21, SCREEN_WIDTH - 32, 16)];
    headerSectionLab.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightHeavy];
    headerSectionLab.textColor = [UIColor blackColor];
    headerSectionLab.textAlignment = NSTextAlignmentLeft;
    headerSectionLab.text = section == 0 ? @"房源信息" : @"应收金额";
    
    [sectionView addSubview:headerSectionLab];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"HomeHouseTableViewCell";
        HomeHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (HomeHouseTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        cell.collectionButton.hidden = YES;
//        cell.collectionButtonLayoutWidth.constant = 0;
//        cell.checkDateLayoutHeight.constant = 0;
//        cell.houseTypeLayoutTop.constant = 15;
        cell.houseNameLayoutRight.constant = 55;
        if (_b_id > 0) {
            cell.unitModel = _billDetailModel.unit;
        } else if (_bookId > 0) {
            cell.houseDetailModel = _houseDetailModel;
        }
        return cell;
    }
    if (_bookId > 0) {
        static NSString *cellID = @"BillDetailAmountTableViewCell";
        BillDetailAmountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (BillDetailAmountTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        float price = _reserveAmount / 100;
        cell.reserveAmountLab.text = [NSString stringWithFormat:@"%.2f",price];
        return cell;
    } else if (_b_id > 0) {
        static NSString *cellID = @"BillAmountDetailTableViewCell";
        BillAmountDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (BillAmountDetailTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.billDetailModel = _billDetailModel;
        return cell;
    }
    return [UITableViewCell new];
}

- (IBAction)payBtnClick:(id)sender
{
    if (_b_id > 0) {
        if (_isCloudPayment == 2) {
            [self cloudPayCostInfo:@{@"bill_id":@(_b_id),@"device_type":_selectPayMethod == 1 ? @(8) : @(5)} urlStr:cloudPayCost_cloudPay_payURL];
            return;
        }
        if (_selectPayMethod == 1) {
            [self alipayDateInfo:@{@"b_id":@(_b_id)} urlStr:bill_aliURL];
        } else {
            [self wxpayDateInfo:@{@"b_id":@(_b_id)} urlStr:bill_wechatURL];
        }
    } else if (_bookId > 0) {
        if (_isCloudPayment == 2) {
            [self cloudPayCostInfo:@{@"book_id":@(_bookId),@"device_type":_selectPayMethod == 1 ? @(8) : @(5)} urlStr:cloudPay_reserve_payURL];
            return;
        }
        if (_selectPayMethod == 1) {
            [self alipayDateInfo:@{@"book_id":@(_bookId)} urlStr:reserve_alipayURL];
        } else {
            [self wxpayDateInfo:@{@"book_id":@(_bookId)} urlStr:reserve_wechatURL];
        }
    }
}

- (void)cloudPayCostInfo:(NSDictionary *)param urlStr:(NSString *)url
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseApiURL urlPath:url parameters:param type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.merOrderDate = [NSDate getNowDateNOXianStr];
            self.pay_sn = NONullString([dic valueForKey:@"pay_sn"]);
            NSLog(@"======%@",self.merOrderDate);
            if (_selectPayMethod == 1) {
                if (!IsStrEmpty([dic valueForKey:@"path"])) {
                    NSArray *pathQueryArr = [[dic valueForKey:@"path"] componentsSeparatedByString:@"?"];
                    if (pathQueryArr.count > 1) {
                        NSString *urlStr = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=%@&page=%@&query=%@",NONullString([dic valueForKey:@"appId"]),NONullString(pathQueryArr[0]),NONullString([dic valueForKey:@"query"])];
                        NSLog(@"======%@",urlStr);
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
                    }
                }
//                NSString *urlStr = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=%@&page=%@&query=%@",NONullString([dic valueForKey:@"appId"]),NONullString([dic valueForKey:@"path"]),NONullString([dic valueForKey:@"query"])];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
            } else {
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

- (void)alipayDateInfo:(NSDictionary *)param urlStr:(NSString *)url
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:url parameters:param type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            NSString *orderString = dic[@"order_string"];
            [[AlipaySDK  defaultService] payOrder:orderString fromScheme:@"huijia" callback:^(NSDictionary *resultDic) {
                if ([resultDic[@"resultStatus"] integerValue] == 9000 ) {
                    [self createNotificationCenterInfo];
                } else {
                    [MBProgressHUD showMessag:@"支付失败" toView:self.view];
                }
            }];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)wxpayDateInfo:(NSDictionary *)param urlStr:(NSString *)url
{
    // 需要判断是否安装微信
    BOOL wxIsInstalled = [WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi];
    if (!wxIsInstalled) {
        [MBProgressHUD showMessag:@"请安装微信" toView:self.view];
        return;
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:url parameters:param type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
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
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

// 微信支付回调结果delegate
- (void)weiXinPayNotification:(NSInteger)errCode message:(NSString *)info
{
    if (errCode == 0) {
        [self createNotificationCenterInfo];
    } else if (errCode == 600) {
        [self getPayStatusMethod];
    } else {
        [MBProgressHUD showMessag:@"支付失败" toView:self.view];
    }
    
}

// 支付宝走客户端回调
- (void)alipayNotificationAction:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    if ([dic[@"resultStatus"] integerValue] == 9000) {
        [self createNotificationCenterInfo];
    } else {
        [MBProgressHUD showMessag:@"支付失败" toView:self.view];
    }
}

- (void)createNotificationCenterInfo
{
    if (_bookId > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HouseApplyNotification" object:nil userInfo:_houseDetailModel.mj_keyValues];
    }
    CommitReserveViewController *vc = [CommitReserveViewController new];
    vc.successType = PaySuccessType;
    [self.navigationController pushViewController:vc animated:YES];
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
        if (_b_id > 0) {
            [self getPaymentStatusInfo:cloudPayCost_cloudPay_getPaymentStatusURL pay_sn:_pay_sn merOrderDate:_merOrderDate];
        } else if (_bookId > 0) {
            [self getPaymentStatusInfo:cloudPay_reserve_statusURL pay_sn:_pay_sn merOrderDate:_merOrderDate];
        }
        _merOrderDate = @"";
        _pay_sn = @"";
    }
}

- (void)getPaymentStatusInfo:(NSString *)urlStr pay_sn:(NSString *)pay_sn merOrderDate:(NSString *)merOrderDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseApiURL urlPath:urlStr parameters:@{@"pay_sn":NONullString(pay_sn),@"merOrderDate":NONullString(merOrderDate)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            if ([[dic valueForKey:@"order_status"] integerValue] == 1 || [[dic valueForKey:@"order_status"] integerValue] == 3) {
                [self createNotificationCenterInfo];
            } else {
                [MBProgressHUD showMessag:@"支付失败" toView:self.view];
            }
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

@end
