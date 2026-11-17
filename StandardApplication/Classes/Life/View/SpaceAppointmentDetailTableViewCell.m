//
//  SpaceAppointmentDetailTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SpaceAppointmentDetailTableViewCell.h"
#import "MacroDefine.h"

@implementation SpaceAppointmentDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSpaceDetailModel:(SpaceDetailModel *)spaceDetailModel
{
    _spaceDetailModel = spaceDetailModel;
    _spaceNameLab.text = NONullString(_spaceDetailModel.space_name);
    _spaceAddressLab.text = [NSString stringWithFormat:@"活动地点：%@",_spaceDetailModel.space_address];
    _spaceIntroLab.text = [NSString stringWithFormat:@"空间介绍：%@",_spaceDetailModel.space_introduction];
    [_spaceImageView setImageUrl:[NSString stringWithFormat:@"%@",_spaceDetailModel.space_imgArr.firstObject] placeholderImage:defaultIconName];
    _spaceOpenTimeLab.text = [NSString stringWithFormat:@"空间开放时间段：%@-%@",_spaceDetailModel.start_opening_hours,_spaceDetailModel.end_opening_hours];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
