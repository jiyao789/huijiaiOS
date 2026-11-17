//
//  HouseBannerTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2023/12/9.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "SDCycleScrollView.h"
#import "NewWaitProjctListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseBannerTableViewCell : UITableViewCell<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;

@property (strong, nonatomic) NewWaitProjctListModel *model;
@end

NS_ASSUME_NONNULL_END
