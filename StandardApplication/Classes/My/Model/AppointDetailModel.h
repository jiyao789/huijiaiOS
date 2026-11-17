//
//  AppointDetailModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/4.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubscribeListModel.h"
#import "BigHouseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppointDetailModel : NSObject

@property (retain, nonatomic) NSString *book_date;
@property (retain, nonatomic) NSString *time_slot;
@property (assign, nonatomic) NSInteger book_id;
@property (retain, nonatomic) NSString *book_number;
@property (retain, nonatomic) NSString *card;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *phone;
@property (assign, nonatomic) CGFloat price;
@property (strong, nonatomic) NSString *priceStr;
@property (assign, nonatomic) NSInteger unit_id;
/// 是否取消 {0:否 1:是}
@property (assign, nonatomic) NSInteger is_cancel;
/// 核验状态 {0:未操作 1:通过 2:拒绝}
@property (assign, nonatomic) NSInteger verify_status;
/// 是否支付 {0:否 1:是}
@property (assign, nonatomic) NSInteger payed;
@property (strong, nonatomic) UnitModel *unit;
// 房源分类 1:常规房源 [返回unit] 2:共享房源 [返回house]
@property (assign, nonatomic) NSInteger classInt;
@property (strong, nonatomic) BigHouseModel *house;
@end

NS_ASSUME_NONNULL_END
