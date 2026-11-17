//
//  CountyTownModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/1.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PointMoreModel : NSObject
@property (assign, nonatomic) NSInteger key;
@property (retain, nonatomic) NSString *val;
@property (assign, nonatomic) BOOL select;
@end

@interface TownModel : NSObject
@property (retain, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger town_id;
@property (assign, nonatomic) BOOL isSelect;
@end

@interface CountyTownModel : NSObject
@property (retain, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger county_id;
@end

NS_ASSUME_NONNULL_END
