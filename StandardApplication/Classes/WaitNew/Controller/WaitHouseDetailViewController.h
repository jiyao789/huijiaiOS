//
//  WaitHouseDetailViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2023/12/9.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitHouseDetailViewController : BaseViewController
@property (assign, nonatomic) NSInteger unitId;
@property (assign, nonatomic) NSInteger projectId;
@property (assign, nonatomic) NSInteger before;
@end

NS_ASSUME_NONNULL_END
