//
//  WorkOrderDetailMyTextTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "WorkOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkOrderDetailMyTextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myTextLab;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myImageViewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myImageViewLayoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTextLayoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTextLayoutBottom;
@property (weak, nonatomic) IBOutlet UIImageView *myIconImageView;

@property (strong, nonatomic) WorkOrderDetailModel *model;
@end

NS_ASSUME_NONNULL_END
