//
//  SpaceAppointmentCalendarTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "SpaceDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpaceAppointmentCalendarTableViewCell : UITableViewCell<FSCalendarDelegate,FSCalendarDataSource>
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (strong, nonatomic) SpaceDetailModel *spaceDetailModel;
@property(nonatomic, copy) void (^didSelectDateBlock) (NSString *dateStr);
@end

NS_ASSUME_NONNULL_END
