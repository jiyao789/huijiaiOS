//
//  SearchHistoryHeaderView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/8.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SearchHistoryHeaderView.h"

@implementation SearchHistoryHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _searchCollectionView.delegate = self;
    _searchCollectionView.dataSource = self;
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
    [_searchCollectionView registerNib:[UINib nibWithNibName:@"SearchHistoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SearchHistoryCollectionViewCell"];
}

- (void)setSearchHistoryArr:(NSMutableArray *)searchHistoryArr
{
    _searchHistoryArr = searchHistoryArr;
    [self.searchCollectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _searchHistoryArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchHistoryCollectionViewCell" forIndexPath:indexPath];
    cell.historySearchLab.text = _searchHistoryArr[indexPath.section];
    KWeakSelf
    cell.removeIndexButtonBlock = ^(NSString * _Nonnull text) {
        [weakSelf removeIndexInfo:text];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SAFE_BLOCK(self.searchHistoryClickBlock,self.searchHistoryArr[indexPath.section]);
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *historyStr = _searchHistoryArr[indexPath.section];
    CGSize poinsSize = [historyStr sizeWithFont:[UIFont systemFontOfSize:13.0f weight:UIFontWeightMedium] constrainedSize:CGSizeMake(SCREEN_WIDTH - 32 - 50, 38)];
    return CGSizeMake(poinsSize.width + 50, 38);
}

- (IBAction)cleanHistoryBtnClick:(id)sender
{
    [[SNFileCache defaultCache] removeDataForKey:@"Search"];
    [_searchHistoryArr removeAllObjects];
    [_searchCollectionView reloadData];
}

- (void)removeIndexInfo:(NSString *)string
{
    NSMutableArray *array = [[SNFileCache defaultCache] removeDataForKey:string forKey:@"Search"];
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    _searchHistoryArr = [[NSMutableArray alloc]initWithArray:[enumerator allObjects]];
    [_searchCollectionView reloadData];
}

@end
