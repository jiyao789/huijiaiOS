//
//  HouseDetailViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseDetailViewController : BaseViewController
@property (strong, nonatomic) NSString *bigHouseId;
@property (assign, nonatomic) NSInteger unit_id;
@property (assign, nonatomic) BOOL isWaitHouse;
@property (nonatomic, copy) void (^houseIsCollectBlock)(NSInteger collect);
@end

NS_ASSUME_NONNULL_END
