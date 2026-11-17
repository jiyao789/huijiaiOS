//
//  ContractListModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/4.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContractUnitModel : NSObject
@property (assign, nonatomic) NSInteger unit_id;
@property (retain, nonatomic) NSString *imgs;
@property (retain, nonatomic) NSString *image_url;

@end

@interface ContractListModel : NSObject
@property (assign, nonatomic) NSInteger c_id;
@property (retain, nonatomic) NSString *download_url;
@property (retain, nonatomic) NSString *end_date;
@property (retain, nonatomic) NSString *start_date;
@property (retain, nonatomic) NSString *house;
@property (retain, nonatomic) NSString *number;
@property (assign, nonatomic) NSInteger online;
@property (assign, nonatomic) NSInteger rent_again;
@property (assign, nonatomic) CGFloat rental;
@property (strong, nonatomic) NSString *rentalString;
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *statusString;
@property (strong, nonatomic) UIColor *statusColor;
@property (retain, nonatomic) NSString *viewpdf_url;
@property (strong, nonatomic) ContractUnitModel *unit;
@end

NS_ASSUME_NONNULL_END
