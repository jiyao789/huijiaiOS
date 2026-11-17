//
//  HouseDetailModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/31.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegionModel : NSObject
@property (assign, nonatomic) NSInteger province_id;
@property (assign, nonatomic) NSInteger city_id;
@property (assign, nonatomic) NSInteger county_id;
@property (assign, nonatomic) NSInteger town_id;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *address;
@property (assign, nonatomic) NSInteger number;
@property (retain, nonatomic) NSString *province_name;
@property (retain, nonatomic) NSString *city_name;
@property (retain, nonatomic) NSString *county_name;
@property (retain, nonatomic) NSString *town_name;
@property (assign, nonatomic) NSInteger choice_get_number;
@property (strong, nonatomic) NSString *choice_get_numberString;
@end

@interface HouseDetailModel : NSObject
@property (assign, nonatomic) NSInteger unit_id;
@property (assign, nonatomic) NSInteger nature;
@property (assign, nonatomic) CGFloat price;
@property (strong, nonatomic) NSString *priceString;
@property (assign, nonatomic) CGFloat area;
@property (assign, nonatomic) NSInteger shi;
@property (strong, nonatomic) NSString *shiString;
@property (assign, nonatomic) NSInteger ting;
@property (assign, nonatomic) NSInteger toward;
@property (strong, nonatomic) NSString *towardString;
@property (strong, nonatomic) NSArray *point;
@property (strong, nonatomic) NSArray *furniture;
@property (strong, nonatomic) NSArray *imgs;
@property (retain, nonatomic) NSString *intro;
@property (assign, nonatomic) BOOL collect;
@property (strong, nonatomic) RegionModel *region;
@end

NS_ASSUME_NONNULL_END
