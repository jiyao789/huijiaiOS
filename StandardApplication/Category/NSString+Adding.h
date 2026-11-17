//
//  NSString+Adding.h
//  PublicFundraising
//
//  Created by liuyong on 15/10/20.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Adding)

- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size;
- (NSString *)strmethodComma;
- (NSString *)wanStrmethodComma;
-(int)convertToInt:(NSString*)strtemp;
- (NSMutableAttributedString *)attributedText:(NSInteger)length colorStr:(NSString *)color font:(CGFloat)font;
+ (NSInteger)foundOnlyStringLocation:(NSString *)text tempStr:(NSString *)tempStr;
// 更改小数点后的font
- (NSMutableAttributedString *)attributedText:(CGFloat)font;
// 改变行间距
- (NSMutableAttributedString *)attributedSpaceText:(NSString *)textStr;
//计算UILabel的高度(带有行间距的情况)
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;
- (id)objectFromJSONString;
+ (NSString *)convertToJsonData:(NSDictionary *)dict;
+ (NSString *)convertNSDictionaryToJsonString:(NSDictionary *)json;
+ (NSArray *)convertJsonStringToNSDictionary:(NSString *)jsonString;
@end
