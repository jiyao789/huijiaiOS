//
//  NewWaitProjctListModel.m
//  StandardApplication
//
//  Created by DTiOS on 2023/12/14.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "NewWaitProjctListModel.h"

@implementation NewWaitProjctListModel

//@synthesize description = _description;
@dynamic description;

- (NSString *)rentString
{
    float minprice = _min_rent / 100;
    float maxprice = _max_rent / 100;
    NSString *rentString = [NSString stringWithFormat:@"¥%.0f-%.0f/月",minprice,maxprice];
    return rentString;
}

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"desc":@"description"};
}

@end
