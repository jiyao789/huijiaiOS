//
//  IOSmd5.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/29.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IOSmd5 : NSObject

+ (NSString *)md5:(NSString *)inPutText;

@end

NS_ASSUME_NONNULL_END
