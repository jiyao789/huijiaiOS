//
//  NSDate+Helper.h
//  SuningEBuy
//
//  Created by 刘坤 on 12-8-30.
//  Copyright (c) 2012年 Suning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)

/*tools*/

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)formatString;

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatString;

//add by cuizl  计算某一天到达现在的天数
+(NSInteger) daysFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;

+(NSDateComponents *)timeMethodGo:(NSString *)dataStr;
//获取当前月份的上一个月
+(NSDate *)getPreMonth:(NSDate *)kdate;
//获取当前月份的下一个月
+(NSDate *)getNextMonth:(NSDate *)kdate;
//获取当前月份的第一天
+(NSString *)getCurMonthFirstDay:(NSDate *)kdate;
//获取当前月份的最后一天
+(NSString *)getCurMonthLastDay:(NSDate *)kdate;

+(NSString *)getCurrentMonthAndYears:(NSDate *)date;

+(NSDate *)getCurMonFirstDay:(NSDate *)kdate;

+ (NSDate *)stringToDate:(NSString *)dateStr;

+ (NSDateComponents *)getNowDate;

+ (NSInteger)getNowDateDay;

+ (NSString *)getNowDateStr;

+ (NSString *)getNowDateNOXianStr;

+ (NSString *)getNowDate1970Str;

+ (NSString *)getNowHMSDateStr;

+ (NSString *)getDateToDateStr:(NSDate *)date;

+ (BOOL)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

/// string形式的时间转NSDateComponents
+ (NSDateComponents *)stringToDateComponents:(NSString *)dataStr;

+ (NSString *)getYMDTimeMethod:(NSString *)dataStr;
+ (NSString *)getFormartTime:(NSString *)dataStr;
/// 获取发布时间距离现在时间
+ (NSString *)getTimeMethod:(NSString *)dataStr;

/// 根据当前日期获取最近一周weekday
+ (NSMutableArray *)getWeekdayArrayFromDate;

/// 根据日期获取时分
+ (NSString *)getHourMinutesFromDate:(NSString *)dateStr;

/// 时间转时间戳
+ (NSString *)timeToTimestampWtihString:(NSString *)time;
@end
