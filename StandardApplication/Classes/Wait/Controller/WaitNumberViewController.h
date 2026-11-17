//
//  WaitNumberViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2023/6/17.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitNumberViewController : BaseViewController
@property (assign, nonatomic) NSInteger unit_id;
@property (assign, nonatomic) NSInteger waiting_project_id;
@property (assign, nonatomic) NSInteger waiting_queue_id;
@end

NS_ASSUME_NONNULL_END
