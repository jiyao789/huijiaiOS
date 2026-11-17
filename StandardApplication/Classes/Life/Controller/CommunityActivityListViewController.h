//
//  CommunityActivityListViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityActivityListViewController : BaseViewController
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString *titleStr;
@end

NS_ASSUME_NONNULL_END
