//
//  SurrenderTimeView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/29.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface SurrenderTimeView : UIView<FSCalendarDelegate,FSCalendarDataSource>
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (nonatomic, copy) void (^didSelectDateBlock) (NSString *dateStr);

@property (strong, nonatomic) NSString *end_date;
@end

NS_ASSUME_NONNULL_END
