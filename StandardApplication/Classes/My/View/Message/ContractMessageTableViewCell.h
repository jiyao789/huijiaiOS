//
//  ContractMessageTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "MessageIndexModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContractMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) MessageModel *messageModel;
@end

NS_ASSUME_NONNULL_END
