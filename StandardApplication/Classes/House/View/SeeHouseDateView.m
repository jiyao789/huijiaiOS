//
//  SeeHouseDateView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/24.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SeeHouseDateView.h"
#import "SeeHouseDateCollectionViewCell.h"

@interface SeeHouseDateView ()
@property (assign, nonatomic) NSInteger dateIndex;
@property (assign, nonatomic) NSInteger timeIndex;
@property (strong, nonatomic) NSString *dateStr;
@property (strong, nonatomic) NSString *timeStr;
@property (strong, nonatomic) NSArray *seeHouseTimeArr;
@property (strong, nonatomic) NSArray *seeHouseDateArr;
@end

@implementation SeeHouseDateView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _dateIndex = -1;
    _timeIndex = -1;
    _seeHouseTimeArr = @[@"09:00 - 11:00",@"11:00 - 12:00",@"12:00 - 13:00",@"13:00 - 14:00",@"14:00 - 15:00",@"15:00 - 16:00",@"16:00 - 17:00"];
    _seeHouseDateArr = [NSDate getWeekdayArrayFromDate];
    
    _dateCollectionView.delegate = self;
    _dateCollectionView.dataSource = self;
    _dateLayout.minimumLineSpacing = 5;
    _dateLayout.minimumInteritemSpacing = 0;
    _dateLayout.itemSize = CGSizeMake(42, 50);
    [_dateCollectionView registerNib:[UINib nibWithNibName:@"SeeHouseDateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SeeHouseDateCollectionViewCell"];
    
    _timeCollectionView.delegate = self;
    _timeCollectionView.dataSource = self;
    _timeLayout.minimumLineSpacing = 5;
    _timeLayout.minimumInteritemSpacing = 5;
    _timeLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 26 - 10) / 3, 34);
    [_timeCollectionView registerNib:[UINib nibWithNibName:@"SeeHouseDateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SeeHouseDateCollectionViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0) {
        SeeHouseDateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SeeHouseDateCollectionViewCell" forIndexPath:indexPath];
        NSDictionary *dic = _seeHouseDateArr[indexPath.row];
        cell.titleLab.text = dic[@"week"];
        cell.titleLab.backgroundColor = indexPath.row == _dateIndex ? [UIColor colorWithHexString:@"#2A629A"] : [UIColor colorWithHexString:@"#D9DADB"];
        return cell;
    }
    SeeHouseDateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SeeHouseDateCollectionViewCell" forIndexPath:indexPath];
    cell.titleLab.backgroundColor = indexPath.row == _timeIndex ? [UIColor colorWithHexString:@"#2A629A"] : [UIColor colorWithHexString:@"#D9DADB"];
    cell.titleLab.text = _seeHouseTimeArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0) {
        _dateIndex = indexPath.row;
        NSDictionary *dic = _seeHouseDateArr[indexPath.row];
        _dateStr = dic[@"date"];
        [_dateCollectionView reloadData];
    } else if (collectionView.tag == 1) {
        _timeIndex = indexPath.row;
        _timeStr = _seeHouseTimeArr[indexPath.row];
        [_timeCollectionView reloadData];
    }
}


- (IBAction)confirmBtnClick:(id)sender
{
    if (_dateIndex == -1) {
        [MBProgressHUD showMessag:@"请选择服务日期" toView:nil];
        return;
    }
    if (_timeIndex == -1) {
        [MBProgressHUD showMessag:@"请选择服务时间" toView:nil];
        return;
    }
    if (self.didConfirmBlock) {
        self.didConfirmBlock(NONullString(_dateStr),NONullString(_timeStr));
    }
}

@end
