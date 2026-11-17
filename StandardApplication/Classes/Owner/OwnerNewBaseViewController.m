//
//  OwnerNewBaseViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2024/10/14.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "OwnerNewBaseViewController.h"
#import "MacroDefine.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorBackgroundView.h"
#import "JXCategoryListContainerView.h"
#import "OwnerViewController.h"
#import "OwnerWantViewController.h"

@interface OwnerNewBaseViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (weak, nonatomic) IBOutlet UIView *entrustView;
@property (weak, nonatomic) IBOutlet UILabel *entrustLab;
@property (weak, nonatomic) IBOutlet UIView *wantView;
@property (weak, nonatomic) IBOutlet UILabel *wantLab;

@end

@implementation OwnerNewBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hideNaviBar = YES;
    self.statusBarStyle = UIStatusBarStyleDefault;
    
    [self.view addSubview:self.myCategoryView];
    [self.view addSubview:self.listContainerView];
    self.myCategoryView.contentScrollView = self.listContainerView.scrollView;
    
    KWeakSelf
    [_entrustView whenTapped:^{
        [weakSelf setViewInfo:0];
        [weakSelf.myCategoryView selectItemAtIndex:0];
        [weakSelf.listContainerView didClickSelectedItemAtIndex:0];
    }];
    
    [_wantView whenTapped:^{
        [weakSelf setViewInfo:1];
        [weakSelf.myCategoryView selectItemAtIndex:1];
        [weakSelf.listContainerView didClickSelectedItemAtIndex:1];
    }];
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
        OwnerViewController *vc = [[OwnerViewController alloc]init];
        vc.naviController = self.navigationController;
        return vc;
    }
    OwnerWantViewController *vc = [[OwnerWantViewController alloc]init];
    vc.naviController = self.navigationController;
    return vc;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    [self setViewInfo:index];
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)setViewInfo:(NSInteger)index
{
    if (index == 0) {
        _entrustView.layer.borderWidth = 0.5;
        _entrustView.layer.borderColor = [UIColor colorWithHexString:@"#3376AA"].CGColor;
        _entrustLab.textColor = [UIColor colorWithHexString:@"#3376AA"];
        _wantView.layer.borderWidth = 0.5;
        _wantView.layer.borderColor = [UIColor whiteColor].CGColor;
        _wantLab.textColor = [UIColor colorWithHexString:@"#333333"];
    } else if (index == 1) {
        _entrustView.layer.borderWidth = 0.5;
        _entrustView.layer.borderColor = [UIColor whiteColor].CGColor;
        _entrustLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _wantView.layer.borderWidth = 0.5;
        _wantView.layer.borderColor = [UIColor colorWithHexString:@"#3376AA"].CGColor;
        _wantLab.textColor = [UIColor colorWithHexString:@"#3376AA"];
    }
}

- (JXCategoryTitleView *)myCategoryView
{
    if (_myCategoryView == nil) {
        _myCategoryView = [[JXCategoryTitleView alloc] init];
        _myCategoryView.delegate = self;
        _myCategoryView.titles = self.titles;
        _myCategoryView.cellSpacing = 0;
        _myCategoryView.cellWidth = 50;
        _myCategoryView.titleColor = [UIColor colorWithHexString:@"#646A70"];
        _myCategoryView.titleSelectedColor = [UIColor colorWithHexString:@"#1B61A0"];
        _myCategoryView.titleFont = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        _myCategoryView.titleSelectedFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
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
    
    self.myCategoryView.frame = CGRectMake(0, 185, 0, 0);
    
    self.listContainerView.frame = CGRectMake(0, 185, SCREEN_WIDTH, SCREEN_HEIGHT - 185 - TABBAR_HEIGHT);
}

- (NSArray *)titles
{
    if (_titles == nil) {
        _titles = @[@"委托",@"求租"];
    }
    return _titles;
}

@end
