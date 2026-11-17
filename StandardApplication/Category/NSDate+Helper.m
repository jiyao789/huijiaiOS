//
//  NSDate+Helper.m
//  SuningEBuy
//
//  Created by 刘坤 on 12-8-30.
//  Copyright (c) 2012年 Suning. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)formatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

//add by cuizl  计算某一天到达现在的天数
+(NSInteger) daysFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate
{
    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSCalendarIdentifierGregorian ];
    
    NSUInteger unitFlags =NSCalendarUnitDay;
    
    NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:fromDate toDate:toDate  options:0];
    
//    chineseClendar = nil;
    return [cps day];
}

+(NSDateComponents *)timeMethodGo:(NSString *)dataStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale* local =[[NSLocale alloc] initWithLocaleIdentifier:@"en_China"];
    [dateFormatter setLocale: local];
    NSDate* fireDate = [dateFormatter dateFromString:dataStr];
    
//    NSDate *fireDate;
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSDate *today = [NSDate date];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *timeDay = [calender components:unitFlags fromDate:today toDate:fireDate options:0];
    return timeDay;
}
+(NSDate *)getPreMonth:(NSDate *)kdate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:-1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:kdate options:0];
    return newdate;
}
+(NSDate *)getNextMonth:(NSDate *)kdate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:kdate options:0];
    return newdate;
}

+ (BOOL)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return NO;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return YES;
    }
    //NSLog(@"Both dates are the same");
    return YES;
}

+(NSString *)getCurrentMonthAndYears:(NSDate *)date{
    NSDate *now = date;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth
                                     fromDate:now];
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString* str = [formatter stringFromDate:firstDay];
    return str;
}
+(NSString *)getCurMonthFirstDay:(NSDate *)kdate{
    NSDate *now = kdate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth
                                     fromDate:now];
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* str = [formatter stringFromDate:firstDay];
    return str;
}
+(NSDate *)getCurMonFirstDay:(NSDate *)kdate{
    NSDate *now = kdate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth
                                     fromDate:now];
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
    return firstDay;
}
+(NSString *)getCurMonthLastDay:(NSDate *)kdate{
    NSDate *now = kdate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth
                                     fromDate:now];
    NSRange daysRange = [cal rangeOfUnit:NSCalendarUnitDay
                                  inUnit:NSCalendarUnitMonth
                                 forDate:now];
    comps.day = daysRange.length;
    NSDate *lastDay = [cal dateFromComponents:comps];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd HH:mm:ss
    NSString* str = [formatter stringFromDate:lastDay];
    return str;
}

+ (NSDate *)stringToDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSLocale* local =[[NSLocale alloc] initWithLocaleIdentifier:@"en_China"];
    [dateFormatter setLocale: local];
    NSDate *fireDate = [dateFormatter dateFromString:dateStr];
    return fireDate;
}

+ (NSDateComponents *)getNowDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    return dateComponent;
}

+ (NSInteger)getNowDateDay
{
    NSInteger day = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    day = dateComponent.day;
    return day;
}

+ (NSString *)getNowDateStr
{
    NSDate *date=[NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = @"";
    dateStr=[format stringFromDate:date];
    return dateStr;
}

+ (NSString *)getNowDateNOXianStr
{
    NSDate *date=[NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = @"";
    dateStr=[format stringFromDate:date];
    return dateStr;
}

+ (NSString *)getDateToDateStr:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = @"";
    dateStr=[format stringFromDate:date];
    return dateStr;
}

+ (NSString *)getNowDate1970Str
{
    NSDate *date=[NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];;
    return dateStr;
}

+ (NSString *)getNowHMSDateStr
{
    NSDate *date=[NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = @"";
    dateStr=[format stringFromDate:date];
    return dateStr;
}

+ (NSDateComponents *)stringToDateComponents:(NSString *)dataStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale* local =[[NSLocale alloc] initWithLocaleIdentifier:@"en_China"];
    [dateFormatter setLocale: local];
    NSDate* fireDate = [dateFormatter dateFromString:dataStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:fireDate];
    return dateComponent;
}

+ (NSString *)getFormartTime:(NSString *)dataStr
{
    NSString *timeStr = @"";
    NSDate* fireDate = [self stringToDate:dataStr];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:fireDate toDate:[NSDate date] options:0];
    
    NSInteger years = [comps year];
    NSInteger months = [comps month];
    NSInteger days = [comps day];
//    NSInteger hours = [comps hour];
//    NSInteger minutes = [comps minute];
    
//    if (years < 0 || months < 0 || days < 0 || hours < 0 || minutes < 0) {
//        timeStr = @"刚刚";
//    } else if (years > 0 || months > 0 || days >= 3) {
//        timeStr = [self getYMDTimeMethod:dataStr];
//    } else if (days > 0 && days < 3) {
//        timeStr = [NSString stringWithFormat:@"%ld天前",days];
//    } else if (hours > 0) {
//        timeStr = [NSString stringWithFormat:@"%ld小时前",hours];
//    } else if (minutes > 1) {
//        timeStr = [NSString stringWithFormat:@"%ld分钟前", minutes];
//    } else if (minutes <= 1) {
//        timeStr = @"刚刚";
//    }
    if (years > 0 || months > 0 || days > 0) {
        timeStr = [self getYMDTimeMethod:dataStr];
    } else {
        NSDateComponents *dataComponent = [self stringToDateComponents:dataStr];
        timeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",(long)dataComponent.year,(long)dataComponent.month,(long)dataComponent.day,(long)dataComponent.hour,(long)dataComponent.minute];
    }
    return timeStr;
    
}
+ (NSString *)getYMDTimeMethod:(NSString *)dataStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale* local =[[NSLocale alloc] initWithLocaleIdentifier:@"en_China"];
    [dateFormatter setLocale: local];
    NSDate* fireDate = [dateFormatter dateFromString:dataStr];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = @"";
    dateStr = [format stringFromDate:fireDate];
    return dateStr;
}
+ (NSString *)getTimeMethod:(NSString *)dataStr
{
    NSString *timeStr = @"";
    NSDateComponents *dateComponent = [self stringToDateComponents:dataStr];
    NSDateComponents *dateNowComponent = [self getNowDate];
    if (dateComponent.year < dateNowComponent.year) {
        timeStr = [NSString stringWithFormat:@"%ld年前",dateNowComponent.year - dateComponent.year];
    } else if (dateComponent.year == dateNowComponent.year && dateComponent.month < dateNowComponent.month) {
        timeStr = [NSString stringWithFormat:@"%ld月前",dateNowComponent.month - dateComponent.month];
    } else if (dateComponent.year == dateNowComponent.year && dateComponent.month == dateNowComponent.month && dateComponent.day < dateNowComponent.day) {
        timeStr = [NSString stringWithFormat:@"%ld天前",dateNowComponent.day - dateComponent.day];
    } else if (dateComponent.year == dateNowComponent.year && dateComponent.month == dateNowComponent.month && dateComponent.day == dateNowComponent.day && dateComponent.hour < dateNowComponent.hour) {
        timeStr = [NSString stringWithFormat:@"%ld小时前",dateNowComponent.hour - dateComponent.hour];
    } else if (dateComponent.year == dateNowComponent.year && dateComponent.month == dateNowComponent.month && dateComponent.day == dateNowComponent.day && dateComponent.hour == dateNowComponent.hour && dateComponent.minute < dateNowComponent.minute) {
        timeStr = [NSString stringWithFormat:@"%ld分钟前",dateNowComponent.minute - dateComponent.minute];
    } else if (dateComponent.year == dateNowComponent.year && dateComponent.month == dateNowComponent.month && dateComponent.day == dateNowComponent.day && dateComponent.hour == dateNowComponent.hour && dateComponent.minute == dateNowComponent.minute && dateComponent.second < dateNowComponent.second) {
        timeStr = [NSString stringWithFormat:@"%ld秒前",dateNowComponent.second - dateComponent.second];
    } else if (dateComponent.year == dateNowComponent.year && dateComponent.month == dateNowComponent.month && dateComponent.day == dateNowComponent.day && dateComponent.hour == dateNowComponent.hour && dateComponent.minute == dateNowComponent.minute && dateComponent.second == dateNowComponent.second) {
        timeStr = @"刚刚";
    } else {
        timeStr = @"1分钟前";
    }
    return timeStr;
}

+ (NSMutableArray *)getWeekdayArrayFromDate
{
    NSMutableArray *weekDayArr = [NSMutableArray array];
    for (int i = 0; i < 7; i ++) {
        NSDate *nowDate = [NSDate date];
        NSTimeInterval oneDay = i * 24 * 60 * 60;
        NSDate *newDate = [nowDate dateByAddingTimeInterval:oneDay];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
        NSString *weekStr = [NSString stringWithFormat:@"%ld/%ld\n%@",(long)dateComponent.month,(long)dateComponent.day,[self theWeek:dateComponent.weekday]];
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)dateComponent.year,(long)dateComponent.month,(long)dateComponent.day];
        NSDictionary *dic = @{@"week":weekStr,@"date":dateStr};
        [weekDayArr addObject:dic];
    }
    return weekDayArr;
}

+ (NSString *)theWeek:(NSInteger)theWeek
{
    NSString *weekStr = @"";
    switch (theWeek) {
        case 1:
            weekStr = @"日";
            break;
        case 2:
            weekStr = @"一";
            break;
        case 3:
            weekStr = @"二";
            break;
        case 4:
            weekStr = @"三";
            break;
        case 5:
            weekStr = @"四";
            break;
        case 6:
            weekStr = @"五";
            break;
        case 7:
            weekStr = @"六";
            break;
            
        default:
            break;
    }
    return weekStr;
}

+ (NSString *)getHourMinutesFromDate:(NSString *)dateStr
{
    NSString *timeStr = @"";
    NSDateComponents *dateComponent = [self stringToDateComponents:dateStr];
    timeStr = [NSString stringWithFormat:@"%ld:%ld",(long)dateComponent.hour,(long)dateComponent.minute];
    return timeStr;
}

+ (NSString *)timeToTimestampWtihString:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"en_China"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [formatter dateFromString:time];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

@end
