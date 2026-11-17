//
//  CommunityActivityDetailTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "ActivityListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityActivityDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *activityBrieflyLab;
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *activityInfoShowLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityTimeLayoutBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityImageViewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityImageViewLayoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityImageViewLayoutBottom;

@property (strong, nonatomic) ActivityListModel *activityListModel;
@end

NS_ASSUME_NONNULL_END
