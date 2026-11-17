//
//  LockListTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/29.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "LockListTableViewCell.h"

@implementation LockListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLockListModel:(LockListModel *)lockListModel
{
    _lockListModel = lockListModel;
    
    _houseNameLab.text = NONullString(_lockListModel.name);
    _houseAddressLab.text = [NSString stringWithFormat:@"%@：%@",(_lockListModel.lock_type == 2 ? @"地址" : @"位置"),NONullString(_lockListModel.bind_name)];
    _lockEventLab.text = _lockListModel.lock_type == 2 ? @"开门" : @"开锁";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
