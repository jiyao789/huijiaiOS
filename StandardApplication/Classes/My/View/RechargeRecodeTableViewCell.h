//
//  RechargeRecodeTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "RechargeRecodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RechargeRecodeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rechargeAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *rechargeBeforeLab;
@property (weak, nonatomic) IBOutlet UILabel *rechargeAfterLab;
@property (weak, nonatomic) IBOutlet UILabel *rechargeDegreeLab;
@property (weak, nonatomic) IBOutlet UIImageView *slideLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *slideRightImageView;

@property (assign, nonatomic) NSInteger meter_type;  // 0电表 1冷水 2热水
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger allIndex;
@property (strong, nonatomic) RechargeRecodeModel *rechargeRecodeModel;

@end

NS_ASSUME_NONNULL_END
