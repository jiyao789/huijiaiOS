//
//  WaitProductTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2023/12/9.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "WaitProductTableViewCell.h"
#import "BasicPoinsCollectionViewCell.h"
#import "HouseLocationViewController.h"

@implementation WaitProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _poinsCollectionView.delegate = self;
    _poinsCollectionView.dataSource = self;
    [_poinsCollectionView registerNib:[UINib nibWithNibName:@"BasicPoinsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BasicPoinsCollectionViewCell"];
    
    _mobileButton.imagePosition = QMUIButtonImagePositionRight;
    [_mobileButton setImage:[UIImage imageNamed:@"wait_call_phone_icon"] forState:UIControlStateNormal];
    _mobileButton.spacingBetweenImageAndTitle = 10;
}

- (IBAction)mapBtnClick:(id)sender
{
    HouseLocationViewController *vc = [HouseLocationViewController new];
    vc.addressStr = NONullString(_model.address);
    vc.projectName = NONullString(_model.name);
    [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
}

- (void)setModel:(NewWaitProjctListModel *)model
{
    _model = model;
    _houseNameLab.text = NONullString(_model.name);
    _houseAmountLab.text = NONullString(_model.rentString);
    _aresLab.text = [NSString stringWithFormat:@"%@㎡  |  共%ld套", NONullString(_model.area),(long)_model.unit_count];
    
    _productNameLab.text = NONullString(_model.name);
    _addressLab.text = NONullString(_model.address);
    [_mobileButton setTitle:NONullString(_model.phone) forState:UIControlStateNormal];
    _productInfoLab.text = NONullString(_model.desc);
    
    _tagsArr = _model.tags;
    [self.poinsCollectionView reloadData];
}

- (IBAction)mobileButtonClick:(id)sender
{
    if (IsStrEmpty(_model.phone)) {
        return;
    }
    NSString * phone = [NSString stringWithFormat:@"telprompt://%@",_model.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:nil];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tagsArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BasicPoinsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BasicPoinsCollectionViewCell" forIndexPath:indexPath];
    NSString *tagStr = _tagsArr[indexPath.row];
    cell.poinsLab.font = [UIFont systemFontOfSize:8.0f weight:UIFontWeightMedium];
    cell.poinsLab.text = NONullString(tagStr);
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tagStr = _tagsArr[indexPath.row];
    CGSize poinsSize = [NONullString(tagStr) sizeWithFont:[UIFont systemFontOfSize:8.0f weight:UIFontWeightMedium] constrainedSize:CGSizeMake(MAXFLOAT, 15)];
    return CGSizeMake(poinsSize.width + 20, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
