//
//  MyNaviView.m
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "MyNaviView.h"
#import "MessageViewController.h"
#import "MessageIndexModel.h"

@implementation MyNaviView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _messageBtn.imagePosition = QMUIButtonImagePositionTop;
    _messageBtn.spacingBetweenImageAndTitle = 2;
    
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
        weakSelf.noReadLab.text = [NSString stringWithFormat:@"  %@  ",dic[@"mark"]];
    }];
}

- (void)getMessageDate
{
    [HttpRequest requestUrlPath:BaseURL urlPath:appMessage_indexURL parameters:@{@"page":@(1),@"page_rows":@"1"} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            MessageIndexModel *messageIndexModel = [MessageIndexModel mj_objectWithKeyValues:dic[@"list"]];
            self.noReadLab.hidden = messageIndexModel.mark == 0 ? YES : NO;
            self.noReadLab.text = [NSString stringWithFormat:@"  %ld  ",(long)messageIndexModel.mark];
        } else {
            self.noReadLab.hidden = YES;
        }
    }];
}

- (IBAction)messageBtnClick:(id)sender
{
    [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
        MessageViewController *vc = [MessageViewController new];
        [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
    }];
}

@end
