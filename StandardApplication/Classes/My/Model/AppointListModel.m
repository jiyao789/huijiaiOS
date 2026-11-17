//
//  AppointListModel.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/4.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "AppointListModel.h"

@implementation AppointOrgModel

@end

@implementation AppointRegionModel

@end

@implementation AppointUnitModel

- (NSString *)towardString
{
    NSString *towardStr = @"";
    switch (_toward) {
        case 1:
            towardStr = @"朝东";
            break;
        case 2:
            towardStr = @"朝西";
            break;
        case 3:
            towardStr = @"朝南";
            break;
        case 4:
            towardStr = @"朝北";
            break;
        default:
            break;
    }
    return towardStr;
}

- (NSString *)shiString
{
    return [NSString stringWithFormat:@"%@居室",[[CommonUtils sharedCommonUtils] returnChineseNumber:_shi]];
}

- (NSString *)priceString
{
    float price = _price / 100;
    NSString *rentString = [NSString stringWithFormat:@"¥%.2f/月",price];
    return rentString;
}

@end

@implementation AppointListModel

@end
