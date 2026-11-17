//
//  SpaceAppointmentListTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SpaceAppointmentListTableViewCell.h"
#import "SecondConfirmView.h"
#import "CancelReserveViewController.h"

@implementation SpaceAppointmentListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setType:(NSString *)type
{
    _type = type;
}

- (void)setMyActivityListModel:(MyActivityListModel *)myActivityListModel
{
    _myActivityListModel = myActivityListModel;
    [_applyImageView setImageUrl:NONullString(_myActivityListModel.activity.image_url) placeholderImage:defaultIconName];
    _titleLab.text = NONullString(_myActivityListModel.activity.title);
    NSString *showTimeStr = @"";
    if ([_type isEqualToString:@"my"]) {
        showTimeStr = @"活动时间：";
    }
    _summyLab.text = [NSString stringWithFormat:@"%@%@ %@-%@",showTimeStr,_myActivityListModel.activity.date,_myActivityListModel.activity.start_time,_myActivityListModel.activity.end_time];
}

- (void)setSpaceModel:(SpaceIndexModel *)spaceModel
{
    _spaceModel = spaceModel;
    [_applyImageView setImageUrl:NONullString(_spaceModel.space_imgArr.firstObject) placeholderImage:defaultIconName];
    _titleLab.text = NONullString(_spaceModel.space_name);
    _summyLab.text = [NSString stringWithFormat:@"可约人数:%ld人",(long)_spaceModel.people_number];
}

- (void)setIsMyAppointment:(BOOL)isMyAppointment
{
    _isMyAppointment = isMyAppointment;
    if (_isMyAppointment) {
        _applyBtn.userInteractionEnabled = YES;
        [_applyBtn setBackgroundColor:[UIColor whiteColor]];
        [_applyBtn setTitleColor:[UIColor colorWithHexString:@"#2B67A4"] forState:UIControlStateNormal];
        [_applyBtn setTitle:@"取消预约" forState:UIControlStateNormal];
    } else {
        _applyBtn.userInteractionEnabled = NO;
        [_applyBtn setBackgroundColor:[UIColor colorWithHexString:@"#2B67A4"]];
        [_applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applyBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    }
}

- (IBAction)applyBtnClick:(id)sender
{
    if (_isMyAppointment) {
        UIViewController *navigation = [CommonUtils getCurrentViewController];
        SecondConfirmView *secondConfirmView = [SecondConfirmView createViewFromNib];
        secondConfirmView.titleLab.text = @"确定取消预约？";
        ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:secondConfirmView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
        KWeakSelf
        secondConfirmView.didConfirmBlock = ^{
            [alertController dismissViewControllerAnimated:YES];
            [weakSelf cancelSpaceAppointmentDate:navigation];
        };
        secondConfirmView.didCancelBlock = ^{
            [alertController dismissViewControllerAnimated:YES];
        };
        alertController.tapBackgroundDismissEnable = YES;
        [navigation presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)cancelSpaceAppointmentDate:(UIViewController *)vc
{
    NSString *urlStr = @"";
    NSDictionary *paraDic = [NSDictionary dictionary];
    if ([_type isEqualToString:@"life"]) {
        urlStr = space_del_appointmentURL;
        paraDic = @{
            @"space_id":@(_spaceModel.id),
            @"u_id":NONullString([User shareUser].getUserId)
        };
    } else if ([_type isEqualToString:@"my"]) {
        urlStr = activity_revokeURL;
        paraDic = @{
            @"id":@(_myActivityListModel.id)
        };
    }
    [MBProgressHUD showStatus:nil toView:nil];
    [HttpRequest requestUrlPath:BaseURL urlPath:urlStr parameters:paraDic type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:nil];
        if (status == 1 || status == 2) {
            CancelReserveViewController *cancelVC = [CancelReserveViewController new];
            cancelVC.showText = @"取消成功～";
            [vc.navigationController pushViewController:cancelVC animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:nil];
        }
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
