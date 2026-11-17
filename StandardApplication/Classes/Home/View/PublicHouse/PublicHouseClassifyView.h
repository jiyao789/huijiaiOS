//
//  PublicHouseClassifyView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublicHouseClassifyView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *classifyCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (nonatomic, copy) void (^publicHouseClassifyViewBlock)(NSInteger unit_type);
@end

NS_ASSUME_NONNULL_END
