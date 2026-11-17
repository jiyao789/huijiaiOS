//
//  UserModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/30.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
@property (retain, nonatomic) NSString *u_id;
@property (retain, nonatomic) NSString *nickname;
@property (retain, nonatomic) NSString *avatar;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *gender;
@property (retain, nonatomic) NSString *phone;
///收藏数量
@property (assign, nonatomic) NSInteger subscribe_count;
///资格预审数量
@property (assign, nonatomic) NSInteger license_count;
///预定看房数量
@property (assign, nonatomic) NSInteger book_count;
///预约看房数量
@property (assign, nonatomic) NSInteger reserve_count;
///轮候数量
@property (assign, nonatomic) NSInteger unitWaiting_count;
///申报数量
@property (assign, nonatomic) NSInteger declaration_count;
///属于同住人性质
@property (assign, nonatomic) NSInteger is_live;
///是否设置密码 true:已设置 false:没有设置    hash 为null 提醒, 不为null 不提醒
@property (assign, nonatomic) BOOL hash;
@end

NS_ASSUME_NONNULL_END
