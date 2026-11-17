//
//  SubscribeListModel.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/3.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SubscribeListModel.h"

@implementation UnitModel

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"classInt":@"class"};
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
    NSString *rentString = [NSString stringWithFormat:@"¥%.2f/月",price];
    return rentString;
}

- (NSString *)choice_get_numberString
{
    return _choice_get_number == 1 ? @"弄" : @"号";
}

- (NSString *)contractWorkHouseString
{
    NSString *houseNameString = @"";
    switch (_show_type) {
        case 1:
            houseNameString = [NSString stringWithFormat:@"%@%@%ld",_region_name,_org_name,(long)_unit_number];
            break;
        case 2:
            houseNameString = [NSString stringWithFormat:@"%@%ld幢%ld单元%ld号%ld室",_region_name,(long)_block_unit,(long)_unit_cell,(long)_unit_floor,(long)_unit_house];
            break;
        case 3:
            houseNameString = [NSString stringWithFormat:@"%@%ld幢%ld单元%ld号%ld室",_region_name,(long)_block_unit,(long)_unit_cell,(long)_unit_floor,(long)_unit_number];
            break;
            
        default:
            break;
    }
    return houseNameString;
}

@end

@implementation SubscribeListModel


@end
