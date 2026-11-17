//
//  NewWaitProjctListModel.h
//  StandardApplication
//
//  Created by DTiOS on 2023/12/14.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewWaitProjctListModel : NSObject

@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *area;
@property (retain, nonatomic) NSString *address;
@property (assign, nonatomic) NSInteger min_rent;
@property (assign, nonatomic) NSInteger max_rent;
@property (strong, nonatomic) NSString *rentString;
@property (strong, nonatomic) NSString *desc;
@property (retain, nonatomic) NSString *phone;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSArray *images;
@property (assign, nonatomic) NSInteger unit_count;
@property (assign, nonatomic) NSInteger waiting_count;
@property (assign, nonatomic) NSInteger waiting_status;


@end

NS_ASSUME_NONNULL_END
