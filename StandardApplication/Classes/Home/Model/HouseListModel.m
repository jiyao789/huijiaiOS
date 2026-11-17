//
//  HouseListModel.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/30.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HouseListModel.h"

@implementation HouseListModel

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

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.unit_id = [[aDecoder decodeObjectForKey:@"unit_id"] integerValue];
        self.shi = [[aDecoder decodeObjectForKey:@"shi"] integerValue];
        self.shiString = [aDecoder decodeObjectForKey:@"shiString"];
        self.ting = [[aDecoder decodeObjectForKey:@"ting"] integerValue];
        self.area = [[aDecoder decodeObjectForKey:@"area"] floatValue];
        self.toward = [[aDecoder decodeObjectForKey:@"toward"] integerValue];
        self.towardString = [aDecoder decodeObjectForKey:@"towardString"];
        self.hot = [[aDecoder decodeObjectForKey:@"hot"] integerValue];
        self.point = [aDecoder decodeObjectForKey:@"point"];
        self.price = [[aDecoder decodeObjectForKey:@"price"] integerValue];
        self.priceString = [aDecoder decodeObjectForKey:@"priceString"];
        self.imgs = [aDecoder decodeObjectForKey:@"imgs"];
        self.region_name = [aDecoder decodeObjectForKey:@"region_name"];
        self.region_address = [aDecoder decodeObjectForKey:@"region_address"];
        self.region_number = [[aDecoder decodeObjectForKey:@"region_number"] integerValue];
        self.book = [[aDecoder decodeObjectForKey:@"book"] integerValue];
        self.nature = [[aDecoder decodeObjectForKey:@"nature"] integerValue];
        self.show_type = [[aDecoder decodeObjectForKey:@"show_type"] integerValue];
        self.collect = [[aDecoder decodeObjectForKey:@"collect"] integerValue];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.unit_id) forKey:@"unit_id"];
    [aCoder encodeObject:@(self.shi) forKey:@"shi"];
    [aCoder encodeObject:self.shiString forKey:@"shiString"];
    [aCoder encodeObject:@(self.ting) forKey:@"ting"];
    [aCoder encodeObject:@(self.toward) forKey:@"toward"];
    [aCoder encodeObject:@(self.area) forKey:@"area"];
    [aCoder encodeObject:self.towardString forKey:@"towardString"];
    [aCoder encodeObject:@(self.hot) forKey:@"hot"];
    [aCoder encodeObject:self.point forKey:@"point"];
    [aCoder encodeObject:@(self.price) forKey:@"price"];
    [aCoder encodeObject:self.priceString forKey:@"priceString"];
    [aCoder encodeObject:self.imgs forKey:@"imgs"];
    [aCoder encodeObject:self.region_name forKey:@"region_name"];
    [aCoder encodeObject:self.region_address forKey:@"region_address"];
    [aCoder encodeObject:@(self.region_number) forKey:@"region_number"];
    [aCoder encodeObject:@(self.book) forKey:@"book"];
    [aCoder encodeObject:@(self.nature) forKey:@"nature"];
    [aCoder encodeObject:@(self.show_type) forKey:@"show_type"];
    [aCoder encodeObject:@(self.collect) forKey:@"collect"];
}
@end
