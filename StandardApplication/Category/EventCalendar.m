//
//  EventCalendar.m
//  添加到手机日历提醒事件
//
//  Created by DTiOS on 20/03/27.
//  Copyright © 2020年 DTiOS. All rights reserved.
//

#import "EventCalendar.h"
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>
#import "MacroDefine.h"

@implementation EventCalendar


static EventCalendar *calendar;

+ (instancetype)sharedEventCalendar{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[EventCalendar alloc] init];
    });
    
    return calendar;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [super allocWithZone:zone];
    });
    return calendar;
}

- (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray{
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (error)
                {
                    [MBProgressHUD showMessag:@"添加失败，请稍后重试" toView:nil];
                }else if (!granted){
                    [MBProgressHUD showMessag:@"不允许使用日历,请在设置中允许此App使用日历" toView:nil];
                    
                }else{
                    
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = title;
                    event.location = location;
                    
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                    
                    event.startDate = startDate;
                    event.endDate   = endDate;
                    event.allDay = allDay;
                    
                    //添加提醒
                    if (alarmArray && alarmArray.count > 0) {
                        
                        for (NSString *timeString in alarmArray) {
                            [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeString integerValue]]];
                        }
                    }
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    [MBProgressHUD showMessag:@"已添加到系统日历中" toView:nil];
                    
                }
            });
        }];
    }
}

@end
