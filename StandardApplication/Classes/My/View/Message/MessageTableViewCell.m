//
//  MessageTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setWorkOrderIndexModel:(WorkOrderIndexModel *)workOrderIndexModel
{
    _workOrderIndexModel = workOrderIndexModel;
    _messageSummyLab.text = NONullString(_workOrderIndexModel.message);
    _messageTimeLab.text = NONullString(_workOrderIndexModel.modified_time);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
