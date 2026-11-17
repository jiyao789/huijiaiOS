//
//  SpaceAppointmentDetailViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SpaceAppointmentDetailViewController.h"
#import "MacroDefine.h"
#import "SpaceAppointmentDetailTableViewCell.h"
#import "SpaceAppointmentCalendarTableViewCell.h"
#import "SpaceDetailModel.h"
#import "SecondConfirmView.h"
#import "ActivityCommitSuccessViewController.h"

@interface SpaceAppointmentDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *applyTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (strong, nonatomic) SpaceDetailModel *spaceDetailModel;
@end

@implementation SpaceAppointmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"空间详情";
    
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    self.applyTableView.tableFooterView = _footerView;

    [self getSpaceDetailDate];
}


- (void)getSpaceDetailDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:space_detailURL parameters:@{@"id":@(_spaceId),@"u_id":NONullString([User shareUser].getUserId)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.spaceDetailModel = [SpaceDetailModel mj_objectWithKeyValues:dic];
            if (!IsStrEmpty(self.spaceDetailModel.user_info.name)) {
                self.nameTextField.text = NONullString(self.spaceDetailModel.user_info.name);
            }
            if (!IsStrEmpty(self.spaceDetailModel.user_info.phone)) {
                self.mobileTextField.text = NONullString(self.spaceDetailModel.user_info.phone);
            }
            [self.applyTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? UITableViewAutomaticDimension : 280;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellID = @"SpaceAppointmentDetailTableViewCell";
        SpaceAppointmentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (SpaceAppointmentDetailTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.spaceDetailModel = _spaceDetailModel;
        return cell;
    }
    static NSString *cellID = @"SpaceAppointmentCalendarTableViewCell";
    SpaceAppointmentCalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (SpaceAppointmentCalendarTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.spaceDetailModel = _spaceDetailModel;
    KWeakSelf
    cell.didSelectDateBlock = ^(NSString * _Nonnull dateStr) {
        weakSelf.dateLab.text = dateStr;
    };
    return cell;
}

- (IBAction)commitBtnClick:(id)sender
{
    if (IsStrEmpty(self.dateLab.text)) {
        [MBProgressHUD showMessag:@"请选择预约日期" toView:self.view];
        return;
    }
    if (IsStrEmpty(self.nameTextField.text)) {
        [MBProgressHUD showMessag:@"请输入姓名" toView:self.view];
        return;
    }
    if (IsStrEmpty(self.mobileTextField.text)) {
        [MBProgressHUD showMessag:@"请输入手机号" toView:self.view];
        return;
    }
    _spaceDetailModel.user_info.name = self.nameTextField.text;
    _spaceDetailModel.user_info.phone = self.mobileTextField.text;
    SecondConfirmView *secondConfirmView = [SecondConfirmView createViewFromNib];
    secondConfirmView.titleLab.text = @"是否确认预约该空间?";
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:secondConfirmView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    secondConfirmView.didConfirmBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
        [self spaceCommitDate];
    };
    secondConfirmView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)spaceCommitDate
{
    NSMutableArray *dateArr = [NSMutableArray array];
    [dateArr addObject:self.dateLab.text];
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:space_reservationURL parameters:@{@"id":@(_spaceId),@"u_id":NONullString([User shareUser].getUserId),@"reservation_time":[dateArr mj_JSONString],@"name":NONullString(_nameTextField.text),@"phone":NONullString(_mobileTextField.text)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            ActivityCommitSuccessViewController *vc = [ActivityCommitSuccessViewController new];
            vc.spaceSelectTime = self.dateLab.text;
            vc.spaceDetailModel = _spaceDetailModel;
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}


@end
