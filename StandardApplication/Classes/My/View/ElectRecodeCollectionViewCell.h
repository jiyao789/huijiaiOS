//
//  ElectRecodeCollectionViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/8.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "RechargeRecodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ElectRecodeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *electImageView;
@property (weak, nonatomic) IBOutlet UIButton *electStatusBtn;
@property (weak, nonatomic) IBOutlet UILabel *electStatusTimeLab;

@property (strong, nonatomic)RechargeRecodeModel *rechargeRecodeModel;
@end

NS_ASSUME_NONNULL_END
