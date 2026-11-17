//
//  WorkOrderDetailViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkOrderDetailViewController : BaseViewController
@property (strong, nonatomic) NSString *orderTitleStr;

@property (assign, nonatomic) BOOL isCommitWork;
@property (assign, nonatomic) NSInteger work_id;
@property (assign, nonatomic) NSInteger work_number;
@property (assign, nonatomic) NSInteger work_status;
@end

NS_ASSUME_NONNULL_END
