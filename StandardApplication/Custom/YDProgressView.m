//
//  YDProgressView.m
//  StandardApplication
//
//  Created by liyuanbo on 2020/9/21.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import "YDProgressView.h"

@implementation YDProgressView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    self.trackTintColor = [UIColor whiteColor];
    self.progressTintColor = [UIColor blueColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setProgress:(float)progress
{
    if (progress < 0) {
        progress = 0;
    }
    if (progress > 1) {
        progress = 1;
    }
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath * backPath = [UIBezierPath bezierPathWithRect:rect];
    [self.trackTintColor setFill];
    [backPath fill];
    
    UIBezierPath * progressPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(rect) * self.progress, CGRectGetHeight(rect)) byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(CGRectGetHeight(rect) / 2, CGRectGetHeight(rect) / 2)];
    [self.progressTintColor setFill];
    [progressPath fill];
}

@end
