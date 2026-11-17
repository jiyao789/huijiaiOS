//
//  OpenCarLockViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2024/9/3.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "OpenCarLockViewController.h"
#import "MacroDefine.h"
#import "LockDetailModel.h"
#import <TTLock/TTLock.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface OpenCarLockViewController ()<CBCentralManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *carLockNameLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopLayout;
@property (weak, nonatomic) IBOutlet UIScrollView *carScrollView;

@property (strong, nonatomic)LockDetailModel *lockDetailModel;
@property (strong, nonatomic)CBCentralManager *bluetoothManager;
@end

@implementation OpenCarLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    self.scrollViewTopLayout.constant = 0;
    self.navBackgroundColor = [UIColor clearColor];
    self.hideNavLine = YES;
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E2EFFC"];
    adjustsScrollViewInsets_NO(_carScrollView, self);
    [self setupBarButtomItemWithImageName:@"white_back_icon" highLightImageName:@"white_back_icon" selectedImageName:@"white_back_icon" target:self action:@selector(backEvent) leftOrRight:YES];
    
    if (_isNeedNet) {
        [self getLockDeviceInfoDate:YES];
    } else {
        [self getContractRefreshStatusInfoDate];
    }
    
    [self detectBluetooth];
}

- (void)backEvent
{
    [self.navigationController popViewControllerAnimated:YES];
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
            
            if (isNeedNet) {
                // 更新门锁刷新完成
                [self getContractRefreshEndInfoDate];
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

    _carLockNameLab.text = NONullString(_lockDetailModel.bind_name);
    
}


- (IBAction)carLockButtonClick:(UIButton *)sender
{
    [TTLock setPrintLog:YES];
    NSLog(@"蓝牙状态 == %ld",(long)self.bluetoothManager.state);
    [TTLock setupBluetooth:nil];

    KWeakSelf
    if (weakSelf.bluetoothManager.state == CBManagerStateUnauthorized || weakSelf.bluetoothManager.state == CBManagerStatePoweredOff) {
        [weakSelf noticeOpenSystemBlue];
    } else if (weakSelf.bluetoothManager.state == CBManagerStatePoweredOn) {
        [weakSelf goOpenLock:sender.tag];  //开锁
        [weakSelf getLockRecord];   //获取最新开锁记录上传服务器
    }
}

// 开锁
- (void)goOpenLock: (NSInteger)status
{
    KWeakSelf
    [MBProgressHUD showStatus:nil toView:self.view];
    [TTLock controlLockWithControlAction:(status == 0 ? TTControlActionLock : TTControlActionUnlock) lockData:NONullString(_lockDetailModel.lock_data) success:^(long long lockTime, NSInteger electricQuantity, long long uniqueId) {
        [MBProgressHUD dismissHUDForView:weakSelf.view];
        
    } failure:^(TTError errorCode, NSString *errorMsg) {
        [MBProgressHUD dismissHUDForView:weakSelf.view];
        [MBProgressHUD showMessag:errorMsg toView:weakSelf.view];
        NSDictionary *errDic = @{@"errorCode":@(errorCode),@"errorMsg":errorMsg};
        [weakSelf getLockErrorRecords:[errDic mj_JSONString]];
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

@end
