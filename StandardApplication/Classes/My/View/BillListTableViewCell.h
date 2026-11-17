//
//  BillListTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BillListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *billInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;

@property (strong, nonatomic) BillListModel *billListModel;
@end

NS_ASSUME_NONNULL_END
