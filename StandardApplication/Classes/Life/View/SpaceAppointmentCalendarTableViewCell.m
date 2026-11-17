//
//  SpaceAppointmentCalendarTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SpaceAppointmentCalendarTableViewCell.h"

@interface SpaceAppointmentCalendarTableViewCell()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation SpaceAppointmentCalendarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _calendar.delegate = self;
    _calendar.dataSource = self;
    _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:[NSDate getNowDateStr]];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did didSelect date %@",[self.dateFormatter stringFromDate:date]);
    SAFE_BLOCK(self.didSelectDateBlock,[self.dateFormatter stringFromDate:date]);
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"------------------%@",calendar.currentPage);
    [self getSpaceDetailDate:[self currentPageDateAddDay:calendar.currentPage]];
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSString *dateStr = [NSDate getDateToDateStr:date];
    NSDictionary *dateDic = [_spaceDetailModel.count objectForKey:dateStr];
    if ([dateDic[@"is_open"] integerValue] == 1 || [dateDic[@"space_count"] integerValue] == _spaceDetailModel.people_number) {
        return NO;
    }
    return YES;
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date
{
    NSString *dateStr = [NSDate getDateToDateStr:date];
    NSDictionary *dateDic = [_spaceDetailModel.count objectForKey:dateStr];
    if ([dateDic[@"is_open"] integerValue] == 1 || [dateDic[@"space_count"] integerValue] == _spaceDetailModel.people_number) {
        return [UIColor lightGrayColor];
    }
    return nil;
}

- (void)getSpaceDetailDate:(NSString *)currentPageDateString
{
    [MBProgressHUD showStatus:nil toView:nil];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:space_detailURL parameters:@{@"id":@(_spaceDetailModel.id),@"u_id":NONullString([User shareUser].getUserId),@"date":NONullString(currentPageDateString)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:nil];
        if (status == 1) {
            self.spaceDetailModel = [SpaceDetailModel mj_objectWithKeyValues:dic];
            [self.calendar reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:nil];
        }
    }];
}

- (NSString *)currentPageDateAddDay:(NSDate *)currentPageDate {
    NSTimeInterval oneDay = 24 * 60 * 60;  // 1天的长度
    NSDate *newDate = [currentPageDate dateByAddingTimeInterval:oneDay];
    return [NSDate getDateToDateStr:newDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
