//
//  AppointDetailModel.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/4.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "AppointDetailModel.h"

@implementation AppointDetailModel

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"classInt":@"class"};
}

- (NSString *)priceStr
{
    float price = _price / 100;
    NSString *rentString = [NSString stringWithFormat:@"¥%.2f/月",price];
    return rentString;
}

@end
