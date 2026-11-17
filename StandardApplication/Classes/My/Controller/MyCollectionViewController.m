//
//  MyCollectionViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MacroDefine.h"
#import "HomeHouseTableViewCell.h"
#import "HouseDetailViewController.h"
#import "SubscribeListModel.h"
#import "HouseListModel.h"

@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *listArr;
@property (strong, nonatomic) NSString *recodeTokenStr;
@end

@implementation MyCollectionViewController

// 收藏&足迹
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = _type == 1 ? @"收藏" : (_type == 2 ? @"足迹" : @"特色房源");
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_type == 1) {
        _pageIndex = 1;
        [self getOperateSubscribeDate];
        [self setupRefreshWithTableView:_tableView];
    } else if (_type == 2) {
        _recodeTokenStr = [User shareUser].token;
        [self getHistoryDate];
    } else if (_type == 3) {
        _pageIndex = 1;
        [self getUnitIndexDate];
        [self setupRefreshWithTableView:_tableView];
    }
    
//    if (self.listArr.count > 0 && _type == 2) {
//        KWeakSelf
//        [RACObserve([User shareUser],token) subscribeNext:^(id x) {
//            if (![x isEqual:weakSelf.recodeTokenStr]) {
//                _recodeTokenStr = x;
//                [weakSelf getHistoryDate];
//            }
//        }];
//    }
    
//    [self getNotificationCenterInfo];
}

- (void)getHistoryDate
{
    NSMutableArray *array = [[SNFileCache defaultCache] arrayForKey:@"House"];
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    self.listArr = [[NSMutableArray alloc]initWithArray: [enumerator allObjects]];
//    for (HouseListModel *model in self.listArr) {
//        if (IsStrEmpty([User shareUser].token)) {
//            model.collect = 0;
//        }
//    }
    [self.tableView reloadData];
}

- (void)getOperateSubscribeDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:operate_subscribeURL parameters:@{@"page":@(_pageIndex),@"page_rows":@"10"} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            if (_pageIndex == 1 && self.listArr.count > 0) {
                [self.listArr removeAllObjects];
            }
            NSArray *listArray = dic[@"list"];
            [self.listArr addObjectsFromArray:[SubscribeListModel mj_objectArrayWithKeyValuesArray:listArray]];
            if (listArray.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.listArr.count == 0) {
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

- (void)getUnitIndexDate
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(_pageIndex) forKey:@"page"];
    [para setObject:@(10) forKey:@"page_rows"];
    [para setObject:NONullString([User shareUser].getUserId) forKey:@"u_id"];
    if (!IsStrEmpty(_point)) {
        [para setObject:NONullString(_point) forKey:@"points"];
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:unit_indexURL parameters:para type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:self.view];
        if (status == 1) {
            if (_pageIndex == 1 && self.listArr.count > 0) {
                [self.listArr removeAllObjects];
            }
            NSArray *listArr = dic[@"list"];
            [self.listArr addObjectsFromArray:[HouseListModel mj_objectArrayWithKeyValuesArray:listArr]];
            if (listArr.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.listArr.count == 0) {
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
    if (_type == 1) {
        [self getOperateSubscribeDate];
    } else if (_type == 3) {
        [self getUnitIndexDate];
    }
    [_tableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    if (_type == 1) {
        [self getOperateSubscribeDate];
    } else if (_type == 3) {
        [self getUnitIndexDate];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
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
    if (_type == 1) {
        SubscribeListModel *model = _listArr[indexPath.row];
        cell.unitModel = model.unit;
//        [cell.collectionButton setImage:[UIImage imageNamed:@"house_collection_select_img"] forState:UIControlStateNormal];
//        KWeakSelf
//        cell.houseIsCollectBlock = ^(NSInteger collect) {
//            [weakSelf createUnitNotificationCenterInfo:model.unit];
//        };
    } else if (_type == 2 || _type == 3) {
        HouseListModel *model = _listArr[indexPath.row];
        cell.houseModel = model;
//        KWeakSelf
//        cell.houseIsCollectBlock = ^(NSInteger collect) {
//            model.collect = collect;
//            [weakSelf createHouseNotificationCenterInfo:model];
//        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 1) {
        HouseDetailViewController *vc = [HouseDetailViewController new];
        SubscribeListModel *model = _listArr[indexPath.row];
        vc.unit_id = model.unit.unit_id;
//        KWeakSelf
//        vc.houseIsCollectBlock = ^(NSInteger collect) {
//            [weakSelf createUnitNotificationCenterInfo:model.unit];
//        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_type == 2) {
        HouseListModel *model = _listArr[indexPath.row];
        [self getUnitDetailDate:model];
    } else if (_type == 3) {
        HouseDetailViewController *vc = [HouseDetailViewController new];
        HouseListModel *model = _listArr[indexPath.row];
        vc.unit_id = model.unit_id;
//        KWeakSelf
//        vc.houseIsCollectBlock = ^(NSInteger collect) {
//            model.collect = collect;
//            [weakSelf createHouseNotificationCenterInfo:model];
//        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getUnitDetailDate:(HouseListModel *)model
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:unit_detailURL parameters:@{@"unit_id":@(model.unit_id),@"platform":@"2"} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            HouseDetailViewController *vc = [HouseDetailViewController new];
            vc.unit_id = model.unit_id;
//            KWeakSelf
//            vc.houseIsCollectBlock = ^(NSInteger collect) {
//                model.collect = collect;
//                [weakSelf createHouseNotificationCenterInfo:model];
//            };
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:@"房源已下架" toView:self.view];
        }
    }];
}

//- (void)createUnitNotificationCenterInfo:(UnitModel *)unitModel
//{
//    for (SubscribeListModel *model in _listArr) {
//        if (model.unit.unit_id == unitModel.unit_id) {
//            [_listArr removeObject:model];
//            [_tableView reloadData];
//            break;
//        }
//    }
//    HouseListModel *listModel = [HouseListModel new];
//    listModel.unit_id = unitModel.unit_id;
//    listModel.collect = 0;
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeCollectNotification" object:nil userInfo:listModel.mj_keyValues];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HouseCollectNotification" object:nil userInfo:listModel.mj_keyValues];
//}
//
//- (void)createHouseNotificationCenterInfo:(HouseListModel *)model
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeCollectNotification" object:nil userInfo:model.mj_keyValues];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HouseCollectNotification" object:nil userInfo:model.mj_keyValues];
//}

//- (void)getNotificationCenterInfo
//{
//    if (self.listArr.count == 0 || _type != 1) {
//        return;
//    }
//    //接收通知
//    RACSignal *siganl = [[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HouseCollectNotification" object:nil];
//    //设置接收通知的回调处理
//    KWeakSelf
//    [siganl subscribeNext:^(NSNotification *x) {
//        KStrongSelf(weakSelf)
//        HouseListModel *notiModel = [HouseListModel mj_objectWithKeyValues:x.userInfo];
//        for (SubscribeListModel *model in strongSelf.listArr) {
//            if (model.unit.unit_id == notiModel.unit_id) {
//                [strongSelf.listArr removeObject:model];
//                [strongSelf.tableView reloadData];
//                break;
//            }
//        }
//    }];
//    
//}

- (NSMutableArray *)listArr
{
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}

@end
