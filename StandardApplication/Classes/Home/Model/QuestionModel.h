//
//  QuestionModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/12/6.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionModel : NSObject

@property (retain, nonatomic) NSString *question;
@property (retain, nonatomic) NSString *answerA;
@property (retain, nonatomic) NSString *answerB;
@property (retain, nonatomic) NSString *select;

@end

NS_ASSUME_NONNULL_END
