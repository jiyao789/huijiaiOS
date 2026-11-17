//
//  WaitInfoTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2023/12/9.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "WaitUnitQueueModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *unitNameLab;
@property (weak, nonatomic) IBOutlet UILabel *waitCountLab;
@property (weak, nonatomic) IBOutlet UILabel *waitNumberLab;

@property (strong, nonatomic) WaitUnitQueueModel *unitModel;
@end

NS_ASSUME_NONNULL_END
