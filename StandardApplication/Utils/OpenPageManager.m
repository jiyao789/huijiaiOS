//
//  OpenPageManager.m
//  StandardApplication
//
//  Created by liyuanbo on 2019/12/24.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "OpenPageManager.h"
#import <UIKit/UIKit.h>
#import "MacroDefine.h"

@implementation OpenPageManager

+ (void)handleOpenUrl:(NSURL *)url
{
    if (![url.scheme.lowercaseString containsString:@"rmtfengxian"]) {
        //不是自定义唤醒
        return;
    }
//    UINavigationController *navController = [YDGlobalModuleRouter getCurrentViewController].navigationController;
//    if (!navController) {
//        return;
//    }
//    
//    NSString * action_url = [url.absoluteString stringByReplacingOccurrencesOfString:@"rmtfengxian" withString:@"rmt"];
//    [YDGlobalModuleRouter jumpToControllerByActionUrl:action_url navigationController:navController];
}

@end
