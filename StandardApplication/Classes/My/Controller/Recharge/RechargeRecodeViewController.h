//
//  RechargeRecodeViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RechargeRecodeViewController : BaseViewController
@property (strong, nonatomic) NSString *device_id;
@property (assign, nonatomic) NSInteger meter_type;  // 0电表 1冷水 2热水
@property (strong, nonatomic) NSString *provider;
@end

NS_ASSUME_NONNULL_END
