//
//  OpenCarLockViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2024/9/3.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenCarLockViewController : BaseViewController
@property (strong, nonatomic) NSString *device_id;
@property (assign, nonatomic) NSInteger unit_id;

@property (assign, nonatomic) BOOL isNeedNet;
@end

NS_ASSUME_NONNULL_END
