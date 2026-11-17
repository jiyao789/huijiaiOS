//
//  CommunityActivityListTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "ActivityListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityActivityListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLab;
@property (strong, nonatomic) ActivityListModel *activityListModel;
@property (weak, nonatomic) IBOutlet UILabel *activityBrieflyLab;
@end

NS_ASSUME_NONNULL_END
