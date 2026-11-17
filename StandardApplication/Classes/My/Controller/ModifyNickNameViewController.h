//
//  ModifyNickNameViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ModifyNickNameViewController : BaseViewController
@property (nonatomic, copy) void (^saveNickNameBlock)(NSString *nickNameStr);
@end

NS_ASSUME_NONNULL_END
