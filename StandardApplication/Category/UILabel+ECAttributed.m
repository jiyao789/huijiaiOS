//
//  UILabel+ECAttributed.m
//  StandardApplication
//
//  Created by chao on 2020/3/24.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import "UILabel+ECAttributed.h"



@implementation UILabel (ECAttributed)

- (void)ec_setAttributedText:(NSString *)text
{
    if (text == nil || text.length == 0) {
      self.text = @"";
    }
    
    NSMutableString *originString = [[NSMutableString alloc] init];

    NSArray *styles = [text componentsSeparatedByString:@"</font>"];
    if (styles.count == 0) {
      self.text = text;
    }
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (NSString *line in styles)
    {
          if (line == nil || line.length == 0)
          {
            continue;
          }
            NSRange range = [line rangeOfString:@"<font" options:NSCaseInsensitiveSearch];
            BOOL hasProperty = [line rangeOfString:@"</font>" options:NSCaseInsensitiveSearch].location == NSNotFound;
            if (range.location != NSNotFound && hasProperty)
            {
                NSString *preString = [line substringToIndex:range.location];
                [originString appendString:preString];
                // 不需要添加样式
                [resultArray addObject:@[preString]];
                NSLog(@"%@", preString);
                NSString *restLine = [line substringFromIndex:range.location + range.length];
                NSLog(@"restLine: %@", restLine);
                // 获取<font的结束标签>，寻找到第一个与之匹配的就是正确的
                range = [restLine rangeOfString:@">"];
                if (range.location != NSNotFound && range.length + range.length < restLine.length)
                {
                    preString = [restLine substringFromIndex:range.location + 1];
                    NSLog(@"tmpString: %@", preString);
                    // 解析样式
                    restLine = [restLine substringWithRange:NSMakeRange(0, restLine.length - 1 - preString.length)];
                    NSLog(@"restLine = %@", restLine);
                    // 过滤多余的空格
                    NSMutableString *styleString = [[NSMutableString alloc] init];
                    BOOL isSpace = NO;
                    for (NSUInteger i = 0; i < restLine.length; ++i) {
                      if ([restLine characterAtIndex:i] != ' ') {
                        if (isSpace && [restLine characterAtIndex:i] != '=' && styleString.length != 0) { // 前一个是空格，则需要先添加一个空格
                          if (i >= 1) {
                            // 如果前面有=号，则不添加空格
                            if ([styleString characterAtIndex:styleString.length - 1] == '=') {
                              [styleString appendString:[NSString stringWithFormat:@"%c", [restLine characterAtIndex:i]]];
                              isSpace = NO;
                              continue;
                            }
                          }
                          
                          [styleString appendString:[NSString stringWithFormat:@" %c", [restLine characterAtIndex:i]]];
                        } else {
                          [styleString appendString:[NSString stringWithFormat:@"%c", [restLine characterAtIndex:i]]];
                        }
                        
                        isSpace = NO;
                      } else {
                        isSpace = YES;
                        continue;
                      }
                    }
                    //
                    NSArray *tmpArray = [styleString componentsSeparatedByString:@" "];
                    NSMutableDictionary *styleDict = [[NSMutableDictionary alloc] init];
                    for (NSString *property in tmpArray) {
                      NSArray *propertyArray = [property componentsSeparatedByString:@"="];
                      if (propertyArray.count >= 2) {
                        NSString *propertyName = propertyArray[0];
                        NSString *propertyValue = propertyArray[1];
                        if (propertyName == nil || propertyName.length == 0 || propertyValue == nil || propertyValue.length == 0) {
                          NSLog(@"property is empty");
                          continue;
                        }
                        switch ([self privatejudgePropertyTypeWithName:propertyName]) {
                          case ECStyleTypeFont:
                            if ([propertyValue respondsToSelector:@selector(floatValue)]) {
                              [styleDict setObject:[UIFont systemFontOfSize:propertyValue.floatValue]
                                            forKey:NSFontAttributeName];
                            }
                            break;
                          case ECStyleTypeBoldFont:
                            if ([propertyValue respondsToSelector:@selector(floatValue)]) {
                              [styleDict setObject:[UIFont boldSystemFontOfSize:propertyValue.floatValue]
                                            forKey:NSFontAttributeName];
                            }
                            break;
                          case ECStyleTypeColor: {
                            UIColor *color = [self privateparseColorWithString:propertyValue];
                            if (color != nil) {
                              [styleDict setObject:color forKey:NSForegroundColorAttributeName];
                            }
                          }
                            break;
                          case ECStyleTypeBackgroundColor: {
                            UIColor *color = [self privateparseColorWithString:propertyValue];
                            if (color != nil) {
                              [styleDict setObject:color forKey:NSBackgroundColorAttributeName];
                            }
                            break;
                          }
                          case ECStyleTypeUnderline: {
                            if ([propertyValue respondsToSelector:@selector(intValue)]) {
                              // 与系统的枚举对应，超过的值过滤掉
                              if (propertyValue.intValue >= 0 && propertyValue.intValue <= 9) {
                                [styleDict setObject:@(propertyValue.intValue) forKey:NSUnderlineStyleAttributeName];
                              }
                            }
                          }
                          default:
                            break;
                        }
                      } else {
                        NSLog(@"属性写法不正确：%@，将会被过滤掉", property);
                      }
                    }
                    if (styleDict.count >= 1) {
                        [resultArray addObject:@[preString, styleDict]];
                      } else {
                        [resultArray addObject:@[preString]];
                      }
                      [originString appendString:preString];
                    } else {
                      NSLog(@"font开始标签没有对应的>符号");
                      // 不合规则的不处理样式
                      [resultArray addObject:@[restLine]];
                      [originString appendString:preString];
                    }
                }else
                {
                    NSString *originLine = [NSString stringWithFormat:@"%@", line];
                    [originString appendString:originLine];
                    // 不需要添加样式
                    [resultArray addObject:@[originLine]];
                }
    }
    // 拼接成完整的字符串
    NSLog(@"originString: %@", originString);
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:originString];
    NSUInteger location = 0;
    for (NSArray *item in resultArray)
    {
      NSString *itemString = item[0];
      if (item.count == 2) { // 有样式
        [attr setAttributes:item[1] range:NSMakeRange(location, itemString.length)];
      }
      location += itemString.length;
    }
    self.attributedText = attr;
}
- (ECStyleType)privatejudgePropertyTypeWithName:(NSString *)name {
  if (name == nil || ![name isKindOfClass:[NSString class]] || name.length == 0) {
    return ECStyleTypeNone;
  }
  // 不区分大小写
  if ([name compare:@"font" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return ECStyleTypeFont;
  } else if ([name compare:@"color" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return ECStyleTypeColor;
  } else if ([name compare:@"backgroundcolor" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return ECStyleTypeBackgroundColor;
  } else if ([name compare:@"boldfont" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return ECStyleTypeBoldFont;
  } else if ([name compare:@"underline" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return ECStyleTypeUnderline;
  }
  
  return ECStyleTypeNone;
}
- (UIColor *)privateparseColorWithString:(NSString *)colorString {
  if (colorString == nil || ![colorString isKindOfClass:[NSString class]] || colorString.length == 0) {
    return nil;
  }
   colorString = [colorString stringByReplacingOccurrencesOfString:@"'" withString:@""];
  if ([colorString hasPrefix:@"0x"] || [colorString hasPrefix:@"0X"])
  {
    if (colorString.length > 2) {
      colorString = [colorString substringFromIndex:2];
      
      return [self privateparseHexColor:colorString];
    }
  } else if ([colorString hasPrefix:@"#"]) {
      return [self privateparseHexColor:colorString];
  }
  return [UIColor yellowColor];
}

- (UIColor *)privateparseHexColor:(NSString *)hexColorString {
  if ([hexColorString hasPrefix:@"#"]) {
    return [self privatecolorWithHexString:hexColorString];
  }
  
  return [self privatecolorWithHexString:[NSString stringWithFormat:@"#%@", hexColorString]];
}

- (UIColor *)privatecolorWithHexString:(NSString *)hexString {
  NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
  CGFloat alpha, red, blue, green;
  switch([colorString length]) {
    case 3: // #RGB
      alpha = 1.0f;
      red = [self privatecolorComponentFrom:colorString start:0 length:1];
      green = [self privatecolorComponentFrom:colorString start:1 length:1];
      blue = [self privatecolorComponentFrom:colorString start:2 length:1];
      break;
    case 4: // #ARGB
      alpha = [self privatecolorComponentFrom:colorString start:0 length:1];
      red = [self privatecolorComponentFrom:colorString start:1 length:1];
      green = [self privatecolorComponentFrom:colorString start:2 length:1];
      blue = [self privatecolorComponentFrom:colorString start:3 length:1];
      break;
    case 6: // #RRGGBB
      alpha = 1.0f;
      red = [self privatecolorComponentFrom:colorString start:0 length:2];
      green = [self privatecolorComponentFrom:colorString start:2 length:2];
      blue = [self privatecolorComponentFrom:colorString start:4 length:2];
      break;
    case 8: // #AARRGGBB
      alpha = [self privatecolorComponentFrom:colorString start:0 length:2];
      red = [self privatecolorComponentFrom:colorString start:2 length:2];
      green = [self privatecolorComponentFrom:colorString start:4 length:2];
      blue = [self privatecolorComponentFrom:colorString start:6 length:2];
      break;
    default:
      [NSException raise:@"Invalid color value" format:@"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
      break;
  }
  
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (CGFloat)privatecolorComponentFrom:(NSString *)string
                         start:(NSUInteger)start
                        length:(NSUInteger)length {
  NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
  NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@",
                                                 substring, substring];
  unsigned hexComponent;
  [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
  
  return hexComponent / 255.0;
}

- (CGSize)preferredSizeWithMaxWidth:(CGFloat)maxWidth
{
    CGSize size = [self sizeThatFits:CGSizeMake(maxWidth, MAXFLOAT)];
    size.width = fmin(size.width, maxWidth); //在numberOfLine为1模式下返回的可能会比maxWidth大，所以这里我们限制下
    return size;
}

@end
