//
//  HouseLocationViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/24.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HouseLocationViewController.h"
#import "MacroDefine.h"
#import "CustomAnnotationView.h"

@interface HouseLocationViewController ()<MAMapViewDelegate,AMapSearchDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *mapSearch;
@end

@implementation HouseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"房源位置";
    
    self.viewLayoutTop.constant = NAVBAR_HEIGHT;
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    //map
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.showsCompass = NO;
    self.mapView.delegate = self;
    self.mapView.showsScale = NO;
    self.mapView.zoomLevel = 13.2;
    
    self.mapSearch = [[AMapSearchAPI alloc] init];
    self.mapSearch.delegate = self;
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = !IsStrEmpty(_addressStr) ? NONullString(_addressStr) : [NSString stringWithFormat:@"%@%@%@%@%ld号",NONullString(_regionModel.province_name),NONullString(_regionModel.city_name),NONullString(_regionModel.county_name),NONullString(_regionModel.address),(long)_regionModel.number];
    NSLog(@"geo.address=========%@",geo.address);
    [self.mapSearch AMapGeocodeSearch:geo];
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    AMapGeocode *mapGeocode = response.geocodes[0];
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(mapGeocode.location.latitude, mapGeocode.location.longitude);
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(mapGeocode.location.latitude, mapGeocode.location.longitude);
    pointAnnotation.title = !IsStrEmpty(_projectName) ? NONullString(_projectName) : NONullString(_regionModel.name);
    [self.mapView addAnnotation:pointAnnotation];
    
    NSLog(@"latitude = %f longitude = %f",mapGeocode.location.latitude,mapGeocode.location.longitude);
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

@end
