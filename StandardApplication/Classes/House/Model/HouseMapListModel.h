//
//  HouseMapListModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/18.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseMapListModel : NSObject

@property (retain, nonatomic) NSString *latitude;
@property (retain, nonatomic) NSString *longitude;
@property (retain, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger num;
@end

NS_ASSUME_NONNULL_END
