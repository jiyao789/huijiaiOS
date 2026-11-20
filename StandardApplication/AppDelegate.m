//
//  AppDelegate.m
//  StandardApplication
//
//  Created by DTiOS on 2019/4/2.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "AppDelegate.h"
#import "UINavigationController+GKCategory.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import "CommonUtils.h"
#import "User.h"
#import <IQKeyboardManager.h>
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>
#import <SDImageCache.h>
#import <SDWebImageDownloader.h>
#import "MBProgressHUD+Add.h"
#import "MacroDefine.h"
#import <Bugly/Bugly.h>
#import "ECLocationManager.h"
#import "SJVideoPlayer.h"
#import "ECUUIDTool.h"
#import "OpenPageManager.h"
@import WechatOpenSDK;
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
#import <TTLock/TTLock.h>

static NSString *const MapApiKey = @"40ec7df263df9014c185bcd45a4e8f03";

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

static void UncaughtExceptionHandler(NSException *exception) {
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *crashInfo = [NSString stringWithFormat:@"\n======== CRASH EXCEPTION ========\nName: %@\nReason: %@\nCallStack:\n%@\n=================================\n", name, reason, [callStack componentsJoinedByString:@"\n"]];
    NSLog(@"%@", crashInfo);
}

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 注册全局未捕获异常捕获，便于定位运行时崩溃堆栈
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    // Override point for customization after application launch.
    
    SDImageWebPCoder *webPCoder = [SDImageWebPCoder sharedCoder];
    [[SDImageCodersManager sharedManager] addCoder:webPCoder];

    application.applicationIconBadgeNumber = 0;
    [[User shareUser] recodeFinishShare];
    
    // 配置导航栏属性
    [[GKNavigationBarConfigure sharedInstance] setupDefaultConfigure];

    //友盟
    [self setUMSocialManager];
//    [self initAuthLogin];
    [self setIQKeyboardManager];
    [self setGlobalAppearance];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [BaseTabbarController new];
    [self.window makeKeyAndVisible];
    
//    @weakify(self)
//    [self showAdViewWithComplete:^{
//        @strongify(self)
//        self.window.rootViewController = [BaseTabbarController new];
//        [self.window makeKeyAndVisible];
//
//        //检查更新
//        [self requestUpgrade];
//
//        //拉起APP相关
//        NSURL *openUrl = launchOptions[UIApplicationLaunchOptionsURLKey];
//        [OpenPageManager handleOpenUrl:openUrl];
//    }];

    application.applicationIconBadgeNumber = 0;

    [self configMapApiKey];
//    [self setSJVideoInfo];
    
    // 设置通通锁蓝牙
    [TTLock setupBluetooth:^(TTBluetoothState state) {
        NSLog(@"##############  TTLock is working, bluetooth state: %ld  ##############",(long)state);
    }];

    return YES;
}

- (void)setGlobalAppearance
{
    if (@available(iOS 15.0, *)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
    }
}

- (void)showAdViewWithComplete:(void(^)(void))complete {
//    YDAdvertisementViewController *adVC = [[YDAdvertisementViewController alloc] init];
//    adVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    adVC.buttonClickBlock = ^{
//        if (complete) {
//            complete();
//        }
//    };
//    [window.rootViewController presentViewController:adVC animated:NO completion:nil];
}

- (void)setSJVideoInfo
{
    SJVideoPlayer.update(^(SJVideoPlayerConfigurations * _Nonnull configs) {
        configs.resources.placeholder = [UIImage imageNamed:@"placeholder"];
        configs.resources.progressThumbSize = 8;
        configs.resources.progressTraceColor = [UIColor beginGradientColor];
        configs.resources.progressTrackColor = [UIColor colorWithWhite:0.8 alpha:1];
        configs.resources.progressBufferColor = [UIColor whiteColor];;
        configs.resources.progressThumbColor = [UIColor beginGradientColor];
        configs.resources.bottomIndicatorTraceColor = [UIColor beginGradientColor];
        configs.resources.bottomIndicatorTrackColor = [UIColor clearColor];
//        configs.resources.fullscreenImage = [UIImage imageNamed:@"player_full_image"];
    });
}

- (void)setUMSocialManager
{
    BOOL isSuccess = [WXApi registerApp:@"wx0a2d222125616ee8" universalLink:@"https://appweb.huichenghuijia.com/"];
    if (isSuccess) {
        NSLog(@"微信支付API注册成功");
    } else {
        NSLog(@"微信支付API注册失败");
    }
    
//    /* 设置友盟appkey */
//    [UMConfigure initWithAppkey:@"5d19a5fb570df3b2b400076e" channel:nil];
//
//    //微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败
//    [UMSocialGlobal shareInstance].universalLinkDic =
//    @{
//        @(UMSocialPlatformType_WechatSession): @"https://www.shmedia.tech/fengxian/",
//        @(UMSocialPlatformType_WechatTimeLine): @"https://www.shmedia.tech/fengxian/",
//        @(UMSocialPlatformType_QQ): @"https://www.shmedia.tech/qq_conn/101680455"
//    };
//
//    /* 打开调试日志 */
//    [[UMSocialManager defaultManager] openLog:YES];
//
//    /* 设置微信的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx8c4785c607f84d5e" appSecret:@"834f6b9475721f586148e2764c9eb928" redirectURL:@""];
//
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:@"wx8c4785c607f84d5e" appSecret:@"834f6b9475721f586148e2764c9eb928" redirectURL:@""];
//
//    /* 设置分享到QQ互联的appID */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101680455"/*设置QQ平台的appID*/  appSecret:@"2ca44c42dbbf90465cc0851c337327af" redirectURL:@""];
}

- (void)setIQKeyboardManager
{
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        // alipay支付后回调app
        if ([url.scheme isEqualToString:@"huijia"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                if (resultDic != nil) {
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"AliPayNotification" object:nil userInfo:resultDic]];
                }
            }];
            return YES;
        }
        
        // weChat支付后回调app
        if ([url.scheme isEqualToString:@"wx0a2d222125616ee8"]) {
            // 支付跳转微信钱包进行支付，处理支付结果
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
    }
    //拉起APP后跳转
    [OpenPageManager handleOpenUrl:url];
    
    return result;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    
    if (![[UMSocialManager defaultManager] handleUniversalLink:userActivity options:nil]) {
        // 其他SDK的回调
    }
    // weChat支付后回调app
    if ([[userActivity.webpageURL absoluteString] containsString:@"wx0a2d222125616ee8"]) {
        // 支付跳转微信钱包进行支付，处理支付结果
        return [WXApi handleOpenUniversalLink:userActivity delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //将小红点清除
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[[SDWebImageManager sharedManager] imageCache] clearWithCacheType:SDImageCacheTypeAll completion:^{
    }];

    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearMemory];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAll;
}

- (void)configMapApiKey
{
    AMapServices *services = [AMapServices sharedServices];
    if ([services respondsToSelector:@selector(updatePrivacyShow:privacyInfo:)]) {
        [services updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    }
    if ([services respondsToSelector:@selector(updatePrivacyAgree:)]) {
        [services updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    }
    services.apiKey = MapApiKey;
}


- (void)requestUpgrade
{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//
//    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
//    NSString* deviceName = [[UIDevice currentDevice] systemName];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:@{@"name":@"iOS",@"version":app_Version} forKey:@"appVersion"];
//    [dic setObject:[ECUUIDTool getUUIDInKeychain] forKey:@"deviceId"];
//    [dic setObject:@{@"name":deviceName,@"version":phoneVersion} forKey:@"osVersion"];
//
//    [dic setObject:@(SCREEN_HEIGHT) forKey:@"screenHeight"];
//    [dic setObject:@(SCREEN_WIDTH) forKey:@"screenWidth"];
//    NSString *str = [NSString stringWithFormat:@"V%@",app_Version];
//    [CommonUtils addTrackView:@[@"版本号",str]];
//    [HttpRequest requestUrlPath:sys_versionURL parameters:dic type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
//        if (status == 1) {
//            YDUpgradeModel *model = [YDUpgradeModel mj_objectWithKeyValues:dic];
//            if (![model.type isEqualToString:@"ignore"])
//            {
//                [self showUpgradeView:model];
//            }
//        }
//    }];
}
//- (void)showUpgradeView:(YDUpgradeModel *)model
//{
//    UpgradeView *upView = [UpgradeView createViewFromNib];
//    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:upView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
//    upView.didSelectedBlock = ^{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.downloadUrl] options:@{} completionHandler:nil];
//    };
//    upView.didCloseBlock = ^{
//        [alertController dismissViewControllerAnimated:YES];
//    };
////    alertController.tapBackgroundDismissEnable = YES;
//    alertController.tapBackgroundDismissEnable = [model.type isEqualToString:@"necessary"] ? NO : YES;
//    [upView alertWithModel:model];
//    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
//}
@end

#pragma mark - rotate

@implementation UIViewController (RotationControl)
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end


@implementation UITabBarController (RotationControl)
- (UIViewController *)sj_topViewController {
    if ( self.selectedIndex == NSNotFound )
        return self.viewControllers.firstObject;
    return self.selectedViewController;
}

- (BOOL)shouldAutorotate {
    return [[self sj_topViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self sj_topViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self sj_topViewController] preferredInterfaceOrientationForPresentation];
}
@end

@implementation UINavigationController (RotationControl)
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
@end

