//
//  LifeMyNaviView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "LifeMyNaviView.h"
#import "CommunityActivityListViewController.h"
#import "NoticeShowView.h"

@implementation LifeMyNaviView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)messageBtnClick:(id)sender
{
    [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
        
        [MBProgressHUD showStatus:nil toView:nil];
        [HttpRequest requestUrlPath:BaseURL urlPath:activity_listURL parameters:@{@"type":@(1),@"page":@(1),@"page_rows":@"10"} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
            [MBProgressHUD dismissWithView:nil];
            if (status == 1 || status == 2) {
                CommunityActivityListViewController *vc = [CommunityActivityListViewController new];
                vc.type = 1;
                vc.titleStr = @"红色社区";
                [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
            } else if (status == 400) {
                [self showNoticeShowView:msg];
            } else {
                [MBProgressHUD showMessag:msg toView:nil];
            }
        }];
    }];
}

- (void)showNoticeShowView:(NSString *)message
{
    NoticeShowView *noticeShowView = [NoticeShowView createViewFromNib];
    noticeShowView.noticeLab.text = NONullString(message);
    noticeShowView.frame = CGRectMake(0, 0, 260, 145);
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:noticeShowView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    noticeShowView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [[CommonUtils getCurrentViewController] presentViewController:alertController animated:YES completion:nil];
}

@end
