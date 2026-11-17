//
//  HomeNaviView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/18.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HomeNaviView.h"
#import "MessageViewController.h"
#import "SearchViewController.h"
#import "MessageIndexModel.h"

@implementation HomeNaviView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_searchView whenTapped:^{
        [[CommonUtils getCurrentViewController].navigationController pushViewController:[SearchViewController new] animated:YES];
    }];
    
    [_messageView whenTapped:^{
        [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
            MessageViewController *vc = [MessageViewController new];
            [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
        }];
    }];
    
    if (!IsStrEmpty([User shareUser].token)) {
        [self getMessageDate];
    }
    
    //接收通知
    KWeakSelf
    RACSignal *siganlCollect = [[NSNotificationCenter defaultCenter] rac_addObserverForName:@"MessageMarkNotification" object:nil];
    //设置接收通知的回调处理
    [siganlCollect subscribeNext:^(NSNotification *x) {
        NSLog(@"MessageMarkNotification == %@",x.userInfo);
        NSDictionary *dic = x.userInfo;
        weakSelf.noReadLab.hidden = [dic[@"mark"] integerValue] == 0 ? YES : NO;
    }];
}

- (void)layoutSubviews
{
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 44);
}

- (void)getMessageDate
{
    [HttpRequest requestUrlPath:BaseURL urlPath:appMessage_indexURL parameters:@{@"page":@(1),@"page_rows":@"1"} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            MessageIndexModel *messageIndexModel = [MessageIndexModel mj_objectWithKeyValues:dic[@"list"]];
            self.noReadLab.hidden = messageIndexModel.mark == 0 ? YES : NO;
        } else {
            self.noReadLab.hidden = YES;
        }
    }];
}

@end
