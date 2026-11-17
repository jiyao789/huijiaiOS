//
//  SystemInfoModel.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/29.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SystemInfoModel.h"

@implementation SystemLabelModel

@end

@implementation SystemInfoModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"occupation" : @"SystemLabelModel",
        @"education" : @"SystemLabelModel",
        @"politics" : @"SystemLabelModel"
    };
}
@end
