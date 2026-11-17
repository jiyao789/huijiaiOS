//
//  UIColor+IHGradientChange.h
//  baseApplication
//
//  Created by aaq on 2019/2/6.
//  Copyright © 2019 leoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (IHGradientChange)
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromHexColor toColor:(UIColor *)toHexColor;
+ (CAGradientLayer *)setUpDownChangingColor:(UIView *)view fromColor:(UIColor *)fromHexColor toColor:(UIColor *)toHexColor;
+ (UIColor *)colorWithHex:(NSString *)hexColor;

@end

NS_ASSUME_NONNULL_END
