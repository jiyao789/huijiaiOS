//
//  CommitReserveViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/8.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CommitSuccessType)
{
    PaySuccessType = 0,
    RechargeSuccessType,
    ReserrveSuccessType,
    EntrustSuccessType,
    OwnerWantSuccessType,
    ContinueReatSuccessType,
    SurrenderReatSuccess,
    CommitFinishSuccessType
};

@interface CommitReserveViewController : BaseViewController
@property (assign, nonatomic) CommitSuccessType successType;
@end

NS_ASSUME_NONNULL_END
