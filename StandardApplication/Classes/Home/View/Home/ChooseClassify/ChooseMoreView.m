//
//  ChooseMoreView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/20.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ChooseMoreView.h"
#import "MacroDefine.h"
#import "ChooseMoreCollectionViewCell.h"
#import "CountyTownModel.h"

@interface ChooseMoreView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *chooseMoreCollectionView;

@property (strong, nonatomic) NSMutableArray *selectKeyArr;
@end

@implementation ChooseMoreView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _chooseMoreCollectionView.delegate = self;
    _chooseMoreCollectionView.dataSource = self;
    _layout.minimumLineSpacing = 10;
    _layout.minimumInteritemSpacing = 15;
    _layout.itemSize = CGSizeMake((SCREEN_WIDTH - 32 - 40 - 30) / 3, 28);
    [_chooseMoreCollectionView registerNib:[UINib nibWithNibName:@"ChooseMoreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ChooseMoreCollectionViewCell"];
}

- (void)setSelectReset:(NSInteger)selectReset
{
    for (PointMoreModel *model in _pointArr) {
        if (model.select) {
            model.select = NO;
        }
    }
    [self.selectKeyArr removeAllObjects];
    [_chooseMoreCollectionView reloadData];
}

- (void)setPointArr:(NSArray *)pointArr
{
    _pointArr = pointArr;
    [_chooseMoreCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _pointArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseMoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseMoreCollectionViewCell" forIndexPath:indexPath];
    PointMoreModel *model = _pointArr[indexPath.row];
    cell.chooseMoreTitleLab.text = NONullString(model.val);
    cell.chooseMoreTitleLab.backgroundColor = model.select ? [UIColor colorWithHexString:@"#2A629A"] : [UIColor clearColor];
    cell.chooseMoreTitleLab.textColor = model.select ? [UIColor whiteColor] : [UIColor colorWithHexString:@"#717071"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PointMoreModel *model = _pointArr[indexPath.row];
    BOOL isHave = NO;
    for (NSString *key in self.selectKeyArr) {
        if ([key integerValue] == model.key) {
            isHave = YES;
            break;
        }
    }
    if (isHave) {
        model.select = NO;
        [self.selectKeyArr removeObject:[NSString stringWithFormat:@"%ld",(long)model.key]];
    } else {
        model.select = YES;
        [self.selectKeyArr addObject:[NSString stringWithFormat:@"%ld",(long)model.key]];
    }
    [_chooseMoreCollectionView reloadData];

    SAFE_BLOCK(self.chooseMoreViewBlock,[self.selectKeyArr mj_JSONString]);
}

- (NSMutableArray *)selectKeyArr
{
    if (!_selectKeyArr) {
        _selectKeyArr = [NSMutableArray array];
    }
    return _selectKeyArr;
}
@end
