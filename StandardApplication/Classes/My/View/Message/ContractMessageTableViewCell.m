//
//  ContractMessageTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ContractMessageTableViewCell.h"
#import "MyContractDetailViewController.h"

@implementation ContractMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMessageModel:(MessageModel *)messageModel
{
    _messageModel = messageModel;
    _timeLab.text = NONullString(_messageModel.created_time);
    _titleLab.text = NONullString(_messageModel.title);
}
- (IBAction)seeDetailBtnClick:(id)sender
{    
    MyContractDetailViewController *vc = [MyContractDetailViewController new];
    vc.cid = _messageModel.other_id;
    vc.contractStatus = _messageModel.contract_status;
    vc.end_date = _messageModel.contract_end_date;
    vc.contract_id = _messageModel.contract_number;
    vc.webUrl = IsNilOrNull(_messageModel.contract_viewpdf_url) ? @"" : _messageModel.contract_viewpdf_url;
    [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
