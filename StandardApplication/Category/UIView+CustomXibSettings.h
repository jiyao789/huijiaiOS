//
//  UIView+CustomXibSettings.h
//  StandardApplication
//
//  Created by liyuanbo on 2019/9/17.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CustomXibSettings)

/**
 圆角
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 是否切割边缘
 */
@property (nonatomic, assign) IBInspectable BOOL maskToBounds;

/**
 边框宽度
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 边框颜色
 */
@property (nonatomic, strong) IBInspectable UIColor * borderColor;

@end

NS_ASSUME_NONNULL_END
