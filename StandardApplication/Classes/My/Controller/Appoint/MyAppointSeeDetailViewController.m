//
//  MyAppointSeeDetailViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyAppointSeeDetailViewController.h"
#import "MacroDefine.h"
#import "HomeHouseTableViewCell.h"
#import "SecondConfirmView.h"
#import "CancelReserveViewController.h"
#import "AppointDetailModel.h"

@interface MyAppointSeeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic)AppointDetailModel *appointDetailModel;
@end

@implementation MyAppointSeeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"约看详情";
    
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    self.detailTableView.tableFooterView = _footerView;
    
    [self getAppointSeeDetailDate];
}

- (void)getAppointSeeDetailDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:operate_book_infoURL parameters:@{@"id":@(_book_id)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.appointDetailModel = [AppointDetailModel mj_objectWithKeyValues:dic];
            self.appointDetailModel.classInt = [[dic valueForKey:@"class"] intValue];
            [self setupModelInfo];
            [self.detailTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)setupModelInfo
{
    _nameTextField.text = NONullString(_appointDetailModel.name);
    _phoneTextField.text = NONullString(_appointDetailModel.phone);
    _dateTextField.text = [NSString stringWithFormat:@"%@ %@",NONullString(_appointDetailModel.book_date),NONullString(_appointDetailModel.time_slot)];
    if (_appointDetailModel.is_cancel == 0 && _appointDetailModel.verify_status == 0) {
        _cancelBtn.hidden = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 134;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"HomeHouseTableViewCell";
    HomeHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (HomeHouseTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.collectionButton.hidden = YES;
//    cell.collectionButtonLayoutWidth.constant = 0;
//    cell.checkDateLayoutHeight.constant = 0;
//    cell.houseTypeLayoutTop.constant = 15;
    cell.houseNameLayoutRight.constant = 55;
    if (_appointDetailModel.classInt == 1) {
        cell.unitModel = _appointDetailModel.unit;
    } else if (_appointDetailModel.classInt == 2) {
        cell.bigHouseModel = _appointDetailModel.house;
    }
    
    return cell;
}

- (IBAction)cancelBtnClick:(id)sender
{
    SecondConfirmView *secondConfirmView = [SecondConfirmView createViewFromNib];
    secondConfirmView.titleLab.text = @"确定取消预约？";
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:secondConfirmView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    secondConfirmView.didConfirmBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
        [self getOperateBrokenDate];
    };
    secondConfirmView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getOperateBrokenDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:operate_brokenURL parameters:@{@"id":@(_book_id)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            CancelReserveViewController *vc = [CancelReserveViewController new];
            vc.showText = @"您已成功取消房源约看";
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

@end
