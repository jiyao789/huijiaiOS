//
//  MessageIndexModel.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/2.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MessageIndexModel.h"

@implementation MessageModel


@end

@implementation MessageIndexModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"system_message" : @"MessageModel",
        @"pay_message" : @"MessageModel",
        @"contract_message" : @"MessageModel",
        @"internal_message" : @"MessageModel"
    };
}

- (BOOL)isSystem
{
    NSArray *markArr = [_content_mark mj_JSONObject];
    for (NSString *mark in markArr) {
        if ([mark integerValue] == 2) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isPay
{
    NSArray *markArr = [_content_mark mj_JSONObject];
    for (NSString *mark in markArr) {
        if ([mark integerValue] == 3) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isContract
{
    NSArray *markArr = [_content_mark mj_JSONObject];
    for (NSString *mark in markArr) {
        if ([mark integerValue] == 4) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isWorkOrder
{
    NSArray *markArr = [_content_mark mj_JSONObject];
    for (NSString *mark in markArr) {
        if ([mark integerValue] == 5) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isPush
{
    NSArray *markArr = [_content_mark mj_JSONObject];
    for (NSString *mark in markArr) {
        if ([mark integerValue] == 6) {
            return YES;
        }
    }
    return NO;
}

@end
