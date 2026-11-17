//
//  PlayPhoneView.m
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "PlayPhoneView.h"
#import "PlayPhoneCollectionViewCell.h"

@implementation PlayPhoneView

- (void)awakeFromNib
{
    [super awakeFromNib];

    _playPhoneCollectionView.delegate = self;
    _playPhoneCollectionView.dataSource = self;
    _phoneLayout.minimumLineSpacing = 0;
    _phoneLayout.minimumInteritemSpacing = 0;
    _phoneLayout.itemSize = CGSizeMake(SCREEN_WIDTH - 40, 50);
    [_playPhoneCollectionView registerNib:[UINib nibWithNibName:@"PlayPhoneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PlayPhoneCollectionViewCell"];
}

- (void)setPhoneArr:(NSMutableArray *)phoneArr
{
    _phoneArr = phoneArr;
    [_playPhoneCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _phoneArr.count > 3 ? 3 : _phoneArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayPhoneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayPhoneCollectionViewCell" forIndexPath:indexPath];
    cell.type = 1;
    cell.phoneInfoModel = _phoneArr[indexPath.row];
    return cell;
}

- (IBAction)backBtnClick:(id)sender
{
    SAFE_BLOCK(self.didCancelBlock);
}


@end
