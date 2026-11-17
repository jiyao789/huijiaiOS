//
//  MyAppointSeeTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseShadowButton.h"
#import "SubscribeListModel.h"
#import "AppointListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAppointSeeTableViewCell : UITableViewCell
@property (assign, nonatomic) NSInteger type;  // 0 预约 1 预定
@property (weak, nonatomic) IBOutlet UILabel *appointSeeTimeLab;
@property (weak, nonatomic) IBOutlet BaseShadowButton *applyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *appointImageView;
@property (weak, nonatomic) IBOutlet UILabel *appointNameLab;
@property (weak, nonatomic) IBOutlet UILabel *appointNatureLab;
@property (weak, nonatomic) IBOutlet UILabel *appointConfigLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (strong, nonatomic) SubscribeListModel *subscribeListModel;
@property (strong, nonatomic) AppointListModel *appointListModel;
@end

NS_ASSUME_NONNULL_END
