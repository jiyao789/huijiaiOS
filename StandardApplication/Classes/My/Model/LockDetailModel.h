//
//  LockDetailModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/6.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LockDetailModel : NSObject
@property (retain, nonatomic) NSString *bind_name;
/// 锁别名
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *device_no;
@property (retain, nonatomic) NSString *device_identity;
@property (assign, nonatomic) NSInteger electric_quantity;
/// 是否在线 1：在线，2：离线，-1：未知
@property (assign, nonatomic) NSInteger is_online;
/// 锁开门的关键信息
@property (retain, nonatomic) NSString *lock_key;
/// 锁数据，操作锁用的
@property (retain, nonatomic) NSString *lock_data;
@property (retain, nonatomic) NSString *lock_mac;
@property (assign, nonatomic) long long updated_at;
@property (assign, nonatomic) long long lock_time;
@end

NS_ASSUME_NONNULL_END
