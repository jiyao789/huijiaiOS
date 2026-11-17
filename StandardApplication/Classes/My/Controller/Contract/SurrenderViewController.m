//
//  SurrenderViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SurrenderViewController.h"
#import "MacroDefine.h"
#import "HomeHouseTableViewCell.h"
#import "BillAmountDetailTableViewCell.h"
#import "JXTAlertManagerHeader.h"
#import "SystemInfoModel.h"
#import "SurrenderTimeView.h"
#import "ReatRenewReatModel.h"
#import "CommitReserveViewController.h"


@interface SurrenderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *surrenderTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextField *surrenderTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardBankTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNameTextField;

@property (strong, nonatomic) SystemInfoModel *systemModel;
@property (strong, nonatomic) ReatRenewReatModel *reatRenewReatModel;
@end

@implementation SurrenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"退租";
    
    _surrenderTableView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    _tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    _surrenderTableView.tableFooterView = _footerView;
    
    NSDictionary *dic = [CommonUtils getJsonObjectFromLocal:@"systeminfo.json"];
    self.systemModel = [SystemInfoModel mj_objectWithKeyValues:dic];
    
    [self getReatRenewDetailDate];
}

- (void)getReatRenewDetailDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:reatRenew_renew_detailURL parameters:@{@"contract_id":@(_cid)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.reatRenewReatModel = [ReatRenewReatModel mj_objectWithKeyValues:dic];
            
            [self setupEventInfo];
            [self.surrenderTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)setReatRenewReatModel:(ReatRenewReatModel *)reatRenewReatModel
{
    _reatRenewReatModel = reatRenewReatModel;
    
    if (![NSDate compareOneDay:[NSDate getNextMonth:[NSDate date]] withAnotherDay:[NSDate stringToDate:NONullString(_reatRenewReatModel.org_info.end_date)]]) {
        _surrenderTimeTextField.text = NONullString(_reatRenewReatModel.org_info.end_date);
    }
}

- (void)setupEventInfo
{
    KWeakSelf
    [_surrenderTimeTextField whenTapped:^{
        KStrongSelf(weakSelf)
        
        [strongSelf.cardNumberTextField resignFirstResponder];
        [strongSelf.cardNameTextField resignFirstResponder];
        [strongSelf.cardBankTextField resignFirstResponder];
        
        if (![NSDate compareOneDay:[NSDate getNextMonth:[NSDate date]] withAnotherDay:[NSDate stringToDate:NONullString(strongSelf.reatRenewReatModel.org_info.end_date)]]) {
            return;
        }
        
        if (IsStrEmpty(strongSelf.reatRenewReatModel.org_info.end_date)) {
            [MBProgressHUD showMessag:@"退租时间有误" toView:strongSelf.view];
            return;
        }

        SurrenderTimeView *surrenderTimeView = [SurrenderTimeView createViewFromNib];
        surrenderTimeView.end_date = NONullString(strongSelf.reatRenewReatModel.org_info.end_date);
        ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:surrenderTimeView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
        surrenderTimeView.didSelectDateBlock = ^(NSString * _Nonnull dateStr) {
            strongSelf.surrenderTimeTextField.text = dateStr;
            [alertController dismissViewControllerAnimated:YES];
        };
        alertController.tapBackgroundDismissEnable = YES;
        [strongSelf presentViewController:alertController animated:YES completion:nil];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 128 : (indexPath.section == 1 ? UITableViewAutomaticDimension : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UILabel *headerSectionLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 21, SCREEN_WIDTH - 32, 16)];
    headerSectionLab.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightHeavy];
    headerSectionLab.textColor = [UIColor blackColor];
    headerSectionLab.textAlignment = NSTextAlignmentLeft;
    headerSectionLab.text = section == 0 ? @"房源信息" : (section == 1 ? @"租客信息" : @"退房时间");
    
    [sectionView addSubview:headerSectionLab];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"HomeHouseTableViewCell";
        HomeHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (HomeHouseTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        cell.collectionButton.hidden = YES;
//        cell.collectionButtonLayoutWidth.constant = 0;
//        cell.checkDateLayoutHeight.constant = 0;
//        cell.houseTypeLayoutTop.constant = 15;
        cell.houseNameLayoutRight.constant = 55;
        cell.reatRenewReatModel = _reatRenewReatModel;
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *cellID = @"BillAmountDetailTableViewCell";
        BillAmountDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (BillAmountDetailTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _reatRenewReatModel.lessee;
        return cell;
    }
    return [UITableViewCell new];
}

- (IBAction)commitBtnClick:(id)sender
{
    
    if (_surrenderTimeTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请选择退租时间" toView:self.view];
        return;
    }
    if (_cardNumberTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入银行账户" toView:self.view];
        return;
    }
    if (_cardBankTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入所属银行" toView:self.view];
        return;
    }
    if (_cardNameTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入收款账户名" toView:self.view];
        return;
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    NSDictionary *dic = @{@"contract_id":@(_cid),
                          @"org_id":@(_reatRenewReatModel.org_info.org_id),
                          @"unit_id":@(_reatRenewReatModel.org_info.unit_id),
                          @"custom_id":NONullString(_reatRenewReatModel.lessee.custom_id),
                          @"surrender_time":NONullString([NSDate timeToTimestampWtihString:NONullString(_surrenderTimeTextField.text)]),
                          @"account":NONullString(_cardNumberTextField.text),
                          @"account_name":NONullString(_cardNameTextField.text),
                          @"bank":NONullString(_cardBankTextField.text)};
    [HttpRequest requestUrlPath:BaseURL urlPath:reatRenew_renewURL parameters:dic type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            CommitReserveViewController *vc = [CommitReserveViewController new];
            vc.successType = SurrenderReatSuccess;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:nil];
        }
    }];
}
@end
