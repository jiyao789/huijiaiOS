//
//  LockListModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/6.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LockListModel : NSObject
@property (assign, nonatomic) NSInteger bind_id;
@property (retain, nonatomic) NSString *bind_name;
@property (retain, nonatomic) NSString *bind_module;
/// 锁别名
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *device_id;
@property (retain, nonatomic) NSString *device_no;
@property (retain, nonatomic) NSString *device_identity;
@property (assign, nonatomic) NSInteger lock_type;
/// 是否在线 1：在线，2：离线，-1：未知
@property (assign, nonatomic) NSInteger is_online;
/// 有效的授权数量
@property (assign, nonatomic) NSInteger available_key_count;
@property (retain, nonatomic) NSString *updated_at;

@end

NS_ASSUME_NONNULL_END
