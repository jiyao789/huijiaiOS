//
//  RechargeViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RechargeViewController : BaseViewController
@property (strong, nonatomic) NSString *device_id;
@property (assign, nonatomic) NSInteger unit_id;
@property (assign, nonatomic) NSInteger meter_type;  // 0电表 1冷水 2热水
@property (strong, nonatomic) NSString *provider;  // 设备提供商
@end

NS_ASSUME_NONNULL_END
