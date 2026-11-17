//
//  SearchHistoryHeaderView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/8.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "SearchHistoryCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryHeaderView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (strong, nonatomic) NSMutableArray *searchHistoryArr;

@property (nonatomic, copy) void (^searchHistoryClickBlock)(NSString *historyStr);
@end

NS_ASSUME_NONNULL_END
