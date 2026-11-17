//
//  CommunityActivityListTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "CommunityActivityListTableViewCell.h"

@implementation CommunityActivityListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setActivityListModel:(ActivityListModel *)activityListModel
{
    _activityListModel = activityListModel;
    [_activityImageView setImageUrl:NONullString(_activityListModel.image_url) placeholderImage:defaultIconName];
    _activityTitleLab.text = NONullString(_activityListModel.title);
    _activityBrieflyLab.text = NONullString(_activityListModel.briefly);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
