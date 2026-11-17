//
//  MyItemCollectionViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2024/10/14.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "MyItemCollectionViewCell.h"
#import "MacroDefine.h"

@implementation MyItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ImageModel *)model
{
    _model = model;
    _itemImageView.image = [UIImage imageNamed: NONullString(_model.imageName)];
    _titleLab.text = NONullString(_model.title);
}

@end
