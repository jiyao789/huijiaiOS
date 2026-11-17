//
//  HomeTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2024/10/21.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "DYWaterFallFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *homeCollectionView;
@property (weak, nonatomic) IBOutlet DYWaterFallFlowLayout *homeLayout;

@property (assign, nonatomic) NSInteger nature;
@property (strong, nonatomic) NSMutableArray *houseList;
@end

NS_ASSUME_NONNULL_END
