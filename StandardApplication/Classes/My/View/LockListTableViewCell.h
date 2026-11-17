//
//  LockListTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/29.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "LockListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LockListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *houseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *houseAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *lockEventLab;

@property (strong, nonatomic) LockListModel *lockListModel;
@end

NS_ASSUME_NONNULL_END
