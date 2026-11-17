//
//  BaseShadowButton.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseShadowButton.h"

@implementation BaseShadowButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12;
        
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
