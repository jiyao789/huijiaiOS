//
//  RechargeRecodeModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/5.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RechargeRecodeModel : NSObject
@property (assign, nonatomic) NSInteger is_success;
@property (retain, nonatomic) NSString *operation;
@property (assign, nonatomic) float remaining_power_before_recharge;
@property (assign, nonatomic) float remaining_power_after_recharge;
@property (assign, nonatomic) float total_price;
@property (retain, nonatomic) NSString *operator;
@property (retain, nonatomic) NSString *recorded_at;
@property (retain, nonatomic) NSString *record_date;
@property (retain, nonatomic) NSString *bind_name;
@end

NS_ASSUME_NONNULL_END
