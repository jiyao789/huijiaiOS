//
//  User.h
//  EnjoyOilBao
//
//  Created by yiye on 2018/10/26.
//  Copyright © 2018 yiye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (copy, nonatomic) NSString *deviceId;

@property (assign, nonatomic) NSInteger fontIndex;

+ (User *)shareUser;

- (void)saveToken:(NSString *)authorization;
- (NSString *)token;
- (void)removeToken;

- (void)saveMobile:(NSString *)mobile;
- (NSString *)getMobile;
- (void)removeMobile;

- (void)recodeBeginShare;
- (void)recodeFinishShare;
- (NSString *)getRecodeShare;

- (void)saveUserId:(NSString *)userId;
- (NSString *)getUserId;
- (void)removeUserId;

- (void)saveApp_key:(NSString *)app_key;
- (NSString *)getApp_key;
- (void)removeApp_key;

// 保存当前token
- (void)saveRecodeToken:(NSString *)recodeToken;
- (NSString *)getRecodeToken;
- (void)removeRecodeToken;

- (void)setBillboards:(NSArray *)array;
- (NSArray *)billboards;

@end

