//
//  LoginViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/18.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "LoginViewController.h"
#import "MacroDefine.h"
#import "JKCountDownButton.h"
#import "ProtocolBaseWKWebViewController.h"
#import <sys/utsname.h>
#import "ECUUIDTool.h"
#import "IOSmd5.h"
#import "SecondConfirmView.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet JKCountDownButton *checkCodeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkCodeBtnLayoutWidth;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *privacyInfoLab;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkProtocalBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (strong, nonatomic) NSString *platformString;
@property (assign, nonatomic) NSInteger changeIndex;
@property (assign, nonatomic) BOOL checkProtocal;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.naviBarAlpha = 0;
    [self leftBarItem];
    _changeIndex = 1;
    _checkProtocal = NO;
    
    KWeakSelf
    [_userInfoLab whenTapped:^{
        [weakSelf pushUserAgreement];
    }];
    
    [_privacyInfoLab whenTapped:^{
        [weakSelf pushProtocalInfo:@"11"];
    }];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    _platformString = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
}

- (void)pushUserAgreement
{
    ProtocolBaseWKWebViewController *webVc = [[ProtocolBaseWKWebViewController alloc] init];
    webVc.webTitle = @"用户协议";
    webVc.webUrl = @"https://docs.qq.com/doc/DTWRuVG9hSWJvY0J5";
    [self.navigationController pushViewController:webVc animated:YES];
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

- (IBAction)getCodeBtnClick:(id)sender
{
    if (_iphoneTextField.text.length != 11) {
        [MBProgressHUD showMessag:@"请输入正确手机号" toView:self.view];
        return;
    }
    if (!_checkProtocal) { 
        [MBProgressHUD showMessag:@"获取验证码，请先阅读并同意《用户协议》与《隐私政策》" toView:self.view];
        return; 
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:login_smsURL parameters:@{@"phone":NONullString(_iphoneTextField.text),@"use_type":@"1"} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:self.view];
        if (status == 1 || status == 2) {
            _checkCodeBtn.userInteractionEnabled = NO;
            [MBProgressHUD showMessag:@"验证码已发送" toView:self.view];
            [_checkCodeBtn startCountDownWithSecond:60];
            
            [self.checkCodeBtn countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"%lu秒",(unsigned long)second];
                return title;
            }];
            [self.checkCodeBtn countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.userInteractionEnabled = YES;
                return @"重新获取";
                
            }];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (IBAction)changeBtnClick:(id)sender
{
    _changeIndex = _changeIndex == 1 ? 2 : 1;
    [_changeBtn setTitle:(_changeIndex == 1 ? @"使用账号密码登录" : @"使用短信验证码登录") forState:UIControlStateNormal];
    _codeTextField.placeholder = _changeIndex == 1 ? @"请输入验证码" : @"请输入密码";
    _codeTextField.keyboardType = _changeIndex == 1 ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
    _checkCodeBtnLayoutWidth.constant = _changeIndex == 1 ? 67 : 0;
    [_checkProtocalBtn setImage:[UIImage imageNamed:@"login_check_noselect_img"] forState:UIControlStateNormal];
    _checkProtocal = NO;
    _codeTextField.text = @"";
    _iphoneTextField.text = @"";
}

- (IBAction)checkProtocalBtnClick:(id)sender
{
    _checkProtocal = !_checkProtocal;
    NSString *imageStr = _checkProtocal ? @"login_check_img" : @"login_check_noselect_img";
    [_checkProtocalBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
}


- (IBAction)loginBtnClick:(id)sender
{
    if (_iphoneTextField.text.length != 11) {
        [MBProgressHUD showMessag:@"请输入正确手机号" toView:self.view];
        return;
    }
    if (_codeTextField.text.length == 0) {
        [MBProgressHUD showMessag:(_changeIndex == 1 ? @"请输入验证码" : @"请输入密码") toView:self.view];
        return;
    }
//    if (_changeIndex == 2 && _codeTextField.text.length < 8) {
//        [MBProgressHUD showMessag:@"8位以上、至少字母、数字、符号等混合组成" toView:self.view];
//        return;
//    }
//    if (_changeIndex == 2 && ![CommonUtils isValidatePwd:_codeTextField.text]) {
//        [MBProgressHUD showMessag:@"8位以上、至少字母、数字、符号等混合组成" toView:self.view];
//        return;
//    }
    if (!_checkProtocal) {
        [MBProgressHUD showMessag:@"登录憓家app，请先阅读并同意《用户协议》与《隐私政策》" toView:self.view];
        return;
    }
    NSString *urlStr = _changeIndex == 1 ? login_appURL : login_pwdURL;
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (_changeIndex == 1) {
        [para setObject:NONullString(_codeTextField.text) forKey:@"code"];
    } else {
        [para setObject:[IOSmd5 md5:NONullString(_codeTextField.text)] forKey:@"pwd"];
    }
    [para setObject:NONullString(_iphoneTextField.text) forKey:@"phone"];
    [para setObject:[NSString stringWithFormat:@"%@",[ECUUIDTool getUUIDInKeychain]] forKey:@"device_id"];
    [para setObject:NONullString(_platformString) forKey:@"device_model"];
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:urlStr parameters:para type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:self.view];
        if (status == 1) {
            [[User shareUser] saveToken:NONullString(dic[@"token"])];
            [[User shareUser] saveMobile:NONullString(dic[@"phone"])];
            [[User shareUser] saveUserId:NONullString(dic[@"u_id"])];
            if ([[dic valueForKey:@"hash"] integerValue] == 0 && [[dic valueForKey:@"not_again"] integerValue] == 0) {
                [self getAuthBaseAppKeyDate:YES];
            } else {
                [self getAuthBaseAppKeyDate:NO];
            }
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
            if ([msg containsString:@"此次登陆需授权"]) {
                self.tipLab.hidden = NO;
            }
        }
    }];
}

/// 保存硬件key
- (void)getAuthBaseAppKeyDate:(BOOL)isShowView
{
    [HttpRequest requestUrlPath:HardwareBaseURL urlPath:auth_base_appKeyURL parameters:@{} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            [[User shareUser] saveApp_key:[NSString stringWithFormat:@"%@",dic[@"app_key"]]];
        }
        [self reloadNaigationChildViewControllers];
        SAFE_BLOCK([CommonUtils sharedCommonUtils].loginSuccessBlock,[User shareUser].token, YES);
        if (isShowView) {
            [self showSecondComfirm];
        }
    }];
}

- (void)showSecondComfirm
{
    SecondConfirmView *secondConfirmView = [SecondConfirmView createViewFromNib];
    secondConfirmView.cancelBtnLayoutX.constant = -126;
    secondConfirmView.cancelBtn.hidden = YES;
    [secondConfirmView.commitBtn setTitle:@"确认" forState:UIControlStateNormal];
    secondConfirmView.titleLab.text = @"您已成功登录，可自行修改登录密码";
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:secondConfirmView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    KWeakSelf
    secondConfirmView.didConfirmBlock = ^{
        [weakSelf settingNoAgainDate];
        [alertController dismissViewControllerAnimated:YES];
    };
    secondConfirmView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = NO;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)settingNoAgainDate
{
    [HttpRequest requestUrlPath:BaseURL urlPath:setting_not_againURL parameters:@{} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1 || status == 2) {
            
        }
    }];
}

//操作视图栈
- (void)reloadNaigationChildViewControllers
{
    NSMutableArray <UIViewController *> * viewControllers = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
    [viewControllers removeLastObject];
    for (UIViewController *obj in viewControllers)
    {
        if ([NSStringFromClass(obj.class) isEqualToString:@"LoginViewController"])
        {
            [viewControllers removeObject:obj];
        }
    }
    [self.navigationController setViewControllers:viewControllers animated:NO];
}

@end
