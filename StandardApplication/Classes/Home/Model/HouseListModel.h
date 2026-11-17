//
//  HouseListModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/30.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseListModel : NSObject
@property (assign, nonatomic) NSInteger unit_id;
@property (assign, nonatomic) NSInteger shi;
@property (strong, nonatomic) NSString *shiString;
@property (assign, nonatomic) NSInteger ting;
@property (assign, nonatomic) CGFloat area;
@property (assign, nonatomic) NSInteger toward;
@property (strong, nonatomic) NSString *towardString;
@property (assign, nonatomic) NSInteger hot;
@property (strong, nonatomic) NSArray *point;
@property (assign, nonatomic) CGFloat price;
@property (strong, nonatomic) NSString *priceString;
@property (retain, nonatomic) NSString *imgs;
@property (retain, nonatomic) NSString *region_name;
@property (retain, nonatomic) NSString *region_address;
@property (assign, nonatomic) NSInteger region_number;
///预定 0 否 1 是
@property (assign, nonatomic) NSInteger book;
///1 公租 2 社租
@property (assign, nonatomic) NSInteger nature;
///1 独栋 2 整套 3 单间
@property (assign, nonatomic) NSInteger show_type;
///是否收藏 0 否 1 是
@property (assign, nonatomic) NSInteger collect;

@property (assign, nonatomic) CGFloat rowHeight;
@end

NS_ASSUME_NONNULL_END
