//
//  WaitHouseInfoTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2023/12/10.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "WaitExistModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitHouseInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *waitPeopleLab;
@property (weak, nonatomic) IBOutlet UILabel *waitNumberLab;
@property (strong, nonatomic) WaitExistModel *queueExistModel;
@end

NS_ASSUME_NONNULL_END
