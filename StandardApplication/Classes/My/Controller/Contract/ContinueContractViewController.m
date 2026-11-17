//
//  ContinueContractViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ContinueContractViewController.h"
#import "MacroDefine.h"
#import "HomeHouseTableViewCell.h"
#import "JXTAlertManagerHeader.h"
#import "SystemInfoModel.h"
#import "ReatRenewReatModel.h"
#import "CommitReserveViewController.h"

@interface ContinueContractViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *politicsTextField;
@property (weak, nonatomic) IBOutlet UITextField *educationTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *genderLab;
@property (weak, nonatomic) IBOutlet UILabel *localLab;
@property (weak, nonatomic) IBOutlet UILabel *nationLab;
@property (weak, nonatomic) IBOutlet UILabel *cardLab;

@property (strong, nonatomic) SystemInfoModel *systemModel;
@property (strong, nonatomic) ReatRenewReatModel *reatRenewReatModel;
@end

@implementation ContinueContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"续租";
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    self.tableView.tableFooterView = _footerView;
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    
    NSDictionary *dic = [CommonUtils getJsonObjectFromLocal:@"systeminfo.json"];
    self.systemModel = [SystemInfoModel mj_objectWithKeyValues:dic];
    
    [self setupEventInfo];
    
    [self getReatRenewReatDetailDate];
}

- (void)getReatRenewReatDetailDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:reatRenew_reat_detailURL parameters:@{@"contract_id":@(_cid)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.reatRenewReatModel = [ReatRenewReatModel mj_objectWithKeyValues:dic];
            [self setupModelInfo];
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)setupModelInfo
{
    _nameLab.text = NONullString(_reatRenewReatModel.lessee.name);
    _genderLab.text = NONullString(_reatRenewReatModel.lessee.genderStr);
    _localLab.text = NONullString(_reatRenewReatModel.lessee.local);
    _nationLab.text = NONullString(_reatRenewReatModel.lessee.nation);
    _cardLab.text = NONullString(_reatRenewReatModel.lessee.card);
}

- (void)setupEventInfo
{
    [_mobileTextField resignFirstResponder];
    KWeakSelf
    [_companyTextField whenTapped:^{
        KStrongSelf(weakSelf)
        [strongSelf jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            for (SystemLabelModel *model in strongSelf.systemModel.occupation) {
                alertMaker.
                addActionDefaultTitle(model.label);
            }
            alertMaker.
            addActionCancelTitle(@"取消");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if ([action.title isEqualToString:@"取消"]) {
                NSLog(@"按钮2");
            } else {
                SystemLabelModel *model = strongSelf.systemModel.occupation[buttonIndex];
                strongSelf.companyTextField.text = model.label;
                strongSelf.reatRenewReatModel.lessee.work_type = [model.value integerValue];
            }
        }];
    }];
    
    [_politicsTextField whenTapped:^{
        KStrongSelf(weakSelf)
        [strongSelf jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            for (SystemLabelModel *model in strongSelf.systemModel.politics) {
                alertMaker.
                addActionDefaultTitle(model.label);
            }
            alertMaker.
            addActionCancelTitle(@"取消");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if ([action.title isEqualToString:@"取消"]) {
                NSLog(@"按钮2");
            } else {
                SystemLabelModel *model = strongSelf.systemModel.politics[buttonIndex];
                strongSelf.politicsTextField.text = model.label;
                strongSelf.reatRenewReatModel.lessee.politics = [model.value integerValue];
            }
        }];
    }];
    
    [_educationTextField whenTapped:^{
        KStrongSelf(weakSelf)
        [strongSelf jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            for (SystemLabelModel *model in strongSelf.systemModel.education) {
                alertMaker.
                addActionDefaultTitle(model.label);
            }
            alertMaker.
            addActionCancelTitle(@"取消");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if ([action.title isEqualToString:@"取消"]) {
                NSLog(@"按钮2");
            } else {
                SystemLabelModel *model = strongSelf.systemModel.education[buttonIndex];
                strongSelf.educationTextField.text = model.label;
                strongSelf.reatRenewReatModel.lessee.edu = [model.value integerValue];
            }
        }];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 128 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UILabel *headerSectionLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 21, SCREEN_WIDTH - 32, 16)];
    headerSectionLab.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightHeavy];
    headerSectionLab.textColor = [UIColor blackColor];
    headerSectionLab.textAlignment = NSTextAlignmentLeft;
    headerSectionLab.text = section == 0 ? @"房源信息" : @"租客信息";
    
    [sectionView addSubview:headerSectionLab];
    return sectionView;
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
    cell.houseNameLayoutRight.constant = 55;
    cell.reatRenewReatModel = _reatRenewReatModel;
    return cell;
}
- (IBAction)commitBtnClick:(id)sender
{
    if (_mobileTextField.text.length != 11) {
        [MBProgressHUD showMessag:@"请输入正确的手机号" toView:self.view];
        return;
    }
    if (_companyTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请选择单位性质" toView:self.view];
        return;
    }
    if (_politicsTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请选择政治面貌" toView:self.view];
        return;
    }
    if (_educationTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请选择学历" toView:self.view];
        return;
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    NSDictionary *dic = @{@"contract_id":@(_cid),
                          @"org_id":@(_reatRenewReatModel.org_info.org_id),
                          @"unit_id":@(_reatRenewReatModel.org_info.unit_id),
                          @"custom_id":NONullString(_reatRenewReatModel.lessee.custom_id),
                          @"phone":NONullString(_mobileTextField.text),
                          @"work_type":@(_reatRenewReatModel.lessee.work_type),
                          @"politics":@(_reatRenewReatModel.lessee.politics),
                          @"edu":@(_reatRenewReatModel.lessee.edu),
                          @"end_date":NONullString([NSDate timeToTimestampWtihString:NONullString(_reatRenewReatModel.org_info.end_date)])};
    [HttpRequest requestUrlPath:BaseURL urlPath:reatRenew_reatURL parameters:dic type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            CommitReserveViewController *vc = [CommitReserveViewController new];
            vc.successType = ContinueReatSuccessType;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:nil];
        }
    }];
}

@end
