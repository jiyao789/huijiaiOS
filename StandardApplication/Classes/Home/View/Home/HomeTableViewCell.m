//
//  HomeTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2024/10/21.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "HomeCollectionViewCell.h"
#import "HouseDetailViewController.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _homeCollectionView.delegate = self;
    _homeCollectionView.dataSource = self;
    [_homeCollectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    _homeLayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
    _homeLayout.minimumLineSpacing = 6;
    _homeLayout.minimumInteritemSpacing = 6;
}

- (void)setNature:(NSInteger)nature
{
    _nature = nature;
}

- (void)setHouseList:(NSMutableArray *)houseList
{
    _houseList = houseList;
    [_homeCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _houseList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = floor((SCREEN_WIDTH - 30) / 2);
    if (_nature == 3) {
        return CGSizeMake(itemWidth, 270);
    }
    HouseListModel * model = _houseList[indexPath.item];
    CGFloat itemHeight = [CommonUtils getHeightWithModel:model];
    return CGSizeMake(itemWidth, itemHeight);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    if (_nature == 3) {
        cell.bigHouseModel = _houseList[indexPath.row];
    } else {
        cell.houseModel = _houseList[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HouseDetailViewController *vc = [HouseDetailViewController new];
    if (_nature == 3) {
        BigHouseModel *bigHouseModel = _houseList[indexPath.row];
        vc.bigHouseId = NONullString(bigHouseModel.house_id);
    } else {
        HouseListModel *model = _houseList[indexPath.row];
        vc.unit_id = model.unit_id;
        dispatch_async(dispatch_queue_create("com.wdit.hzapp", DISPATCH_QUEUE_SERIAL), ^{
            [[SNFileCache defaultCache] saveDictionary:model forKey:@"House"];
        });
    }
    [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
