//
//  MyHeaderView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyHeaderView.h"
#import "MacroDefine.h"
#import "MyHeaderCollectionViewCell.h"
#import "MyCollectionViewController.h"
#import "PersonInfoViewController.h"
#import "MyBaseApplyViewController.h"
#import "MyCollectionViewCell.h"
#import "MyContractListViewController.h"
#import "BillListViewController.h"
#import "LiveChargeViewController.h"
//#import "LockListViewController.h"
#import "LockSelectViewController.h"
#import "MyWaitViewController.h"
#import "WaitViewController.h"
#import "AcquisitionListVC.h"

@interface MyHeaderView ()
@property (assign, nonatomic) NSInteger declarationCount;
@property (strong, nonatomic) NSArray *titleArr;
@property (strong, nonatomic) NSArray *secondTitleArr;
@property (strong, nonatomic) NSArray *secondImageArr;
@end

@implementation MyHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_mobileView.layer insertSublayer :[UIColor setGradualChangingColor:_mobileView fromColor:[UIColor colorWithHexString:@"#2945CB"] toColor:[UIColor colorWithHexString:@"#8A9EFF"]] atIndex:0];
    [CommonUtils addCorner:_mobileView rect:_mobileView.bounds rectCorner:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    
//    _titleArr = @[@"我的收藏",@"我的足迹",@"我的预约",@"我的轮候"];
    _titleArr = @[@"我的收藏",@"我的申报",@"我的足迹",@"我的预约"];
    _secondTitleArr = @[@"我的合同",@"我的账单",@"水电燃气",@"锁信息"];
    _secondImageArr = @[@"my_contract_img",@"my_bill_img",@"my_waterElec_img",@"my_lockInfo_img"];

    _myHeaderCollectionView.delegate = self;
    _myHeaderCollectionView.dataSource = self;
    CGFloat space = (SCREEN_WIDTH - 16 * 2 - 10 * 2 - 57 * _titleArr.count) / (_titleArr.count - 1);
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = space;
    _layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _layout.itemSize = CGSizeMake(57, 57);
    [_myHeaderCollectionView registerNib:[UINib nibWithNibName:@"MyHeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyHeaderCollectionViewCell"];
    
    _myHeaderSecondCollectionView.delegate = self;
    _myHeaderSecondCollectionView.dataSource = self;
    CGFloat secondSpace = (SCREEN_WIDTH - 16 * 2 - 15 * 2 - 50 * 4) / 3;
    _secondLayout.minimumLineSpacing = 0;
    _secondLayout.minimumInteritemSpacing = secondSpace;
    _secondLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _secondLayout.itemSize = CGSizeMake(50, 105);
    [_myHeaderSecondCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
    
    KWeakSelf
    [_averteImageView whenTapped:^{
        [weakSelf pushPersonViewController];
    }];
}

- (void)layoutSubviews
{
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 360);
}

- (void)setModel:(UserModel *)model
{
    _model = model;
    if (IsNilOrNull(_model)) {
        _averteImageView.image = [UIImage imageNamed:defaultIconName];
        _nameLab.text = @"未登录";
        _mobileLab.text = @"";
        _mobileView.hidden = YES;
        _declarationCount = 0;
        [self.myHeaderCollectionView reloadData];
        return;
    }
    [_averteImageView setImageUrl:NONullString(_model.avatar) placeholderImage:defaultIconName];
    _nameLab.text = NONullString(_model.nickname);
    NSString *numberString = NONullString(_model.phone);
    if (_model.phone.length > 9) {
        numberString = [_model.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    _mobileView.hidden = NO;
    _mobileLab.text = numberString;

    // 获取申报数量
    [self getDeclarationCount];

    [self.myHeaderCollectionView reloadData];
}

- (void)getDeclarationCount
{
    [HttpRequest requestUrlPath:BaseURL urlPath:acquisitionDeclaration_countURL parameters:@{} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            self.declarationCount = [dic[@"count"] integerValue];
            [self.myHeaderCollectionView reloadData];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return collectionView.tag == 1 ? _titleArr.count : _secondTitleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1) {
        MyHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyHeaderCollectionViewCell" forIndexPath:indexPath];
        cell.nameLab.text = _titleArr[indexPath.row];
        if (indexPath.row == 0) {
            // 我的收藏
            cell.numberLab.text = IsNilOrNull(_model) ? @"0" : [NSString stringWithFormat:@"%ld",(long)_model.subscribe_count];
        } else if (indexPath.row == 1) {
            // 我的申报
            cell.numberLab.text = [NSString stringWithFormat:@"%ld",(long)_declarationCount];
        } else if (indexPath.row == 2) {
            // 我的足迹
            NSMutableArray *array = [[SNFileCache defaultCache] arrayForKey:@"House"];
            cell.numberLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)array.count];
        } else if (indexPath.row == 3) {
            // 我的预约
            cell.numberLab.text = IsNilOrNull(_model) ? @"0" : [NSString stringWithFormat:@"%ld",(_model.book_count + _model.reserve_count)];
        }
        return cell;
    }
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    cell.myNameLab.text = _secondTitleArr[indexPath.row];
    cell.myImageView.image = [UIImage imageNamed:_secondImageArr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1) {
        // 我的足迹（index 2）不需要登录
        if (indexPath.row == 2) {
            MyCollectionViewController *vc = [MyCollectionViewController new];
            vc.type = 2;
            [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
            return;
        }
    }
    [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
        if (performLogin) {
            [[CommonUtils getCurrentViewController].navigationController popToRootViewControllerAnimated:YES];
        } else {
            if (collectionView.tag == 1) {
                if (indexPath.row == 0) {
                    // 我的收藏
                    MyCollectionViewController *vc = [MyCollectionViewController new];
                    vc.type = 1;
                    [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
                } else if (indexPath.row == 1) {
                    // 我的申报
                    [[CommonUtils getCurrentViewController].navigationController pushViewController:[AcquisitionListVC new] animated:YES];
                } else if (indexPath.row == 3) {
                    // 我的预约
                    [[CommonUtils getCurrentViewController].navigationController pushViewController:[MyBaseApplyViewController new] animated:YES];
                }
            } else if (collectionView.tag == 2) {
                [self pushController:indexPath.row];
            }
        }
    }];
}

- (void)pushController:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            [[CommonUtils getCurrentViewController].navigationController pushViewController:[MyContractListViewController new] animated:YES];
            break;
        }
        case 1:
        {
            [[CommonUtils getCurrentViewController].navigationController pushViewController:[BillListViewController new] animated:YES];
            break;
        }
        case 2:
        {
            [[CommonUtils getCurrentViewController].navigationController pushViewController:[LiveChargeViewController new] animated:YES];
            break;
        }
        case 3:
        {
            [[CommonUtils getCurrentViewController].navigationController pushViewController:[LockSelectViewController new] animated:YES];
            break;
        }
        default:
            break;
    }
}

- (IBAction)editPersonalBtnClick:(id)sender
{
    [self pushPersonViewController];
}

- (void)pushPersonViewController
{
    [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
        if (performLogin) {
            [[CommonUtils getCurrentViewController].navigationController popToRootViewControllerAnimated:YES];
        } else {
            PersonInfoViewController *vc = [PersonInfoViewController new];
            [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end
