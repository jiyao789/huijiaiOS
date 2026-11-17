//
//  WorkOrderDetailTextTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "WorkOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkOrderDetailTextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sysTextLab;
@property (weak, nonatomic) IBOutlet UIImageView *systemImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *systemImageViewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *systemImageViewLayoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *systemTextLayoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *systemTextLayoutBottom;
@property (weak, nonatomic) IBOutlet UIImageView *systemIconImageView;

@property (strong, nonatomic) WorkOrderDetailModel *model;
@end

NS_ASSUME_NONNULL_END
