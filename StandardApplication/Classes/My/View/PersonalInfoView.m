//
//  PersonalInfoView.m
//  smarthome
//
//  Created by DTiOS on 2021/8/18.
//  Copyright © 2021 Dev6. All rights reserved.
//

#import "PersonalInfoView.h"
#import "MacroDefine.h"

@implementation PersonalInfoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.commitBtn setBackgroundImage:[self setupBackgroundColor:[UIColor colorWithHexString:@"#6C9DFF"] toColor:[UIColor colorWithHexString:@"#2F72F6"] view:self.commitBtn] forState:UIControlStateNormal];
}

- (IBAction)cancelBtnClick:(id)sender
{
    if (self.personInfoCancelBlock) {
        self.personInfoCancelBlock();
    }
}

- (IBAction)commitBtnClick:(id)sender
{
    if (_nameTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入姓名" toView:nil];
        return;
    }
    if (_cardTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入身份证号" toView:nil];
        return;
    }
    
    [MBProgressHUD showStatus:nil toView:nil];
    [HttpRequest requestUrlPath:BaseURL urlPath:setting_profileURL parameters:@{@"name":_nameTextField.text,@"card":_cardTextField.text} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:nil];
        if (status == 1) {
            SAFE_BLOCK(self.personInfoCommitBlock);
        } else {
            [MBProgressHUD showMessag:msg toView:nil];
        }
    }];
}

- (UIImage *)setupBackgroundColor:(UIColor *)fromColor toColor:(UIColor *)toColor view:(UIView *)view
{
    CGRect viewFrame = view.frame;
    UIView *barBackgroundView = [[UIView alloc]initWithFrame:viewFrame];
    [barBackgroundView.layer addSublayer:[UIColor setGradualChangingColor:barBackgroundView fromColor:fromColor toColor:toColor]];
    UIImage *image = [UIImage convertViewToImage:barBackgroundView];
    return image;
}

@end
