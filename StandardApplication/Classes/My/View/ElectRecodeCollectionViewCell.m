//
//  ElectRecodeCollectionViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/8.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ElectRecodeCollectionViewCell.h"

@implementation ElectRecodeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRechargeRecodeModel:(RechargeRecodeModel *)rechargeRecodeModel
{
    _rechargeRecodeModel = rechargeRecodeModel;
}

@end
