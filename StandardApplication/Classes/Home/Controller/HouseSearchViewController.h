//
//  HouseSearchViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseSearchViewController : BaseViewController
@property (strong, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSString *pointsIdJsonStr;
@property (assign, nonatomic) NSInteger nature;
@end

NS_ASSUME_NONNULL_END
