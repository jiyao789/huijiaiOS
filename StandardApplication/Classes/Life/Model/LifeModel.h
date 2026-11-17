//
//  LifeModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/1.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListModel : NSObject
@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) NSString *image_url;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *link;
@property (retain, nonatomic) NSString *content;
@end

@interface LifeModel : NSObject
@property (retain, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSArray *list;
@end

NS_ASSUME_NONNULL_END
