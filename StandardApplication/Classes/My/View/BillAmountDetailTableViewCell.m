//
//  BillAmountDetailTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BillAmountDetailTableViewCell.h"

@implementation BillAmountDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ReatLesseeModel *)model
{
    _model = model;
    _timeLab.hidden = YES;
    _showNameLab1.text = @"姓名";
    _nameLab1.text = NONullString(_model.name);
    _showNameLab2.text = @"性别";
    _nameLab2.text = NONullString(_model.genderStr);
    _showNameLab3.text = @"手机号";
    _nameLab3.text = NONullString(_model.phone);
    _showNameLab4.text = @"身份证";
    _nameLab4.text = NONullString(_model.card);
}

- (void)setBillDetailModel:(BillDetailModel *)billDetailModel
{
    _billDetailModel = billDetailModel;
    _timeLab.hidden = NO;
    _nameLab1.text = NONullString(_billDetailModel.priceString);
    _timeLab.text = [NSString stringWithFormat:@"%@至%@",_billDetailModel.start_date,_billDetailModel.end_date];
    _nameLab2.text = NONullString(_billDetailModel.lateString);
    _nameLab3.text = NONullString(_billDetailModel.priceString);
    _nameLab4.text = NONullString(_billDetailModel.bill_date);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
