//
//  BillDetailModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/6.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SubscribeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookDateModel : NSObject
@property (assign, nonatomic) NSInteger book_id;
@property (retain, nonatomic) NSString *book_date;
@property (retain, nonatomic) NSString *book_number;
@property (assign, nonatomic) CGFloat price;
@property (strong, nonatomic) NSString *priceString;
@property (assign, nonatomic) CGFloat income_price;
@property (strong, nonatomic) NSString *income_priceString;
@property (assign, nonatomic) CGFloat deduct;
@property (strong, nonatomic) NSString *deductString;
@property (strong, nonatomic) NSString *income_way;
@property (strong, nonatomic) NSString *name;
@end

@interface BillDetailModel : NSObject
@property (assign, nonatomic) NSInteger b_id;
@property (assign, nonatomic) NSInteger unit_id;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *number;
@property (strong, nonatomic) UnitModel *unit;
@property (assign, nonatomic) CGFloat total;
@property (strong, nonatomic) NSString *totalString;
/// 押金
@property (assign, nonatomic) CGFloat income;
@property (strong, nonatomic) NSString *incomeString;
@property (assign, nonatomic) CGFloat price;
@property (strong, nonatomic) NSString *priceString;
/// 滞纳金
@property (assign, nonatomic) CGFloat late;
@property (strong, nonatomic) NSString *lateString;
@property (retain, nonatomic) NSString *start_date;
@property (retain, nonatomic) NSString *end_date;
@property (retain, nonatomic) NSString *created_time;
@property (retain, nonatomic) NSString *bill_date;
@property (retain, nonatomic) NSString *income_date;
///是否逾期 0 否 1是
@property (assign, nonatomic) NSInteger overdue;
///是否收款 0 否 1 是
@property (assign, nonatomic) NSInteger payed;
///是否有效 0 否 1 是
@property (assign, nonatomic) NSInteger active;
///是否结清 {1:是 0:否} (结清:total=income)
@property (assign, nonatomic) NSInteger clear;
@property (retain, nonatomic) NSString *note;
@property (strong, nonatomic) BookDateModel *book_data;
@end

NS_ASSUME_NONNULL_END
