//
//  MyInfoModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageModel : NSObject
@property (retain, nonatomic) NSString *imageName;
@property (retain, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger actionType;
@end

@interface MyInfoModel : NSObject
@property (retain, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *image;
@property (assign, nonatomic) NSInteger shadow;
@end

NS_ASSUME_NONNULL_END
