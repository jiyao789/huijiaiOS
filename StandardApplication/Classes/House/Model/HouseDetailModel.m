//
//  HouseDetailModel.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/31.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HouseDetailModel.h"

@implementation RegionModel

- (NSString *)choice_get_numberString
{
    return _choice_get_number == 1 ? @"弄" : @"号";
}

@end

@implementation HouseDetailModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"furniture" : @"PointFurnitureModel"
    };
}

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
    NSString *rentString = [NSString stringWithFormat:@"¥%.2f",price];
    return rentString;
}

@end
