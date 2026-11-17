//
//  SpaceIndexModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/31.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpaceIndexModel : NSObject
@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *space_name;
@property (strong, nonatomic) NSString *space_img;
@property (strong, nonatomic) NSArray *space_imgArr;
@property (assign, nonatomic) NSInteger people_number;
@end

NS_ASSUME_NONNULL_END
