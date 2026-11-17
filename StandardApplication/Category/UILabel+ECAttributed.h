//
//  UILabel+ECAttributed.h
//  StandardApplication
//
//  Created by chao on 2020/3/24.
//  Copyright © 2020 DTiOS. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, ECStyleType) {
  ECStyleTypeNone = 0,
  ECStyleTypeFont = 1,
  ECStyleTypeColor = 2,
  ECStyleTypeBoldFont = 3,
  ECStyleTypeUnderline = 4,
  ECStyleTypeBackgroundColor = 5
};

@interface UILabel (ECAttributed)


- (void)ec_setAttributedText:(NSString *)text;

//自动计算尺寸
- (CGSize)preferredSizeWithMaxWidth:(CGFloat)maxWidth;

@end

NS_ASSUME_NONNULL_END
