//
//  ZKCollectionViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2019/7/29.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#define fsRGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#import "ZKCollectionViewCell.h"
#import "UIColor+IHGradientChange.h"
#import "MacroDefine.h"

@implementation ZKCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.zkImageView.layer.cornerRadius = 0;
//    self.zkImageView.layer.masksToBounds = YES;
//
//    self.zkTitleLab.font = MakeSNRegularFontSize18;
    
//    [_backView.layer addSublayer:[UIColor setUpDownChangingColor:_backView fromColor:fsRGBAlpha(0, 0, 0, 0) toColor:fsRGBAlpha(0, 0, 0, 1)]];
    
    [CommonUtils addCorner:_liveStatusButton rect:_liveStatusButton.bounds rectCorner:UIRectCornerTopLeft cornerRadii:CGSizeMake(6, 6)];
}

@end
