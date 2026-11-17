//
//  ChooseClassifyView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/19.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseClassifyView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *classifyCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *bottomBackView;
@property (nonatomic, copy) void (^ChooseClassifyViewBlock)(NSInteger height);
@property (nonatomic, copy) void (^chooseClassifyViewFilterBlock)(NSMutableDictionary * _Nullable unitFilterDic);

@property (assign, nonatomic) BOOL needResetSelect;
@property (assign, nonatomic) NSInteger isHouseType; // 1 找房 2 首页 3 轮候
@property (assign, nonatomic) NSInteger needNewLayoutHouseType; // 1 找房 2 首页 3 其他
@end

NS_ASSUME_NONNULL_END
