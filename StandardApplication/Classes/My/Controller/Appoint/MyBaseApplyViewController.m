//
//  MyBaseApplyViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyBaseApplyViewController.h"
#import "MacroDefine.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorBackgroundView.h"
#import "JXCategoryListContainerView.h"
#import "MyAppointSeeViewController.h"

@interface MyBaseApplyViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@end

@implementation MyBaseApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self leftBarItem];
    self.navTitle = @"我的预约";
    self.hideNavLine = YES;
    
    [self.view addSubview:self.myCategoryView];
    [self.view addSubview:self.listContainerView];
    self.myCategoryView.contentScrollView = self.listContainerView.scrollView;
}

#pragma mark - JXCategoryViewDelegate

#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView
{
    return self.titles.count;
}
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index
{
    if (index == 0) {
        MyAppointSeeViewController *vc = [[MyAppointSeeViewController alloc]init];
        vc.type = index;
        vc.naviController = self.navigationController;
        return vc;
    }
    MyAppointSeeViewController *vc = [[MyAppointSeeViewController alloc]init];
    vc.type = index;
    vc.naviController = self.navigationController;
    return vc;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (JXCategoryTitleView *)myCategoryView
{
    if (_myCategoryView == nil) {

        _myCategoryView = [[JXCategoryTitleView alloc] init];
        _myCategoryView.layer.cornerRadius = 6;
        _myCategoryView.layer.masksToBounds = YES;
        _myCategoryView.delegate = self;
        _myCategoryView.titles = self.titles;
        _myCategoryView.cellSpacing = 0;
        _myCategoryView.cellWidth = [self preferredCategoryViewWeith] / self.titles.count;
        _myCategoryView.titleColor = [UIColor colorWithHexString:@"#2B66A4"];
        _myCategoryView.titleSelectedColor = [UIColor whiteColor];
        _myCategoryView.titleLabelMaskEnabled = YES;
        _myCategoryView.titleFont = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
        _myCategoryView.titleSelectedFont = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
        _myCategoryView.backgroundColor = [UIColor whiteColor];
        
        JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
        backgroundView.indicatorHeight = 42;
        backgroundView.indicatorWidthIncrement = 0;
        backgroundView.indicatorCornerRadius = 6;
        backgroundView.indicatorColor = [UIColor colorWithHexString:@"#2B66A4"];
        self.myCategoryView.indicators = @[backgroundView];
    }
    return _myCategoryView;
}
- (JXCategoryListContainerView *)listContainerView
{
    if (_listContainerView == nil) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.myCategoryView.frame = CGRectMake((SCREEN_WIDTH - [self preferredCategoryViewWeith]) / 2, NAVBAR_HEIGHT + 12, [self preferredCategoryViewWeith], 42);
    
    self.listContainerView.frame = CGRectMake(0, [self preferredCategoryViewHeight] + NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT - [self preferredCategoryViewHeight]);
}

- (CGFloat)preferredCategoryViewHeight {
    return 60;
}

- (CGFloat)preferredCategoryViewWeith {
    return SCREEN_WIDTH - 32;
}

- (NSArray *)titles
{
    if (_titles == nil) {
        _titles = @[@"预约看房",@"预定房源"];
    }
    return _titles;
}

@end
