//
//  HouseViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/18.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HouseViewController.h"
#import "MacroDefine.h"
#import "ChooseClassifyView.h"
#import "HomeHouseTableViewCell.h"
#import "HouseDetailViewController.h"
#import "MapSearchHouseViewController.h"
#import "HouseListModel.h"
#import "HouseDetailModel.h"
#import "SearchViewController.h"
#import "HouseMapListModel.h"
#import "CustomAnnotationView.h"

@interface HouseViewController ()<UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate,AMapLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet ChooseClassifyView *chooseClassifyView;
@property (weak, nonatomic) IBOutlet UITableView *houseTableView;
@property (weak, nonatomic) IBOutlet UIImageView *houseMapImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutHeight;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchSelectViewLayoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBgViewLayoutHeight;
@property (strong, nonatomic) IBOutlet UIView *headerTableView;
@property (weak, nonatomic) IBOutlet UIView *searchBgView;

@property (nonatomic, strong) AMapLocationManager * locationManager;
@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *houseListArr;
@property (strong, nonatomic) NSMutableDictionary *houseUnitFilterDic;
@property (strong, nonatomic) NSString *recodeTokenStr;
@property (strong, nonatomic) NSMutableArray *mapHouseListArr;
@end

@implementation HouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.hideNaviBar = YES;
    self.statusBarStyle = UIStatusBarStyleDefault;
    _searchSelectViewLayoutTop.constant = STATUSBAR_HEIGHT;
    _searchBgViewLayoutHeight.constant = 102 + STATUSBAR_HEIGHT;
    _recodeTokenStr = [User shareUser].token;
    _houseTableView.tableHeaderView = _headerTableView;
    [self setupRefreshWithTableView:_houseTableView];
    adjustsScrollViewInsets_NO(_houseTableView, self);
    
    KWeakSelf
    _chooseClassifyView.needNewLayoutHouseType = 1;
    _chooseClassifyView.isHouseType = 1;
    _chooseClassifyView.ChooseClassifyViewBlock = ^(NSInteger height) {
        weakSelf.viewLayoutHeight.constant = 102 + height;
    };
    _chooseClassifyView.chooseClassifyViewFilterBlock = ^(NSMutableDictionary * _Nullable unitFilterDic) {
        weakSelf.houseUnitFilterDic = unitFilterDic;
        weakSelf.pageIndex = 1;
        [weakSelf getUnitIndexDate];
    };
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    //map
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 12.7;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(31.147977, 121.426382);
    
    [self.houseMapImageView whenTapped:^{
        MapSearchHouseViewController *vc = [MapSearchHouseViewController new];
        vc.isNeedBlock = NO;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [_searchView whenTapped:^{
        SearchViewController *vc = [SearchViewController new];
        [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
    }];
    
    // 获取地图上数据
    [self getUnitMapListDate];
    
    _pageIndex = 1;
    [self getUnitIndexDate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    _pageIndex = 1;
//    [self getUnitIndexDate];
    
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
//    self.houseNameStr = @"";
//    self.pageIndex = 1;
//    self.chooseClassifyView.needResetSelect = YES;
//    [self.houseUnitFilterDic removeAllObjects];
//    [self getUnitIndexDate];
//}

- (void)getUnitIndexDate
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(_pageIndex) forKey:@"page"];
    [para setObject:@(10) forKey:@"page_rows"];
    [para setObject:NONullString([User shareUser].getUserId) forKey:@"u_id"];
    if (_houseUnitFilterDic.allKeys.count > 0) {
        [para addEntriesFromDictionary:_houseUnitFilterDic];
    }
//    if (!IsStrEmpty(_houseNameStr)) {
//        [para setObject:NONullString(_houseNameStr) forKey:@"region_name"];
//    }
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
                [self.houseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.houseTableView.mj_footer endRefreshing];
            }
            [self.houseTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getUnitIndexDate];
    [_houseTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getUnitIndexDate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.houseListArr.count;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"==============%f",offsetY);
    if (offsetY > (330 - 102 - NAVBAR_HEIGHT)) {
        self.searchBgView.backgroundColor = [UIColor whiteColor];
    } else {
        self.searchBgView.backgroundColor = [UIColor clearColor];
    }
}

//- (void)createNotificationCenterInfo:(HouseListModel *)model
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HouseCollectNotification" object:nil userInfo:model.mj_keyValues];
//}
//
//- (void)getNotificationCenterInfo
//{
//    if (self.houseListArr.count == 0) {
//        return;
//    }
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
//    
//    //接收通知
//    RACSignal *signalApply = [[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HouseApplyNotification" object:nil];
//    //设置接收通知的回调处理
//    [signalApply subscribeNext:^(NSNotification *x) {
//        NSLog(@"HouseApplyNotification == %@",x.userInfo);
//        HouseDetailModel *notiModel = [HouseDetailModel mj_objectWithKeyValues:x.userInfo];
//        for (HouseListModel *model in weakSelf.houseListArr) {
//            if (model.unit_id == notiModel.unit_id) {
//                [weakSelf.houseListArr removeObject:model];
//                break;
//            }
//        }
//        [weakSelf.houseTableView reloadData];
//    }];
//}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager
{
    //未打开定位
    [locationManager requestWhenInUseAuthorization];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"当前位置： %@",location);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    [MBProgressHUD showMessag:@"定位失败，请去设置中打开APP的定位后再试" toView:self.view];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager startUpdatingLocation];
    }
}

- (void)getUnitMapListDate
{
    [HttpRequest requestArrUrlPath:ReleaseBaseURL urlPath:unit_listings_mapURL parameters:@{} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            NSMutableArray *houseArr = [HouseMapListModel mj_objectArrayWithKeyValuesArray:arr];
            for (HouseMapListModel *model in houseArr) {
                MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
                pointAnnotation.coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
                pointAnnotation.subtitle = NONullString(model.name);
                pointAnnotation.title = [NSString stringWithFormat:@"%@（%ld套）",NONullString(model.name),(long)model.num];
                [self.mapHouseListArr addObject:pointAnnotation];
            }
            [self.mapView addAnnotations:self.mapHouseListArr];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
        {
            static NSString *reuseIndetifier = @"annotationReuseIndetifier";
            CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
                annotationView.canShowCallout= NO;
                annotationView.draggable = YES;
                annotationView.calloutOffset = CGPointMake(0, -5);
            }
            annotationView.calloutView.title = annotation.title;
            return annotationView;
        }
        return nil;
}

#pragma mark - lazyloads
- (AMapLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [AMapLocationManager new];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (NSMutableArray *)houseListArr
{
    if (!_houseListArr) {
        _houseListArr = [NSMutableArray array];
    }
    return _houseListArr;
}

- (NSMutableArray *)mapHouseListArr
{
    if (!_mapHouseListArr) {
        _mapHouseListArr = [NSMutableArray array];
    }
    return _mapHouseListArr;
}

@end
