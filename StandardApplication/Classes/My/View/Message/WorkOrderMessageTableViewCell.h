//
//  WorkOrderMessageTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "WorkOrderIndexModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkOrderMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLab;
@property (weak, nonatomic) IBOutlet UIButton *seeDetailBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderContentLab;
@property (strong, nonatomic) WorkOrderIndexModel *workOrderIndexModel;
@end

NS_ASSUME_NONNULL_END
