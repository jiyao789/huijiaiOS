//
//  WaitUnitQueueModel.h
//  StandardApplication
//
//  Created by DTiOS on 2023/12/14.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaitingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitUnitQueueModel : NSObject
@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger min_rent;
@property (assign, nonatomic) NSInteger unit_count;
@property (assign, nonatomic) NSInteger waiting_count;
@property (strong, nonatomic) WaitingModel *waiting;
@end

NS_ASSUME_NONNULL_END
