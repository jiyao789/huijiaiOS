//
//  LogoutSuccessViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2024/9/25.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "LogoutSuccessViewController.h"
#import "MacroDefine.h"
#import "SettingViewController.h"

@interface LogoutSuccessViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLayoutTop;

@end

@implementation LogoutSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self leftBarItem];
    self.navTitle = @"申请注销账号";
    _labelLayoutTop.constant = NAVBAR_HEIGHT + 30;
}

- (void)backAction
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SettingViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

@end
