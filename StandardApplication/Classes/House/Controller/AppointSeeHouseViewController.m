//
//  AppointSeeHouseViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "AppointSeeHouseViewController.h"
#import "MacroDefine.h"
#import "HomeHouseTableViewCell.h"
#import "MyReserveDetailViewController.h"
#import "SeeHouseDateView.h"
#import "CommitReserveViewController.h"

@interface AppointSeeHouseViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *textCountLab;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (strong, nonatomic) NSString *bookDateStr;
@property (strong, nonatomic) NSString *timeSlotStr;
@end

@implementation AppointSeeHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"预约看房";
    _bookDateStr = @"";
    _timeSlotStr = @"";
    
    _tableViewLayoutTop.constant = NAVBAR_HEIGHT + 10;
    _tableView.tableFooterView = _footerView;
    _mobileTextField.text = [User shareUser].getMobile;
    
//    [self setupInfo];
}

- (void)setupInfo
{
    [_nameTextField resignFirstResponder];
    [_mobileTextField resignFirstResponder];
    [_noteTextView resignFirstResponder];
    KWeakSelf
    [_dateView whenTapped:^{
        KStrongSelf(weakSelf)
        SeeHouseDateView *seeHouseDateView = [SeeHouseDateView createViewFromNib];
        seeHouseDateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 320);
        ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:seeHouseDateView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
        alertController.alertOriginY = SCREEN_HEIGHT - 320;
        seeHouseDateView.didConfirmBlock = ^(NSString * _Nonnull book_date,NSString * _Nonnull time_slot) {
            strongSelf.dateTextField.text = [NSString stringWithFormat:@"%@ %@",book_date,time_slot];
            strongSelf.bookDateStr = book_date;
            strongSelf.timeSlotStr = time_slot;
            [alertController dismissViewControllerAnimated:YES];
        };
        alertController.tapBackgroundDismissEnable = YES;
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    //字数限制
    if (textView.text.length >= 200) {
        textView.text = [textView.text substringToIndex:200];
    }
    
    if (textView.text.length > 0)  {
        _tipLab.hidden = YES;
        _textCountLab.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
    } else {
        _tipLab.hidden = NO;
        _textCountLab.text = @"0/200";
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
    cell.isNotHouseDetail = YES;
    cell.houseDetailModel = _houseDetailModel;
    return cell;
}

- (IBAction)commitBtnClick:(id)sender
{
    if (_nameTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入姓名" toView:self.view];
        return;
    }
    [MBProgressHUD showStatus:nil toView:self.view];
//  @"book_date":NONullString(_bookDateStr),@"time_slot":NONullString(_timeSlotStr)
    [HttpRequest requestUrlPath:BaseURL urlPath:operate_bookURL parameters:@{@"unit_id":@(_houseDetailModel.unit_id),@"name":_nameTextField.text,@"phone":_mobileTextField.text,@"note":_noteTextView.text} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            CommitReserveViewController *vc = [CommitReserveViewController new];
            vc.successType = ReserrveSuccessType;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}


@end
