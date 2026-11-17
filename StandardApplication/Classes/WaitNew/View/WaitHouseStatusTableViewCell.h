//
//  WaitHouseStatusTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2023/12/10.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "WaitExistModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitHouseStatusTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;

@property (nonatomic, copy) void (^ReloadWaitHouseDetailBlock)(void);
@property (strong, nonatomic) WaitExistModel *queueExistModel;
@end

NS_ASSUME_NONNULL_END
