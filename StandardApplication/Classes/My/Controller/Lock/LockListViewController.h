//
//  LockListViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/29.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LockListViewController : BaseViewController
@property (assign, nonatomic) NSInteger lock_type;  // 2:电子锁 7:车位锁
@end

NS_ASSUME_NONNULL_END
