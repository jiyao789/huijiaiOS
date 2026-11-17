//
//  ECLocationManager.h
//  StandardApplication
//
//  Created by chao on 2019/12/11.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


typedef void (^LocationBlock)(CLLocationCoordinate2D locationCorrrdinate);
typedef void (^LocationErrorBlock) (NSError *error);
typedef void(^NSStringBlock)(NSString *cityString);
typedef void(^NSStringBlock)(NSString *addressString);


NS_ASSUME_NONNULL_BEGIN

@interface ECLocationManager : NSObject
@property (nonatomic)CLLocationCoordinate2D currentCoordinate;
@property(nonatomic,strong)NSString *currentCity;
@property (nonatomic,strong)NSString *currentAddress;
@property(nonatomic,assign)float latitude;
@property(nonatomic,assign)float longitude;


+ (ECLocationManager *)shareLocation;

/**

 *  获取坐标

 *

 *  @param locaiontBlock locaiontBlock description

 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock;

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock errorHandle:(void (^) (NSError * error))errorHandle;

/**

 *  获取坐标和详细地址
 */

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock withAddress:(NSStringBlock) addressBlock;

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock placemark:(void (^) (CLPlacemark * placeMark))placeMarkHandle;

/**

 *  获取详细地址

 *

 *  @param addressBlock addressBlock description

 */

- (void) getAddress:(NSStringBlock)addressBlock;



/**

 *  获取城市

 *

 *  @param cityBlock cityBlock description

 */

- (void) getCity:(NSStringBlock)cityBlock;


@end

NS_ASSUME_NONNULL_END
