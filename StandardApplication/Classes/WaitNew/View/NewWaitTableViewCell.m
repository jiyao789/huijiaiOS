//
//  NewWaitTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2023/12/9.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "NewWaitTableViewCell.h"
#import "MacroDefine.h"
#import "BasicPoinsCollectionViewCell.h"

@implementation NewWaitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _poinsCollectionView.delegate = self;
    _poinsCollectionView.dataSource = self;
    [_poinsCollectionView registerNib:[UINib nibWithNibName:@"BasicPoinsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BasicPoinsCollectionViewCell"];
}

- (void)setWaitListModel:(NewWaitProjctListModel *)waitListModel
{
    _waitListModel = waitListModel;
    [_houseImageView setImageUrl:NONullString(_waitListModel.images.firstObject) placeholderImage:defaultIconName];
    _addressLab.text = NONullString(_waitListModel.address);
    if (_waitListModel.waiting_status == 1 || _waitListModel.waiting_status == 2 || _waitListModel.waiting_status == 5) {
        _statusLab.hidden = NO;
        _statusLab.text = _waitListModel.waiting_status == 1 ? @"已参与轮候" : @"已匹配房源";
    } else {
        _statusLab.hidden = YES;
    }
    _houseNameLab.text = [NSString stringWithFormat:@"%@",NONullString(_waitListModel.name)];
    _houseInfoLab.text = [NSString stringWithFormat:@"%@㎡    |    共%@套    |    当前轮候%@人",NONullString(_waitListModel.area),@(_waitListModel.unit_count),@(_waitListModel.waiting_count)];
    _houseAmountLab.text = NONullString(_waitListModel.rentString);
    
    
    _tagsArr = _waitListModel.tags;
    [self.poinsCollectionView reloadData];
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
