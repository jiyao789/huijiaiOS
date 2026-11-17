//
//  AccountLogoutViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2024/9/25.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "AccountLogoutViewController.h"
#import "MacroDefine.h"
#import "LogoutSuccessViewController.h"

@interface AccountLogoutViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (assign, nonatomic) BOOL checkProtocal;
@end

@implementation AccountLogoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"申请注销账号";
    _viewLayoutTop.constant = NAVBAR_HEIGHT;
    _checkProtocal = NO;
}

- (IBAction)agreementBtnClick:(id)sender
{
    _checkProtocal = !_checkProtocal;
    NSString *imageStr = _checkProtocal ? @"login_check_img" : @"login_check_noselect_img";
    [_agreementBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
}


- (IBAction)commitLogoutClick:(id)sender
{
    if (!_checkProtocal) {
        [MBProgressHUD showMessag:@"请确认阅读并同意" toView:self.view];
        return;
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:account_cancellationURL parameters:@{@"u_id": NONullString([User shareUser].getUserId)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            [self.navigationController pushViewController:[LogoutSuccessViewController new] animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}


@end
