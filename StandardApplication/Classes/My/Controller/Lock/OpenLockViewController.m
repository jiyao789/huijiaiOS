//
//  OpenLockViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/29.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "OpenLockViewController.h"
#import "MacroDefine.h"
#import "LockDetailModel.h"
#import <TTLock/TTLock.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface OpenLockViewController ()<CBCentralManagerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLayoutTop;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *houseTimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *lockBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lockImageView;
@property (weak, nonatomic) IBOutlet UILabel *lockStatusLab;
@property (weak, nonatomic) IBOutlet UILabel *doorStatusLab;
@property (weak, nonatomic) IBOutlet QMUIButton *batteryButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonLayoutTop;

@property (strong, nonatomic)LockDetailModel *lockDetailModel;
@property (strong, nonatomic) CBCentralManager *bluetoothManager;
@property (assign, nonatomic) NSInteger againCount;
@end

@implementation OpenLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"门锁信息";

    self.view.backgroundColor = [UIColor colorWithHexString:@"#1A2434"];
    self.labelLayoutTop.constant = NAVBAR_HEIGHT + 100;
    self.buttonLayoutTop.constant = NAVBAR_HEIGHT + 22;
    self.batteryButton.imagePosition = QMUIButtonImagePositionTop;
    self.batteryButton.spacingBetweenImageAndTitle = 3;
    
    if (_isNeedNet) {
        [self getLockDeviceInfoDate:YES];
    } else {
        [self getContractRefreshStatusInfoDate];
    }
    
    _againCount = 0;
    
    KWeakSelf
    [_lockImageView whenTapped:^{
        [weakSelf setupLockInfo];
    }];
    
    [self detectBluetooth];
}

- (void)detectBluetooth
{
    if(!self.bluetoothManager)
    {
        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    [self centralManagerDidUpdateState:self.bluetoothManager];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (self.bluetoothManager.state) {
        case CBManagerStateUnknown:
        {
            [MBProgressHUD showMessag:@"蓝牙未知状态，即将更新" toView:self.view];
            break;
        }
        case CBManagerStateResetting:
        {
            [MBProgressHUD showMessag:@"蓝牙与系统服务链接失败，即将更新" toView:self.view];
            break;
        }
        case CBManagerStateUnsupported:
        {
            [MBProgressHUD showMessag:@"手机不支持蓝牙" toView:self.view];
            break;
        }
        case CBManagerStateUnauthorized:
        {
            [self noticeOpenSystemBlue];
            break;
        }
        case CBManagerStatePoweredOff:
        {
            [self noticeOpenSystemBlue];
            break;
        }
        default:
            break;
    }
}

// 判断是否要更新门锁数据
- (void)getContractRefreshStatusInfoDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:contract_refresh_statusURL parameters:@{@"unit_id":@(_unit_id)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            if ([dic[@"refresh_hardware"] integerValue] == 1) {
                [self getLockDeviceInfoDate:YES];
            } else {
                [self getLockDeviceInfoDate:NO];
            }
        } else {
            [self getLockDeviceInfoDate:NO];
        }
    }];
}

// 获取门锁数据
- (void)getLockDeviceInfoDate:(BOOL)isNeedNet
{
//    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest cacheResponseObject:HardwareBaseURL urlPath:lock_device_infoURL parameters:@{@"device_id":NONullString(_device_id),@"username":NONullString([User shareUser].getMobile),@"app_key":NONullString([User shareUser].getApp_key)} isNeedNet:isNeedNet type:HttpRequestTypeGet result:^(id  _Nonnull objs, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.lockDetailModel = [LockDetailModel mj_objectWithKeyValues:objs];
            [self getLockKeySearchInfoDate:isNeedNet];
            
            if (isNeedNet) {
                // 更新门锁刷新完成
                [self getContractRefreshEndInfoDate];
            }
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

// 获取门锁有效期
- (void)getLockKeySearchInfoDate:(BOOL)isNeedNet
{
    [HttpRequest cacheResponseObject:HardwareBaseURL urlPath:lock_key_search_keyURL parameters:@{@"device_id":NONullString(_device_id),@"app_key":NONullString([User shareUser].getApp_key),@"username":NONullString([User shareUser].getMobile)} isNeedNet:isNeedNet type:HttpRequestTypeGet result:^(id  _Nonnull objs, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            if ([objs isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)objs;
                self.houseTimeLab.text = [NSString stringWithFormat:@"%@-%@",NONullString(dic[@"start_at"]),NONullString(dic[@"end_at"])];
            }
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

// 门锁刷新完成
- (void)getContractRefreshEndInfoDate
{
    [HttpRequest requestUrlPath:BaseURL urlPath:contract_refresh_endURL parameters:@{} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        
    }];
}

- (void)setLockDetailModel:(LockDetailModel *)lockDetailModel
{
    _lockDetailModel = lockDetailModel;

    _houseNameLab.text = NONullString(_lockDetailModel.bind_name);
    [_batteryButton setTitle:[NSString stringWithFormat:@"%ld%@",(long)_lockDetailModel.electric_quantity,@"%"] forState:UIControlStateNormal];
    [TTLock getElectricQuantityWithLockData:NONullString(_lockDetailModel.lock_data) success:^(NSInteger electricQuantity) {
        [_batteryButton setTitle:[NSString stringWithFormat:@"%ld%@",(long)electricQuantity,@"%"] forState:UIControlStateNormal];
    } failure:^(TTError errorCode, NSString *errorMsg) {
        [_batteryButton setTitle:[NSString stringWithFormat:@"%ld%@",(long)_lockDetailModel.electric_quantity,@"%"] forState:UIControlStateNormal];
    }];
}

- (void)setupLockInfo
{
    [TTLock setPrintLog:YES];
    NSLog(@"蓝牙状态 == %ld",(long)self.bluetoothManager.state);
    [TTLock setupBluetooth:nil];

    KWeakSelf
    if (weakSelf.bluetoothManager.state == CBManagerStateUnauthorized || weakSelf.bluetoothManager.state == CBManagerStatePoweredOff) {
        [weakSelf noticeOpenSystemBlue];
    } else if (weakSelf.bluetoothManager.state == CBManagerStatePoweredOn) {
        [weakSelf goOpenLock];  //开锁
        [weakSelf getLockRecord];   //获取最新开锁记录上传服务器
    }
}

- (void)noticeOpenSystemBlue
{
    //通知没有打开蓝牙的自定义提示弹窗（弹窗代码自行实现）
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"“憓家”需要您的蓝牙功能用于智能门锁，对锁进行扫描开关操作，请前往设置打开蓝牙" preferredStyle:(UIAlertControllerStyleAlert)];
    
    // 是否跳转到蓝牙界面()
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"前往设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }];
    // 创建按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 开锁
- (void)goOpenLock
{
    KWeakSelf
    [MBProgressHUD showStatus:nil toView:self.view];
    [TTLock controlLockWithControlAction:TTControlActionUnlock lockData:NONullString(_lockDetailModel.lock_data) success:^(long long lockTime, NSInteger electricQuantity, long long uniqueId) {
        [MBProgressHUD dismissHUDForView:weakSelf.view];
        [weakSelf lockIsOpen];
        [weakSelf performSelector:@selector(autoLock) withObject:nil afterDelay:3.5];
    } failure:^(TTError errorCode, NSString *errorMsg) {
        [MBProgressHUD dismissHUDForView:weakSelf.view];
        if ((errorCode == TTErrorEkeyInactive || errorCode == TTErrorEkeyExpired) && _againCount < 3) {
            [weakSelf updateLockWithTime:YES];
        } else {
            [MBProgressHUD showMessag:errorMsg toView:weakSelf.view];
        }
        NSDictionary *errDic = @{@"errorCode":@(errorCode),@"errorMsg":errorMsg};
        [weakSelf getLockErrorRecords:[errDic mj_JSONString]];
    }];
}

// 校准锁时间
- (void)updateLockWithTime:(BOOL)isNeedAgainOpen
{
    KWeakSelf
    [MBProgressHUD showStatus:nil toView:self.view];
    [TTLock setLockTimeWithTimestamp:[[self getNowTimeTimestamp] longLongValue] lockData:NONullString(_lockDetailModel.lock_data) success:^{
        [MBProgressHUD dismissHUDForView:weakSelf.view];
        if (isNeedAgainOpen) {
            weakSelf.againCount ++;
            [weakSelf goOpenLock];
        }
    } failure:^(TTError errorCode, NSString *errorMsg) {
        [MBProgressHUD dismissHUDForView:weakSelf.view];
        [MBProgressHUD showMessag:errorMsg toView:weakSelf.view];
    }];
}

// 上传开锁失败原因
- (void)getLockErrorRecords:(NSString *)errContent
{
    [HttpRequest requestUrlPath:HardwareBaseURL urlPath:lock_error_recordsURL parameters:@{@"app_key":NONullString([User shareUser].getApp_key),@"lock_id":NONullString(_device_id),@"content":NONullString(errContent)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        
    }];
}

// 获取最新开锁记录
- (void)getLockRecord
{
    [TTLock getOperationLogWithType:TTOperateLogTypeLatest lockData:NONullString(_lockDetailModel.lock_data) success:^(NSString *operateRecord) {
        [self postLockRecord:operateRecord];
        NSLog(@"获取开锁记录 == %@", operateRecord);
     } failure:^(TTError errorCode, NSString *errorMsg) {
         NSLog(@"获取开锁记录失败 == %@", errorMsg);
     }];
}

// 上传开锁记录
- (void)postLockRecord:(NSString *)records
{
    [HttpRequest requestUrlPath:HardwareBaseURL urlPath:lock_device_upload_open_recordsURL parameters:@{@"app_key":NONullString([User shareUser].getApp_key),@"device_id":NONullString(_device_id),@"records":NONullString(records),@"username":NONullString([User shareUser].getMobile)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        
    }];
}

// 延迟自动上锁
- (void)autoLock
{
    [self lockIsClose];
}

- (void)lockIsOpen
{
    _lockBgImageView.tag = 1;
    _lockBgImageView.image = [UIImage imageNamed:@"lock_open_bg_img"];
    _lockImageView.image = [UIImage imageNamed:@"lock_open_img"];
    _lockStatusLab.text = @"请下压门把手开锁";
    _doorStatusLab.textColor = [UIColor colorWithHexString:@"#B79965"];
    _doorStatusLab.text = @"已开锁";
}

- (void)lockIsClose
{
    _lockBgImageView.tag = 0;
    _lockBgImageView.image = [UIImage imageNamed:@"lock_close_bg_img"];
    _lockImageView.image = [UIImage imageNamed:@"lock_close_img"];
    _lockStatusLab.text = @"点击开锁";
    _doorStatusLab.textColor = [UIColor colorWithHexString:@"#2A6299"];
    _doorStatusLab.text = @"门已反锁";
}

//获取当前时间戳 （以毫秒为单位）
-(NSString *)getNowTimeTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"en_China"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}

@end
