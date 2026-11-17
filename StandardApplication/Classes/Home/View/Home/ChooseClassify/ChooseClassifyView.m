//
//  ChooseClassifyView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/19.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ChooseClassifyView.h"
#import "MacroDefine.h"
#import "ClassifyCollectionViewCell.h"
#import "ChooseLocationView.h"
#import "ChooseHouseRentView.h"
#import "ChooseMoreView.h"
#import "CountyTownModel.h"

@interface ChooseClassifyView()
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutRight;
@property (strong, nonatomic) NSArray *nameArr;
@property (assign, nonatomic) NSInteger selectIndex;
@property (strong, nonatomic) ChooseLocationView *chooseLocationView;
@property (strong, nonatomic) ChooseHouseRentView *chooseHouseRentView;
@property (strong, nonatomic) ChooseMoreView *chooseMoreView;
@property (strong, nonatomic) NSArray *pointMoreArr;

@property (strong, nonatomic) NSMutableDictionary *unitFilterDic;
@property (strong, nonatomic) NSString *county_id;
@property (strong, nonatomic) NSString *town_id;
@property (strong, nonatomic) NSString *shi;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *points;
@property (assign, nonatomic) NSInteger nature;
@property (assign, nonatomic) NSInteger recodeShowHeight; // 方便点击同一个能展开收起
@end

@implementation ChooseClassifyView

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
    
    _selectIndex = -1;
    _county_id = @"";
    _town_id = @"";
    _shi = @"";
    _price = @"";
    _points = @"";
    _nature = 0;
    
    [self getUnitFilterDate];
    
    [self getWaitQueueNameDate];
}

- (void)setNeedNewLayoutHouseType:(NSInteger)needNewLayoutHouseType
{
    _needNewLayoutHouseType = needNewLayoutHouseType;
    if (_needNewLayoutHouseType == 1 || _needNewLayoutHouseType == 2) {
        _viewLayoutTop.constant = 0;
        _viewLayoutLeft.constant = _needNewLayoutHouseType == 2 ? 10 : 0;
        _viewLayoutRight.constant = 0;
        _viewLayoutBottom.constant = 0;
    }
}

- (void)setIsHouseType:(NSInteger)isHouseType
{
    _isHouseType = isHouseType;
    if (_isHouseType == 1) {
        _nameArr = @[@"位置",@"房型",@"租金",@"性质",@"更多"];
    } else if (_isHouseType == 2) {
        _nameArr = @[@"位置",@"房型",@"租金",@"更多"];
    } else if (_isHouseType == 3) {
        _nameArr = @[@"租金",@"户型"];
    }
    
    _classifyCollectionView.delegate = self;
    _classifyCollectionView.dataSource = self;
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
    _layout.itemSize = CGSizeMake((SCREEN_WIDTH - 24) / _nameArr.count, 40);
    [_classifyCollectionView registerNib:[UINib nibWithNibName:@"ClassifyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ClassifyCollectionViewCell"];
}

- (void)getUnitFilterDate
{
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:unit_filterJsonURL parameters:@{} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            if (_isHouseType != 3) {
                self.chooseHouseRentView.shiArr = dic[@"shi"];
            }
            self.chooseHouseRentView.priceDic = dic[@"price"];
            self.chooseHouseRentView.natureArr = @[@"全部",@"公租房",@"社租房"];
            self.pointMoreArr = [PointMoreModel mj_objectArrayWithKeyValuesArray:dic[@"point"]];
            self.chooseMoreView.pointArr = self.pointMoreArr;
        }
    }];
}

- (void)getWaitQueueNameDate
{
    [HttpRequest requestArrUrlPath:BaseURL urlPath:cityWaiting_queue_queueNameURL parameters:@{} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            if (_isHouseType == 3) {
                NSMutableArray *waitArr = [NSMutableArray array];
                for (NSString *name in arr) {
                    [waitArr addObject:@{@"key":name,@"val":name}];
                }
                self.chooseHouseRentView.shiArr = waitArr;
            }
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _nameArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClassifyCollectionViewCell" forIndexPath:indexPath];
    cell.nameLab.text = NONullString(_nameArr[indexPath.row]);
    NSString *nameColor = _selectIndex == indexPath.row ? @"#2A629A" : @"#999999";
    NSString *nameImage = _selectIndex == indexPath.row ? @"classify_select_img" : @"classify_unselect_img";
    cell.nameLab.textColor = [UIColor colorWithHexString:nameColor];
    cell.nameImageView.image = [UIImage imageNamed:nameImage];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex == indexPath.row && _recodeShowHeight == 262) {
        [self changeView:YES height:0];
        _recodeShowHeight = 0;
        if (self.unitFilterDic.allKeys.count == 0) {
            [self resetSelectInfo];
        }
        return;
    }
    _selectIndex = indexPath.row;
    [self.classifyCollectionView reloadData];
    _recodeShowHeight = 262;
    [self changeView:NO height:262];
    switch (indexPath.row) {
        case 0:
        {
            if (_isHouseType == 3) {
                [_chooseMoreView removeFromSuperview];
                [_chooseLocationView removeFromSuperview];
                self.chooseHouseRentView.selectIndex = indexPath.row + 2;
                [_chooseView addSubview:self.chooseHouseRentView];
            } else {
                [_chooseMoreView removeFromSuperview];
                [_chooseHouseRentView removeFromSuperview];
                [_chooseView addSubview:self.chooseLocationView];
            }
            break;
        }
        case 1:
        {
            if (_isHouseType == 3) {
                [_chooseMoreView removeFromSuperview];
                [_chooseLocationView removeFromSuperview];
                self.chooseHouseRentView.selectIndex = indexPath.row;
                [_chooseView addSubview:self.chooseHouseRentView];
            } else {
                [_chooseMoreView removeFromSuperview];
                [_chooseLocationView removeFromSuperview];
                self.chooseHouseRentView.selectIndex = indexPath.row;
                [_chooseView addSubview:self.chooseHouseRentView];
            }
            break;
        }
        case 2:
        {
            [_chooseMoreView removeFromSuperview];
            [_chooseLocationView removeFromSuperview];
            self.chooseHouseRentView.selectIndex = indexPath.row;
            [_chooseView addSubview:self.chooseHouseRentView];
            break;
        }
        case 3:
        {
            if (_isHouseType == 1) {
                [_chooseMoreView removeFromSuperview];
                [_chooseLocationView removeFromSuperview];
                self.chooseHouseRentView.selectIndex = indexPath.row;
                [_chooseView addSubview:self.chooseHouseRentView];
            } else if (_isHouseType == 2) {
                [_chooseHouseRentView removeFromSuperview];
                [_chooseLocationView removeFromSuperview];
                [_chooseView addSubview:self.chooseMoreView];
            }
            break;
        }
        case 4:
        {
            [_chooseHouseRentView removeFromSuperview];
            [_chooseLocationView removeFromSuperview];
            [_chooseView addSubview:self.chooseMoreView];
            break;
        }
        default:
            break;
    }
}

- (void)setNeedResetSelect:(BOOL)needResetSelect
{
    _needResetSelect = needResetSelect;
    if (_needResetSelect) {
        [self resetSelectInfo];
    }
    [self.unitFilterDic removeAllObjects];
}

- (IBAction)resetBtnClick:(id)sender
{
    [self resetSelectInfo];
    
    [self.unitFilterDic removeAllObjects];
    SAFE_BLOCK(self.chooseClassifyViewFilterBlock,self.unitFilterDic);
}

- (void)resetSelectInfo
{
    [self changeView:YES height:0];
    _recodeShowHeight = 0;
    self.chooseLocationView.selectReset = -1;
    [self.chooseHouseRentView.selectShiArr removeAllObjects];
    [self.chooseHouseRentView.selectShiArr addObject:@"不限"];
    [self.chooseHouseRentView.selectPriceArr removeAllObjects];
    [self.chooseHouseRentView.selectPriceArr addObject:@"不限"];
    [self.chooseHouseRentView.selectShiKeyArr removeAllObjects];
    self.chooseHouseRentView.selectNatureIndex = 0;
    self.chooseMoreView.selectReset = -1;
    _selectIndex = -1;
    _county_id = @"";
    _town_id = @"";
    _shi = @"";
    _price = @"";
    _points = @"";
    _nature = 0;
}

- (IBAction)commitBtnClick:(id)sender
{
    [self changeView:YES height:0];
    _recodeShowHeight = 0;
    [self.unitFilterDic removeAllObjects];
    
    if (!IsStrEmpty(self.county_id)) {
        [self.unitFilterDic setObject:NONullString(self.county_id) forKey:@"county_ids"];
    }
    if (!IsStrEmpty(self.town_id)) {
        [self.unitFilterDic setObject:NONullString(self.town_id) forKey:@"town_ids"];
    }
    if (!IsStrEmpty(self.price)) {
        if (_isHouseType == 3) {
            NSArray *priceArr = [self.price mj_JSONObject];
            NSMutableArray *priceWaitArr = [NSMutableArray array];
            for (NSArray *arr in priceArr) {
                if (arr.count > 1) {
                    [priceWaitArr addObject:@{@"min":arr[0],@"max":arr[1]}];
                }
            }
            [self.unitFilterDic setObject:NONullString([priceWaitArr mj_JSONString]) forKey:@"rent"];
        } else {
            [self.unitFilterDic setObject:NONullString(self.price) forKey:@"multiple_price"];
        }
    }
    if (!IsStrEmpty(self.points)) {
        [self.unitFilterDic setObject:NONullString(self.points) forKey:@"points"];
    }
    if (!IsStrEmpty(self.shi)) {
        if (_isHouseType == 3) {
            [self.unitFilterDic setObject:NONullString(self.shi) forKey:@"queue_name"];
        } else {
            [self.unitFilterDic setObject:NONullString(self.shi) forKey:@"shi_multiple"];
        }
    }
    if (_nature > 0) {
        [self.unitFilterDic setObject:@(self.nature) forKey:@"nature"];
    }
    SAFE_BLOCK(self.chooseClassifyViewFilterBlock,self.unitFilterDic);
}

- (void)changeView:(BOOL)change height:(NSInteger)height
{
    _chooseView.hidden = change;
    _bottomView.hidden = change;
    // 初始化 0，点击筛选 262，点击确定重置 0
    SAFE_BLOCK(self.ChooseClassifyViewBlock,height);
}

- (ChooseLocationView *)chooseLocationView
{
    if (!_chooseLocationView) {
        _chooseLocationView = [ChooseLocationView viewFromXib];
        _chooseLocationView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 32, 209);
        KWeakSelf
        _chooseLocationView.chooseLocationViewBlock = ^(NSString * _Nonnull county_id, NSString * _Nonnull town_id, NSString * _Nonnull name) {
            weakSelf.county_id = county_id;
            weakSelf.town_id = town_id;
        };
    }
    return _chooseLocationView;
}

- (ChooseHouseRentView *)chooseHouseRentView
{
    if (!_chooseHouseRentView) {
        _chooseHouseRentView = [ChooseHouseRentView viewFromXib];
        _chooseHouseRentView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 32, 209);
        KWeakSelf
        _chooseHouseRentView.chooseHouseShiViewBlock = ^(NSString * _Nonnull shi) {
            weakSelf.shi = shi;
        };
        _chooseHouseRentView.chooseHousePriceViewBlock = ^(NSString * _Nonnull price) {
            weakSelf.price = price;
        };
        _chooseHouseRentView.chooseHouseNatureViewBlock = ^(NSInteger nature) {
            weakSelf.nature = nature;
        };
    }
    return _chooseHouseRentView;
}

- (ChooseMoreView *)chooseMoreView
{
    if (!_chooseMoreView) {
        _chooseMoreView = [ChooseMoreView viewFromXib];
        _chooseMoreView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 32, 209);
        KWeakSelf
        _chooseMoreView.chooseMoreViewBlock = ^(NSString * _Nonnull points) {
            weakSelf.points = points;
        };
    }
    return _chooseMoreView;
}

- (NSMutableDictionary *)unitFilterDic
{
    if (!_unitFilterDic) {
        _unitFilterDic = [NSMutableDictionary dictionary];
    }
    return _unitFilterDic;
}

@end
