//
//  BaseViewController.m
//  TestNavigation
//
//  Created by DTiOS on 2019/3/15.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "BaseViewController.h"
#import "MacroDefine.h"
#import "UIColor+Helper.h"

@interface BaseViewController ()

kPropertyStrong(UIView, navLine)
@end


@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //确定app主调是白色还是黑色，改此处值和框架里的默认值
    //否则iPhoneX在push的时候会出现闪动
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navTitleColor = [UIColor colorWithHexString:@"#0E2F55"];
    self.gk_navTitleFont = [UIFont systemFontOfSize:17.0f weight:UIFontWeightMedium];
    self.gk_navBackgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Public
- (UIBarButtonItem*)leftBarItem
{
    PSBarButtonItem *leftItem = [PSBarButtonItem itemWithTitle:nil barStyle:PSNavItemStyleLeft target:self action:@selector(backAction) leftOrRight:YES];
    self.gk_navLeftBarButtonItem = leftItem;
    return leftItem;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)setupOtherBarButtomItemWithTitle:(NSString *)title target:(id)target action:(SEL)action leftOrRight:(BOOL)isLeft
{
    PSBarButtonItem *item = [PSBarButtonItem itemWithTitle:title barStyle:PSNavItemStyleMainDone target:target action:action leftOrRight:isLeft];
    if (isLeft)
    {
        self.gk_navLeftBarButtonItem = item;
    }
    else
    {
        self.gk_navRightBarButtonItem = item;
    }
    return item;
}
- (UIView *)navLine
{
    if (_navLine == nil) {
        _navLine = [UIView new];
        _navLine.backgroundColor = [UIColor separatorLineColor];
        _navLine.hidden = YES;
        
    }
    return _navLine;
}
- (void)setShowCustomNavLine:(BOOL)showCustomNavLine
{
    _showCustomNavLine = showCustomNavLine;
    self.navLine.hidden = NO;
}
/// 黑色的字
- (UIBarButtonItem *)setupBlackBarButtomItemWithTitle:(NSString *)title target:(id)target action:(SEL)action leftOrRight:(BOOL)isLeft
{
    PSBarButtonItem *item = [PSBarButtonItem itemWithTitle:title barStyle:PSNavItemStyleBlackDone target:target action:action leftOrRight:isLeft];
    if (isLeft)
    {
        self.gk_navLeftBarButtonItem = item;
    }
    else
    {
        self.gk_navRightBarButtonItem = item;
    }
    return item;
}

- (void)setupCustomNavBarButton:(UIView *)view leftOrRight:(BOOL)isLeft
{
    PSBarButtonItem *item = [[PSBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *paddingItem = [[UIBarButtonItem alloc]
    initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
    target:nil action:nil];
    paddingItem.width = 20;
    if (isLeft) {
        self.gk_navLeftBarButtonItems = @[item,paddingItem];
        
    }else
    {
        self.gk_navRightBarButtonItems = @[paddingItem,item];
    }
}
- (UIBarButtonItem *)setupBarButtomItemWithImageName:(NSString *)normalImageName highLightImageName:(NSString *)highImageName selectedImageName:(NSString *)selectedImaegName target:(id)target action:(SEL)action leftOrRight:(BOOL)isLeft
{
    PSBarButtonItem *item;
    if (isLeft)
    {
        item = [PSBarButtonItem itemLeftWithImageName:normalImageName highLightImageName:highImageName selectedImageName:selectedImaegName target:target action:action];
        self.gk_navLeftBarButtonItem = item;
    }
    else
    {
        item = [PSBarButtonItem itemRightWithImageName:normalImageName highLightImageName:highImageName selectedImageName:selectedImaegName target:target action:action];
        self.gk_navRightBarButtonItem = item;
    }
    return item;
}

- (void)setupBarButtonRightItem:(NSString *)imageNameF target:(id)targetF action:(SEL)actionF imageNameS:(NSString *)imageNameS target:(id)targetS action:(SEL)actionS
{
    UIBarButtonItem *itemF = [PSBarButtonItem itemRightWithImageName:imageNameF highLightImageName:imageNameF selectedImageName:imageNameF target:targetF action:actionF];
    UIBarButtonItem *itemS = [PSBarButtonItem itemRightWithImageName:imageNameS highLightImageName:imageNameS selectedImageName:imageNameS target:targetS action:actionS];
    
    self.gk_navRightBarButtonItems = @[itemF,itemS];
}

- (void)setupBarButtonRightItem:(NSString *)titleF target:(id)targetF action:(SEL)actionF titleS:(NSString *)titleS target:(id)targetS action:(SEL)actionS
{
    
    PSBarButtonItem *itemF = [PSBarButtonItem itemWithTitle:titleF barStyle:PSNavItemStyleBlackDone target:targetF action:actionF leftOrRight:NO];
    PSBarButtonItem *itemS = [PSBarButtonItem itemWithTitle:titleS barStyle:PSNavItemStyleBlackDone target:targetS action:actionS leftOrRight:NO];
    self.gk_navRightBarButtonItems = @[itemS,itemF];
}
/// 左边增加两个图片
- (void)setupBarButtonLeftItem:(NSString *)imageNameF target:(id)targetF action:(SEL)actionF imageNameS:(NSString *)imageNameS target:(id)targetS action:(SEL)actionS
{
    UIBarButtonItem *itemF = [PSBarButtonItem itemLeftWithImageName:imageNameF highLightImageName:imageNameF selectedImageName:imageNameF target:targetF action:actionF];
    UIBarButtonItem *itemS = [PSBarButtonItem itemLeftWithImageName:imageNameS highLightImageName:imageNameS selectedImageName:imageNameS target:targetS action:actionS];
    
    self.gk_navLeftBarButtonItems = @[itemF,itemS];
}

#pragma mark - Setter & Getter
- (void)setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
    self.gk_navTitle = _navTitle;
}

- (void)setHideNaviBar:(BOOL)hideNaviBar
{
    _hideNaviBar = hideNaviBar;
    self.gk_navigationBar.hidden = _hideNaviBar;
}

- (void)setNavTitleColor:(UIColor *)navTitleColor
{
    _navTitleColor = navTitleColor;
    self.gk_navTitleColor = _navTitleColor;
}

- (void)setNavBackgroundColor:(UIColor *)navBackgroundColor
{
    _navBackgroundColor = navBackgroundColor;
    self.gk_navBackgroundColor = _navBackgroundColor;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    _statusBarStyle = statusBarStyle;
    self.gk_statusBarStyle = _statusBarStyle;
}

- (void)setNaviBarAlpha:(CGFloat)naviBarAlpha
{
    _naviBarAlpha = naviBarAlpha;
    self.gk_navBarAlpha = _naviBarAlpha;
}

- (void)setHideStatusBar:(BOOL)hideStatusBar
{
    _hideStatusBar = hideStatusBar;
    self.gk_statusBarHidden = _hideStatusBar;
}

- (void)setHideNavLine:(BOOL)hideNavLine
{
    _hideNavLine = hideNavLine;
    self.gk_navLineHidden = _hideNavLine;
}

- (void)setNaviBackgroundImage:(UIImage *)naviBackgroundImage
{
    _naviBackgroundImage = naviBackgroundImage;
    self.gk_navBackgroundImage = _naviBackgroundImage;
}

- (void)setNaviAddView:(UIView *)naviAddView
{
    _naviAddView = naviAddView;
    self.gk_navTitleView = naviAddView;
}


- (void)setupNavBackgroundColor:(UIColor *)fromColor toColor:(UIColor *)toColor
{
    UIView *barBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT)];
    [barBackgroundView.layer addSublayer:[UIColor setGradualChangingColor:barBackgroundView fromColor:fromColor toColor:toColor]];
    self.naviBackgroundImage = [UIImage convertViewToImage:barBackgroundView];
}

#pragma mark - MJRefresh
- (void)setupHeaderRefresh:(UIScrollView *)tableView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshloadData)];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateIdle];
    [header setTitle:@"正在刷新..." forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    tableView.mj_header = header;
}

- (void)setupFooterRefresh:(UIScrollView *)tableView
{
    //     MJRefreshAutoNormalFooter     MJRefreshBackNormalFooter
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshloadData)];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    // 设置文字
    [footer setTitle:@"正在刷新..." forState:MJRefreshStateIdle];
    [footer setTitle:@"正在刷新..." forState:MJRefreshStatePulling];
    [footer setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];

    footer.arrowView.alpha = 0.0;
    [footer setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
    tableView.mj_footer = footer;
}

- (void)setupRefreshWithTableView:(UIScrollView *)tableView
{
    [self setupHeaderRefresh:tableView];
    [self setupFooterRefresh:tableView];
}

- (void)headerRefreshloadData
{
    
}

- (void)footerRefreshloadData
{
    
}

- (NoMsgView *)noMsgView
{
    if (!_noMsgView)
    {
        _noMsgView = [NoMsgView viewFromXib];
    }
    _noMsgView.centerX = self.view.center.x;
    return _noMsgView;
}

@end
