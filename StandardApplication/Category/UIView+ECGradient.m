//
//  UIView+ECGradient.m
//  StandardApplication
//
//  Created by chao on 2020/2/18.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import "UIView+ECGradient.h"
#import <objc/runtime.h>


@implementation UIView (ECGradient)

+ (Class)layerClass {
    return [CAGradientLayer class];
}

+ (UIView *)ec_gradientViewWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    UIView *view = [[self alloc] init];
    [view ec_setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint];
    return view;
}

- (void)ec_setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    self.ec_colors = [colorsM copy];
    self.ec_locations = locations;
    self.ec_startPoint = startPoint;
    self.ec_endPoint = endPoint;
}

#pragma mark- Getter&Setter

- (NSArray *)ec_colors {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEc_colors:(NSArray *)colors {
    objc_setAssociatedObject(self, @selector(ec_colors), colors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setColors:self.ec_colors];
    }
}

- (NSArray<NSNumber *> *)ec_locations {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEc_locations:(NSArray<NSNumber *> *)locations {
    objc_setAssociatedObject(self, @selector(ec_locations), locations, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setLocations:self.ec_locations];
    }
}

- (CGPoint)ec_startPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setEc_startPoint:(CGPoint)startPoint {
    objc_setAssociatedObject(self, @selector(ec_startPoint), [NSValue valueWithCGPoint:startPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setStartPoint:self.ec_startPoint];
    }
}

- (CGPoint)ec_endPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setEc_endPoint:(CGPoint)endPoint {
    objc_setAssociatedObject(self, @selector(ec_endPoint), [NSValue valueWithCGPoint:endPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setEndPoint:self.ec_endPoint];
    }
}
@end

//对于UILabel这种貌似已经重写过+layerClass方法的view，我目前是直接在其分类中再次重写+layerClass方法
@implementation UILabel (ECGradient)

+ (Class)layerClass {
    return [CAGradientLayer class];
}
@end
