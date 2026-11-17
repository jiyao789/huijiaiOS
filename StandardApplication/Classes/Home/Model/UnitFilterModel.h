//
//  UnitFilterModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/2.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnitFilterModel : NSObject
@property (assign, nonatomic) NSInteger min_price;
@property (assign, nonatomic) NSInteger max_price;
@property (assign, nonatomic) NSInteger shi;
@property (strong, nonatomic) NSString *points;
@property (assign, nonatomic) NSInteger county_id;
@property (assign, nonatomic) NSInteger town_id;
@end

NS_ASSUME_NONNULL_END
