//
//  SpaceAppointmentTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "SDCycleScrollView.h"
#import "LifeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpaceAppointmentTableViewCell : UITableViewCell<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet QMUIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (strong, nonatomic) LifeModel *model;
@end

NS_ASSUME_NONNULL_END
