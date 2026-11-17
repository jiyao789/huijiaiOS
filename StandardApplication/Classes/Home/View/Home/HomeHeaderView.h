//
//  HomeHeaderView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/19.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "MacroDefine.h"
#import "HomeHeaderNatureView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeHeaderView : UIView<SDCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *homeCycleScrollView;
@property (weak, nonatomic) IBOutlet HomeHeaderNatureView *homeNatureView;
@property (weak, nonatomic) IBOutlet UICollectionView *homeCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) UIImageView *acquisitionBannerView;
@property (assign, nonatomic) BOOL isRefreshDate;
@end

NS_ASSUME_NONNULL_END
