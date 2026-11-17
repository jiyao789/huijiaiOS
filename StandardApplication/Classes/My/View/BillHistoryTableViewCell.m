//
//  BillHistoryTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BillHistoryTableViewCell.h"
#import "ProtocolBaseWKWebViewController.h"

@implementation BillHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBillListModel:(BillListModel *)billListModel
{
    _billListModel = billListModel;
    _houseNameLab.text = [NSString stringWithFormat:@"账单名称：%@",_billListModel.name];
    _billCreatedTimeLab.text = NONullString(_billListModel.created_time);
    _billIncomeWayLab.text = NONullString(_billListModel.income_wayString);
    _billIncomeDateLab.text = NONullString(_billListModel.income_date);
    _billStartEndDateLab.text = [NSString stringWithFormat:@"%@至%@",_billListModel.start_date,_billListModel.end_date];
    _billIncomeLab.text = NONullString(_billListModel.incomeString);
    _billLateAmountLab.text = NONullString(_billListModel.lateString);
    _billPriceLab.text = NONullString(_billListModel.priceString);
    _billTotalLab.text = NONullString(_billListModel.totalString);
}

- (IBAction)seeInvoiceBtnClick:(id)sender
{
//    ProtocolBaseWKWebViewController *vc = [ProtocolBaseWKWebViewController new];
//    vc.webUrl = NONullString(_billListModel.invoice_url);
//    vc.webTitle = @"查看发票";
//    [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
    
    if (!IsNilOrNull(_billListModel.invoice_url)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NONullString(_billListModel.invoice_url)] options:@{} completionHandler:nil];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
