//
//  ContractWarnView.m
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "ContractWarnView.h"
#import "SurrenderViewController.h"
#import "ContinueContractViewController.h"

@implementation ContractWarnView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setMessageModel:(MessageModel *)messageModel
{
    _messageModel = messageModel;
    if ([[_messageModel.content valueForKey:@"type"] integerValue] == 1) {
        _commitBtn.hidden = YES;
    } else if ([[_messageModel.content valueForKey:@"type"] integerValue] == 2) {
        _refundContractBtn.hidden = YES;
        _continueContractBtn.hidden = YES;
        _closeBtn.hidden = YES;
    }
    _contentLab.text = NONullString(_messageModel.title);
    if (![NSDate compareOneDay:[NSDate getNextMonth:[NSDate date]] withAnotherDay:[NSDate stringToDate:NONullString(_messageModel.contract_end_date)]]) {
        [_continueContractBtn setBackgroundColor:[UIColor colorWithHexString:@"#EEEEEE"]];
        _continueContractBtn.userInteractionEnabled = NO;
    }
}

- (IBAction)buttonInfoClick:(UIButton *)sender
{
    SAFE_BLOCK(self.didCancelBlock);
    switch (sender.tag) {
        case 0:
        {
            SurrenderViewController *vc = [SurrenderViewController new];
            vc.cid = _messageModel.other_id;
            [_navigation pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            ContinueContractViewController *vc = [ContinueContractViewController new];
            vc.cid = _messageModel.other_id;
            [_navigation pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
    [self getAppMessagePopupReadDate];
}

- (void)getAppMessagePopupReadDate
{
    [HttpRequest requestUrlPath:BaseURL urlPath:appMessage_popup_readURL parameters:@{@"id":@(_messageModel.id)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1 || status == 2) {
            
        }
    }];
}

@end
