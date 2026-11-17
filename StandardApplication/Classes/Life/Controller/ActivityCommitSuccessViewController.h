//
//  ActivityCommitSuccessViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/8.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"
#import "ActivityListModel.h"
#import "SpaceDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityCommitSuccessViewController : BaseViewController
@property (assign, nonatomic) NSInteger type; // 1 空间  2 活动
@property (strong, nonatomic) NSString *spaceSelectTime;
@property (strong, nonatomic) SpaceDetailModel *spaceDetailModel; //  空间
@property (strong, nonatomic) ActivityListModel *activityListModel; //  活动
@end

NS_ASSUME_NONNULL_END
