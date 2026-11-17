//
//  WaitNotesModel.h
//  StandardApplication
//
//  Created by DTiOS on 2023/6/17.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaitNotesModel : NSObject
@property (assign, nonatomic) NSInteger new_id;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *file_url;
@property (retain, nonatomic) NSString *created_time;
@end

NS_ASSUME_NONNULL_END
