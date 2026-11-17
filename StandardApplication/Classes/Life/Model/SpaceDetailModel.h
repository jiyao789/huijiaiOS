//
//  SpaceDetailModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/1.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpaceDetailModel : NSObject
@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) NSString *space_name;
@property (retain, nonatomic) NSString *space_introduction;
@property (assign, nonatomic) NSInteger people_number;
@property (retain, nonatomic) NSString *start_opening_hours;
@property (retain, nonatomic) NSString *end_opening_hours;
@property (retain, nonatomic) NSString *open_date;
@property (retain, nonatomic) NSString *space_img;
@property (strong, nonatomic) NSArray *space_imgArr;
@property (retain, nonatomic) NSString *space_address;
@property (retain, nonatomic) NSDictionary *count;
@property (strong, nonatomic) UserModel *user_info;
@end

NS_ASSUME_NONNULL_END
