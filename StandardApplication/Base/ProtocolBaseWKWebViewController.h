//
//  ProtocolBaseWKWebViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2020/4/12.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProtocolBaseWKWebViewController : BaseViewController

@property (nonatomic,copy) NSString *webTitle;

@property (nonatomic,copy) NSString *webUrl;

@property (nonatomic,copy) NSString *htmlStr;

@end


NS_ASSUME_NONNULL_END
