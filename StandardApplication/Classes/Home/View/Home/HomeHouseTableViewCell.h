//
//  HomeHouseTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/19.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseListModel.h"
#import "HouseDetailModel.h"
#import "SubscribeListModel.h"
#import "ReatRenewReatModel.h"
#import "BasicPoinsCollectionViewCell.h"
#import "BigHouseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeHouseTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseNameLayoutRight;
@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *houseInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *houseAmountLab;
@property (weak, nonatomic) IBOutlet UICollectionView *poinsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *bookLab;
@property (weak, nonatomic) IBOutlet UIImageView *houseTypeImageView;

@property (strong, nonatomic) HouseListModel *houseModel;
@property (strong, nonatomic) HouseDetailModel *houseDetailModel;
@property (strong, nonatomic) UnitModel *unitModel;
@property (strong, nonatomic) ReatRenewReatModel *reatRenewReatModel;

@property (strong, nonatomic) BigHouseModel *bigHouseModel;

@property (strong, nonatomic) NSArray *poinsArr;
@property (assign, nonatomic) BOOL isNotHouseDetail;
@property (assign, nonatomic) BOOL isWaitHouse;

@property (nonatomic, copy) void (^houseIsCollectBlock)(NSInteger collect);
@end

NS_ASSUME_NONNULL_END
