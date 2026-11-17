//
//  SpaceDetailModel.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/1.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SpaceDetailModel.h"

@implementation SpaceDetailModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"user_info" : @"UserModel"
    };
}
- (NSArray *)space_imgArr
{
    return [_space_img mj_JSONObject];
}
@end
