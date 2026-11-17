//
//  WaitInfoTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2023/12/9.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "WaitInfoTableViewCell.h"

@implementation WaitInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.11].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0,1);
    self.bgView.layer.shadowOpacity = 1;
    self.bgView.layer.shadowRadius = 5;
}

- (void)setUnitModel:(WaitUnitQueueModel *)unitModel
{
    _unitModel = unitModel;
    _unitNameLab.text = NONullString(_unitModel.name);
    _waitCountLab.text = [NSString stringWithFormat:@"共%ld套，当前轮候%ld人", (long)_unitModel.unit_count,(long)_unitModel.waiting_count];
    if (_unitModel.waiting.status == 1) {
        _waitNumberLab.text = IsStrEmpty(_unitModel.waiting.number) ? [NSString stringWithFormat:@"前方%ld人",(long)_unitModel.waiting.before] : [NSString stringWithFormat:@"轮候号码：%@       前方%ld人",NONullString(_unitModel.waiting.number),(long)_unitModel.waiting.before];
    } else if (_unitModel.waiting.status == 2 || _unitModel.waiting.status == 4 || _unitModel.waiting.status == 5 || _unitModel.waiting.status == 6) {
        _waitNumberLab.text = IsStrEmpty(_unitModel.waiting.number) ? @"房源已匹配" : [NSString stringWithFormat:@"轮候号码：%@       房源已匹配",NONullString(_unitModel.waiting.number)];
    } else if (_unitModel.waiting.status == 2) {
        _waitNumberLab.text = @"";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
