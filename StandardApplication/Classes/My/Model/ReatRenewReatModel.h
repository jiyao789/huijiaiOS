//
//  ReatRenewReatModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/4.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReatLesseeModel : NSObject
@property (retain, nonatomic) NSString *custom_id;
@property (retain, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger gender;
@property (strong, nonatomic) NSString *genderStr;
@property (retain, nonatomic) NSString *phone;
@property (retain, nonatomic) NSString *nation;
@property (retain, nonatomic) NSString *card;
@property (retain, nonatomic) NSString *local;
@property (assign, nonatomic) NSInteger politics;
@property (assign, nonatomic) NSInteger work_type;
@property (assign, nonatomic) NSInteger edu;
@end

@interface ReatOrgInfoModel : NSObject
@property (assign, nonatomic) NSInteger contract_id;
@property (assign, nonatomic) CGFloat area;
@property (retain, nonatomic) NSString *end_date;
@property (retain, nonatomic) NSString *imgs;
@property (retain, nonatomic) NSString *image_url;
@property (strong, nonatomic) NSArray *image_url_arr;
@property (retain, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger org_id;
@property (assign, nonatomic) CGFloat price;
@property (strong, nonatomic) NSString *priceString;
@property (assign, nonatomic) NSInteger room_type;
@property (strong, nonatomic) NSString *room_type_string;
@property (assign, nonatomic) NSInteger show_type;
@property (assign, nonatomic) NSInteger toward;
@property (strong, nonatomic) NSString *towardString;
@property (assign, nonatomic) NSInteger unit_id;
@property (assign, nonatomic) NSInteger nature;
@property (strong, nonatomic) NSArray *point;

@end

@interface ReatRenewReatModel : NSObject

@property (strong, nonatomic)ReatOrgInfoModel *org_info;
@property (strong, nonatomic)ReatLesseeModel *lessee;

@end

NS_ASSUME_NONNULL_END
