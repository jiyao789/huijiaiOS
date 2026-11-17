//
//  OwnerAddressView.h
//  StandardApplication
//
//  Created by DTiOS on 2022/2/16.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OwnerAddressView : UIView

@property (nonatomic, copy) void (^chooseLocationViewBlock)(NSInteger county_id,NSInteger town_id,NSString *name,NSInteger countySelectIndex,NSInteger townSelectIndex);
@property (nonatomic, copy) void (^resetLocationViewBlock)(void);

@property (weak, nonatomic) IBOutlet UITableView *countyTableView;
@property (weak, nonatomic) IBOutlet UITableView *townTableView;
@property (assign, nonatomic) NSInteger countySelectIndex;
@property (assign, nonatomic) NSInteger townSelectIndex;
@end

NS_ASSUME_NONNULL_END
