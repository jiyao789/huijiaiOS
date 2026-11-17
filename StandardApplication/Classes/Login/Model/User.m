//
//  User.m
//  EnjoyOilBao
//
//  Created by yiye on 2018/10/26.
//  Copyright © 2018 yiye. All rights reserved.
//

#import "User.h"
#define KHaveLogin    @"KHaveLogin"
#import "User.h"
#import "MacroDefine.h"
#import <SDWebImageDownloader.h>
#import "VideoDownLoadManager.h"

@interface User ()

@property (nonatomic, strong) NSArray * billboardArray;
@property (nonatomic, assign) NSInteger index;

@end

@implementation User

static User *instance = nil;

+ (User *)shareUser
{
    if (!instance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[super allocWithZone:NULL] init];
        });
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareUser];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init {
    if (instance) {
        return instance;
    }
    self = [super init];
    return self;
}
- (NSString *)deviceId
{
    if ([_deviceId length] == 0)
    {
        return @"cannotgetdeviceid";
    }
    return _deviceId;
}

- (void)saveToken:(NSString *)authorization
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:authorization forKey:@"authorization"];
    [userDefaults synchronize];
}

- (NSString *)token
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"authorization"];
    return [token length] ? token : @"";
}

- (void)removeToken
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"authorization"];
    [userDefaults synchronize];
}

- (void)removeUserInfo
{
    [self removeKey:@"mobile"];
    [self removeKey:@"authorization"];
}
- (void)saveMobile:(NSString *)mobile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:mobile forKey:@"mobile"];
    [userDefaults synchronize];
}

- (NSString *)getMobile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"mobile"];
}

- (void)removeMobile
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"mobile"];
    [userDefaults synchronize];
}

- (void)removeKey:(NSString *)key
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

- (void)recodeBeginShare
{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IS_SHARE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)recodeFinishShare
{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"IS_SHARE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getRecodeShare
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"IS_SHARE"];
}

- (void)saveUserId:(NSString *)userId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [userDefaults synchronize];
}
- (NSString *)getUserId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"userId"];
}
- (void)removeUserId
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"userId"];
    [userDefaults synchronize];
}

- (void)saveApp_key:(NSString *)app_key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",app_key] forKey:@"app_key"];
    [userDefaults synchronize];
}
- (NSString *)getApp_key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"app_key"];
}
- (void)removeApp_key
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"app_key"];
    [userDefaults synchronize];
}

- (void)saveRecodeToken:(NSString *)recodeToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:recodeToken forKey:@"recodeToken"];
    [userDefaults synchronize];
}

- (NSString *)getRecodeToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"recodeToken"];
}

- (void)removeRecodeToken
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"recodeToken"];
    [userDefaults synchronize];
}

@end
