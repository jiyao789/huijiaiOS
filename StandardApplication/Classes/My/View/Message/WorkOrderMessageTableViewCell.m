//
//  WorkOrderMessageTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "WorkOrderMessageTableViewCell.h"
#import "WorkOrderDetailViewController.h"

@implementation WorkOrderMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setWorkOrderIndexModel:(WorkOrderIndexModel *)workOrderIndexModel
{
    _workOrderIndexModel = workOrderIndexModel;
    _orderTimeLab.text = NONullString(_workOrderIndexModel.modified_time);
    _orderTitleLab.text = [NSString stringWithFormat:@"工单%ld",(long)_workOrderIndexModel.work_id];
    _orderContentLab.text = [NSString stringWithFormat:@"您于%@提交的工单“%@”需要您补充信息，请及时回复。",NONullString(_workOrderIndexModel.created_time),NONullString(_workOrderIndexModel.message)];
    switch (_workOrderIndexModel.status) {
        case 1:
        case 2:
        {
            UIImage *statusImage = [UIImage setupBackgroundColor:NO fromColor:[UIColor whiteColor] toColor:[UIColor colorWithHexString:@"#2A629A"] view:_orderStatusLab];
            _orderStatusLab.backgroundColor = [UIColor colorWithPatternImage:statusImage];
            _orderStatusLab.textColor = [UIColor whiteColor];
            _orderStatusLab.text = @"正在进行";
            break;
        }
        case 3:
        {
            _orderStatusLab.backgroundColor = [UIColor clearColor];
            _orderStatusLab.textColor = [UIColor colorWithHexString:@"#2A629A"];
            _orderStatusLab.text = @"已完结";
            _seeDetailBtn.backgroundColor = [UIColor colorWithHexString:@"#D0D0D0"];
            break;
        }
        case 4:
        {
            _orderStatusLab.backgroundColor = [UIColor clearColor];
            _orderStatusLab.textColor = [UIColor colorWithHexString:@"#2A629A"];
            _orderStatusLab.text = @"已评价";
            _seeDetailBtn.backgroundColor = [UIColor colorWithHexString:@"#D0D0D0"];
            break;
        }
        case 5:
        {
            _orderStatusLab.backgroundColor = [UIColor clearColor];
            _orderStatusLab.textColor = [UIColor colorWithHexString:@"#2A629A"];
            _orderStatusLab.text = @"已作废";
            _seeDetailBtn.backgroundColor = [UIColor colorWithHexString:@"#D0D0D0"];
            break;
        }
        default:
            break;
    }
}

- (IBAction)seeDetailBtnClick:(id)sender
{
    WorkOrderDetailViewController *vc = [WorkOrderDetailViewController new];
    vc.orderTitleStr = [NSString stringWithFormat:@"工单%ld",(long)_workOrderIndexModel.work_id];
    vc.work_id = _workOrderIndexModel.id;
    vc.work_number = _workOrderIndexModel.work_id;
    vc.work_status = _workOrderIndexModel.status;
    [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
