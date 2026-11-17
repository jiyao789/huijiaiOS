//
//  WorkOrderEvaluateTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "WorkOrderEvaluateTableViewCell.h"
#import "MacroDefine.h"
#import "TggStarEvaluationView.h"
#import "ComplaintViewController.h"

@interface WorkOrderEvaluateTableViewCell()
@property (weak, nonatomic) IBOutlet BaseShadowView *evaluateView;
@property (weak, nonatomic) IBOutlet UILabel *evaluateTitleLab;
@property (weak, nonatomic) IBOutlet UIButton *complaintBtn;

@property (strong, nonatomic) TggStarEvaluationView *tggStarEvaView;
@end

@implementation WorkOrderEvaluateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setWork_status:(NSInteger)work_status
{
    _work_status = work_status;
    if (_work_status == 5) {
        _evaluateTitleLab.text = @"您的工单已被工作人员作废,如有疑问可点击投诉";
        _complaintBtn.hidden = NO;
    } else {
        _evaluateTitleLab.text = @"工单已结束，请您对此工单进行评价";
        _complaintBtn.hidden = YES;
        [_evaluateView addSubview:self.tggStarEvaView];
        
        if (_work_status == 4) {
            [self getWorkOrderEvaluationDetailDate];
        }
    }
}

- (void)getWorkOrderEvaluationDetailDate
{
    [MBProgressHUD showStatus:nil toView:nil];
    [HttpRequest requestUrlPath:BaseURL urlPath:workOrder_evaluationDetailURL parameters:@{@"id":@(_work_id)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:nil];
        if (status == 1) {
            self.tggStarEvaView.starCount = [dic[@"reply"] integerValue];
            self.tggStarEvaView.tapEnabled = NO;
        }
    }];
}

- (IBAction)complaintBtnClick:(id)sender
{
    [[CommonUtils getCurrentViewController].navigationController pushViewController:[ComplaintViewController new] animated:YES];
}

- (TggStarEvaluationView *)tggStarEvaView
{
    if (!_tggStarEvaView) {
        KWeakSelf
        _tggStarEvaView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
            if (weakSelf.work_status == 3) {
                [weakSelf getWorkOrder_workOrderEvaluationDate:count];
            }
        }];
        _tggStarEvaView.spacing = 0.2;
        _tggStarEvaView.frame = CGRectMake(30, 40, 178, 30);
    }
    return _tggStarEvaView;
}

- (void)getWorkOrder_workOrderEvaluationDate:(NSInteger)starCount
{
    [MBProgressHUD showStatus:nil toView:nil];
    [HttpRequest requestUrlPath:BaseURL urlPath:workOrder_workOrderEvaluationURL parameters:@{@"id":@(_work_id),@"reply":@(starCount)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:nil];
        [MBProgressHUD showMessag:msg toView:nil];
        if (status == 1 || status == 2) {
            self.tggStarEvaView.tapEnabled = NO;
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
