//
//  OpenLockViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/29.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenLockViewController : BaseViewController
@property (strong, nonatomic) NSString *device_id;
@property (assign, nonatomic) NSInteger unit_id;

@property (assign, nonatomic) BOOL isNeedNet;
@end

NS_ASSUME_NONNULL_END
