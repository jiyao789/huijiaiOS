//
//  SurrenderTimeView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/29.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SurrenderTimeView.h"

@interface SurrenderTimeView()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation SurrenderTimeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _calendar.delegate = self;
    _calendar.dataSource = self;
    _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
//    [_calendar selectDate:[NSDate date]];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
}

- (void)setEnd_date:(NSString *)end_date
{
    _end_date = end_date;
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate getNextMonth:[NSDate date]];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:_end_date];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did didSelect date %@",[self.dateFormatter stringFromDate:date]);
    SAFE_BLOCK(self.didSelectDateBlock,[self.dateFormatter stringFromDate:date]);
}

@end
