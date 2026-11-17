//
//  SpaceAppointmentDetailTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpaceDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpaceAppointmentDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *spaceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *spaceAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *spaceIntroLab;
@property (weak, nonatomic) IBOutlet UIImageView *spaceImageView;
@property (weak, nonatomic) IBOutlet UILabel *spaceOpenTimeLab;

@property (strong, nonatomic) SpaceDetailModel *spaceDetailModel;
@end

NS_ASSUME_NONNULL_END
