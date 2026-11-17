//
//  MyCollectionViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ImageModel *)model
{
    _model = model;
    _myNameLab.text = NONullString(_model.title);
    _myImageView.image = [UIImage imageNamed:NONullString(_model.imageName)];
}
@end
