//
//  HouseDetailConfigTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HouseDetailConfigTableViewCell.h"
#import "MacroDefine.h"
#import "HouseConfigCollectionViewCell.h"

@implementation HouseDetailConfigTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _houseConfigCollectionView.delegate = self;
    _houseConfigCollectionView.dataSource = self;
    _layout.minimumLineSpacing = 10;
    _layout.minimumInteritemSpacing = 0;
    _layout.itemSize = CGSizeMake((SCREEN_WIDTH - 34) / 5, 70);
    [_houseConfigCollectionView registerNib:[UINib nibWithNibName:@"HouseConfigCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HouseConfigCollectionViewCell"];
}

- (void)setFurnitureArr:(NSArray *)furnitureArr
{
    _furnitureArr = furnitureArr;
    [_houseConfigCollectionView reloadData];
}

- (void)setFacilities:(NSString *)facilities
{
    _facilities = facilities;
    NSArray *components = [_facilities componentsSeparatedByString:@"|"];
    for (NSString *tagStr in components) {
        NSDictionary *tagDic = [NSDictionary dictionary];
        switch ([tagStr integerValue]) {
            case 0:
                tagDic = @{@"name":@"冰箱"};
                break;
            case 1:
                tagDic = @{@"name":@"空调"};
                break;
            case 2:
                tagDic = @{@"name":@"洗衣机"};
                break;
            case 3:
                tagDic = @{@"name":@"热水器"};
                break;
            case 4:
                tagDic = @{@"name":@"宽带"};
                break;
            case 5:
                tagDic = @{@"name":@"电视"};
                break;
            case 6:
                tagDic = @{@"name":@"床"};
                break;
            case 7:
                tagDic = @{@"name":@"衣柜"};
                break;
                
            default:
                break;
        }
        [self.facilitiesArr addObject:tagDic];
    }
    [_houseConfigCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return !IsStrEmpty(_facilities) ? _facilitiesArr.count : _furnitureArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HouseConfigCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HouseConfigCollectionViewCell" forIndexPath:indexPath];
    cell.pointDic = !IsStrEmpty(_facilities) ? _facilitiesArr[indexPath.row] : _furnitureArr[indexPath.row];
    return cell;
}

- (NSMutableArray *)facilitiesArr
{
    if (!_facilitiesArr) {
        _facilitiesArr = [NSMutableArray array];
    }
    return _facilitiesArr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
