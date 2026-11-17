//
//  SystemInfoModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/29.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemLabelModel : NSObject
@property (retain, nonatomic) NSString *label;
@property (retain, nonatomic) NSString *value;
@end

@interface SystemInfoModel : NSObject

@property (strong, nonatomic) NSArray *occupation;
@property (strong, nonatomic) NSArray *education;
@property (strong, nonatomic) NSArray *politics;
@end

NS_ASSUME_NONNULL_END
