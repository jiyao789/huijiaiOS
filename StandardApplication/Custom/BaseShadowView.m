//
//  BaseShadowView.m
//  EnjoyOilBao
//
//  Created by yiye on 2018/12/28.
//  Copyright © 2018 yiye. All rights reserved.
//

#import "BaseShadowView.h"

@implementation BaseShadowView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        
        self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.11].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,1);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 5;
    }
    return self;
}

- (void)setCornerRadiu:(NSInteger)cornerRadiu
{
    _cornerRadiu = cornerRadiu;
    self.layer.cornerRadius = cornerRadiu;
}

@end
