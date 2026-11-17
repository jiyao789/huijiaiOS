//
//  BillListModel.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/4.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BillListModel.h"

@implementation BillListModel

- (NSString *)totalString
{
    float price = _total / 100;
    NSString *rentString = [NSString stringWithFormat:@"¥%.2f",price];
    return rentString;
}

- (NSString *)totalIncomeString
{
    float total = _total / 100;
    float income = _income / 100;
    NSString *rentString = [NSString stringWithFormat:@"¥%.2f",total - income];
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

- (NSString *)income_wayString
{
    NSString *payWayStr = @"";
    switch (_income_way) {
        case 1:
            payWayStr = @"微信";
            break;
        case 2:
            payWayStr = @"支付宝";
            break;
        case 3:
            payWayStr = @"银行卡";
            break;
        case 4:
            payWayStr = @"现金";
            break;
        case 5:
            payWayStr = @"线上-微信";
            break;
        case 6:
            payWayStr = @"线上-支付宝";
            break;
        default:
            break;
    }
    return payWayStr;
}

@end
