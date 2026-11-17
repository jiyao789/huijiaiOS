//
//  ActivityReviewCollectionViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2024/10/15.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "ActivityReviewCollectionViewCell.h"

@implementation ActivityReviewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ListModel *)model
{
    [_activityImageView setImageUrl:NONullString(model.image_url) placeholderImage:defaultIconName];
    _activityTitleLab.text = NONullString(model.title);
}

@end
