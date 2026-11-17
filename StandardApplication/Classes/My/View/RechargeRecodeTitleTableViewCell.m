//
//  RechargeRecodeTitleTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2024/6/30.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "RechargeRecodeTitleTableViewCell.h"

@implementation RechargeRecodeTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
}

- (void)setRechargeRecodeModel:(RechargeRecodeModel *)rechargeRecodeModel
{
    _rechargeRecodeModel = rechargeRecodeModel;
    if (IsNilOrNull(_rechargeRecodeModel) && _index == 0) {
        _rechargeTimeLab.text = @"充值时间";
        _rechargeTimeLab.textColor = [UIColor colorWithHexString:@"#0063A5"];
        _rechargeTimeLab.backgroundColor = [UIColor colorWithHexString:@"#D7E5F9"];
    } else if (IsNilOrNull(_rechargeRecodeModel)) {
        _rechargeTimeLab.text = @"";
    } else {
        _rechargeTimeLab.textColor = [UIColor colorWithHexString:@"#393D41"];
        _rechargeTimeLab.backgroundColor = [UIColor whiteColor];
        _rechargeTimeLab.text = NONullString(_rechargeRecodeModel.record_date);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
