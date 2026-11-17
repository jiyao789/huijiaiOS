//
//  SearchViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SearchViewController.h"
#import "MacroDefine.h"
#import "SearchNaviView.h"
#import "SearchHistoryCollectionViewCell.h"
#import "HouseListModel.h"
#import "HomeHouseTableViewCell.h"
#import "HouseDetailViewController.h"
#import "SearchHistoryHeaderView.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) SearchNaviView *searchNaviView;
@property (strong, nonatomic) SearchHistoryHeaderView *searchHistoryHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;

@property (strong, nonatomic) NSMutableArray *searchListArr;
@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSString *recodeTokenStr;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.gk_navigationBar addSubview:self.searchNaviView];
    _recodeTokenStr = [User shareUser].token;
    
    _pageIndex = 1;
    _viewLayoutTop.constant = NAVBAR_HEIGHT;
    
    self.searchHistoryHeaderView.searchHistoryArr = [self getSearchHistoryDate];
    self.searchTableView.tableHeaderView = self.searchHistoryHeaderView;
    [self setupRefreshWithTableView:self.searchTableView];
}

- (void)getUnitIndexDate
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(_pageIndex) forKey:@"page"];
    [para setObject:@(10) forKey:@"page_rows"];
    if (_nature == 1 || _nature == 2) {
        [para setObject:@(_nature) forKey:@"nature"];
    }
    if (!IsStrEmpty(_searchText)) {
        [para setObject:NONullString(_searchText) forKey:@"region_name"];
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:unit_indexURL parameters:para type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:self.view];
        if (status == 1) {
            if (_pageIndex == 1 && self.searchListArr.count > 0) {
                [self.searchListArr removeAllObjects];
            }
            NSArray *listArr = dic[@"list"];
            [self.searchListArr addObjectsFromArray:[HouseListModel mj_objectArrayWithKeyValuesArray:listArr]];
            if (listArr.count < 10) {
                [self.searchTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.searchTableView.mj_footer endRefreshing];
            }
            if (self.searchListArr.count > 0) {
                self.searchTableView.tableHeaderView = [UIView new];
                self.searchTableView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
            }
            if (self.searchListArr.count == 0) {
                [self.searchTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.searchTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    if (!IsStrEmpty(_searchText)) {
        _pageIndex = 1;
        [self getUnitIndexDate];
    }
    [_searchTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    if (!IsStrEmpty(_searchText)) {
        _pageIndex ++;
        [self getUnitIndexDate];
    } else {
        [self.searchTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchListArr.count;
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
    HouseListModel *model = _searchListArr[indexPath.row];
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
    HouseListModel *model = _searchListArr[indexPath.row];
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

- (void)createNotificationCenterInfo:(HouseListModel *)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeCollectNotification" object:nil userInfo:model.mj_keyValues];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HouseCollectNotification" object:nil userInfo:model.mj_keyValues];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (self.searchListArr.count > 0) {
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

- (NSMutableArray *)searchListArr
{
    if (!_searchListArr) {
        _searchListArr = [NSMutableArray array];
    }
    return _searchListArr;
}

- (SearchNaviView *)searchNaviView
{
    if (!_searchNaviView) {
        _searchNaviView = [SearchNaviView viewFromXib];
        _searchNaviView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        KWeakSelf
        _searchNaviView.searchNaviButtonBlock = ^(NSString * _Nonnull text) {
            weakSelf.searchText = text;
            [weakSelf getUnitIndexDate];
        };
        _searchNaviView.searchNaviTextFieldBlock = ^{
            [weakSelf.searchListArr removeAllObjects];
            weakSelf.searchText = @"";
            weakSelf.searchHistoryHeaderView.searchHistoryArr = [weakSelf getSearchHistoryDate];
            weakSelf.searchTableView.tableHeaderView = weakSelf.searchHistoryHeaderView;
            [weakSelf.noMsgView removeFromSuperview];
            [weakSelf.searchTableView reloadData];
        };
    }
    return _searchNaviView;
}

- (SearchHistoryHeaderView *)searchHistoryHeaderView
{
    if (!_searchHistoryHeaderView) {
        _searchHistoryHeaderView = [SearchHistoryHeaderView viewFromXib];
        KWeakSelf
        _searchHistoryHeaderView.searchHistoryClickBlock = ^(NSString * _Nonnull historyStr) {
            weakSelf.searchText = historyStr;
            weakSelf.searchNaviView.searchTextField.text = historyStr;
            [weakSelf getUnitIndexDate];
        };
    }
    return _searchHistoryHeaderView;
}

- (NSMutableArray *)getSearchHistoryDate
{
    NSMutableArray *array = [[SNFileCache defaultCache] arrayForKey:@"Search"];
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    return [[NSMutableArray alloc]initWithArray:[enumerator allObjects]];
}

@end
