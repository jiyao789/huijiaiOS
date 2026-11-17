//
//  NSString+Adding.m
//  PublicFundraising
//
//  Created by liuyong on 15/10/20.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "NSString+Adding.h"
#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "UIColor+SNFoundation.h"

@implementation NSString (Adding)
- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size{

    CGSize retSize = CGSizeZero;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {

        CGRect rect =  [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil];
        retSize.width = ceil(rect.size.width);
        retSize.height = ceil(rect.size.height);

    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        retSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
    return retSize;
}

- (NSString *)strmethodComma
{
    NSString *string = self;
    if (string.length <= 3) {
        return string;
    }
    NSString *sign = nil;
    if ([string hasPrefix:@"-"]||[string hasPrefix:@"+"]) {
        sign = [string substringToIndex:1];
        string = [string substringFromIndex:1];
        if (string.length <= 3) {
            return [sign stringByAppendingString:string];
        }
    }
    
    NSArray *signs = [string componentsSeparatedByString:@"."];
    string = signs[0];
    if (string.length <= 3 && signs.count == 2) {
        string = [string stringByAppendingString:[NSString stringWithFormat:@".%@",signs[1]]];
        if (sign) {
            string = [sign stringByAppendingString:string];
        }
        return string;
    }
    
    NSString *pointLast = [string substringFromIndex:[string length]-3];
    NSString *pointFront = [string substringToIndex:[string length]-3];
    
    NSInteger commaNum = ([pointFront length]-1)/3;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < commaNum+1; i++) {
        NSInteger index = [pointFront length] - (i+1)*3;
        NSInteger leng = 3;
        if(index < 0)
        {
            leng = 3+index;
            index = 0;
            
        }
        NSRange range = {index,leng};
        NSString *stq = [pointFront substringWithRange:range];
        [arr addObject:stq];
    }
    NSMutableArray *arr2 = [NSMutableArray array];
    for (NSInteger i = [arr count]-1; i>=0; i--) {
        
        [arr2 addObject:arr[i]];
    }
    [arr2 addObject:pointLast];
    NSString *commaString = [arr2 componentsJoinedByString:@","];
    if (sign) {
        commaString = [sign stringByAppendingString:commaString];
    }
    if (signs.count == 2) {
        commaString = [commaString stringByAppendingString:[NSString stringWithFormat:@".%@",signs[1]]];
    }
    return commaString;
    
}

- (NSString *)wanStrmethodComma
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"," withString:@""];
    CGFloat value = [str floatValue];
    CGFloat wanValue = value/10000;
    str = [NSString stringWithFormat:@"%f",wanValue];
    str = [str strmethodComma];
    NSRange range = [str rangeOfString:@"."];
    
    if (range.location != NSNotFound)
    {
        NSArray *strs = [str componentsSeparatedByString:@"."];
        NSUInteger index = -1;
        if (strs.count>=2)
        {
            str = strs[1];
            if ([str hasSuffix:@"0"])
            {
                
                for (int i = 0;i<str.length; i++)
                {
                    NSString *subString = [str substringWithRange:NSMakeRange(i, 1)];
                    if ([subString integerValue] != 0)
                    {
                        index = i;
                    }
                }
            }
        }
        
        if (index == -1)
        {
            str = strs[0];
        }
        else
        {
            if (index == str.length - 1)
            {
                str = [NSString stringWithFormat:@"%@.%@",strs[0],str];
            }
            else
            {
                str = [NSString stringWithFormat:@"%@.%@",strs[0],[str substringWithRange:NSMakeRange(0, index + 1)]];
            }
        }
        
        //strs[0] ,
    }
    return str;
}

//  判断输入框汉字/英文的字符多少个
-(int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

//  富文本
- (NSMutableAttributedString *)attributedText:(NSInteger)length colorStr:(NSString *)color font:(CGFloat)font
{
    NSString *textStr = self;
    NSMutableAttributedString *borrowStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    [borrowStr beginEditing];
    [borrowStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:color] range:NSMakeRange(textStr.length - length, length)];
    [borrowStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(textStr.length - length, length)];
    return borrowStr;
}

- (NSMutableAttributedString *)attributedText:(CGFloat)font
{
    NSString *textStr = self;
    NSMutableAttributedString *borrowStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    if ([textStr rangeOfString:@"."].location != NSNotFound) {
        [borrowStr beginEditing];
        [borrowStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(textStr.length - 2, 2)];
    }
    return borrowStr;
}

//  发现text中只有唯一一个tempStr的位置
+ (NSInteger)foundOnlyStringLocation:(NSString *)text tempStr:(NSString *)tempStr
{
    NSRange range;
    range = [text rangeOfString:tempStr];
    if (range.location != NSNotFound) {
        return range.location;
    }else{
        NSLog(@"Not Found");
    }
    return 0;
}

- (NSMutableAttributedString *)attributedSpaceText:(NSString *)textStr
{
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:textStr];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
    return setString;
}

+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    
    NSDictionary *dic =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height;
}
- (id)objectFromJSONString
{
    if (self == nil) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    id parserJson = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return parserJson;
}

+ (NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSString *jsonString = [self convertNSDictionaryToJsonString:dict];
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    NSData *data = [mutStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
    
}

+ (NSString *)convertNSDictionaryToJsonString:(NSDictionary *)json {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"json解析失败:%@", error);
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSArray *)convertJsonStringToNSDictionary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSString *urlStr = [jsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonData = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"jsonString解析失败:%@", error);
        return nil;
    }
    return json;
}

@end
