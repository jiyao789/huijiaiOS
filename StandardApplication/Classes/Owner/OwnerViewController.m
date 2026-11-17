//
//  OwnerViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/18.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "OwnerViewController.h"
#import "MacroDefine.h"
#import "UnitFilterModel.h"
#import "CommitReserveViewController.h"
#import "JXTAlertManagerHeader.h"
#import "OwnerAddressView.h"

@interface OwnerViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *familyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *houseTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (strong, nonatomic) NSArray *shiArr;
@property (strong, nonatomic) UnitFilterModel *unitFilterModel;
@property (assign, nonatomic) NSInteger countySelectIndex;
@property (assign, nonatomic) NSInteger townSelectIndex;
@end

@implementation OwnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.hideNaviBar = YES;
    self.viewLayoutTop.constant = 20;
    self.mobileTextField.text = NONullString([User shareUser].getMobile);
    self.view.backgroundColor = [UIColor clearColor];
    
    _countySelectIndex = 0;
    _townSelectIndex = 0;
    [self setupViewInfo];
    
    [self getUnitFilterDate];
}

- (void)getUnitFilterDate
{
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:unit_filterJsonURL parameters:@{} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            self.shiArr = dic[@"shi"];
        }
    }];
}

- (void)setupViewInfo
{
    [_familyNameTextField resignFirstResponder];
    [_mobileTextField resignFirstResponder];
    KWeakSelf
    [_locationTextField whenTapped:^{
        KStrongSelf(weakSelf)
        OwnerAddressView *ownerAddressView = [OwnerAddressView createViewFromNib];
        ownerAddressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 280);
        ownerAddressView.countySelectIndex = strongSelf.countySelectIndex;
        ownerAddressView.townSelectIndex = strongSelf.townSelectIndex;
        ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:ownerAddressView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
        alertController.alertOriginY = SCREEN_HEIGHT - 280;
        ownerAddressView.chooseLocationViewBlock = ^(NSInteger county_id, NSInteger town_id, NSString * _Nonnull name, NSInteger countySelectIndex, NSInteger townSelectIndex) {
            strongSelf.locationTextField.text = NONullString(name);
            strongSelf.unitFilterModel.county_id = county_id;
            strongSelf.unitFilterModel.town_id = town_id;
            strongSelf.countySelectIndex = countySelectIndex;
            strongSelf.townSelectIndex = townSelectIndex;
            [alertController dismissViewControllerAnimated:YES];
        };
        ownerAddressView.resetLocationViewBlock = ^{
            strongSelf.locationTextField.text = @"请选择位置";
            strongSelf.unitFilterModel.county_id = 0;
            strongSelf.unitFilterModel.town_id = 0;
            strongSelf.countySelectIndex = 0;
            strongSelf.townSelectIndex = 0;
            [alertController dismissViewControllerAnimated:YES];
        };
        alertController.tapBackgroundDismissEnable = YES;
        [strongSelf presentViewController:alertController animated:YES completion:nil];
    }];
    
    [_houseTypeTextField whenTapped:^{
        KStrongSelf(weakSelf)
        [strongSelf jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            for (NSDictionary *dic in strongSelf.shiArr) {
                alertMaker.
                addActionDefaultTitle(dic[@"val"]);
            }
            alertMaker.
            addActionCancelTitle(@"取消");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if ([action.title isEqualToString:@"取消"]) {
                NSLog(@"按钮2");
            } else {
                NSDictionary *dic = strongSelf.shiArr[buttonIndex];
                strongSelf.houseTypeTextField.text = NONullString(dic[@"val"]);
                strongSelf.unitFilterModel.shi = [dic[@"key"] integerValue];
            }
        }];
    }];
}

- (IBAction)sendBtnClick:(id)sender
{
    if (_unitFilterModel.county_id == 0 || _unitFilterModel.town_id == 0) {
        [MBProgressHUD showMessag:@"请选择位置" toView:self.view];
        return;
    }
    if (_familyNameTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入小区名称" toView:self.view];
        return;
    }
    if (_houseTypeTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请选择户型" toView:self.view];
        return;
    }
    if (_mobileTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入联系电话" toView:self.view];
        return;
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:unit_entrustURL parameters:@{@"phone":NONullString(_mobileTextField.text),@"province_id":@"310000000000",@"city_id":@"310100000000",@"county_id":@(_unitFilterModel.county_id),@"town_id":@(_unitFilterModel.town_id),@"shi":@(_unitFilterModel.shi),@"region_name":NONullString(_familyNameTextField.text)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            self.locationTextField.text = @"请选择位置";
            self.familyNameTextField.text = @"";
            self.houseTypeTextField.text = @"";
            self.mobileTextField.text = NONullString([User shareUser].getMobile);
            self.unitFilterModel.county_id = 0;
            self.unitFilterModel.town_id = 0;
            self.countySelectIndex = 0;
            self.townSelectIndex = 0;
            CommitReserveViewController *vc = [CommitReserveViewController new];
            vc.successType = EntrustSuccessType;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (UnitFilterModel *)unitFilterModel
{
    if (!_unitFilterModel) {
        _unitFilterModel = [UnitFilterModel new];
    }
    return _unitFilterModel;
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

@end
