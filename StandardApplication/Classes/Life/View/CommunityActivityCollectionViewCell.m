//
//  CommunityActivityCollectionViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "CommunityActivityCollectionViewCell.h"

@implementation CommunityActivityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ListModel *)model
{
    [_activityImageView setImageUrl:NONullString(model.image_url) placeholderImage:defaultIconName];
//    _activityTitleLab.text = NONullString(model.title);
}

@end
