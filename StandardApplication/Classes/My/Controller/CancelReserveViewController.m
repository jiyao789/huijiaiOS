//
//  CancelReserveViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "CancelReserveViewController.h"
#import "MacroDefine.h"

@interface CancelReserveViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet UILabel *showTitleLab;
@end

@implementation CancelReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"取消成功";
    self.gk_interactivePopDisabled = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F9FE"];
    
    _viewLayoutTop.constant = NAVBAR_HEIGHT + 70;
    
    _showTitleLab.text = _showText;
}

- (void)backAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backHomeBtnClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
