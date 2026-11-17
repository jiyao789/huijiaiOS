//
//  ReserveHouseViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ReserveHouseViewController.h"
#import "MacroDefine.h"
#import "HomeHouseTableViewCell.h"
#import "BillDetailViewController.h"
#import "WSDatePickerView.h"


@interface ReserveHouseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *dataTextField;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *reserveNotesLab;
@property (weak, nonatomic) IBOutlet UILabel *reserveAmountLab;
@property (weak, nonatomic) IBOutlet UIButton *tipProtocolBtn;

@property (assign, nonatomic) CGFloat money;
@property (assign, nonatomic) NSInteger days;
@end

@implementation ReserveHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"预定详情";
    
    _tableViewLayoutTop.constant = NAVBAR_HEIGHT + 10;
    _tableView.tableHeaderView = _headerView;
    _tableView.tableFooterView = _footerView;
    _mobileTextField.text = NONullString([User shareUser].getMobile);
    [self setupInfo];
    
    [self getSetting_get_resDate];
}

- (void)getSetting_get_resDate
{
    [HttpRequest requestUrlPath:BaseURL urlPath:setting_get_resURL parameters:@{} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            _money = [dic[@"money"] floatValue];
            _days = [dic[@"days"] integerValue];
            
            [self setResInfo];
        }
    }];
}

- (void)setResInfo
{
    _reserveNotesLab.text = [NSString stringWithFormat:@"1. 您只能预定%ld天之内的房源\n\n2. 预定将收取定金费用\n\n3. 若由于租客原因导致预定取消，定金将不退换",(long)_days];
    float price = _money / 100;
    _reserveAmountLab.text = [NSString stringWithFormat:@"¥%.2f/月",price];
}

- (void)setupInfo
{
    
    // 预计入住时间
    KWeakSelf
    [_dateView whenTapped:^{
        
        [weakSelf.nameTextField resignFirstResponder];
        [weakSelf.mobileTextField resignFirstResponder];
        [weakSelf.idCardTextField resignFirstResponder];
        
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
            NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            NSLog(@"选择的日期：%@",dateString);
            weakSelf.dataTextField.text = dateString;
        }];
        datepicker.minLimitDate = [NSDate date];
        datepicker.maxLimitDate = [self addDay];
        datepicker.dateLabelColor = [UIColor colorWithHex:@"#202224"];//年-月-日-时-分 颜色
        datepicker.datePickerColor = [UIColor colorWithHex:@"#202224"];//滚轮日期颜色
        [datepicker show];
    }];
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

- (IBAction)tipProtocolBtnClick:(UIButton *)sender
{
    NSString *imageNameStr = _tipProtocolBtn.tag == 0 ? @"reserve_select_img" : @"reserve_noselect_img";
    [_tipProtocolBtn setImage:[UIImage imageNamed:imageNameStr] forState:UIControlStateNormal];
    _tipProtocolBtn.tag = sender.tag == 0 ? 1 : 0;
}

- (IBAction)payBtnClick:(id)sender
{
    if (_nameTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入真实姓名" toView:self.view];
        return;
    }
    if (_idCardTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入身份证号" toView:self.view];
        return;
    }
    if (_dataTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请选择日期" toView:self.view];
        return;
    }
    
    if (_tipProtocolBtn.tag == 0) {
        [MBProgressHUD showMessag:@"请同意《憓家预定规则》" toView:self.view];
        return;
    }
    
    [self loadUserInfo];
}

- (void)loadUserInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:setting_profileURL parameters:@{@"name":_nameTextField.text,@"card":_idCardTextField.text} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            [self reserveApplyDate];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)reserveApplyDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:reserve_applyURL parameters:@{@"unit_id":@(_houseDetailModel.unit_id),@"book_date":_dataTextField.text} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            BillDetailViewController *vc = [BillDetailViewController new];
            vc.reserveAmount = _money;
            vc.houseDetailModel = _houseDetailModel;
            vc.bookId = [dic[@"book_id"] integerValue];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (NSDate *)addDay {
    NSDate *nowDate = [NSDate date];
    NSTimeInterval oneDay = 24 * 60 * 60;  // 1天的长度
    NSDate *newDate = [nowDate dateByAddingTimeInterval:oneDay * _days];
    return newDate;
}

@end
