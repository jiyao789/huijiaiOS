//
//  HomeHeaderView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/19.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HomeHeaderView.h"
#import "HouseSearchViewController.h"
#import "PublicHouseSearchViewController.h"
#import "HomeBannerModel.h"
#import "XHPageControl.h"
#import "BasicPoinsCollectionViewCell.h"
#import "ProtocolBaseWKWebViewController.h"
#import "MapSearchHouseViewController.h"
#import "VRSeeHouseViewController.h"
#import "WaitViewController.h"
#import "MyCollectionViewController.h"
#import "HomeHeaderNatureView.h"
#import "NewWaitViewController.h"
#import "MyCollectionViewCell.h"
#import "LockSelectViewController.h"
#import "AcquisitionStep1VC.h"
#import "AcquisitionFormData.h"

@interface HomeHeaderView()

@property (strong, nonatomic) XHPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *listArr;

@property (strong, nonatomic) NSArray *secondTitleArr;
@property (strong, nonatomic) NSArray *secondImageArr;
@end

@implementation PoinsModel

@end

@implementation HomeHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _homeCycleScrollView.delegate = self;
    _homeCycleScrollView.autoScroll = YES;

    _homeNatureView.view.backgroundColor = [UIColor clearColor];

    _secondTitleArr = @[@"门禁开锁",@"VR看房",@"房源轮候",@"地图找房"];
    _secondImageArr = @[@"lock_door_icon",@"vr_look_house_icon",@"house_wait_icon",@"map_search_house_icon"];

    _homeCollectionView.delegate = self;
    _homeCollectionView.dataSource = self;
    CGFloat secondSpace = (SCREEN_WIDTH - 25 * 2 - 50 * 4) / 3;
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = secondSpace;
    _layout.sectionInset = UIEdgeInsetsMake(0, 25, 0, 25);
    _layout.itemSize = CGSizeMake(50, 102);
    [_homeCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyCollectionViewCell"];

    // 添加房源收购意向申报横幅
    [self setupAcquisitionBanner];

    [self getBannerListData];
}


- (void)setIsRefreshDate:(BOOL)isRefreshDate
{
    [self getBannerListData];
    _homeNatureView.isRefreshDate = YES;
}

- (void)getBannerListData
{
    [HttpRequest requestArrUrlPath:BaseURL urlPath:banner_listURL parameters:@{@"use":@(1)} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            self.listArr = [HomeBannerModel mj_objectArrayWithKeyValuesArray:arr];
            [self setBannarImageInfo];
        }
    }];
}

- (void)setBannarImageInfo
{
    NSMutableArray *bannarImageArr = [NSMutableArray array];
    for (HomeBannerModel *model in self.listArr) {
        [bannarImageArr addObject:model.image_url];
    }
    _homeCycleScrollView.imageURLStringsGroup = bannarImageArr;
    _homeCycleScrollView.placeholderImage = [UIImage imageNamed:defaultIconName];
    _homeCycleScrollView.showPageControl = NO;
    if (bannarImageArr.count > 1) {
        self.pageControl.numberOfPages = bannarImageArr.count;
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    HomeBannerModel *model = self.listArr[index];
    if (!IsStrEmpty(model.link)) {
        ProtocolBaseWKWebViewController *vc = [ProtocolBaseWKWebViewController new];
        vc.webTitle = NONullString(model.title);
        vc.webUrl = NONullString(model.link);
        [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    self.pageControl.currentPage = index;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _secondTitleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    cell.myNameLab.text = _secondTitleArr[indexPath.row];
    cell.myImageView.image = [UIImage imageNamed:_secondImageArr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
                if (performLogin) {
                    [[CommonUtils getCurrentViewController].navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [[CommonUtils getCurrentViewController].navigationController pushViewController:[LockSelectViewController new] animated:YES];
                }
            }];
            break;
        }
        case 1:
        {
            [[CommonUtils getCurrentViewController].navigationController pushViewController:[VRSeeHouseViewController new] animated:YES];
            break;
        }
        case 2:
        {
            [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentNavgationController:[CommonUtils getCurrentViewController].navigationController loginSuccessed:^(NSString *authorization, BOOL performLogin) {
                if (!performLogin) {
                    NewWaitViewController *vc = [NewWaitViewController new];
                    [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
                }
            }];
            break;
        }
        case 3:
        {
            KWeakSelf
            MapSearchHouseViewController *vc = [MapSearchHouseViewController new];
            [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

- (XHPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[XHPageControl alloc] initWithFrame:CGRectMake(0, 312 - 102 - 30, SCREEN_WIDTH, 12)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentMultiple = 1;
        _pageControl.otherColor = [UIColor whiteColor];
        _pageControl.currentColor = [UIColor colorWithHexString:@"#2A629A"];
        [self.homeCycleScrollView addSubview:_pageControl];
    }
    return _pageControl;
}

- (NSMutableArray *)listArr
{
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}

#pragma mark - Acquisition Banner

- (void)setupAcquisitionBanner
{
    // 创建横幅视图
    _acquisitionBannerView = [[UIImageView alloc] init];
    UIImage *bannerImage = [UIImage imageNamed:@"home_banner_acquisition"];
    _acquisitionBannerView.image = bannerImage;

    // 关键：完整显示图片
    _acquisitionBannerView.contentMode = UIViewContentModeScaleAspectFit;
    _acquisitionBannerView.userInteractionEnabled = YES;
    _acquisitionBannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_acquisitionBannerView];

    // 点击手势（保持原逻辑）
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acquisitionBannerTapped)];
    [_acquisitionBannerView addGestureRecognizer:tap];

    // 找到原有间距约束，保持你的原始结构
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstItem == _homeCollectionView &&
            constraint.firstAttribute == NSLayoutAttributeTop &&
            constraint.secondItem == _homeNatureView &&
            constraint.secondAttribute == NSLayoutAttributeBottom) {
            constraint.constant = 160;
            break;
        }
    }

    // === Auto Layout 约束（只控制横幅） ===
    CGFloat bannerMargin = 15;

    [NSLayoutConstraint activateConstraints:@[
        // 宽度不变
        [_acquisitionBannerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:bannerMargin],
        [_acquisitionBannerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-bannerMargin],

        // 位置不变
        [_acquisitionBannerView.topAnchor constraintEqualToAnchor:_homeNatureView.bottomAnchor constant:8],
    ]];

    // 高度自适应（按图片比例）
    if (bannerImage.size.width > 0) {
        CGFloat ratio = bannerImage.size.height / bannerImage.size.width;
        NSLayoutConstraint *ratioConstraint =
        [_acquisitionBannerView.heightAnchor constraintEqualToAnchor:_acquisitionBannerView.widthAnchor multiplier:ratio];
        ratioConstraint.active = YES;
    }
    // === 新增：最大高度限制（关键） ===
    NSLayoutConstraint *maxHeightConstraint =
    [_acquisitionBannerView.heightAnchor constraintLessThanOrEqualToConstant:130];
    maxHeightConstraint.priority = UILayoutPriorityRequired;
    maxHeightConstraint.active = YES;
}


- (void)acquisitionBannerTapped
{
    [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
        if (!performLogin) {
            // Clear form data before entering new declaration
            [[AcquisitionFormData sharedInstance] clear];
            AcquisitionStep1VC *vc = [AcquisitionStep1VC new];
            [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
