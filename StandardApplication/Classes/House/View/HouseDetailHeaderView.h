//
//  HouseDetailHeaderView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "SDCycleScrollView.h"
#import "HouseDetailModel.h"
#import "BigHouseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseDetailHeaderView : UIView<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *houseAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *houseAresLab;
@property (weak, nonatomic) IBOutlet UILabel *houseAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *shiLab;
@property (weak, nonatomic) IBOutlet UILabel *towardLab;
@property (weak, nonatomic) IBOutlet BaseShadowView *locationView;

@property (strong, nonatomic) HouseDetailModel *model;
@property (strong, nonatomic) BigHouseModel *bigHouseModel;
@end

NS_ASSUME_NONNULL_END
