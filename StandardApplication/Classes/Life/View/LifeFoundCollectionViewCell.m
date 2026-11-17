//
//  LifeFoundCollectionViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2022/8/3.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "LifeFoundCollectionViewCell.h"

@implementation LifeFoundCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ListModel *)model
{
    _model = model;
    [_lifeImageView setImageUrl:NONullString(_model.image_url) placeholderImage:defaultIconName];
    _contentLab.text = NONullString(_model.title);
}

@end
