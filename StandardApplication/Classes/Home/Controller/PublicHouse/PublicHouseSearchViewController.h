//
//  PublicHouseSearchViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PublicHouseSearchViewController : BaseViewController
@property (strong, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSString *pointsIdJsonStr;
@end

NS_ASSUME_NONNULL_END
