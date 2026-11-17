//
//  BaseViewController.h
//  TestNavigation
//
//  Created by DTiOS on 2019/3/15.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "GKNavigationBarViewController.h"
#import "NoMsgView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : GKNavigationBarViewController
/// 导航栏title
@property (strong, nonatomic) NSString *navTitle;
/// 导航栏title颜色
@property (strong, nonatomic) UIColor *navTitleColor;
/// 导航栏title字号
@property (strong, nonatomic) UIFont *navTitleFont;
/// 导航栏背景颜色
@property (strong, nonatomic) UIColor *navBackgroundColor;
/// 导航栏的透明度
@property (assign, nonatomic) CGFloat naviBarAlpha;
/// 导航栏设置图片
@property (nonatomic, strong) UIImage *naviBackgroundImage;
/// 导航栏增加view
@property (nonatomic, strong) UIView *naviAddView;
/// 状态栏类型
@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;
/// 是否隐藏nav
@property (assign, nonatomic) BOOL hideNaviBar;
/// 是否隐藏导航栏状态
@property (assign, nonatomic) BOOL hideStatusBar;
/// 是否隐藏分割线（默认NO）
/// 注意：此方法尽量在viewDidAppear中使用
@property (assign, nonatomic) BOOL hideNavLine;

@property (assign, nonatomic) BOOL showCustomNavLine;
/**
 是否是视老化样式
 */
@property (nonatomic, assign) BOOL isBarrierFreeStyle;
/// noMsgView
@property (nonatomic,strong)NoMsgView *noMsgView;

/// 黑色返回
- (UIBarButtonItem *)leftBarItem;

/// 可在子页面重写
- (void)backAction;

/// 其他色的字
- (UIBarButtonItem *)setupOtherBarButtomItemWithTitle:(NSString *)title target:(id)target action:(SEL)action leftOrRight:(BOOL)isLeft;
/// 黑色的字
- (UIBarButtonItem *)setupBlackBarButtomItemWithTitle:(NSString *)title target:(id)target action:(SEL)action leftOrRight:(BOOL)isLeft;
/// 增加图片
- (UIBarButtonItem *)setupBarButtomItemWithImageName:(NSString *)normalImageName highLightImageName:(NSString *)highImageName selectedImageName:(NSString *)selectedImaegName target:(id)target action:(SEL)action leftOrRight:(BOOL)isLeft;
/// 右边增加两个图片
- (void)setupBarButtonRightItem:(NSString *)imageNameF target:(id)targetF action:(SEL)actionF imageNameS:(NSString *)imageNameS target:(id)targetS action:(SEL)actionS;
/// 右边增加两个文案
- (void)setupBarButtonRightItem:(NSString *)titleF target:(id)targetF action:(SEL)actionF titleS:(NSString *)titleS target:(id)targetS action:(SEL)actionS;
/// 左边增加两个图片
- (void)setupBarButtonLeftItem:(NSString *)imageNameF target:(id)targetF action:(SEL)actionF imageNameS:(NSString *)imageNameS target:(id)targetS action:(SEL)actionS;
- (void)setupCustomNavBarButton:(UIView *)view leftOrRight:(BOOL)isLeft;

/// nav设置颜色渐变
- (void)setupNavBackgroundColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

/// MJRefresh
- (void)setupRefreshWithTableView:(UIScrollView *)tableView;
- (void)setupFooterRefresh:(UIScrollView *)tableView;
- (void)setupHeaderRefresh:(UIScrollView *)tableView;

- (void)headerRefreshloadData;
- (void)footerRefreshloadData;

@end

NS_ASSUME_NONNULL_END
