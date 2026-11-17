//
//  MyReserveDetailViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyReserveDetailViewController.h"
#import "MacroDefine.h"
#import "HomeHouseTableViewCell.h"
#import "CancelReserveViewController.h"
#import "SecondConfirmView.h"
#import "AppointDetailModel.h"

@interface MyReserveDetailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UILabel *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelbtn;

@property (strong, nonatomic)AppointDetailModel *appointDetailModel;
@end

@implementation MyReserveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"预定详情";
    
    _tableViewLayoutTop.constant = NAVBAR_HEIGHT + 10;
    _tableView.tableFooterView = _footerView;
    
    [self getReserveInfoDate];
}

- (void)getReserveInfoDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:reserve_infoURL parameters:@{@"book_id":@(_book_id)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.appointDetailModel = [AppointDetailModel mj_objectWithKeyValues:dic];
            [self setupModelInfo];
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)setupModelInfo
{
    _nameTextField.text = NONullString(_appointDetailModel.name);
    _phoneTextField.text = NONullString(_appointDetailModel.phone);
    _cardTextField.text = NONullString(_appointDetailModel.card);
    _dateTextField.text = NONullString(_appointDetailModel.book_date);
    _amountTextField.text = NONullString(_appointDetailModel.priceStr);
    if (_appointDetailModel.payed == 1 && _appointDetailModel.is_cancel == 0) {
        _cancelbtn.hidden = NO;
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
    cell.unitModel = _appointDetailModel.unit;
    return cell;
}

- (IBAction)cancelReserveBtnClick:(id)sender
{
    SecondConfirmView *secondConfirmView = [SecondConfirmView createViewFromNib];
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:secondConfirmView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    secondConfirmView.didConfirmBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
        [self getReserveRevokeDate];
    };
    secondConfirmView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getReserveRevokeDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:reserve_revokeURL parameters:@{@"book_id":@(_book_id)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            CancelReserveViewController *vc = [CancelReserveViewController new];
            vc.showText = @"您已成功取消房源预定";
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

@end
