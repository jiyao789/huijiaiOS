//
//  MapSearchHouseViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/24.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapSearchHouseViewController : BaseViewController
@property (copy, nonatomic) void (^mapSearchHouseBlock)(NSString *name);
@property (assign, nonatomic) BOOL isNeedBlock;
@end

NS_ASSUME_NONNULL_END
