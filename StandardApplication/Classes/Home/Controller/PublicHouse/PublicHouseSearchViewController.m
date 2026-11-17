//
//  PublicHouseSearchViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "PublicHouseSearchViewController.h"
#import "MacroDefine.h"
#import "HouseSearchNaviView.h"
#import "ChooseClassifyView.h"
#import "HomeHouseTableViewCell.h"
#import "ApplyEnterViewController.h"
#import "ApplyNotesViewController.h"
#import "HouseDetailViewController.h"
#import "PublicHouseClassifyView.h"

@interface PublicHouseSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)HouseSearchNaviView *houseSearchNaviView;
@property (weak, nonatomic) IBOutlet BaseShadowView *applyNotesView;
@property (weak, nonatomic) IBOutlet BaseShadowView *applyEnterView;
@property (weak, nonatomic) IBOutlet ChooseClassifyView *chooseClassifyView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutHeight;
@property (weak, nonatomic) IBOutlet PublicHouseClassifyView *publicHouseClassifyView;

@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *houseListArr;
@property (strong, nonatomic) NSMutableDictionary *unitFilterDic;
@property (assign, nonatomic) NSInteger unit_type;
@property (strong, nonatomic) NSString *recodeTokenStr;
@end

@implementation PublicHouseSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.houseSearchNaviView.searchTitleLab.text = @"公租房";
    self.houseSearchNaviView.nature = 1;
    [self.gk_navigationBar addSubview:self.houseSearchNaviView];
    _viewLayoutTop.constant = NAVBAR_HEIGHT + 10;
    _recodeTokenStr = [User shareUser].token;
    
    _pageIndex = 1;
    _unit_type = 0;
    [self setupRefreshWithTableView:_tableView];
    
    KWeakSelf
    _chooseClassifyView.isHouseType = 2;
    _chooseClassifyView.ChooseClassifyViewBlock = ^(NSInteger height) {
        weakSelf.viewLayoutHeight.constant = 215 + height;
    };
    _chooseClassifyView.chooseClassifyViewFilterBlock = ^(NSMutableDictionary * _Nullable unitFilterDic) {
        weakSelf.unitFilterDic = unitFilterDic;
        weakSelf.pageIndex = 1;
        weakSelf.keyword = @"";
        weakSelf.pointsIdJsonStr = @"";
        [weakSelf getUnitIndexDate];
    };
    _publicHouseClassifyView.publicHouseClassifyViewBlock = ^(NSInteger unit_type) {
        weakSelf.unit_type = unit_type;
        weakSelf.pageIndex = 1;
        weakSelf.keyword = @"";
        weakSelf.pointsIdJsonStr = @"";
        [weakSelf getUnitIndexDate];
    };
        
    [_applyNotesView whenTapped:^{
        [weakSelf.navigationController pushViewController:[ApplyNotesViewController new] animated:YES];
    }];
    
    [_applyEnterView whenTapped:^{
        [weakSelf.navigationController pushViewController:[ApplyEnterViewController new] animated:YES];
    }];
}

- (void)getUnitIndexDate
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(_pageIndex) forKey:@"page"];
    [para setObject:@(10) forKey:@"page_rows"];
    [para setObject:@(1) forKey:@"nature"];   //1:公租房 2:社租房
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
    if (_unit_type != 0) {
        [para setObject:@(_unit_type) forKey:@"unit_type"];
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
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.houseListArr.count == 0) {
                [self.tableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getUnitIndexDate];
    [_tableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getUnitIndexDate];
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
    HouseListModel *model = _houseListArr[indexPath.row];
    cell.houseModel = model;
//    KWeakSelf
//    cell.houseIsCollectBlock = ^(NSInteger collect) {
//        model.collect = collect;
//        [weakSelf createNotificationCenterInfo:model];
//    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseDetailViewController *vc = [HouseDetailViewController new];
    HouseListModel *model = _houseListArr[indexPath.row];
    vc.unit_id = model.unit_id;
//    KWeakSelf
//    vc.houseIsCollectBlock = ^(NSInteger collect) {
//        model.collect = collect;
//        [weakSelf createNotificationCenterInfo:model];
//    };
    [self.navigationController pushViewController:vc animated:YES];
    
    dispatch_async(dispatch_queue_create("com.wdit.hzapp", DISPATCH_QUEUE_SERIAL), ^{
        [[SNFileCache defaultCache] saveDictionary:model forKey:@"House"];
    });
}

//- (void)createNotificationCenterInfo:(HouseListModel *)model
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeCollectNotification" object:nil userInfo:model.mj_keyValues];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HouseCollectNotification" object:nil userInfo:model.mj_keyValues];
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _pageIndex = 1;
    [self getUnitIndexDate];
    
//    if (self.houseListArr.count > 0) {
//        KWeakSelf
//        [RACObserve([User shareUser],token) subscribeNext:^(id x) {
//            if (![x isEqual:weakSelf.recodeTokenStr]) {
//                weakSelf.recodeTokenStr = x;
//                weakSelf.pageIndex = 1;
//                [weakSelf getUnitIndexDate];
//            }
//        }];
//    }
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
