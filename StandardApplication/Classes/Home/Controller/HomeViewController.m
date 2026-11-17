//
//  HomeViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/18.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HomeViewController.h"
#import "MacroDefine.h"
#import "HomeNaviView.h"
#import "HomeHeaderView.h"
#import "HomeHouseTableViewCell.h"
#import "HomeHeaderSectionView.h"
#import "HouseDetailViewController.h"
#import "HouseListModel.h"
#import "VersionUpdateView.h"
#import "ECLocationManager.h"
#import "ECUUIDTool.h"
#import "ContractWarnView.h"
#import "MessageIndexModel.h"
#import "HomeHeaderNatureView.h"
#import "BigHouseModel.h"
#import "HomeTableViewCell.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (weak, nonatomic) IBOutlet HomeHeaderNatureView *homeNatureView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeNatureViewLayoutTop;
@property (strong, nonatomic)HomeNaviView *homeNaviView;
@property (strong, nonatomic)HomeHeaderView *homeHeaderView;
@property (strong, nonatomic)HomeHeaderSectionView *sectionHeaderView;
@property (assign, nonatomic)NSInteger sectionChangeHeight;

@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *houseListArr;
@property (strong, nonatomic) UIView *statusbarView;
@property (strong, nonatomic) NSMutableDictionary *unitFilterDic;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSString *recodeTokenStr;
@property (assign, nonatomic) NSInteger nature;
@property (assign, nonatomic) CGFloat singleHeight;
@property (assign, nonatomic) CGFloat doubleHeight;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviBarAlpha = 0;
    _recodeTokenStr = [User shareUser].token;
//    self.navBackgroundColor = [UIColor colorWithHexString:@"#2A629A"];
    adjustsScrollViewInsets_NO(self.homeTableView, self);
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [self.gk_navigationBar addSubview:self.homeNaviView];
    self.homeTableView.tableHeaderView = self.homeHeaderView;
    [self.view addSubview:self.statusbarView];
    
    [self setupRefreshWithTableView:_homeTableView];
    
    _sectionChangeHeight = 0;
    _count = 0;
    _nature = 1;
    _singleHeight = 0;
    _doubleHeight = 0;
    _homeNatureViewLayoutTop.constant = STATUSBAR_HEIGHT;
    
    // 获取版本号接口
    [self getVersionInfoDate];
    
    KWeakSelf
    [RACObserve([User shareUser],token) subscribeNext:^(id x) {
        weakSelf.pageIndex = 1;
        [weakSelf getUnitIndexDate];
    }];
    _homeNatureView.chooseHouseNatureViewBlock = ^(NSInteger nature) {
        weakSelf.homeHeaderView.homeNatureView.natureIndex = nature;
        weakSelf.nature = nature;
        if (nature == 3) {
            weakSelf.pageIndex = 1;
            [weakSelf getBigHouseSearchListData];
        } else {
            weakSelf.pageIndex = 1;
            [weakSelf getUnitIndexDate];
        }
    };
    _homeNatureView.houseTextFieldBlock = ^(NSString * _Nonnull searchText) {
        weakSelf.homeHeaderView.homeNatureView.searchString = NONullString(searchText);
    };
    
    self.pageIndex = 1;
    [self getUnitIndexDate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    if (_nature != 3) {
//        self.pageIndex = 1;
//        [self getUnitIndexDate];
//    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarSelectNotificationAction:) name:@"TabBarControllerNotification" object:nil];
    
//    KWeakSelf
//    [RACObserve([User shareUser],token) subscribeNext:^(id x) {
//        if (![x isEqual:weakSelf.recodeTokenStr]) {
//            weakSelf.recodeTokenStr = x;
//            weakSelf.pageIndex = 1;
//            [weakSelf getUnitIndexDate];
//        }
//    }];
//    
//    // 获取通知
//    [self getNotificationCenterInfo];
}

//- (void)tabbarSelectNotificationAction:(NSNotification *)notification
//{
//    // 每次进入到页面都需要重置
//    _pageIndex = 1;
//    _homeHeaderView.isRefreshDate = YES;
//    _sectionHeaderView.isRefreshDate = YES;
//    _sectionHeaderView.classifyView.needResetSelect = YES;
//    [self.unitFilterDic removeAllObjects];
//    [self getUnitIndexDate];
//}

- (void)getUnitIndexDate
{
    if (_nature == 3) {
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(_pageIndex) forKey:@"page"];
    [para setObject:@(10) forKey:@"page_rows"];
    [para setObject:NONullString([User shareUser].getUserId) forKey:@"u_id"];
    if (_nature > 0) {
        [para setObject:@(_nature) forKey:@"nature"];
    }
    if (_unitFilterDic.allKeys.count > 0) {
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
                [self.homeTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.homeTableView.mj_footer endRefreshing];
            }
            
            [self.homeTableView reloadData];
        } else {
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
    [_homeTableView.mj_header endRefreshing];
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

// 大房鸭
- (void)getBigHouseSearchListData
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(_pageIndex) forKey:@"page"];
    [para setObject:@(10) forKey:@"page_rows"];
    [para setObject:@(1) forKey:@"source_type"];
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
                [self.homeTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.homeTableView.mj_footer endRefreshing];
            }
            
            [self.homeTableView reloadData];
        } else {
            [self.houseListArr removeAllObjects];
            [self.homeTableView reloadData];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40 + _sectionChangeHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = _houseListArr.count % 2 == 0 ? (_houseListArr.count / 2) : (_houseListArr.count / 2 + 1);
    if (_nature == 3) {
        NSInteger height = 270 + 7;
        return count * height;
    }
    
    if (_singleHeight >= count * 270 || _doubleHeight >= count * 270) {
        return _singleHeight > _doubleHeight ? _singleHeight : _doubleHeight;
    }
    
    for (NSInteger index = ((_pageIndex - 1) * 10); index < _houseListArr.count; index ++) {
        HouseListModel * model = _houseListArr[index];
        if (index % 2 == 0) {
            _singleHeight += [CommonUtils getHeightWithModel: model];
            _singleHeight += 7;
        } else {
            _doubleHeight += [CommonUtils getHeightWithModel: model];
            _doubleHeight += 7;
        }
    }
    
    return _singleHeight > _doubleHeight ? _singleHeight : _doubleHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellID = @"HomeHouseTableViewCell";
//    HomeHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil) {
//        cell = (HomeHouseTableViewCell *)LoadNibNamed(cellID);
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    if (_nature == 3) {
//        BigHouseModel *bigHouseModel = _houseListArr[indexPath.row];
//        cell.bigHouseModel = bigHouseModel;
//        cell.poinsCollectionView.hidden = YES;
//    } else {
//        HouseListModel *model = _houseListArr[indexPath.row];
//        cell.houseModel = model;
//        cell.poinsCollectionView.hidden = NO;
////        KWeakSelf
////        cell.houseIsCollectBlock = ^(NSInteger collect) {
////            model.collect = collect;
////            [weakSelf createNotificationCenterInfo:model];
////        };
//    }
//    return cell;
    
    static NSString *cellID = @"HomeTableViewCell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (HomeTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.nature = _nature;
    cell.houseList = _houseListArr;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    HouseDetailViewController *vc = [HouseDetailViewController new];
//    if (_nature == 3) {
//        BigHouseModel *bigHouseModel = _houseListArr[indexPath.row];
//        vc.bigHouseId = NONullString(bigHouseModel.house_id);
//    } else {
//        HouseListModel *model = _houseListArr[indexPath.row];
//        vc.unit_id = model.unit_id;
////        KWeakSelf
////        vc.houseIsCollectBlock = ^(NSInteger collect) {
////            model.collect = collect;
////            [weakSelf createNotificationCenterInfo:model];
////        };
//        dispatch_async(dispatch_queue_create("com.wdit.hzapp", DISPATCH_QUEUE_SERIAL), ^{
//            [[SNFileCache defaultCache] saveDictionary:model forKey:@"House"];
//        });
//    }
//    [self.navigationController pushViewController:vc animated:YES];
//}

//- (void)createNotificationCenterInfo:(HouseListModel *)model
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeCollectNotification" object:nil userInfo:model.mj_keyValues];
//}
//
//- (void)getNotificationCenterInfo
//{
//    if (self.houseListArr.count == 0) {
//        return;
//    }
//    //接收通知
//    KWeakSelf
//    RACSignal *siganlCollect = [[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HouseCollectNotification" object:nil];
//    //设置接收通知的回调处理
//    [siganlCollect subscribeNext:^(NSNotification *x) {
//        NSLog(@"HouseCollectNotification == %@",x.userInfo);
//        HouseListModel *notiModel = [HouseListModel mj_objectWithKeyValues:x.userInfo];
//        for (HouseListModel *model in weakSelf.houseListArr) {
//            if (model.unit_id == notiModel.unit_id) {
//                model.collect = notiModel.collect;
//                break;
//            }
//        }
//    }];
//    
//    //接收通知
//    RACSignal *siganlApply = [[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HouseApplyNotification" object:nil];
//    //设置接收通知的回调处理
//    [siganlApply subscribeNext:^(NSNotification *x) {
//        NSLog(@"HouseApplyNotification == %@",x.userInfo);
//        HouseDetailModel *notiModel = [HouseDetailModel mj_objectWithKeyValues:x.userInfo];
//        for (HouseListModel *model in weakSelf.houseListArr) {
//            if (model.unit_id == notiModel.unit_id) {
//                [weakSelf.houseListArr removeObject:model];
//                break;
//            }
//        }
//        [weakSelf.homeTableView reloadData];
//    }];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"==============%f",offsetY);
    if (offsetY > 262 - STATUSBAR_HEIGHT) {
//        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
//        self.naviBarAlpha = alpha;
        self.hideNaviBar = YES;
        self.statusBarStyle = UIStatusBarStyleDefault;
        _homeNatureView.hidden = NO;
        _statusbarView.hidden = NO;
    } else {
//        self.naviBarAlpha = 0;
        self.hideNaviBar = NO;
        self.statusBarStyle = UIStatusBarStyleLightContent;
        _homeNatureView.hidden = YES;
        _statusbarView.hidden = YES;
    }

    CGFloat headerHeight = 705; // 585 + 120 (acquisition banner height)
    if (offsetY < (headerHeight - STATUSBAR_HEIGHT - 280) && offsetY >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else if(offsetY >= (headerHeight - STATUSBAR_HEIGHT - 280)) {
        scrollView.contentInset = UIEdgeInsetsMake(STATUSBAR_HEIGHT + 280, 0, 0, 0);
    }
}

- (void)getVersionInfoDate
{
    [HttpRequest requestUrlPath:BaseURL urlPath:Version_indexURL parameters:@{@"client_type":@(1),@"system_type":@(2)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            NSInteger version_sn = [[dic[@"version_sn"] stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
            NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSInteger version = [[app_Version stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
            if (version_sn > version) {
                VersionUpdateView *versionUpdateView = [VersionUpdateView createViewFromNib];
                versionUpdateView.versionDic = dic;
                ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:versionUpdateView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
                versionUpdateView.didConfirmBlock = ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dic[@"package_link"]] options:@{} completionHandler:nil];
                };
                versionUpdateView.didCancelBlock = ^{
                    [alertController dismissViewControllerAnimated:YES];
                    [self getAppMessagePopupDate];
                };
                alertController.tapBackgroundDismissEnable = NO;
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                [self getAppMessagePopupDate];
            }
        } else {
            [self getAppMessagePopupDate];
        }
    }];
}

- (void)getAppMessagePopupDate
{
    if (IsStrEmpty([User shareUser].token)) {
        return;
    }
    [HttpRequest requestArrUrlPath:BaseURL urlPath:appMessage_popupURL parameters:@{} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            NSArray *contractArr = [MessageModel mj_objectArrayWithKeyValuesArray:arr];
            for (MessageModel *model in contractArr) {
                if (model.message_type == 4) {
                    [self showContractWarnView:model];
                    return;
                }
            }
        }
    }];
}

- (void)showContractWarnView:(MessageModel *)messageModel
{
    ContractWarnView *contractWarnView = [ContractWarnView createViewFromNib];
    contractWarnView.messageModel = messageModel;
    contractWarnView.navigation = self.navigationController;
    if ([[messageModel.content valueForKey:@"type"] integerValue] == 1) {
        contractWarnView.frame = CGRectMake(0, 0, 300, 420);
    } else if ([[messageModel.content valueForKey:@"type"] integerValue] == 2) {
        contractWarnView.frame = CGRectMake(0, 0, 300, 350);
    }
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:contractWarnView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    contractWarnView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = NO;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (HomeNaviView *)homeNaviView
{
    if (!_homeNaviView) {
        _homeNaviView = [HomeNaviView viewFromXib];
        _homeNaviView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    }
    return _homeNaviView;
}

- (HomeHeaderView *)homeHeaderView
{
    if (!_homeHeaderView) {
        _homeHeaderView = [HomeHeaderView viewFromXib];
        // 设置header高度为705 (原585 + 横幅120)
        CGRect frame = _homeHeaderView.frame;
        frame.size.height = 705;
        _homeHeaderView.frame = frame;

        KWeakSelf
        _homeHeaderView.homeNatureView.chooseHouseNatureViewBlock = ^(NSInteger nature) {
            weakSelf.homeNatureView.natureIndex = nature;
            weakSelf.nature = nature;
            if (nature == 3) {
                weakSelf.pageIndex = 1;
                [weakSelf getBigHouseSearchListData];
            } else {
                weakSelf.pageIndex = 1;
                [weakSelf getUnitIndexDate];
            }
        };
        _homeHeaderView.homeNatureView.houseTextFieldBlock = ^(NSString * _Nonnull searchText) {
            weakSelf.homeNatureView.searchString = NONullString(searchText);
        };
    }
    return _homeHeaderView;
}

- (HomeHeaderSectionView *)sectionHeaderView
{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [HomeHeaderSectionView viewFromXib];
        KWeakSelf
        _sectionHeaderView.classifyView.needNewLayoutHouseType = 2;
        _sectionHeaderView.classifyView.bottomBackView.backgroundColor = [UIColor clearColor];
        _sectionHeaderView.classifyView.isHouseType = 2;
        _sectionHeaderView.classifyView.ChooseClassifyViewBlock = ^(NSInteger height) {
            weakSelf.sectionChangeHeight = height;
            [weakSelf.homeTableView reloadData];
            //若cell被遮挡则滚动
//            [weakSelf.homeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
        };
        _sectionHeaderView.classifyView.chooseClassifyViewFilterBlock = ^(NSMutableDictionary * _Nullable unitFilterDic) {
            weakSelf.unitFilterDic = unitFilterDic;
            weakSelf.pageIndex = 1;
            [weakSelf getUnitIndexDate];
            
            [weakSelf.homeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
        };
    }
    return _sectionHeaderView;
}

- (UIView *)statusbarView
{
    if (!_statusbarView) {
        _statusbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUSBAR_HEIGHT)];
        _statusbarView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        _statusbarView.hidden = YES;
    }
    return _statusbarView;
}

- (NSMutableArray *)houseListArr
{
    if (!_houseListArr) {
        _houseListArr = [NSMutableArray array];
    }
    return _houseListArr;
}

@end
