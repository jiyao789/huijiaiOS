//
//  SeeHouseDateView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/24.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface SeeHouseDateView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, copy) void (^didConfirmBlock) (NSString *book_date,NSString *time_slot);

@property (weak, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *dateLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *timeCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *timeLayout;

@end

NS_ASSUME_NONNULL_END
