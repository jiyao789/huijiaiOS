//
//  UITextField+Helper.m
//  gongfubao
//
//  Created by gonghuiiOS on 15/11/4.
//  Copyright © 2015年 刘义喜. All rights reserved.
//

#define placeholder @" "


#import "UITextField+Helper.h"
#import <objc/runtime.h>

@implementation UITextField (Helper)

//Property
@dynamic isAddHideBtn;

/**
 *  手机号码格式化
 *  参数 textField UITextField控件
 *  参数 range 文本范围
 *  参数 string 字符串
 */
+ (BOOL)phoneNumberFormatTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField text];
    // 只能输入数字
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
    {
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];

    // 如果是电话号码格式化，需要添加这三行代码
    NSMutableString *temString = [NSMutableString stringWithString:text];
    [temString insertString:@" " atIndex:0];
    text = temString;

    
    NSString *newString = @"";
    
    while (text.length > 0)
    {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4)
        {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    // 号码14 银行卡 24
    if (newString.length >= 14)
    {
        return NO;
    }
    
    [textField setText:newString];
    
    return NO;
}

/**
 *  银行卡格式化
 *  参数 textField UITextField控件
 *  参数 range 文本范围
 *  参数 string 字符串
 */
+ (BOOL)bankNumberFormatTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *phStr = @" ";
    unichar phChar = ' ';
    if (phStr.length) {
        phChar = [phStr characterAtIndex:0];
    }
    
    if (textField) {
        NSString* text = textField.text;
        //删除
        if([string isEqualToString:@""]){
            
            //删除一位
            if(range.length == 1){
                //最后一位,遇到空格则多删除一次
                if (range.location == text.length - 1 ) {
                    if ([text characterAtIndex:text.length - 1] == phChar) {
                        [textField deleteBackward];
                    }
                    return YES;
                }
                //从中间删除
                else{
                    NSInteger offset = range.location;
                    
                    if (range.location < text.length && [text characterAtIndex:range.location] == phChar && [textField.selectedTextRange isEmpty]) {
                        [textField deleteBackward];
                        offset --;
                    }
                    [textField deleteBackward];
                    textField.text = [textField _parseString:textField.text];
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                    
//                    [self matchBankNameAndType:textField];
//                    [self textChangeText];
                    
                    return NO;
                }
            }
            else if (range.length > 1) {
                BOOL isLast = NO;
                //如果是从最后一位开始
                if(range.location + range.length == textField.text.length ){
                    isLast = YES;
                }
                [textField deleteBackward];
                textField.text = [textField _parseString:textField.text];
                
                NSInteger offset = range.location;
                if (range.location == 4 || range.location  == 9 || range.location  == 14 || range.location  == 19|| range.location  == 24) {
                    offset ++;
                }
                if (isLast) {
                    //光标直接在最后一位了
                }else{
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                }
                
//                [self matchBankNameAndType:textField];
//                [self textChangeText];
                
                return NO;
            }
            
            else{
                return YES;
            }
        }
        
        else if(string.length >0){
            
            //限制输入字符个数
            if (([textField _noneSpaseString:textField.text].length + string.length - range.length > 20) ) {
                
//                [self matchBankNameAndType:textField];
//                [self textChangeText];
                
                return NO;
            }
            
            //判断是否是纯数字(搜狗，百度输入法，数字键盘居然可以输入其他字符)
            if(![textField _isNum:string]){
                
//                [self matchBankNameAndType:textField];
//                [self textChangeText];
                
                return NO;
            }
            [textField insertText:string];
            textField.text = [textField _parseString:textField.text];
            
            NSInteger offset = range.location + string.length;
            if (range.location == 4 || range.location  == 9 || range.location  == 14 || range.location  == 19|| range.location  == 24) {
                offset ++;
            }
            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            
//            [self matchBankNameAndType:textField];
//            [self textChangeText];
            
            return NO;
        }else{
            return YES;
        }
        
    }
    
    
    
    return YES;
}

/**
 *  银行卡 手机号 格式化
 *  格式说明 银行卡 XXXX XXXX XXXX XXXX XXX 或 XXXX XXXX XXXX XXXX  手机号 XXX XXXX XXXX
 *  参数 textField UITextField控件
 *  参数 range 文本范围
 *  参数 string 字符串
 *  参数 bankCodeOrPhoneCodeFlag 标记是银行卡 还是 手机号  银行卡 24(kBankCardFlag)  手机号 14(kPhoneFlag)
 *
 */
+ (BOOL)bankCardOrPhoneNumberFormatTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string bankCodeOrPhoneCodeFlag:(NSInteger )bankCodeOrPhoneCodeFlag
{
    NSString *text = [textField text];
    // 只能输入数字
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
    {
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 电话号码 传14 银行卡 传24
    if (bankCodeOrPhoneCodeFlag == 14)
    {
        // 如果是电话号码格式化，需要添加这三行代码
        NSMutableString *temString = [NSMutableString stringWithString:text];
        [temString insertString:@" " atIndex:0];
        text = temString;
    }
    
    NSString *newString = @"";
    
    while (text.length > 0)
    {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4)
        {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    // 号码14 银行卡 24
    if (newString.length >= bankCodeOrPhoneCodeFlag)
    {
        
        return NO;
    }
    
    [textField setText:newString];
    
    return NO;
}


/**
 *  验证码判断 只能是数字
 *  参数 digits 只能输入的位数
 */
+ (BOOL)codeNumberFormatTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string digits:(NSInteger)digits
{
    if(range.location <= digits - 1)
    {
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9'))//数据格式正确
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return NO;
    }
}


/**
 *  格式化后的号码转正常数字
 *  参数 textField UITextField控件
 */
+ (NSString *)numberToNormalNumTextField:(UITextField *)textField
{
    return [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}


- (NSString*)_parseString:(NSString*)string{
    
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:placeholder withString:@""]];
    if (mStr.length >4) {
        [mStr insertString:placeholder atIndex:4];
    }
    if (mStr.length > 9) {
        [mStr insertString:placeholder atIndex:9];
    }
    if (mStr.length > 14) {
        [mStr insertString:placeholder atIndex:14];
    }
    if (mStr.length > 19) {
        [mStr insertString:placeholder atIndex:19];
    }
    if (mStr.length > 24) {
        [mStr insertString:placeholder atIndex:24];
    }
    
    return  mStr;
    
}

/** 获取正常电话号码（去掉空格） */
- (NSString*)_noneSpaseString:(NSString*)string{
    
    return [string stringByReplacingOccurrencesOfString:placeholder withString:@""];
    
}

- (BOOL)_isNum:(NSString *)checkedNumString {
    
    if (!checkedNumString) {
        return NO;
    }
    
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if(checkedNumString.length > 0) {
        return NO;
    }
    
    return YES;
    
}
- (NSString *)plainPhoneNum {
    return [self _noneSpaseString:self.text];
}

@end
