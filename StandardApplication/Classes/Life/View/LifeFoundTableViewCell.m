//
//  LifeFoundTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2022/8/3.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "LifeFoundTableViewCell.h"
#import "LifeFoundCollectionViewCell.h"
#import "CommunityActivityDetailViewController.h"
#import "CommunityActivityListViewController.h"

@implementation LifeFoundTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _moreButton.imagePosition = QMUIButtonImagePositionRight;
    _moreButton.spacingBetweenImageAndTitle = 5;
    
    _lifeFoundCollectionView.delegate = self;
    _lifeFoundCollectionView.dataSource = self;
    [_lifeFoundCollectionView registerNib:[UINib nibWithNibName:@"LifeFoundCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LifeFoundCollectionViewCell"];
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 12);
    _layout.minimumLineSpacing = 10;
    _layout.minimumInteritemSpacing = 0;
    _layout.itemSize = CGSizeMake(298, 180);
}

- (void)setLifeModel:(LifeModel *)lifeModel
{
    _lifeModel = lifeModel;
    _titleLab.text = NONullString(_lifeModel.name);
    [_lifeFoundCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _lifeModel.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LifeFoundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LifeFoundCollectionViewCell" forIndexPath:indexPath];
    cell.model = _lifeModel.list[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ListModel *model = _lifeModel.list[indexPath.row];
    CommunityActivityDetailViewController *vc = [CommunityActivityDetailViewController new];
    vc.act_id = model.id;
    [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
}

- (IBAction)moreBtnClick:(id)sender
{
    CommunityActivityListViewController *vc = [CommunityActivityListViewController new];
    vc.type = _lifeModel.type;
    vc.titleStr = _lifeModel.name;
    [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
