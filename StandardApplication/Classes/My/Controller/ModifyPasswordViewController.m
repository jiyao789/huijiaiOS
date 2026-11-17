//
//  ModifyPasswordViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2022/8/3.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "MacroDefine.h"
#import "IOSmd5.h"

@interface ModifyPasswordViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkTextField;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"修改密码";
    
    _viewLayoutTop.constant = NAVBAR_HEIGHT + 30;
}

- (IBAction)saveBtnClick:(id)sender
{
    if (_passwordTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入密码" toView:self.view];
        return;
    }
    if (_checkTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请再次输入密码" toView:self.view];
        return;
    }
    if (_passwordTextField.text.length < 8) {
        [MBProgressHUD showMessag:@"8位以上、至少字母、数字、符号等混合组成" toView:self.view];
        return;
    }
    if (![_passwordTextField.text isEqualToString: _checkTextField.text]) {
        [MBProgressHUD showMessag:@"与第一次输入的密码不一致，请重新输入" toView:self.view];
        return;
    }
    
    if (![CommonUtils isValidatePwd:_passwordTextField.text]) {
        [MBProgressHUD showMessag:@"8位以上、至少字母、数字、符号等混合组成" toView:self.view];
        return;
    }
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:setting_change_pwdURL parameters:@{@"pwd":[IOSmd5 md5:NONullString(_passwordTextField.text)],@"repeat_pwd":[IOSmd5 md5:NONullString(_checkTextField.text)]} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            [[User shareUser] saveUserId:NONullString(dic[@"u_id"])];
            [MBProgressHUD showMessag:@"修改成功" toView:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

@end
