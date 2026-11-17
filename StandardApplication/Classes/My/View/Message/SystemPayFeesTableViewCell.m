//
//  SystemPayFeesTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SystemPayFeesTableViewCell.h"
#import "CommunityActivityDetailViewController.h"
#import "BillDetailViewController.h"

@implementation SystemPayFeesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMessageModel:(MessageModel *)messageModel
{
    _messageModel = messageModel;
    if (_messageModel.message_type == 3) {
        _subtitleTwoLab.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightMedium];
        _titleLab.text = NONullString(_messageModel.title);
        float pay = [_messageModel.content[@"pay_total"] floatValue] / 100;
        _subtitleOneLab.text = [NSString stringWithFormat:@"续缴费：%.2f",pay];
        _subtitleTwoLab.text = [NSString stringWithFormat:@"缴费日：%@",NONullString(_messageModel.content[@"pay_time"])];
    } else {
        _subtitleTwoLab.font = [UIFont systemFontOfSize:11.0f weight:UIFontWeightLight];
        NSString *typeStr = _messageModel.message_type == 5 ? @"推送" : @"活动";
        _titleLab.text = _messageModel.message_type == 5 ? NONullString(_messageModel.title) : @"活动消息";
        _subtitleOneLab.text = _messageModel.message_type == 5 ? NONullString(_messageModel.content[@"push_content"]) : NONullString(_messageModel.title);
        NSString *timeStr = _messageModel.message_type == 5 ? NONullString(_messageModel.content[@"push_time"]) : [NSString stringWithFormat:@"%@ %@-%@",NONullString(_messageModel.content[@"activity_time"]),NONullString(_messageModel.content[@"start_time"]),NONullString(_messageModel.content[@"end_time"])];
        
        _subtitleTwoLab.text = [NSString stringWithFormat:@"%@时间：%@",typeStr,timeStr];
    }
}

- (IBAction)seeDetailBtnClick:(id)sender
{
    switch (_messageModel.message_type) {
        case 2:
        {
            CommunityActivityDetailViewController *vc = [CommunityActivityDetailViewController new];
            vc.act_id = _messageModel.other_id;
            [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            BillDetailViewController *vc = [BillDetailViewController new];
            vc.b_id = _messageModel.other_id;
            [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
