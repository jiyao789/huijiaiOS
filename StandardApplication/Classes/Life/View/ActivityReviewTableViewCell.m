//
//  ActivityReviewTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2024/10/15.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "ActivityReviewTableViewCell.h"
#import "CommunityActivityDetailViewController.h"
#import "CommunityActivityListViewController.h"
#import "ActivityReviewCollectionViewCell.h"

@implementation ActivityReviewTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _moreButton.imagePosition = QMUIButtonImagePositionRight;
    _moreButton.spacingBetweenImageAndTitle = 5;
    
    _communityCollectionView.delegate = self;
    _communityCollectionView.dataSource = self;
    [_communityCollectionView registerNib:[UINib nibWithNibName:@"ActivityReviewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ActivityReviewCollectionViewCell"];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 12);
    _layout.minimumLineSpacing = 10;
    _layout.minimumInteritemSpacing = 0;
    _layout.itemSize = CGSizeMake(178, 143);
}

- (void)setLifeModel:(LifeModel *)lifeModel
{
    _lifeModel = lifeModel;
    _titleLab.text = NONullString(_lifeModel.name);
    [_communityCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _lifeModel.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityReviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityReviewCollectionViewCell" forIndexPath:indexPath];
    cell.model = _lifeModel.list[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ListModel *model = _lifeModel.list[indexPath.row];
//    if (!IsStrEmpty(model.link)) {
//        ProtocolBaseWKWebViewController *vc = [ProtocolBaseWKWebViewController new];
//        vc.webUrl = NONullString(model.link);
//        vc.webTitle = @"活动详情";
//        [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
//        return;
//    }
//
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
