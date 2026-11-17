//
//  HouseSearchViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HouseSearchViewController.h"
#import "MacroDefine.h"
#import "HouseSearchNaviView.h"
#import "ChooseClassifyView.h"
#import "HomeHouseTableViewCell.h"
#import "HouseDetailViewController.h"
#import "BigHouseModel.h"

@interface HouseSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)HouseSearchNaviView *houseSearchNaviView;
@property (weak, nonatomic) IBOutlet ChooseClassifyView *chooseClassifyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseViewLayoutHeight;
@property (weak, nonatomic) IBOutlet UITableView *houseSearchTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseViewLayoutTop;

@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *houseListArr;
@property (strong, nonatomic) NSMutableDictionary *unitFilterDic;
@property (strong, nonatomic) NSString *recodeTokenStr;
@end
// 社租房
@implementation HouseSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.houseSearchNaviView.searchTitleLab.text = _nature == 3 ? @"大房鸭" : @"社租房";
    self.houseSearchNaviView.nature = _nature;
    [self.gk_navigationBar addSubview:self.houseSearchNaviView];
    _chooseViewLayoutTop.constant = NAVBAR_HEIGHT;
    _recodeTokenStr = [User shareUser].token;
    
    [self setupRefreshWithTableView:_houseSearchTableView];
    
    KWeakSelf
    _chooseClassifyView.isHouseType = 2;
    _chooseClassifyView.ChooseClassifyViewBlock = ^(NSInteger height) {
        weakSelf.chooseViewLayoutHeight.constant = 60 + height;
    };
    _chooseClassifyView.chooseClassifyViewFilterBlock = ^(NSMutableDictionary * _Nullable unitFilterDic) {
        weakSelf.unitFilterDic = unitFilterDic;
        weakSelf.pageIndex = 1;
        weakSelf.keyword = @"";
        weakSelf.pointsIdJsonStr = @"";
        [weakSelf getUnitIndexDate];
    };
    if (_nature == 3) {
        _pageIndex = 1;
        [self getBigHouseSearchListData];
    } else {
        _pageIndex = 1;
        [self getUnitIndexDate];
    }
}

- (void)getUnitIndexDate
{
    if (_nature == 3) {
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(_pageIndex) forKey:@"page"];
    [para setObject:@(10) forKey:@"page_rows"];
    [para setObject:@(2) forKey:@"nature"];   //1:公租房 2:社租房
    [para setObject:NONullString([User shareUser].getUserId) forKey:@"u_id"];
    if (!IsStrEmpty(_keyword)) {
        [para setObject:_keyword forKey:@"region_name"];
    }
    if (!IsStrEmpty(_pointsIdJsonStr)) {
        [para setObject:_pointsIdJsonStr forKey:@"points"];
    }
    if (_unitFilterDic) {
        [para addEntriesFromDictionary:_unitFilterDic];
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:unit_indexURL parameters:para type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:self.view];
        if (status == 1) {
            if (_pageIndex == 1 && self.houseListArr.count > 0) {
                [self.houseListArr removeAllObjects];
            }
            NSArray *listArr = dic[@"list"];
            [self.houseListArr addObjectsFromArray:[HouseListModel mj_objectArrayWithKeyValuesArray:listArr]];
            if (listArr.count < 10) {
                [self.houseSearchTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.houseSearchTableView.mj_footer endRefreshing];
            }
            if (self.houseListArr.count == 0) {
                [self.houseSearchTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.houseSearchTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

// 大房鸭
- (void)getBigHouseSearchListData
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(_pageIndex) forKey:@"page"];
    [para setObject:@(10) forKey:@"page_rows"];
    [para setObject:@(1) forKey:@"source_type"];
//    if (!IsStrEmpty(_keyword)) {
//        [para setObject:_keyword forKey:@"neighborhood_name"];
//    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:house_listURL parameters:para type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:self.view];
        if (status == 1) {
            if (_pageIndex == 1 && self.houseListArr.count > 0) {
                [self.houseListArr removeAllObjects];
            }
            NSArray *listArr = dic[@"list"];
            [self.houseListArr addObjectsFromArray:[BigHouseModel mj_objectArrayWithKeyValuesArray:listArr]];
            if (listArr.count < 10) {
                [self.houseSearchTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.houseSearchTableView.mj_footer endRefreshing];
            }
            if (self.houseListArr.count == 0) {
                [self.houseSearchTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.houseSearchTableView reloadData];
        } else {
            [self.houseListArr removeAllObjects];
            [self.houseSearchTableView reloadData];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    if (_nature == 3) {
        _pageIndex = 1;
        [self getBigHouseSearchListData];
    } else {
        _pageIndex = 1;
        [self getUnitIndexDate];
    }
    [_houseSearchTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    if (_nature == 3) {
        [self getBigHouseSearchListData];
    } else {
        [self getUnitIndexDate];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _houseListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 134;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"HomeHouseTableViewCell";
    HomeHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (HomeHouseTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_nature == 3) {
        BigHouseModel *bigHouseModel = _houseListArr[indexPath.row];
        cell.bigHouseModel = bigHouseModel;
        cell.poinsCollectionView.hidden = YES;
    } else {
        HouseListModel *model = _houseListArr[indexPath.row];
        cell.houseModel = model;
        cell.poinsCollectionView.hidden = NO;
//        KWeakSelf
//        cell.houseIsCollectBlock = ^(NSInteger collect) {
//            model.collect = collect;
//            [weakSelf createNotificationCenterInfo:model];
//        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseDetailViewController *vc = [HouseDetailViewController new];
    if (_nature == 3) {
        BigHouseModel *bigHouseModel = _houseListArr[indexPath.row];
        vc.bigHouseId = NONullString(bigHouseModel.house_id);
    } else {
        HouseListModel *model = _houseListArr[indexPath.row];
        vc.unit_id = model.unit_id;
        KWeakSelf
        vc.houseIsCollectBlock = ^(NSInteger collect) {
            model.collect = collect;
            [weakSelf createNotificationCenterInfo:model];
        };
        dispatch_async(dispatch_queue_create("com.wdit.hzapp", DISPATCH_QUEUE_SERIAL), ^{
            [[SNFileCache defaultCache] saveDictionary:model forKey:@"House"];
        });
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createNotificationCenterInfo:(HouseListModel *)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeCollectNotification" object:nil userInfo:model.mj_keyValues];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HouseCollectNotification" object:nil userInfo:model.mj_keyValues];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.houseListArr.count > 0) {
        KWeakSelf
        [RACObserve([User shareUser],token) subscribeNext:^(id x) {
            if (![x isEqual:weakSelf.recodeTokenStr]) {
                weakSelf.recodeTokenStr = x;
                weakSelf.pageIndex = 1;
                [weakSelf getUnitIndexDate];
            }
        }];
    }
}

- (HouseSearchNaviView *)houseSearchNaviView
{
    if (!_houseSearchNaviView) {
        _houseSearchNaviView = [HouseSearchNaviView viewFromXib];
        _houseSearchNaviView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    }
    return _houseSearchNaviView;
}

- (NSMutableArray *)houseListArr
{
    if (!_houseListArr) {
        _houseListArr = [NSMutableArray array];
    }
    return _houseListArr;
}

@end
