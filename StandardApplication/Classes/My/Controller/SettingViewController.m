//
//  SettingViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2022/1/19.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "SettingViewController.h"
#import "MacroDefine.h"
#import <SDWebImage/SDImageCache.h>
#import "ProtocolBaseWKWebViewController.h"
#import "AccountLogoutViewController.h"
#import "PersonalInfoDetailsViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopLayout;
@property (weak, nonatomic) IBOutlet UILabel *versionNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabe;
@property (weak, nonatomic) IBOutlet UIView *cacheView;
@property (weak, nonatomic) IBOutlet UIView *userProtocalView;
@property (weak, nonatomic) IBOutlet UIView *prrivateProtocolView;
@property (weak, nonatomic) IBOutlet UIView *userSummaryView;
@property (weak, nonatomic) IBOutlet UIView *privacySummaryView;
@property (weak, nonatomic) IBOutlet UIView *personalInfoListView;
@property (weak, nonatomic) IBOutlet UIButton *accountCancelBtn;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"设置";
    
    _viewTopLayout.constant = NAVBAR_HEIGHT + 20;
    
    NSString *currentVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    _versionNumberLab.text = [NSString stringWithFormat:@"V%@",currentVersion];
    
    NSUInteger intg = [SDImageCache sharedImageCache].totalDiskSize;
    _cacheLabe.text =  [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:intg]];
    
    KWeakSelf
    [_cacheView whenTapped:^{
        KStrongSelf(weakSelf)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[SDImageCache sharedImageCache] clearWithCacheType:SDImageCacheTypeDisk completion:nil];
            strongSelf.cacheLabe.text = @"0B";
        }];
        [action1 setValue:[UIColor colorWithHex:@"#999999"] forKey:@"titleTextColor"];
        [alert addAction:action1];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [action2 setValue:[UIColor colorWithHexString:@"#2C6DB0"] forKey:@"titleTextColor"];
        [alert addAction:action2];
        [strongSelf presentViewController:alert animated:YES completion:nil];
    }];
    
    [_userProtocalView whenTapped:^{
        [weakSelf pushProtocalInfo:@"10"];
    }];
    
    [_prrivateProtocolView whenTapped:^{
        [weakSelf pushProtocalInfo:@"11"];
    }];

    // 用户协议摘要点击
    [_userSummaryView whenTapped:^{
        // 复用“用户协议”的类型标识（假设摘要和全文指向同一个后端解析ID，或你有新的ID）
        [weakSelf pushProtocalInfo:@"10"]; 
    }];
    
    // 隐私政策摘要点击
    [_privacySummaryView whenTapped:^{
        // 复用“隐私政策”的类型标识
        [weakSelf pushProtocalInfo:@"11"];
    }];

    // 个人信息收集清单点击

    [_personalInfoListView whenTapped:^{
        PersonalInfoDetailsViewController *vc = [[PersonalInfoDetailsViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    if (!IsStrEmpty([User shareUser].token)) {
        [self getLogoutDetailData];
    }
}

- (void)pushProtocalInfo:(NSString *)type
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestNewsInfoData:type result:^(NewsInfoModel * _Nonnull model, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (!IsNilOrNull(model)) {
            ProtocolBaseWKWebViewController *webVc = [[ProtocolBaseWKWebViewController alloc] init];
            webVc.webTitle = NONullString(model.title);
            webVc.webUrl = NONullString(model.file_url);
            [self.navigationController pushViewController:webVc animated:YES];
        }
    }];
}

- (void)getLogoutDetailData
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:logout_detailURL parameters:@{@"u_id": NONullString([User shareUser].getUserId)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            _accountCancelBtn.hidden = [[dic valueForKey:@"switch"] intValue] == 1 ? NO : YES;
            [_accountCancelBtn setTitle:[[dic valueForKey:@"logout"] intValue] == 1 ? @"账号注销已提交" : @"账号注销" forState:UIControlStateNormal];
            _accountCancelBtn.userInteractionEnabled = [[dic valueForKey:@"logout"] intValue] == 1 ? NO : YES;
        } else if (status != 2) {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

//计算出大小
- (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

- (IBAction)accountCancelBtnClick:(id)sender 
{
    [self.navigationController pushViewController:[AccountLogoutViewController new] animated:YES];
}


@end
