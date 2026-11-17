//
//  MapSearchHouseViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/24.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MapSearchHouseViewController.h"
#import "MacroDefine.h"
#import "HouseSearchNaviView.h"
#import "HouseMapListModel.h"
#import "CustomAnnotationView.h"
#import "ShowMapSelectHouseView.h"

@interface MapSearchHouseViewController ()<MAMapViewDelegate>
@property (strong, nonatomic)HouseSearchNaviView *houseSearchNaviView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet MAMapView *mapView;

@property (strong, nonatomic) NSMutableArray *mapHouseListArr;
@end

@implementation MapSearchHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.houseSearchNaviView.searchTitleLab.text = @"搜索内容";
    [self.gk_navigationBar addSubview:self.houseSearchNaviView];
    
    self.viewLayoutTop.constant = NAVBAR_HEIGHT;
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    //map
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(31.147977, 121.426382);
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.zoomLevel = 13.2;
    
    [self getUnitListDate];
}

- (void)getUnitListDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:ReleaseBaseURL urlPath:unit_listings_mapURL parameters:@{} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
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

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        NSLog(@"===========%@",view.annotation.subtitle);
        if (_isNeedBlock) {
            SAFE_BLOCK(self.mapSearchHouseBlock,NONullString(view.annotation.subtitle));
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showShowMapSelectHouseView:NONullString(view.annotation.title) subTitle:NONullString(view.annotation.subtitle)];
            
            [mapView deselectAnnotation:view.annotation animated:YES];
        }
    }
}

- (void)showShowMapSelectHouseView:(NSString *)title subTitle:(NSString *)subTitle
{
    ShowMapSelectHouseView *showMapSelectHouseView = [ShowMapSelectHouseView createViewFromNib];
    showMapSelectHouseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 450);
    showMapSelectHouseView.navigation = self.navigationController;
    showMapSelectHouseView.nameLab.text = title;
    showMapSelectHouseView.houseNameStr = subTitle;
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:showMapSelectHouseView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    alertController.alertOriginY = SCREEN_HEIGHT - 450;
    showMapSelectHouseView.didDismissBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (HouseSearchNaviView *)houseSearchNaviView
{
    if (!_houseSearchNaviView) {
        _houseSearchNaviView = [HouseSearchNaviView viewFromXib];
        _houseSearchNaviView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    }
    return _houseSearchNaviView;
}

- (NSMutableArray *)mapHouseListArr
{
    if (!_mapHouseListArr) {
        _mapHouseListArr = [NSMutableArray array];
    }
    return _mapHouseListArr;
}
@end
