//
//  ModifyNickNameViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ModifyNickNameViewController.h"
#import "MacroDefine.h"

@interface ModifyNickNameViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@end

@implementation ModifyNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"修改用户名";
    
    _viewLayoutTop.constant = NAVBAR_HEIGHT + 30;
}

- (IBAction)saveBtnClick:(id)sender
{
    if (_nickNameTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入用户名" toView:self.view];
        return;
    }
    if (self.saveNickNameBlock) {
        self.saveNickNameBlock(_nickNameTextField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
