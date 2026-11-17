//
//  BillAmountDetailTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "ReatRenewReatModel.h"
#import "BillDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BillAmountDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *showNameLab1;
@property (weak, nonatomic) IBOutlet UILabel *nameLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *showNameLab2;
@property (weak, nonatomic) IBOutlet UILabel *nameLab2;
@property (weak, nonatomic) IBOutlet UILabel *showNameLab3;
@property (weak, nonatomic) IBOutlet UILabel *nameLab3;
@property (weak, nonatomic) IBOutlet UILabel *showNameLab4;
@property (weak, nonatomic) IBOutlet UILabel *nameLab4;

@property (strong, nonatomic) ReatLesseeModel *model;
@property (strong, nonatomic) BillDetailModel *billDetailModel;
@end

NS_ASSUME_NONNULL_END
