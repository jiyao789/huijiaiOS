//
//  UIView+CustomXibSettings.m
//  StandardApplication
//
//  Created by liyuanbo on 2019/9/17.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "UIView+CustomXibSettings.h"

@implementation UIView (CustomXibSettings)

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setMaskToBounds:(BOOL)maskToBounds
{
    self.layer.masksToBounds = maskToBounds;
}

- (BOOL)maskToBounds
{
    return self.layer.masksToBounds;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

@end
