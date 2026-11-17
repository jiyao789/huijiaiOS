//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"
@import WechatOpenSDK;

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}
 
#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        PayResp *response = (PayResp *)resp;
        if (self.delegate && [self.delegate respondsToSelector:@selector(weiXinPayNotification:message:)]) {
            [self.delegate weiXinPayNotification:response.errCode message:response.returnKey];
        }
    } else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(weiXinPayNotification:message:)]) {
            [self.delegate weiXinPayNotification:600 message:@""];
        }
    }
}

- (void)onReq:(BaseReq *)req {

}

@end
