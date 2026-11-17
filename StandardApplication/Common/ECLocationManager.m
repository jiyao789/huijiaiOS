//
//  ECLocationManager.m
//  StandardApplication
//
//  Created by chao on 2019/12/11.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "ECLocationManager.h"
#import "MacroDefine.h"


@interface ECLocationManager ()<CLLocationManagerDelegate>
{
    CLLocationManager *_manager;
    
}
@property (nonatomic,copy) LocationBlock locationBlock;

@property (nonatomic,copy) NSStringBlock cityBlock;

@property (nonatomic,copy) NSStringBlock addressBlock;

@property (nonatomic,copy) LocationErrorBlock errorBlock;

@property (nonatomic,copy) void (^PlacemarkHandle) (CLPlacemark *);

@end

@implementation ECLocationManager


+ (ECLocationManager *)shareLocation{

    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        
    });
    return _sharedObject;
}
//获取经纬度

- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock

{
    self.locationBlock = [locaiontBlock copy];
    [self startLocation];
}

- (void)getLocationCoordinate:(LocationBlock)locaiontBlock errorHandle:(void (^)(NSError * _Nonnull))errorHandle
{
    self.locationBlock = locaiontBlock;
    self.errorBlock = errorHandle;
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock withAddress:(NSStringBlock) addressBlock

{
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void)getLocationCoordinate:(LocationBlock)locaiontBlock placemark:(void (^)(CLPlacemark * _Nonnull))placeMarkHandle
{
    self.locationBlock = locaiontBlock;
    self.PlacemarkHandle = placeMarkHandle;
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock

{
    self.addressBlock = [addressBlock copy];
    [self startLocation];

}

//获取省市

- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //当前所在城市坐标值
    CLLocation *curLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:curLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] >0)
        {
            CLPlacemark *placemark  = placemarks[0];
            self.currentCity = [NSString stringWithFormat:@"%@%@",placemark.administrativeArea,placemark.locality];
            self.currentAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@",placemark.country,placemark.administrativeArea,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare];
            
            if (self.cityBlock)
            {
                self.cityBlock(self.currentCity);
                self.cityBlock = nil;
            }
            if (self.addressBlock) {
                self.addressBlock(self.currentAddress);
                self.addressBlock = nil;
            }
            if (self.PlacemarkHandle) {
                self.PlacemarkHandle(placemark);
                self.PlacemarkHandle = nil;
            }
        }
    }];

   _currentCoordinate = CLLocationCoordinate2DMake(curLocation.coordinate.latitude, curLocation.coordinate.longitude);
    if (_locationBlock) {
        _locationBlock(_currentCoordinate);
        _locationBlock = nil;
    }
    [manager stopUpdatingLocation];
}
-(void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        [_manager requestWhenInUseAuthorization];
        _manager.distanceFilter=5.0;
        [_manager startUpdatingLocation];
        
    }else
    {
        UIAlertController  *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL*settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];

        }];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alertVC  addAction:cancel];
        [alertVC addAction:ok];

        [[CommonUtils getCurrentViewController] presentViewController:alertVC animated:YES completion:nil];
        
        SAFE_BLOCK(self.errorBlock,[NSError errorWithDomain:NSCocoaErrorDomain code:-1111 userInfo:@{NSLocalizedDescriptionKey : @"需要开启定位服务,请到设置->隐私,打开定位服务"}]);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopLocation];
    SAFE_BLOCK(self.errorBlock,error);
}

-(void)stopLocation
{
    _manager = nil;
}

 CLLocationCoordinate2D gdTobd(double lat ,double lon)
{
    double x_pi = M_PI * 3000.0 / 180.0;
    double x = lon, y = lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(z * sin(theta)+0.006, z * cos(theta)+0.0065);
    return coordinate;
}
 CLLocationCoordinate2D bdTogd(double lat ,double lon)
{
    double x_pi = M_PI * 3000.0 / 180.0;
    double x = lon - 0.0065, y = lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(z * sin(theta), z * cos(theta));
    return coordinate;
}




@end
