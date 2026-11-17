//
//  WebViewJavascriptBridgeBase.h
//
//  Created by @LokiMeyburg on 10/15/14.
//  Copyright (c) 2014 @LokiMeyburg. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOldProtocolScheme @"https"
#define kNewProtocolScheme @"rmt"
#define kQueueHasMessage   @"__queue_message__"
#define kINSPECTHasMessage @"__inspect__"
#define kBridgeLoaded      @"return/_fetchQueue"


typedef NS_ENUM(NSInteger,WVJBResponseState) {
    WVJBResponse_success = 0,
    WVJBResponse_fail,
    WVJBResponse_complete, // 自动调用，无需手动操作
    WVJBResponse_progress,
    WVJBResponse_cancel
};
typedef void (^WVJBResponseCallback)(WVJBResponseState state,id responseData);
typedef void (^WVJBHandler)(id data, WVJBResponseCallback responseCallback);
typedef NSDictionary WVJBMessage;

@protocol WebViewJavascriptBridgeBaseDelegate <NSObject>
- (NSString*) _evaluateJavascript:(NSString*)javascriptCommand;
@end

@interface WebViewJavascriptBridgeBase : NSObject

@property (weak, nonatomic) id <WebViewJavascriptBridgeBaseDelegate> delegate;
@property (strong, nonatomic) NSMutableArray* startupMessageQueue;
@property (strong, nonatomic) NSMutableDictionary* responseCallbacks;
@property (strong, nonatomic) NSMutableDictionary* messageHandlers;
@property (strong, nonatomic) WVJBHandler messageHandler;

+ (void)enableLogging;
+ (void)setLogMaxLength:(int)length;
- (void)reset;
- (void)sendData:(id)data responseCallback:(WVJBResponseCallback)responseCallback handlerName:(NSString*)handlerName;
- (void)flushMessageQueue:(NSString *)messageQueueString;
- (void)injectJavascriptFile;
- (BOOL)isWebViewJavascriptBridgeURL:(NSURL*)url;
- (BOOL)isQueueMessageURL:(NSURL*)url;
- (BOOL)isINSPECTMessageURL:(NSURL*)url;
- (BOOL)isBridgeLoadedURL:(NSURL*)url;
- (void)logUnkownMessage:(NSURL*)url;
- (NSString *)webViewJavascriptCheckCommand;
- (NSString *)webViewJavascriptFetchQueyCommand;
- (void)disableJavscriptAlertBoxSafetyTimeout;
- (void)_evaluateJavascriptMessage:(WVJBMessage*)message;

@end
