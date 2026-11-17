//
//  NSURL+YBExstension.m
//  StandardApplication
//
//  Created by liyuanbo on 2021/2/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "NSURL+YBExstension.h"
#import <objc/runtime.h>

@implementation NSURL (YBExstension)

- (void)setFileIdentifier:(NSString *)fileIdentifier
{
    objc_setAssociatedObject(self, @selector(fileIdentifier), fileIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)fileIdentifier
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
