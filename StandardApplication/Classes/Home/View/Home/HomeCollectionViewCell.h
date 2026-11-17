//
//  HomeCollectionViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2024/10/21.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseListModel.h"
#import "BigHouseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeCollectionViewCell : UICollectionViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *houseTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *houseInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *houseAmountLab;
@property (weak, nonatomic) IBOutlet UICollectionView *poinsCollectionView;

@property (strong, nonatomic) HouseListModel *houseModel;

@property (strong, nonatomic) BigHouseModel *bigHouseModel;

@property (strong, nonatomic) NSArray *poinsArr;

@end

NS_ASSUME_NONNULL_END
