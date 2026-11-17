//
//  RmtNewsTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2024/10/25.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "RmtNewsTableViewCell.h"
#import "RmtNewsCollectionViewCell.h"
#import "RmtTitleCollectionViewCell.h"
#import "ProtocolBaseWKWebViewController.h"
#import "NewsInfoModel.h"
#import "RmtNewsViewController.h"

@implementation RmtNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _moreButton.imagePosition = QMUIButtonImagePositionRight;
    _moreButton.spacingBetweenImageAndTitle = 5;
    
    _rmtNewsCollectionView.delegate = self;
    _rmtNewsCollectionView.dataSource = self;
    [_rmtNewsCollectionView registerNib:[UINib nibWithNibName:@"RmtNewsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RmtNewsCollectionViewCell"];
    [_rmtNewsCollectionView registerNib:[UINib nibWithNibName:@"RmtTitleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RmtTitleCollectionViewCell"];
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
}

- (void)setLifeModel:(LifeModel *)lifeModel
{
    _lifeModel = lifeModel;
    _titleLab.text = NONullString(_lifeModel.name);
}

- (void)setRmtNewsList:(NSMutableArray *)rmtNewsList
{
    _rmtNewsList = rmtNewsList;
    [_rmtNewsCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _rmtNewsList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = floor(SCREEN_WIDTH - 24);
    NewsInfoModel * model = _rmtNewsList[indexPath.item];
    CGFloat itemHeight = [CommonUtils getNewsHeightWithModel:model];
    return CGSizeMake(itemWidth, itemHeight);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsInfoModel * model = _rmtNewsList[indexPath.item];
    if (IsStrEmpty(model.image_url)) {
        RmtTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RmtTitleCollectionViewCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    RmtNewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RmtNewsCollectionViewCell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsInfoModel *model = _rmtNewsList[indexPath.item];
    ProtocolBaseWKWebViewController *webVc = [[ProtocolBaseWKWebViewController alloc] init];
    webVc.webTitle = NONullString(model.title);
    webVc.webUrl = NONullString(model.file_url);
    [[CommonUtils getCurrentViewController].navigationController pushViewController:webVc animated:YES];
}

- (IBAction)moreBtnClick:(id)sender 
{
    RmtNewsViewController *vc = [RmtNewsViewController new];
    vc.titleStr = NONullString(_lifeModel.name);
    [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
