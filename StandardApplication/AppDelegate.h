//
//  AppDelegate.h
//  StandardApplication
//
//  Created by DTiOS on 2019/4/2.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BaseTabbarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain)BaseTabbarController *tabbarController;


@end

