//
//  LockSelectViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2024/9/2.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "LockSelectViewController.h"
#import "MacroDefine.h"
#import "LockListViewController.h"

@interface LockSelectViewController ()
@property (weak, nonatomic) IBOutlet UIView *elecLockView;
@property (weak, nonatomic) IBOutlet UIView *carLockView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;

@end

@implementation LockSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"锁选择";
    _topLayoutConstraint.constant = NAVBAR_HEIGHT + 30;
    
    [_elecLockView whenTapped:^{
        LockListViewController *vc = [LockListViewController new];
        vc.lock_type = 2;
        [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
    }];

    [_carLockView whenTapped:^{
        LockListViewController *vc = [LockListViewController new];
        vc.lock_type = 7;
        [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_elecLockView.layer insertSublayer:[UIColor setGradualChangingColor:_elecLockView fromColor:[UIColor colorWithHexString:@"#317DD8"] toColor:[UIColor colorWithHexString:@"#5FB4EE"]] atIndex:0];
    [_carLockView.layer insertSublayer:[UIColor setGradualChangingColor:_carLockView fromColor:[UIColor colorWithHexString:@"#317DD8"] toColor:[UIColor colorWithHexString:@"#5FB4EE"]] atIndex:0];
}


@end
