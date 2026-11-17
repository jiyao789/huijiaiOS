//
//  PublicHouseClassifyView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "PublicHouseClassifyView.h"
#import "MacroDefine.h"
#import "PublicHouseClassifyCollectionViewCell.h"

@interface PublicHouseClassifyView()
@property (strong, nonatomic) NSArray *unitTypeArr;
@property (assign, nonatomic) NSInteger selectIndex;
@end

@implementation PublicHouseClassifyView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.view.frame = self.bounds;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _classifyCollectionView.delegate = self;
    _classifyCollectionView.dataSource = self;
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 30;
    _layout.itemSize = CGSizeMake((SCREEN_WIDTH - 32 - 90) / 3, 28);
    [_classifyCollectionView registerNib:[UINib nibWithNibName:@"PublicHouseClassifyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PublicHouseClassifyCollectionViewCell"];
    
    _selectIndex = -1;
    _unitTypeArr = @[@"综合",@"独栋",@"零散房源"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _unitTypeArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublicHouseClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublicHouseClassifyCollectionViewCell" forIndexPath:indexPath];
    cell.unitTypeLab.text = _unitTypeArr[indexPath.row];
    cell.unitTypeLab.backgroundColor = _selectIndex == indexPath.row ? [UIColor colorWithHexString:@"#2A629A"] : [UIColor colorWithHexString:@"#D9DADB"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    [_classifyCollectionView reloadData];

    SAFE_BLOCK(self.publicHouseClassifyViewBlock,indexPath.row);
}

@end
