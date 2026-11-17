//
//  WorkOrderIndexModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/3.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkOrderIndexModel : NSObject
@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger work_id;
@property (strong, nonatomic) NSString *end_time;
@property (strong, nonatomic) NSString *finisher;
@property (strong, nonatomic) NSString *manager;
///工单状态 1 待回复、2 已回复、3 已完结、4 已评价 5 已作废
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *created_time;
@property (strong, nonatomic) NSString *modified_time;
@property (strong, nonatomic) NSString *message;
@end

NS_ASSUME_NONNULL_END
