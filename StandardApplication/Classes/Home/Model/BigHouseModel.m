//
//  BigHouseModel.m
//  StandardApplication
//
//  Created by DTiOS on 2024/3/30.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "BigHouseModel.h"

@implementation BigHouseModel

@dynamic description;

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"desc":@"description"};
}

- (NSString *)bedroom_num_string
{
    return [NSString stringWithFormat:@"%@居室",[[CommonUtils sharedCommonUtils] returnChineseNumber:_bedroom_num]];
}

- (NSArray *)picturesArr
{
    return _pictures.mj_JSONObject;
}

- (NSString *)priceString
{
    NSString *rentString = [NSString stringWithFormat:@"¥%.2f",_price];
    return rentString;
}


@end
