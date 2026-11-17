//
//  BillDetailModel.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/6.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BillDetailModel.h"

@implementation BookDateModel
- (NSString *)priceString
{
    float price = _price / 100;
    NSString *rentString = [NSString stringWithFormat:@"¥%.2f",price];
    return rentString;
}
@end

@implementation BillDetailModel

- (NSString *)totalString
{
    float price = _total / 100;
    NSString *rentString = [NSString stringWithFormat:@"¥%.2f",price];
    return rentString;
}

- (NSString *)incomeString
{
    float price = _income / 100;
    NSString *rentString = [NSString stringWithFormat:@"¥%.2f",price];
    return rentString;
}

- (NSString *)priceString
{
    float price = _price / 100;
    NSString *rentString = [NSString stringWithFormat:@"¥%.2f",price];
    return rentString;
}

- (NSString *)lateString
{
    float price = _late / 100;
    NSString *rentString = [NSString stringWithFormat:@"¥%.2f",price];
    return rentString;
}

@end
