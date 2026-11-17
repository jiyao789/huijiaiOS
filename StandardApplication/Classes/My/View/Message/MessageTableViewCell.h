//
//  MessageTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "MessageIndexModel.h"
#import "WorkOrderIndexModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *messageTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *messageSummyLab;
@property (weak, nonatomic) IBOutlet UILabel *messageNoreadLab;

@property (strong, nonatomic) WorkOrderIndexModel *workOrderIndexModel;
@end

NS_ASSUME_NONNULL_END
