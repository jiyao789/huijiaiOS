//
//  BillListModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/4.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SubscribeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BillListModel : NSObject

@property (assign, nonatomic) NSInteger b_id;
@property (assign, nonatomic) NSInteger unit_id;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *house;
@property (retain, nonatomic) NSString *start_date;
@property (retain, nonatomic) NSString *end_date;
@property (retain, nonatomic) NSString *created_time;
@property (retain, nonatomic) NSString *bill_date;
@property (retain, nonatomic) NSString *income_date;
@property (assign, nonatomic) NSInteger income_way;
@property (strong, nonatomic) NSString *income_wayString;
/// 实付款
@property (assign, nonatomic) CGFloat total;
@property (strong, nonatomic) NSString *totalString;
@property (strong, nonatomic) NSString *totalIncomeString;
/// 押金
@property (assign, nonatomic) CGFloat income;
@property (strong, nonatomic) NSString *incomeString;
/// 应付款
@property (assign, nonatomic) CGFloat price;
@property (strong, nonatomic) NSString *priceString;
/// 滞纳金
@property (assign, nonatomic) CGFloat late;
@property (strong, nonatomic) NSString *lateString;
@property (assign, nonatomic) NSInteger payed;
@property (retain, nonatomic) NSString *invoice_url;
@property (strong, nonatomic) UnitModel *unit;
@end

NS_ASSUME_NONNULL_END
