//
//  TabbarController.m
//  TestNavigation
//
//  Created by DTiOS on 2019/3/15.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "BaseTabbarController.h"
#import "MacroDefine.h"
#import "BaseNavigationViewController.h"
#import "HomeViewController.h"
#import "HouseViewController.h"
#import "LifeViewController.h"
#import "OwnerNewBaseViewController.h"
#import "MyViewController.h"


@interface BaseTabbarController () <UITabBarControllerDelegate>
@property (nonatomic, strong) NSMutableArray *tabBarButtons;
@property (assign, nonatomic) NSInteger shouldSelectIndex;
@end

@implementation BaseTabbarController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [UITabBar appearance].tintColor = [UIColor colorWithHexString:@"#3376AA"];
    [[UITabBar appearance] setUnselectedItemTintColor:[UIColor colorWithHexString:@"#64748B"]];

    self.tabBar.translucent = NO;
    self.delegate = self;
    
    [self showFiveTab];
}

- (void)showFiveTab
{
    [self addChildVC:[HomeViewController new] title:@"首页" imageName:@"home"];
    [self addChildVC:[HouseViewController new] title:@"找房" imageName:@"house"];
    [self addChildVC:[LifeViewController new] title:@"憓家生活" imageName:@"life"];
    [self addChildVC:[OwnerNewBaseViewController new] title:@"委托" imageName:@"owner"];
    [self addChildVC:[MyViewController new] title:@"我的" imageName:@"my"];
    
    _shouldSelectIndex = 0;
    self.selectedIndex = 0;
}

#define padding 2
- (void)addChildVC:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)name {
    
    BaseNavigationViewController *navigationController = [BaseNavigationViewController rootVC:vc translationScale:NO];
    navigationController.gk_openScrollLeftPush = YES;
    navigationController.tabBarItem.title = title;
    [navigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#64748B"],NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} forState:UIControlStateNormal];
    [navigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#3376AA"],NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} forState:UIControlStateSelected];
    [navigationController.tabBarItem setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@", name]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected", name]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [self addChildViewController:navigationController];
    
//    //调整位置 image Label
//    [navigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0,-padding*3)];
//    //image上移
//    navigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(padding-1, 0, -padding+3, 0);
    
    
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    self.gk_fullScreenPopDisabled = viewController.gk_fullScreenPopDisabled;
    self.gk_interactivePopDisabled = viewController.gk_interactivePopDisabled;
    self.gk_popMaxAllowedDistanceToLeftEdge = viewController.gk_popMaxAllowedDistanceToLeftEdge;
    
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"TabBarControllerNotification" object:nil userInfo:nil]];
    
    //点击tabBarItem动画
    [self tabBarButtonClick:[self getTabBarButton]];

    if (tabBarController.selectedIndex == 3) {
        self.selectedIndex = self.shouldSelectIndex;
        KWeakSelf
        [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
            weakSelf.selectedIndex = 3;
        }];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    _shouldSelectIndex = tabBarController.selectedIndex;
    return YES;
}

- (BOOL)checkIsDoubleClick:(UIViewController *)viewController
{
    static UIViewController *lastViewController = nil;
    static NSTimeInterval lastClickTime = 0;
    
    if (lastViewController != viewController) {
        lastViewController = viewController;
        lastClickTime = [NSDate timeIntervalSinceReferenceDate];
        
        return NO;
    }
    
    NSTimeInterval clickTime = [NSDate timeIntervalSinceReferenceDate];
    if (clickTime - lastClickTime > 0.5 ) {
        lastClickTime = clickTime;
        return NO;
    }
    
    lastClickTime = clickTime;
    return YES;
}

- (UIControl *)getTabBarButton{
    if (self.tabBarButtons.count > 0) {
        [self.tabBarButtons removeAllObjects];
    }
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [self.tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [self.tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}

- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews)
    {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据需求自定义
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //把动画添加上去就OK了
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}

- (NSMutableArray *)tabBarButtons{
    if (!_tabBarButtons) {
        _tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _tabBarButtons;
}

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
