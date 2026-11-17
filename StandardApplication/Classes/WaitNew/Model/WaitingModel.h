//
//  WaitingModel.h
//  StandardApplication
//
//  Created by DTiOS on 2023/12/19.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaitingModel : NSObject
@property (retain, nonatomic) NSString *number;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger before;
@end

NS_ASSUME_NONNULL_END
