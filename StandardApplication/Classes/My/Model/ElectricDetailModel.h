//
//  ElectricDetailModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/5.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ElectricDetailModel : NSObject

@property (retain, nonatomic) NSString *bind_name;
@property (retain, nonatomic) NSString *name;
/// 付费模式 1：预付费，2后付费
@property (assign, nonatomic) NSInteger pay_type;
@property (retain, nonatomic) NSString *device_no;
@property (retain, nonatomic) NSString *device_identity;
/// 是否在线 1：在线，2：离线，-1：未知
@property (assign, nonatomic) NSInteger is_online;
/// 是否合闸 1：合闸，2：跳闸，-1：未知
@property (assign, nonatomic) NSInteger is_switch_on;
/// 电水表读数
@property (assign, nonatomic) CGFloat scale;
@property (retain, nonatomic) NSString *updated_at;
@property (retain, nonatomic) NSString *scale_updated_at;
@property (retain, nonatomic) NSString *scale_update_at;
/// 剩余电水量
@property (assign, nonatomic) CGFloat remaining_power;
/// 电水费单价
@property (assign, nonatomic) CGFloat unit_price;

@end

NS_ASSUME_NONNULL_END
