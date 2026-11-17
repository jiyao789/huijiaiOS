//
//  CommunityActivityDetailTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "CommunityActivityDetailTableViewCell.h"

@implementation CommunityActivityDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setActivityListModel:(ActivityListModel *)activityListModel
{
    _activityListModel = activityListModel;
    _activityTitleLab.text = NONullString(_activityListModel.title);
    _activityBrieflyLab.text = NONullString(_activityListModel.briefly);
    _activityImageViewLayoutHeight.constant = IsNilOrNull(_activityListModel.image_url) ? 0 : 170;
    _activityImageViewLayoutTop.constant = IsNilOrNull(_activityListModel.image_url) ? 0 : 20;
    _activityImageViewLayoutBottom.constant = IsNilOrNull(_activityListModel.image_url) ? 0 : 20;
    [_activityImageView setImageUrl:NONullString(_activityListModel.image_url) placeholderImage:defaultIconName];
    if ([_activityListModel.type isEqualToString:@"活动回顾"] || [_activityListModel.type isEqualToString:@"憓家发现"]) {
        _activityInfoShowLab.text = @"";
        _activityTimeLayoutBottom.constant = 0;
        return;
    }

    _activityTimeLab.text = [NSString stringWithFormat:@"活动时间：%@ %@-%@",_activityListModel.date,_activityListModel.start_time,_activityListModel.end_time];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
