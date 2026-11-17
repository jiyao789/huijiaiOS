//
//  MyActivityListModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/4.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyActivityListModel : NSObject

@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger revoke;
@property (strong, nonatomic) ActivityListModel *activity;

@end

NS_ASSUME_NONNULL_END
