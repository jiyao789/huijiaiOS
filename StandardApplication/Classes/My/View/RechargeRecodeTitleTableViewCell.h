//
//  RechargeRecodeTitleTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2024/6/30.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "RechargeRecodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RechargeRecodeTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rechargeTimeLab;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) RechargeRecodeModel *rechargeRecodeModel;
@end

NS_ASSUME_NONNULL_END
