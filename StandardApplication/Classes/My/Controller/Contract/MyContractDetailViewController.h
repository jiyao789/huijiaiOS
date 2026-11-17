//
//  MyContractDetailViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>
#import "YDProgressView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyContractDetailViewController : BaseViewController
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, strong) NSString *contract_id;
@property (nonatomic, assign) NSInteger contractStatus;
@property (strong, nonatomic) NSString *webUrl;
@property (strong, nonatomic) NSString *end_date;
@end

NS_ASSUME_NONNULL_END
