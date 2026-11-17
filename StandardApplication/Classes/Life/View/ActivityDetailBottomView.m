//
//  ActivityDetailBottomView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/4.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ActivityDetailBottomView.h"
#import "MacroDefine.h"
#import "SecondConfirmView.h"
#import "ActivityCommitSuccessViewController.h"

@implementation ActivityDetailBottomView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _mobileTextField.text = NONullString([User shareUser].getMobile);
}

- (IBAction)commitBtnClick:(id)sender
{
    KWeakSelf
    [[CommonUtils sharedCommonUtils]judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
        if (!performLogin) {
            [weakSelf applyActivityBtn];
        } else {
            weakSelf.mobileTextField.text = NONullString([User shareUser].getMobile);
        }
    }];
    
}

- (void)applyActivityBtn
{
    if (IsStrEmpty(_nameTextField.text)) {
        [MBProgressHUD showMessag:@"请输入姓名" toView:nil];
        return;
    }
    if (IsStrEmpty(_mobileTextField.text)) {
        [MBProgressHUD showMessag:@"请输入手机号" toView:nil];
        return;
    }
    
    _activityListModel.name = _nameTextField.text;
    _activityListModel.phone = _mobileTextField.text;
    
    SecondConfirmView *secondConfirmView = [SecondConfirmView createViewFromNib];
    secondConfirmView.titleLab.text = @"是否确认预约报名该活动？";
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:secondConfirmView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    secondConfirmView.didConfirmBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
        [self activityCommitDate];
    };
    secondConfirmView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [[CommonUtils getCurrentViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)activityCommitDate
{
    [MBProgressHUD showStatus:nil toView:nil];
    [HttpRequest requestUrlPath:BaseURL urlPath:activity_applyURL parameters:@{@"act_id":@(_activityListModel.act_id),@"name":NONullString(_nameTextField.text),@"phone":NONullString(_mobileTextField.text)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:nil];
        if (status == 1 || status == 2) {
            ActivityCommitSuccessViewController *vc = [ActivityCommitSuccessViewController new];
            vc.activityListModel = _activityListModel;
            vc.type = 2;
            [self.navigation pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:nil];
        }
    }];
}

@end
