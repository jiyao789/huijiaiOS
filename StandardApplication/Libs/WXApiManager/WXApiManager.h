//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
@import WechatOpenSDK;
 
@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)weiXinPayNotification:(NSInteger)errCode message:(NSString *)info;

@end

@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;

@end
