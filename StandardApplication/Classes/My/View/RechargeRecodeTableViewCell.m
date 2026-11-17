//
//  RechargeRecodeTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "RechargeRecodeTableViewCell.h"


@implementation RechargeRecodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMeter_type:(NSInteger)meter_type
{
    _meter_type = meter_type;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
}

- (void)setAllIndex:(NSInteger)allIndex
{
    _allIndex = allIndex;
}

- (void)setRechargeRecodeModel:(RechargeRecodeModel *)rechargeRecodeModel
{
    _rechargeRecodeModel = rechargeRecodeModel;
    if (IsNilOrNull(_rechargeRecodeModel) && _index == 0) {
        _rechargeAmountLab.text = @"充值金额（元）";
        _rechargeAmountLab.textColor = [UIColor colorWithHexString:@"#0063A5"];
        _rechargeDegreeLab.text = [NSString stringWithFormat:@"充值额度（%@）", _meter_type == 0 ? @"度" : @"吨"];
        _rechargeDegreeLab.textColor = [UIColor colorWithHexString:@"#0063A5"];
        _rechargeBeforeLab.text = @"旧值";
        _rechargeBeforeLab.textColor = [UIColor colorWithHexString:@"#0063A5"];
        _rechargeAfterLab.text = @"新值";
        _rechargeAfterLab.textColor = [UIColor colorWithHexString:@"#0063A5"];
        _slideLeftImageView.hidden = YES;
        _slideRightImageView.hidden = YES;
    } else if (IsNilOrNull(_rechargeRecodeModel)) {
        _rechargeAmountLab.text = @"";
        _rechargeDegreeLab.text = @"";
        _rechargeBeforeLab.text = @"";
        _rechargeAfterLab.text = @"";
        _slideLeftImageView.hidden = YES;
        _slideRightImageView.hidden = YES;
        if (_index == _allIndex - 1) {
            _slideLeftImageView.hidden = NO;
            _slideRightImageView.hidden = NO;
        }
    } else {
        _rechargeAmountLab.textColor = [UIColor colorWithHexString:@"#393D41"];
        _rechargeDegreeLab.textColor = [UIColor colorWithHexString:@"#393D41"];
        _rechargeBeforeLab.textColor = [UIColor colorWithHexString:@"#393D41"];
        _rechargeAfterLab.textColor = [UIColor colorWithHexString:@"#393D41"];
        _rechargeAmountLab.text = [NSString stringWithFormat:@"%.2f",_rechargeRecodeModel.total_price];
        _rechargeDegreeLab.text = [NSString stringWithFormat:@"%.2f",(_rechargeRecodeModel.remaining_power_after_recharge - _rechargeRecodeModel.remaining_power_before_recharge)];
        _rechargeBeforeLab.text = [NSString stringWithFormat:@"%.2f",_rechargeRecodeModel.remaining_power_before_recharge];
        _rechargeAfterLab.text = [NSString stringWithFormat:@"%.2f",_rechargeRecodeModel.remaining_power_after_recharge];
        _slideLeftImageView.hidden = YES;
        _slideRightImageView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
