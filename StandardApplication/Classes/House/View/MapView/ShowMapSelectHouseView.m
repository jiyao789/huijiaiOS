//
//  ShowMapSelectHouseView.m
//  StandardApplication
//
//  Created by DTiOS on 2022/8/4.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "ShowMapSelectHouseView.h"
#import "MacroDefine.h"
#import "HouseListModel.h"
#import "HomeHouseTableViewCell.h"
#import "HouseDetailViewController.h"

@interface ShowMapSelectHouseView ()
@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *houseListArr;
@end

@implementation ShowMapSelectHouseView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _mapHouseTableView.delegate = self;
    _mapHouseTableView.dataSource = self;
    
    [self setupFooterRefresh:_mapHouseTableView];
}

- (void)setHouseNameStr:(NSString *)houseNameStr
{
    _houseNameStr = houseNameStr;
    _pageIndex = 1;
    [self getUnitIndexDate];
}

- (void)getUnitIndexDate
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(_pageIndex) forKey:@"page"];
    [para setObject:@(10) forKey:@"page_rows"];
    [para setObject:NONullString([User shareUser].getUserId) forKey:@"u_id"];
    if (!IsStrEmpty(_houseNameStr)) {
        [para setObject:NONullString(_houseNameStr) forKey:@"region_name"];
    }
    [MBProgressHUD showStatus:nil toView:self];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:unit_indexURL parameters:para type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:self];
        if (status == 1) {
            if (_pageIndex == 1 && self.houseListArr.count > 0) {
                [self.houseListArr removeAllObjects];
            }
            NSArray *listArr = dic[@"list"];
            [self.houseListArr addObjectsFromArray:[HouseListModel mj_objectArrayWithKeyValuesArray:listArr]];
            if (listArr.count < 10) {
                [self.mapHouseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.mapHouseTableView.mj_footer endRefreshing];
            }
            [self.mapHouseTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:nil];
        }
    }];
}

//- (void)headerRefreshloadData
//{
//    _pageIndex = 1;
//    [self getUnitIndexDate];
//    [_mapHouseTableView.mj_header endRefreshing];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"-------%f",offsetY);
    if (offsetY < -100) {
        SAFE_BLOCK(self.didDismissBlock);
    }
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
    SAFE_BLOCK(self.didDismissBlock);
    
    HouseDetailViewController *vc = [HouseDetailViewController new];
    HouseListModel *model = _houseListArr[indexPath.row];
    vc.unit_id = model.unit_id;
//    KWeakSelf
//    vc.houseIsCollectBlock = ^(NSInteger collect) {
//        model.collect = collect;
//        [weakSelf createNotificationCenterInfo:model];
//    };
    [_navigation pushViewController:vc animated:YES];
    
    dispatch_async(dispatch_queue_create("com.wdit.hzapp", DISPATCH_QUEUE_SERIAL), ^{
        [[SNFileCache defaultCache] saveDictionary:model forKey:@"House"];
    });
}

//- (void)createNotificationCenterInfo:(HouseListModel *)model
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HouseCollectNotification" object:nil userInfo:model.mj_keyValues];
//}

- (void)getNotificationCenterInfo
{
    if (self.houseListArr.count == 0) {
        return;
    }
//    //接收通知
//    RACSignal *signalCollect = [[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HomeCollectNotification" object:nil];
//    //设置接收通知的回调处理
//    KWeakSelf
//    [signalCollect subscribeNext:^(NSNotification *x) {
//        NSLog(@"HomeCollectNotification == %@",x.userInfo);
//        HouseListModel *notiModel = [HouseListModel mj_objectWithKeyValues:x.userInfo];
//        for (HouseListModel *model in weakSelf.houseListArr) {
//            if (model.unit_id == notiModel.unit_id) {
//                model.collect = notiModel.collect;
//                break;
//            }
//        }
//    }];
    
    KWeakSelf
    //接收通知
    RACSignal *signalApply = [[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HouseApplyNotification" object:nil];
    //设置接收通知的回调处理
    [signalApply subscribeNext:^(NSNotification *x) {
        NSLog(@"HouseApplyNotification == %@",x.userInfo);
        HouseDetailModel *notiModel = [HouseDetailModel mj_objectWithKeyValues:x.userInfo];
        for (HouseListModel *model in weakSelf.houseListArr) {
            if (model.unit_id == notiModel.unit_id) {
                [weakSelf.houseListArr removeObject:model];
                break;
            }
        }
        [weakSelf.mapHouseTableView reloadData];
    }];
}

- (NSMutableArray *)houseListArr
{
    if (!_houseListArr) {
        _houseListArr = [NSMutableArray array];
    }
    return _houseListArr;
}

- (void)setupFooterRefresh:(UIScrollView *)tableView
{
    //     MJRefreshAutoNormalFooter     MJRefreshBackNormalFooter
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshloadData)];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    // 设置文字
    [footer setTitle:@"正在刷新..." forState:MJRefreshStateIdle];
    [footer setTitle:@"正在刷新..." forState:MJRefreshStatePulling];
    [footer setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];

    footer.arrowView.alpha = 0.0;
    [footer setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
    tableView.mj_footer = footer;
}

@end
