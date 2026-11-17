//
//  WorkOrderDetailModel.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/3.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "WorkOrderDetailModel.h"

@implementation WorkOrderDetailModel

- (NSArray *)imageArr
{
    return [_img_url objectFromJSONString];
}

@end
