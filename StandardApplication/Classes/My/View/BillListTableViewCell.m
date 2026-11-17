//
//  BillListTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BillListTableViewCell.h"
#import "MacroDefine.h"
#import "BillDetailViewController.h"

@implementation BillListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBillListModel:(BillListModel *)billListModel
{
    _billListModel = billListModel;
    _billInfoLab.text = [NSString stringWithFormat:@"账单名称    %@\n账单周期    %@ 至 %@",_billListModel.name,_billListModel.start_date,_billListModel.end_date];
    _amountLab.text = NONullString(_billListModel.totalIncomeString);
}

- (IBAction)payBtnClick:(id)sender
{
    BillDetailViewController *vc = [BillDetailViewController new];
    vc.b_id = _billListModel.b_id;
    [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
