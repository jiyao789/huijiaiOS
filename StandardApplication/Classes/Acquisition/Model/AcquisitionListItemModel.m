//
//  AcquisitionListItemModel.m
//  StandardApplication
//
//  Property acquisition declaration list item model
//

#import "AcquisitionListItemModel.h"
#import "MJExtension.h"

@implementation AcquisitionListItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"itemId": @"id",
        @"declareTime": @"declare_time"
    };
}

@end
