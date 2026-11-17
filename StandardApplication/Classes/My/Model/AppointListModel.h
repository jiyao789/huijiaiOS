//
//  AppointListModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/4.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppointOrgModel : NSObject
@property (retain, nonatomic) NSString *all_floor;
@property (assign, nonatomic) NSInteger region_id;
@property (retain, nonatomic) NSString *name;
@end

@interface AppointRegionModel : NSObject
@property (retain, nonatomic) NSString *address;
@property (assign, nonatomic) NSInteger choice_get_number;
@property (retain, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger number;
@end

@interface AppointUnitModel : NSObject
@property (assign, nonatomic) CGFloat area;
@property (retain, nonatomic) NSString *imgs;
@property (retain, nonatomic) NSString *image_url;
@property (assign, nonatomic) CGFloat price;
@property (retain, nonatomic) NSString *priceString;
@property (assign, nonatomic) NSInteger number;
@property (assign, nonatomic) NSInteger floor;
@property (assign, nonatomic) NSInteger level;
@property (assign, nonatomic) NSInteger shi;
@property (strong, nonatomic) NSString *shiString;
@property (assign, nonatomic) NSInteger ting;
@property (assign, nonatomic) NSInteger toward;
@property (retain, nonatomic) NSString *towardString;
@property (assign, nonatomic) NSInteger wei;
@property (assign, nonatomic) NSInteger nature;
@end

@interface AppointListModel : NSObject
@property (assign, nonatomic) NSInteger book_id;
@property (assign, nonatomic) NSInteger org_id;
@property (assign, nonatomic) NSInteger unit_id;
@property (retain, nonatomic) NSString *book_date;
@property (assign, nonatomic) NSInteger payed;
@property (assign, nonatomic) NSInteger income_price;
@property (strong, nonatomic) AppointUnitModel *unit;
@property (strong, nonatomic) AppointRegionModel *region;
@property (strong, nonatomic) AppointOrgModel *org;

@end

NS_ASSUME_NONNULL_END
