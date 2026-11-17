//
//  WaitExistModel.h
//  StandardApplication
//
//  Created by DTiOS on 2023/12/15.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubscribeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitExistModel : NSObject
@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *number;
@property (retain, nonatomic) NSString *phone;
@property (retain, nonatomic) NSString *certificate_number;
@property (assign, nonatomic) NSInteger waiting_project_id;
@property (assign, nonatomic) NSInteger waiting_queue_id;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger org_id;
@property (assign, nonatomic) NSInteger unit_id;
@property (assign, nonatomic) NSInteger before;
@property (strong, nonatomic) UnitModel *unit;
@end

NS_ASSUME_NONNULL_END
