//
//  HomeCollectionViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2024/10/21.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "BasicPoinsCollectionViewCell.h"

@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _poinsCollectionView.delegate = self;
    _poinsCollectionView.dataSource = self;
    [_poinsCollectionView registerNib:[UINib nibWithNibName:@"BasicPoinsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BasicPoinsCollectionViewCell"];
}

- (void)setHouseModel:(HouseListModel *)houseModel
{
    _houseModel = houseModel;
    [_houseImageView setImageUrl:NONullString(_houseModel.imgs) placeholderImage:defaultIconName];
    _houseNameLab.text = [NSString stringWithFormat:@"%@%@",NONullString(_houseModel.region_name),NONullString(_houseModel.shiString)];
    _houseTypeImageView.image = [UIImage imageNamed:_houseModel.nature == 1 ? @"house_gong_icon" : @"house_she_icon"];
    _houseInfoLab.text = [NSString stringWithFormat:@"%.2f㎡    |    %@    |    %@",_houseModel.area,NONullString(_houseModel.shiString),NONullString(_houseModel.towardString)];
    float price = _houseModel.price / 100;
    _houseAmountLab.text = [NSString stringWithFormat:@"%.2f",price];
    
    _poinsArr = _houseModel.point;
    [self.poinsCollectionView reloadData];

}

- (void)setBigHouseModel:(BigHouseModel *)bigHouseModel
{
    _bigHouseModel = bigHouseModel;
    _houseTypeImageView.hidden = YES;
    [_houseImageView setImageUrl:NONullString(_bigHouseModel.main_img) placeholderImage:defaultIconName];
    _houseNameLab.text = [NSString stringWithFormat:@"%@%@",NONullString(_bigHouseModel.neighborhood_name),NONullString(_bigHouseModel.bedroom_num_string)];
    _houseInfoLab.text = [NSString stringWithFormat:@"%.2f㎡    |    %@",_bigHouseModel.total_area,NONullString(_bigHouseModel.bedroom_num_string)];
    _houseAmountLab.text = [NSString stringWithFormat:@"%.2f",_bigHouseModel.price];
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
    cell.poinsLab.font = [UIFont systemFontOfSize:10.0f weight:UIFontWeightRegular];
    cell.poinsLab.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
    if ([NONullString([dic valueForKey:@"name"]) isEqual:@"精选房源"]) {
        cell.poinsLab.backgroundColor = [UIColor colorWithHexString:@"#FFF7DC"];
        cell.poinsLab.textColor = [UIColor colorWithHexString:@"#C1A36C"];
    } else {
        cell.poinsLab.backgroundColor = [UIColor colorWithHexString:@"#E8F5FF"];
        cell.poinsLab.textColor = [UIColor colorWithHexString:@"#3376AA"];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _poinsArr[indexPath.row];
    CGSize poinsSize = [dic[@"name"] sizeWithFont:[UIFont systemFontOfSize:10.0f weight:UIFontWeightRegular] constrainedSize:CGSizeMake(MAXFLOAT, 18)];
    return CGSizeMake(poinsSize.width + 20, 18);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

@end
