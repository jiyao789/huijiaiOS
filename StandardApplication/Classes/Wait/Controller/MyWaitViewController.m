//
//  MyWaitViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2023/6/18.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "MyWaitViewController.h"
#import "MacroDefine.h"
#import "WaitNotesViewController.h"
#import "SecondConfirmView.h"
#import "WaitingDetailModel.h"
#import "BasicPoinsCollectionViewCell.h"
#import "HouseDetailViewController.h"

@interface MyWaitViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *waitNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *waitDateLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionButtonLayoutWidth;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;
@property (weak, nonatomic) IBOutlet UILabel *houseWaitLab;
@property (weak, nonatomic) IBOutlet UILabel *houseNatureLab;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *houseInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *houseAmountLab;
@property (weak, nonatomic) IBOutlet UICollectionView *poinsCollectionView;
@property (weak, nonatomic) IBOutlet UIView *houseInfoView;
@property (weak, nonatomic) IBOutlet UIButton *cancelWaitBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitRuleBtn;
@property (weak, nonatomic) IBOutlet UIButton *allocatedBtn;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet UILabel *waitnumLab;
@property (weak, nonatomic) IBOutlet BaseShadowView *allocatedOneView;
@property (weak, nonatomic) IBOutlet BaseShadowView *allocatedTwoView;
@property (weak, nonatomic) IBOutlet UILabel *waitdateLab;
@property (weak, nonatomic) IBOutlet UILabel *showLab1;
@property (weak, nonatomic) IBOutlet UILabel *showLab2;
@property (weak, nonatomic) IBOutlet UILabel *showLab3;

@property (strong, nonatomic) WaitingDetailModel *waitingDetailModel;
@property (strong, nonatomic) NSArray *poinsArr;
@end

@implementation MyWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = @"我的轮候";
    [self leftBarItem];
    _viewLayoutTop.constant = NAVBAR_HEIGHT + 16;
    self.gk_interactivePopDisabled = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F9FE"];
    
    _poinsCollectionView.delegate = self;
    _poinsCollectionView.dataSource = self;
    [_poinsCollectionView registerNib:[UINib nibWithNibName:@"BasicPoinsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BasicPoinsCollectionViewCell"];
    
    KWeakSelf
    [_houseInfoView whenTapped:^{
        [weakSelf getUnitDetailDate];
    }];
}

- (void)getUnitDetailDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:unit_detailURL parameters:@{@"unit_id":@(self.waitingDetailModel.unit_id),@"platform":@"2"} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            HouseDetailViewController *vc = [HouseDetailViewController new];
            vc.unit_id = self.waitingDetailModel.unit_id;
            KWeakSelf
            vc.houseIsCollectBlock = ^(NSInteger collect) {
                weakSelf.waitingDetailModel.unitInfo.collect = collect;
                NSString *imageStr = weakSelf.waitingDetailModel.unitInfo.collect ? @"house_collection_select_img" : @"house_collection_unselect_img";
                [weakSelf.collectionButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getUnitWaitingDetailDate];
}

- (void)createNotificationCenterInfo:(HouseListModel *)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HouseCollectNotification" object:nil userInfo:model.mj_keyValues];
}

- (void)getUnitWaitingDetailDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:unitWaiting_infoURL parameters:@{} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.waitingDetailModel = [WaitingDetailModel mj_objectWithKeyValues:dic];
            [self showWaitingDetailInfo];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)showWaitingDetailInfo
{
    if (self.waitingDetailModel.allocated == 0) {
        _allocatedBtn.hidden = YES;
        _cancelWaitBtn.hidden = NO;
        _waitRuleBtn.hidden = NO;
        _allocatedOneView.hidden = NO;
        _allocatedTwoView.hidden = YES;
        _showLab3.hidden = IsNilOrNull(self.waitingDetailModel.allocate_time) ? YES : NO;
        _waitNumberLab.text = [NSString stringWithFormat:@"%@",self.waitingDetailModel.number];
        _waitDateLab.text = NONullString(self.waitingDetailModel.allocate_time);
    } else {
        _allocatedOneView.hidden = YES;
        _allocatedTwoView.hidden = NO;
        _allocatedBtn.hidden = NO;
        _allocatedBtn.backgroundColor = [UIColor colorWithHexString:self.waitingDetailModel.allocated == 2 ? @"#1B61A0" : @"#F8F9FE"];
        [_allocatedBtn setTitle:self.waitingDetailModel.allocated == 2 ? @"确认" : @"致电选房中心" forState:UIControlStateNormal];
        [_allocatedBtn setTitleColor:[UIColor colorWithHexString:self.waitingDetailModel.allocated == 2 ? @"#FFFFFF" : @"#616161"] forState:UIControlStateNormal];
        _messageLab.text = self.waitingDetailModel.allocated == 2 ? @"很遗憾，房源未能匹配" : @"恭喜您，房源已匹配";
        _waitnumLab.text = [NSString stringWithFormat:@"%@",self.waitingDetailModel.number];
        _showLab1.hidden = self.waitingDetailModel.allocated == 2 ? YES : NO;
        _showLab2.hidden = self.waitingDetailModel.allocated == 2 ? NO : YES;
        _waitdateLab.hidden = self.waitingDetailModel.allocated == 2 ? NO : YES;
        _waitdateLab.text = NONullString(self.waitingDetailModel.allocate_time);
        _cancelWaitBtn.hidden = YES;
        _waitRuleBtn.hidden = YES;
    }
    if (!IsNilOrNull(self.waitingDetailModel.unitInfo)) {
        _houseInfoView.hidden = NO;
        [_houseImageView setImageUrl:self.waitingDetailModel.unitInfo.imgs placeholderImage:defaultIconName];
        _houseNameLab.text = [NSString stringWithFormat:@"%@%@",NONullString(self.waitingDetailModel.unitInfo.region_name),NONullString(self.waitingDetailModel.unitInfo.shiString)];
        _houseNatureLab.text = self.waitingDetailModel.unitInfo.nature == 1 ? @"公租" : @"社租";
        _houseInfoLab.text = [NSString stringWithFormat:@"%.2f㎡    |    %@    |    %@",self.waitingDetailModel.unitInfo.area,NONullString(self.waitingDetailModel.unitInfo.shiString),NONullString(self.waitingDetailModel.unitInfo.towardString)];
        _houseAmountLab.text = NONullString(self.waitingDetailModel.unitInfo.priceString);
        NSString *imageStr = self.waitingDetailModel.unitInfo.collect ? @"house_collection_select_img" : @"house_collection_unselect_img";
        [self.collectionButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        
        _poinsArr = self.waitingDetailModel.unitInfo.point;
        [self.poinsCollectionView reloadData];
    } else {
        _houseInfoView.hidden = YES;
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _poinsArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BasicPoinsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BasicPoinsCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic = _poinsArr[indexPath.row];
    cell.poinsLab.font = [UIFont systemFontOfSize:8.0f weight:UIFontWeightMedium];
    cell.poinsLab.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _poinsArr[indexPath.row];
    CGSize poinsSize = [dic[@"name"] sizeWithFont:[UIFont systemFontOfSize:8.0f weight:UIFontWeightMedium] constrainedSize:CGSizeMake(MAXFLOAT, 15)];
    return CGSizeMake(poinsSize.width + 20, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (IBAction)cancelWaitBtnClick:(id)sender
{
    SecondConfirmView *secondConfirmView = [SecondConfirmView createViewFromNib];
    secondConfirmView.titleLab.text = !IsNilOrNull(self.waitingDetailModel.unitInfo) ? @"确认取消此房源轮候？\n注：取消房源轮候不会取消轮候排队" : @"若取消当前轮候号码将失效,\n确认取消轮候？";
    secondConfirmView.titleLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    secondConfirmView.titleLab.textColor = [UIColor colorWithHexString:@"#52595E"];
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:secondConfirmView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    KWeakSelf
    secondConfirmView.didConfirmBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
        [weakSelf getCancelUnitWaitDate];
    };
    secondConfirmView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getCancelUnitWaitDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:unitWaiting_cancelURL parameters:@{} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        [MBProgressHUD showMessag: (status == 1 || status == 2) ? @"取消成功" :msg toView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)waitRuleBtnClick:(id)sender
{
    WaitNotesViewController *vc = [WaitNotesViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)allocatedBtnClick:(id)sender
{
    if (self.waitingDetailModel.allocated == 1) {
        NSString * phone = [NSString stringWithFormat:@"telprompt://%@",@"021-64835777"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:nil];
    } else {
        [MBProgressHUD showStatus:nil toView:self.view];
        [HttpRequest requestUrlPath:BaseURL urlPath:unitWaiting_cancel_pickURL parameters:@{} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
            [MBProgressHUD dismissHUDForView:self.view];
            if (status == 1 || status == 2) {
                MyWaitViewController *vc = [MyWaitViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [MBProgressHUD showMessag:msg toView:self.view];
            }
        }];
    }
}

- (IBAction)collectionBtnClick:(id)sender
{
    NSString *urlStr = self.waitingDetailModel.unitInfo.collect ? unit_cancelcollectURL : unit_collectURL;
    [HttpRequest requestUrlPath:BaseURL urlPath:urlStr parameters:@{@"unit_id":@(self.waitingDetailModel.unit_id)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:nil];
        if (status == 1 || status == 2) {
            self.waitingDetailModel.unitInfo.collect = !self.waitingDetailModel.unitInfo.collect;
            NSString *imageStr = self.waitingDetailModel.unitInfo.collect ? @"house_collection_select_img" : @"house_collection_unselect_img";
            [self.collectionButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        } else if (status == 403) {
            [MBProgressHUD showMessag:msg toView:nil];
        }
    }];
}

- (void)backAction
{
    if ([_backType isEqualToString:@"previous"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
