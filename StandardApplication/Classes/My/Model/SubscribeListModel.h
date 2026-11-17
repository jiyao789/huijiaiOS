//
//  SubscribeListModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/3.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "BigHouseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnitModel : NSObject
@property (assign, nonatomic) CGFloat area;
@property (retain, nonatomic) NSString *imgs;
@property (strong, nonatomic) NSArray *point;
@property (assign, nonatomic) CGFloat price;
@property (assign, nonatomic) NSInteger nature;
@property (strong, nonatomic) NSString *priceString;
@property (retain, nonatomic) NSString *region_address;
@property (retain, nonatomic) NSString *region_name;
@property (assign, nonatomic) NSInteger region_number;
@property (assign, nonatomic) NSInteger shi;
@property (strong, nonatomic) NSString *shiString;
@property (assign, nonatomic) NSInteger ting;
@property (assign, nonatomic) NSInteger org_unit;
@property (assign, nonatomic) NSInteger org_id;
@property (assign, nonatomic) NSInteger unit_cell;
@property (assign, nonatomic) NSInteger unit_floor;
@property (assign, nonatomic) NSInteger unit_house;
@property (retain, nonatomic) NSString *org_name;
@property (assign, nonatomic) NSInteger unit_number;
@property (assign, nonatomic) NSInteger block_unit;
@property (assign, nonatomic) NSInteger toward;
@property (strong, nonatomic) NSString *towardString;
@property (assign, nonatomic) NSInteger unit_id;
@property (assign, nonatomic) NSInteger show_type;
@property (assign, nonatomic) NSInteger choice_get_number;
@property (strong, nonatomic) NSString *choice_get_numberString;
@property (strong, nonatomic) NSString *contractWorkHouseString;

@end

@interface SubscribeListModel : NSObject

@property (assign, nonatomic) NSInteger id;
// 房源分类 1:常规房源 [返回unit] 2:共享房源 [返回house]
@property (assign, nonatomic) NSInteger classInt;
@property (assign, nonatomic) NSInteger unit_id;
@property (retain, nonatomic) NSString *created_date;
@property (strong, nonatomic) UnitModel *unit;
@property (strong, nonatomic) BigHouseModel *house;

// 预约看房相关
@property (retain, nonatomic) NSString *book_date;
@property (retain, nonatomic) NSString *time_slot;
///是否取消 {0:否 1:是}
@property (assign, nonatomic) NSInteger is_cancel;
///核验状态 {0:未操作 1:通过 2:拒绝}
@property (assign, nonatomic) NSInteger verify_status;
@end

NS_ASSUME_NONNULL_END
