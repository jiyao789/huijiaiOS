//
//  WaitHouseInfoTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2023/12/10.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "WaitHouseInfoTableViewCell.h"

@implementation WaitHouseInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setQueueExistModel:(WaitExistModel *)queueExistModel
{
    _queueExistModel = queueExistModel;
    _waitNumberLab.text = [NSString stringWithFormat:@"轮候号码：%@", NONullString(_queueExistModel.number)];
    _waitPeopleLab.text = _queueExistModel.status == 1 ? [NSString stringWithFormat:@"前方轮候：%@人", @(_queueExistModel.before)] : @"已匹配房源";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
