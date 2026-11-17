//
//  BillHistoryTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "BillListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BillHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *houseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *billCreatedTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *billIncomeWayLab;
@property (weak, nonatomic) IBOutlet UILabel *billIncomeDateLab;
@property (weak, nonatomic) IBOutlet UILabel *billStartEndDateLab;
@property (weak, nonatomic) IBOutlet UILabel *billLateAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *billPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *billIncomeLab;
@property (weak, nonatomic) IBOutlet UILabel *billTotalLab;

@property (strong, nonatomic)BillListModel *billListModel;
@end

NS_ASSUME_NONNULL_END
