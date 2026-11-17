//
//  HomeHouseTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/19.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HomeHouseTableViewCell.h"
#import "MacroDefine.h"

@implementation HomeHouseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _poinsCollectionView.delegate = self;
    _poinsCollectionView.dataSource = self;
    [_poinsCollectionView registerNib:[UINib nibWithNibName:@"BasicPoinsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BasicPoinsCollectionViewCell"];
}

- (void)setBigHouseModel:(BigHouseModel *)bigHouseModel
{
    _bigHouseModel = bigHouseModel;
    _houseTypeImageView.hidden = YES;
    _bookLab.hidden = YES;
    [_houseImageView setImageUrl:NONullString(_bigHouseModel.main_img) placeholderImage:defaultIconName];
    _houseNameLab.text = [NSString stringWithFormat:@"%@%@",NONullString(_bigHouseModel.neighborhood_name),NONullString(_bigHouseModel.bedroom_num_string)];
    _houseInfoLab.text = [NSString stringWithFormat:@"%.2f㎡    |    %@",_bigHouseModel.total_area,NONullString(_bigHouseModel.bedroom_num_string)];
    _houseAmountLab.text = [NSString stringWithFormat:@"%.2f",_bigHouseModel.price];
}

- (void)setHouseModel:(HouseListModel *)houseModel
{
    _houseModel = houseModel;
    _bookLab.hidden = !_houseModel.book;
    [_houseImageView setImageUrl:NONullString(_houseModel.imgs) placeholderImage:defaultIconName];
    _houseNameLab.text = [NSString stringWithFormat:@"%@%@",NONullString(_houseModel.region_name),NONullString(_houseModel.shiString)];
    _houseTypeImageView.image = [UIImage imageNamed:_houseModel.nature == 1 ? @"house_gong_icon" : @"house_she_icon"];
    _houseInfoLab.text = [NSString stringWithFormat:@"%.2f㎡    |    %@    |    %@",_houseModel.area,NONullString(_houseModel.shiString),NONullString(_houseModel.towardString)];
    float price = _houseModel.price / 100;
    _houseAmountLab.text = [NSString stringWithFormat:@"%.2f",price];
    
//    KWeakSelf
//    [RACObserve(_houseModel, collect) subscribeNext:^(id x) {
//        KStrongSelf(weakSelf)
//        NSString *imageName = strongSelf.houseModel.collect == 0 ? @"house_collection_unselect_img" : @"house_collection_select_img";
//        [strongSelf.collectionButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    }];
    
    _poinsArr = _houseModel.point;
    [self.poinsCollectionView reloadData];
}

- (void)setHouseDetailModel:(HouseDetailModel *)houseDetailModel
{
    _houseDetailModel = houseDetailModel;
    _bookLab.hidden = YES;
    if (_houseDetailModel.imgs.count > 0) {
        [_houseImageView setImageUrl:_houseDetailModel.imgs[0] placeholderImage:defaultIconName];
    }
    _houseNameLab.text = [NSString stringWithFormat:@"%@%@",NONullString(_houseDetailModel.region.name),NONullString(_houseDetailModel.shiString)];
    _houseTypeImageView.image = [UIImage imageNamed:_houseDetailModel.nature == 1 ? @"house_gong_icon" : @"house_she_icon"];
    _houseInfoLab.text = [NSString stringWithFormat:@"%.2f㎡    |    %@    |    %@",_houseDetailModel.area,NONullString(_houseDetailModel.shiString),NONullString(_houseDetailModel.towardString)];
    
    float price = _houseDetailModel.price / 100;
    if (_isNotHouseDetail) {
        _houseAmountLab.text = [NSString stringWithFormat:@"%.2f", price];
    } else {
        _houseAmountLab.text = [NSString stringWithFormat:@"%.2f", price];
    }
    
    _poinsArr = _houseDetailModel.point;
    [self.poinsCollectionView reloadData];
}

- (void)setIsWaitHouse:(BOOL)isWaitHouse
{
    _isWaitHouse = isWaitHouse;
}

- (void)setUnitModel:(UnitModel *)unitModel
{
    _unitModel = unitModel;
    _bookLab.hidden = YES;
    [_houseImageView setImageUrl:_unitModel.imgs placeholderImage:defaultIconName];
    _houseNameLab.text = [NSString stringWithFormat:@"%@%@",NONullString(_unitModel.region_name),NONullString(_unitModel.shiString)];
    if (_isWaitHouse) {
        _houseTypeImageView.hidden = YES;
    } else {
        _houseTypeImageView.hidden = NO;
        _houseTypeImageView.image = [UIImage imageNamed:_unitModel.nature == 1 ? @"house_gong_icon" : @"house_she_icon"];
    }
    _houseInfoLab.text = [NSString stringWithFormat:@"%.2f㎡    |    %@    |    %@",_unitModel.area,NONullString(_unitModel.shiString),NONullString(_unitModel.towardString)];
    float price = _unitModel.price / 100;
    _houseAmountLab.text = [NSString stringWithFormat:@"%.2f", price];
    
    _poinsArr = _unitModel.point;
    [self.poinsCollectionView reloadData];
}

- (void)setReatRenewReatModel:(ReatRenewReatModel *)reatRenewReatModel
{
    _reatRenewReatModel = reatRenewReatModel;
    _bookLab.hidden = YES;
    if (reatRenewReatModel.org_info.image_url_arr.count > 0) {
        [_houseImageView setImageUrl:_reatRenewReatModel.org_info.image_url_arr.firstObject placeholderImage:defaultIconName];
    }
    _houseNameLab.text = [NSString stringWithFormat:@"%@%@",NONullString(_reatRenewReatModel.org_info.name),NONullString(_reatRenewReatModel.org_info.room_type_string)];
    _houseTypeImageView.image = [UIImage imageNamed:_reatRenewReatModel.org_info.nature == 1 ? @"house_gong_icon" : @"house_she_icon"];
    _houseInfoLab.text = [NSString stringWithFormat:@"%.2f㎡    |    %@    |    %@",_reatRenewReatModel.org_info.area,NONullString(_reatRenewReatModel.org_info.room_type_string),NONullString(_reatRenewReatModel.org_info.towardString)];
    float price = _reatRenewReatModel.org_info.price / 100;
    _houseAmountLab.text = [NSString stringWithFormat:@"%.2f", price];
    
    _poinsArr = _reatRenewReatModel.org_info.point;
    [self.poinsCollectionView reloadData];
}

- (IBAction)collectionButtonClick:(id)sender
{
//    KWeakSelf
//    [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
//        if (!performLogin) {
//            [weakSelf collectionInfo];
//        }
//    }];
}

//- (void)collectionInfo
//{
//    [MBProgressHUD showStatus:nil toView:nil];
//    NSString *urlStr = @"";
//    NSInteger unit_id = 0;
//    if (!IsNilOrNull(_houseModel)) {
//        urlStr = _houseModel.collect ? unit_cancelcollectURL : unit_collectURL;
//        unit_id = _houseModel.unit_id;
//    } else if (!IsNilOrNull(_unitModel)) {
//        urlStr = unit_cancelcollectURL;
//        unit_id = _unitModel.unit_id;
//    }
//    [HttpRequest requestUrlPath:BaseURL urlPath:urlStr parameters:@{@"unit_id":@(unit_id)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
//        [MBProgressHUD dismissWithView:nil];
//        if (status == 1 || status == 2) {
//            if (!IsNilOrNull(_houseModel)) {
//                self.houseModel.collect = !self.houseModel.collect;
//                NSString *imageStr = self.houseModel.collect ? @"house_collection_select_img" : @"house_collection_unselect_img";
//                [self.collectionButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
//                
//                SAFE_BLOCK(self.houseIsCollectBlock,self.houseModel.collect);
//            } else if (!IsNilOrNull(_unitModel)) {
//                SAFE_BLOCK(self.houseIsCollectBlock,0);
//            }
//        } else if (status == 403) {
//            [MBProgressHUD showMessag:msg toView:nil];
//        }
//    }];
//}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _poinsArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BasicPoinsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BasicPoinsCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic = _poinsArr[indexPath.row];
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
    NSDictionary *dic = _poinsArr[indexPath.row];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
