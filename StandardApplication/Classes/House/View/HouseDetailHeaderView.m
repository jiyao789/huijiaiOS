//
//  HouseDetailHeaderView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HouseDetailHeaderView.h"
#import "HouseLocationViewController.h"
#import "XHPageControl.h"
#import "KNPhotoBrowser.h"
#import "BasicPoinsCollectionViewCell.h"

@interface HouseDetailHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *poinsCollectionView;
@property (strong, nonatomic) XHPageControl *pageControl;
@end

@implementation HouseDetailHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _locationView.cornerRadiu = 20;
    
    _cycleScrollView.delegate = self;
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    _cycleScrollView.autoScroll = YES;
    _cycleScrollView.showPageControl = NO;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"default_img"];
    
    _poinsCollectionView.delegate = self;
    _poinsCollectionView.dataSource = self;
    [_poinsCollectionView registerNib:[UINib nibWithNibName:@"BasicPoinsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BasicPoinsCollectionViewCell"];
    
    KWeakSelf
    [_locationView whenTapped:^{
        HouseLocationViewController *vc = [HouseLocationViewController new];
        if (!IsNilOrNull(weakSelf.bigHouseModel)) {
            vc.addressStr = weakSelf.bigHouseModel.neighborhood_address;
            vc.projectName = weakSelf.bigHouseModel.neighborhood_name;
        } else {
            vc.regionModel = weakSelf.model.region;
        }
        [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
    }];
}

- (void)layoutSubviews
{
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 520);
}

- (void)setModel:(HouseDetailModel *)model
{
    _model = model;
    _cycleScrollView.localizationImageNamesGroup = _model.imgs;
    _cycleScrollView.showPageControl = NO;
    if (_model.imgs.count > 1) {
        self.pageControl.numberOfPages = _model.imgs.count;
    }
    
    _houseNameLab.text = [NSString stringWithFormat:@"%@%@",_model.region.name,_model.shiString];
    _houseAddressLab.text = [NSString stringWithFormat:@"%@%@%@%@%ld%@",NONullString(_model.region.province_name),NONullString(_model.region.county_name),NONullString(_model.region.town_name),NONullString(_model.region.address),(long)_model.region.number,NONullString(_model.region.choice_get_numberString)];
    float price = _model.price / 100;
    _houseAmountLab.text = [NSString stringWithFormat:@"%.2f",price];
    _houseAresLab.text = [NSString stringWithFormat:@"%.2f㎡",_model.area];
    _shiLab.text = [NSString stringWithFormat:@"%@",_model.shiString];
    _towardLab.text = NONullString(_model.towardString);
    
    [_poinsCollectionView reloadData];
}

- (void)setBigHouseModel:(BigHouseModel *)bigHouseModel
{
    _bigHouseModel = bigHouseModel;
    _cycleScrollView.localizationImageNamesGroup = _bigHouseModel.picturesArr;
    _cycleScrollView.showPageControl = NO;
    if (_bigHouseModel.picturesArr.count > 1) {
        self.pageControl.numberOfPages = _bigHouseModel.picturesArr.count;
    }
    
    _houseNameLab.text = [NSString stringWithFormat:@"%@%@",_bigHouseModel.neighborhood_name,_bigHouseModel.bedroom_num_string];
    _houseAddressLab.text = NONullString(_bigHouseModel.neighborhood_address);
    _houseAmountLab.text = [NSString stringWithFormat:@"%.2f",_bigHouseModel.price];
    _houseAresLab.text = [NSString stringWithFormat:@"%.2f㎡",_bigHouseModel.total_area];
    _shiLab.text = NONullString(_bigHouseModel.bedroom_num_string);
    _towardLab.text = NONullString(_bigHouseModel.orientation);
    
    _poinsCollectionView.hidden = YES;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    self.pageControl.currentPage = index;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSMutableArray *imageShowArr = [NSMutableArray array];
    if (!IsNilOrNull(_bigHouseModel)) {
        [imageShowArr addObjectsFromArray:_bigHouseModel.picturesArr];
    } else {
        [imageShowArr addObjectsFromArray:_model.imgs];
    }
    NSMutableArray *datas = [NSMutableArray array];
    for (NSString *imageUrlStr in imageShowArr) {
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        items.sourceView = cycleScrollView;
        items.url = imageUrlStr;
        [datas addObject:items];
    }
    if (datas.count == 0) {
        return;
    }
    KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
    photoBrowser.itemsArr = datas;
//    photoBrowser.isNeedPageControl = true; // if it has video to play , I do not suggest you to use PageControl
    photoBrowser.isNeedPageNumView = true;
//    photoBrowser.isNeedRightTopBtn = true;
    photoBrowser.isNeedPrefetch = true;
    photoBrowser.isNeedPanGesture = true;
    photoBrowser.isNeedAutoPlay = true;
    photoBrowser.currentIndex = index;
    [photoBrowser present];
}

- (XHPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[XHPageControl alloc] initWithFrame:CGRectMake(0, 270 , SCREEN_WIDTH, 12)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentMultiple = 1;
        _pageControl.otherColor = [UIColor whiteColor];
        _pageControl.currentColor = [UIColor colorWithHexString:@"#2A629A"];
        [self.cycleScrollView addSubview:_pageControl];
    }
    return _pageControl;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _model.point.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BasicPoinsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BasicPoinsCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic = _model.point[indexPath.row];
    cell.poinsLab.font = [UIFont systemFontOfSize:10.0f weight:UIFontWeightRegular];
    cell.poinsLab.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
    if ([NONullString([dic valueForKey:@"name"]) isEqual:@"精选房源"]) {
        cell.poinsLab.backgroundColor = [UIColor colorWithHexString:@"#FFF7DC"];
        cell.poinsLab.textColor = [UIColor colorWithHexString:@"#C1A36C"];
    } else {
        cell.poinsLab.backgroundColor = [UIColor colorWithHexString:@"#E8F5FF"];
        cell.poinsLab.textColor = [UIColor colorWithHexString:@"#3376AA"];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _model.point[indexPath.row];
    CGSize poinsSize = [dic[@"name"] sizeWithFont:[UIFont systemFontOfSize:10.0f weight:UIFontWeightRegular] constrainedSize:CGSizeMake(MAXFLOAT, 18)];
    return CGSizeMake(poinsSize.width + 20, 18);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

@end
