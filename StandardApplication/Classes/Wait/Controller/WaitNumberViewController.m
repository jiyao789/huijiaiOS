//
//  WaitNumberViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2023/6/17.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "WaitNumberViewController.h"
#import "MacroDefine.h"
#import "MyWaitViewController.h"
#import "SecondConfirmView.h"
#import "LookCerViewController.h"
#import "WaitHouseDetailViewController.h"
#import "WaitNotesViewController.h"

@interface WaitNumberViewController ()<FSCalendarDelegate,FSCalendarDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewLayoutTop;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *certificateTextField;
@property (weak, nonatomic) IBOutlet UITextField *certificateDateTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *certificateDateViewLayoutHeight;
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (assign, nonatomic) BOOL isAgree;
@property (assign, nonatomic) BOOL isUnfold;
@end

@implementation WaitNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = @"房源轮候";
    [self leftBarItem];
    _scrollViewLayoutTop.constant = NAVBAR_HEIGHT;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F9FE"];
    
    _calendar.delegate = self;
    _calendar.dataSource = self;
    _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";

    _isAgree = NO;
    _isUnfold = NO;
    
    KWeakSelf
    [_certificateDateTextField whenTapped:^{
        [weakSelf.nameTextField resignFirstResponder];
        [weakSelf.phoneTextField resignFirstResponder];
        [weakSelf.certificateTextField resignFirstResponder];
        
        [weakSelf unfoldInfo];
    }];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:[NSDate getNowDateStr]];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did didSelect date %@",[self.dateFormatter stringFromDate:date]);
    _certificateDateTextField.text = [self.dateFormatter stringFromDate:date];
    
    [self unfoldInfo];
}

- (IBAction)downBtnClick:(UIButton *)sender
{
    [_nameTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    [_certificateTextField resignFirstResponder];
    
    [self unfoldInfo];
}

- (void)unfoldInfo
{
    _isUnfold = !_isUnfold;
    _certificateDateViewLayoutHeight.constant = _isUnfold ? 430 : 100;
    _calendar.hidden = _isUnfold ? NO : YES;
}

- (IBAction)lookCerBtnClick:(UIButton *)sender
{
    LookCerViewController *vc = [LookCerViewController new];
    vc.type = sender.tag;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)agreeBtnClick:(id)sender
{
    _isAgree = !_isAgree;
    NSString *imageStr = _isAgree ? @"reserve_select_img" : @"reserve_noselect_img";
    [_agreeBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
}

- (IBAction)waitMessageBtnClick:(id)sender
{
    WaitNotesViewController *vc = [WaitNotesViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)commitBtnClick:(id)sender
{
    if (!_isAgree) {
        [MBProgressHUD showMessag:@"请阅读并同意轮候须知" toView:self.view];
        return;
    }
    if (IsStrEmpty(_nameTextField.text)) {
        [MBProgressHUD showMessag:@"请输入您的姓名" toView:self.view];
        return;
    }
    if (IsStrEmpty(_phoneTextField.text)) {
        [MBProgressHUD showMessag:@"请输入您的手机号" toView:self.view];
        return;
    }
    if (IsStrEmpty(_certificateTextField.text)) {
        [MBProgressHUD showMessag:@"请输入准入资格证书" toView:self.view];
        return;
    }
    if (IsStrEmpty(_certificateDateTextField.text)) {
        [MBProgressHUD showMessag:@"请选择准入资格生效日期" toView:self.view];
        return;
    }
    [self registerHouseInfo];
}

- (void)registerHouseInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:cityWaiting_attendURL parameters:@{@"name":NONullString(_nameTextField.text),@"phone":NONullString(_phoneTextField.text),@"certificate_number":NONullString(_certificateTextField.text),@"certificate_effective_date":NONullString(_certificateDateTextField.text),@"waiting_queue_id":@(_waiting_queue_id),@"waiting_project_id":@(_waiting_project_id)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
//            MyWaitViewController *vc = [MyWaitViewController new];
//            [self.navigationController pushViewController:vc animated:YES];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[WaitHouseDetailViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

@end
