//
//  HouseLocationViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/24.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"
#import "HouseDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseLocationViewController : BaseViewController
@property (strong, nonatomic)RegionModel *regionModel;
@property (strong, nonatomic) NSString *addressStr;
@property (strong, nonatomic) NSString *projectName;
@end

NS_ASSUME_NONNULL_END
