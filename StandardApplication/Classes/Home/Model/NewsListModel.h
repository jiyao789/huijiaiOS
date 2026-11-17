//
//  NewsListModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/3.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsModel : NSObject

@property (assign, nonatomic) NSInteger *new_id;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *file_url;
@property (retain, nonatomic) NSString *created_time;

@end

@interface NewsListModel : NSObject

@property (retain, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray *list;

@end

NS_ASSUME_NONNULL_END
