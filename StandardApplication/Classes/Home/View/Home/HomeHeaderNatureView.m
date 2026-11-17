//
//  HomeHeaderNatureView.m
//  StandardApplication
//
//  Created by DTiOS on 2023/8/24.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "HomeHeaderNatureView.h"
#import "MacroDefine.h"
#import "BasicPoinsCollectionViewCell.h"
#import "HouseSearchViewController.h"
#import "PublicHouseSearchViewController.h"
#import "MapSearchHouseViewController.h"
#import "LockSelectViewController.h"

@interface HomeHeaderNatureView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backBgImageView;
@property (weak, nonatomic) IBOutlet UIButton *publicHouseBtn;
@property (weak, nonatomic) IBOutlet UIButton *communityHouseBtn;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *basicPoinsCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *otherHouseBtn;

@property (strong, nonatomic) NSArray *poinsArr;
@end

@implementation HomeHeaderNatureView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.view.frame = self.bounds;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _searchType = 1;
    
    _basicPoinsCollectionView.delegate = self;
    _basicPoinsCollectionView.dataSource = self;
    [_basicPoinsCollectionView registerNib:[UINib nibWithNibName:@"BasicPoinsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BasicPoinsCollectionViewCell"];
    
    [self getBasicPoinsDate:1];
}

- (void)setIsRefreshDate:(BOOL)isRefreshDate
{
    [self getBasicPoinsDate:1];
}

- (void)setNatureIndex:(NSInteger)natureIndex
{
    _natureIndex = natureIndex;
    _searchType = _natureIndex;
    [self changeHouseButton:_natureIndex - 1];
}

- (void)setSearchString:(NSString *)searchString
{
    _searchString = searchString;
    _inputTextField.text = _searchString;
}

- (void)getBasicPoinsDate:(NSInteger)type
{
    [HttpRequest requestArrUrlPath:ReleaseBaseURL urlPath:unit_tabIndexURL parameters:@{@"type":@(type)} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            self.poinsArr = [PoinsModel mj_objectArrayWithKeyValuesArray:arr];
            [self.basicPoinsCollectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.poinsArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BasicPoinsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BasicPoinsCollectionViewCell" forIndexPath:indexPath];
    PoinsModel *poinsModel = self.poinsArr[indexPath.row];
    cell.poinsLab.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightRegular];
    cell.poinsLab.text = NONullString(poinsModel.region_name);
    if ([NONullString(poinsModel.region_name) isEqual:@"精选房源"]) {
        cell.poinsLab.backgroundColor = [UIColor colorWithHexString:@"#FFF7DC"];
        cell.poinsLab.textColor = [UIColor colorWithHexString:@"#C1A36C"];
    } else {
        cell.poinsLab.backgroundColor = [UIColor colorWithHexString:@"#E8F5FF"];
        cell.poinsLab.textColor = [UIColor colorWithHexString:@"#3376AA"];
    }
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_inputTextField resignFirstResponder];
    PoinsModel *poinsModel = self.poinsArr[indexPath.row];
    [self pushViewController:poinsModel.region_name];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PoinsModel *poinsModel = self.poinsArr[indexPath.row];
    CGSize poinsSize = [poinsModel.region_name sizeWithFont:[UIFont systemFontOfSize:12.0f weight:UIFontWeightRegular] constrainedSize:CGSizeMake(MAXFLOAT, 24)];
    return CGSizeMake(poinsSize.width + 20, 24);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (IBAction)textFieldEditChanged:(UITextField *)sender
{
    SAFE_BLOCK(self.houseTextFieldBlock,_inputTextField.text);
}

- (IBAction)houseBtnClick:(UIButton *)sender
{
    [_inputTextField resignFirstResponder];
    _searchType = sender.tag + 1;
    [self changeHouseButton:sender.tag];
    SAFE_BLOCK(self.chooseHouseNatureViewBlock,_searchType);
}

- (void)changeHouseButton:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            _backBgImageView.image = [UIImage imageNamed:@"select_one_img"];
            [_publicHouseBtn setTitleColor:[UIColor colorWithHexString:@"#070707"] forState:UIControlStateNormal];
            [_communityHouseBtn setTitleColor:[UIColor colorWithHexString:@"#64748B"] forState:UIControlStateNormal];
            [_otherHouseBtn setTitleColor:[UIColor colorWithHexString:@"#64748B"] forState:UIControlStateNormal];
            [self getBasicPoinsDate:1];
            break;
        }
        case 1:
        {
            _backBgImageView.image = [UIImage imageNamed:@"select_two_icon"];
            [_publicHouseBtn setTitleColor:[UIColor colorWithHexString:@"#64748B"] forState:UIControlStateNormal];
            [_communityHouseBtn setTitleColor:[UIColor colorWithHexString:@"#070707"] forState:UIControlStateNormal];
            [_otherHouseBtn setTitleColor:[UIColor colorWithHexString:@"#64748B"] forState:UIControlStateNormal];
            [self getBasicPoinsDate:2];
            break;
        }
        case 2:
        {
            _backBgImageView.image = [UIImage imageNamed:@"select_three_icon"];
            [_publicHouseBtn setTitleColor:[UIColor colorWithHexString:@"#64748B"] forState:UIControlStateNormal];
            [_communityHouseBtn setTitleColor:[UIColor colorWithHexString:@"#64748B"] forState:UIControlStateNormal];
            [_otherHouseBtn setTitleColor:[UIColor colorWithHexString:@"#070707"] forState:UIControlStateNormal];
            self.poinsArr = [NSArray array];
            [self.basicPoinsCollectionView reloadData];
            break;
        }
        default:
            break;
    }
}

- (IBAction)mapBtnClick:(id)sender
{
    [_inputTextField resignFirstResponder];
    KWeakSelf
    MapSearchHouseViewController *vc = [MapSearchHouseViewController new];
    vc.isNeedBlock = YES;
    vc.mapSearchHouseBlock = ^(NSString * _Nonnull name) {
        weakSelf.inputTextField.text = name;
    };
    [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
}

- (IBAction)searchHouseBtnClick:(id)sender
{
    [_inputTextField resignFirstResponder];
    [self pushViewController:_inputTextField.text];
    _inputTextField.text = @"";
}

- (void)pushViewController:(NSString *)name
{
    if (_searchType == 1) {
        PublicHouseSearchViewController *vc = [PublicHouseSearchViewController new];
        vc.keyword = name;
        [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
    } else if (_searchType == 2 || _searchType == 3) {
        HouseSearchViewController *vc = [HouseSearchViewController new];
        vc.keyword = name;
        vc.nature = _searchType;
        [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
    }
}

@end
