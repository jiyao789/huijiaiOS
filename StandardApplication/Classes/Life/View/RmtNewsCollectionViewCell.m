//
//  RmtNewsCollectionViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2024/10/25.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "RmtNewsCollectionViewCell.h"

@implementation RmtNewsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NewsInfoModel *)model
{
    _model = model;
    [_imageView setImageUrl:NONullString(_model.image_url) placeholderImage:defaultIconName];
    _titleLab.text = NONullString(_model.title);
}

@end
