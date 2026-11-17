//
//  MyHeaderView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyHeaderView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *averteImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UICollectionView *myHeaderCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UILabel *mobileLab;
@property (weak, nonatomic) IBOutlet UIView *mobileView;
@property (weak, nonatomic) IBOutlet UICollectionView *myHeaderSecondCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *secondLayout;

@property (strong, nonatomic) UserModel * _Nullable model;
@end

NS_ASSUME_NONNULL_END
