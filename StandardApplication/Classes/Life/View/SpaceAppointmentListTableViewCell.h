//
//  SpaceAppointmentListTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "SpaceIndexModel.h"
#import "MyActivityListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpaceAppointmentListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *applyImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UILabel *summyLab;
@property (assign, nonatomic) BOOL isMyAppointment;

@property (strong, nonatomic) SpaceIndexModel *spaceModel;
@property (strong, nonatomic) MyActivityListModel *myActivityListModel;

@property (strong, nonatomic) NSString *type;  // life 憓家生活里的空间我的预约  my 活动预约
@end

NS_ASSUME_NONNULL_END
