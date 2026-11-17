//
//  WaitHouseStatusTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2023/12/10.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "WaitHouseStatusTableViewCell.h"
#import "SecondConfirmView.h"
#import "WaitNumberViewController.h"

@implementation WaitHouseStatusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setQueueExistModel:(WaitExistModel *)queueExistModel
{
    _queueExistModel = queueExistModel;
    if (_queueExistModel.status == 2) { // 已匹配
        _twoButton.hidden = NO;
    } else if (_queueExistModel.status == 3) { // 已放弃
        _twoButton.hidden = YES;
        _oneButton.userInteractionEnabled = NO;
        [_oneButton setTitle:@"已放弃" forState:UIControlStateNormal];
        _oneButton.backgroundColor = [UIColor colorWithHexString:@"#7F7F7F"];
        [_threeButton setTitle:@"重新轮候" forState:UIControlStateNormal];
        _threeButton.backgroundColor = [UIColor colorWithHexString:@"#E37846"];
    } else if (_queueExistModel.status == 4 || _queueExistModel.status == 6) { // 签约 & 后台签约完成
        _twoButton.hidden = YES;
        _oneButton.userInteractionEnabled = NO;
        [_oneButton setTitle:@"已签约" forState:UIControlStateNormal];
        _oneButton.backgroundColor = [UIColor colorWithHexString:@"#7F7F7F"];
        [_threeButton setTitle:@"重新轮候" forState:UIControlStateNormal];
        _threeButton.backgroundColor = [UIColor colorWithHexString:@"#E37846"];
    } else if (_queueExistModel.status == 5) { // 确认中
        _twoButton.hidden = YES;
    }
}

- (IBAction)oneButtonClick:(id)sender
{
    [self showSecondConfimViewInfo:@"您将放弃此房源并重新轮候此队伍" tag:1];
}

- (IBAction)twoButtonClick:(id)sender 
{
    [self showSecondConfimViewInfo:@"您需在房源匹配后的72小时内做出决定，超时将自动放弃此房源并需重新轮候此队伍（其余轮候队伍不受影响）" tag:2];
}

- (IBAction)threebuttonClick:(id)sender
{
    if (_queueExistModel.status == 3 || _queueExistModel.status == 4) {
        WaitNumberViewController *vc = [WaitNumberViewController new];
        vc.waiting_project_id = _queueExistModel.waiting_project_id;
        vc.waiting_queue_id = _queueExistModel.waiting_queue_id;
        [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
        return;
    }
    [self showSecondConfimViewInfo:@"您将选择此房源并放弃其余所有轮候队伍" tag:3];
}

- (void)showSecondConfimViewInfo:(NSString *)showString tag:(NSInteger)tag
{
    SecondConfirmView *secondConfirmView = [SecondConfirmView createViewFromNib];
    secondConfirmView.titleLab.text = showString;
    secondConfirmView.titleLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    secondConfirmView.titleLab.textColor = [UIColor colorWithHexString:@"#52595E"];
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:secondConfirmView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    KWeakSelf
    secondConfirmView.didConfirmBlock = ^{
        if (tag == 1) {
            [weakSelf getCancelWaitDate];
        } else if (tag == 2) {
            [weakSelf getThinkAgainWaitDate];
        } else if (tag == 3) {
            [weakSelf getSigningWaitDate];
        }
        [alertController dismissViewControllerAnimated:YES];
    };
    secondConfirmView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [[CommonUtils getCurrentViewController]  presentViewController:alertController animated:YES completion:nil];
}

- (void)getCancelWaitDate
{
    [MBProgressHUD showStatus:nil toView:nil];
    [HttpRequest requestUrlPath:BaseURL urlPath:cityWaiting_cancelURL parameters:@{@"id":@(_queueExistModel.id)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:nil];
        if (status == 1 || status == 2) {
            [MBProgressHUD showMessag:@"取消成功" toView:nil];
            SAFE_BLOCK(self.ReloadWaitHouseDetailBlock);
        } else {
            [MBProgressHUD showMessag:msg toView:nil];
        }
    }];
}

- (void)getThinkAgainWaitDate
{
    [MBProgressHUD showStatus:nil toView:nil];
    [HttpRequest requestUrlPath:BaseURL urlPath:cityWaiting_thinkAgainURL parameters:@{@"id":@(_queueExistModel.id)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:nil];
        if (status == 1 || status == 2) {
            [MBProgressHUD showMessag:@"操作成功" toView:nil];
            SAFE_BLOCK(self.ReloadWaitHouseDetailBlock);
        } else {
            [MBProgressHUD showMessag:msg toView:nil];
        }
    }];
}

- (void)getSigningWaitDate
{
    [MBProgressHUD showStatus:nil toView:nil];
    [HttpRequest requestUrlPath:BaseURL urlPath:cityWaiting_signingURL parameters:@{@"id":@(_queueExistModel.id)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:nil];
        if (status == 1 || status == 2) {
            [MBProgressHUD showMessag:@"签约成功" toView:nil];
            SAFE_BLOCK(self.ReloadWaitHouseDetailBlock);
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
