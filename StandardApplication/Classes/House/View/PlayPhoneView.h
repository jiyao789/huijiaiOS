//
//  PlayPhoneView.h
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayPhoneView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *playPhoneCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *phoneLayout;

@property (nonatomic, copy) void (^didCancelBlock) (void);
@property (strong, nonatomic) NSMutableArray *phoneArr;
@end

NS_ASSUME_NONNULL_END
