//
//  RmtTitleCollectionViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2024/10/25.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "RmtTitleCollectionViewCell.h"

@implementation RmtTitleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NewsInfoModel *)model
{
    _model = model;
    _titleLab.text = NONullString(_model.title);
}

@end
