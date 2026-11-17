//
//  CommunityActivityWebView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>
#import "YDProgressView.h"
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityActivityWebView : UIView
@property (strong, nonatomic) WKWebView *myWebView;
@property (copy, nonatomic) NSString *webContentStr;
@property (copy, nonatomic) NSString *webUrl;
@property (nonatomic, strong) YDProgressView *progressView;

- (void)loadWebView;
@end

NS_ASSUME_NONNULL_END
