//
//  CommunityActivityWebView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "CommunityActivityWebView.h"

@interface CommunityActivityWebView ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@end

@implementation CommunityActivityWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addWebViewObserver];
    }
    return self;
}

- (void)loadWebView {
    
    if (IsStrEmpty(self.webUrl)) {
        [self.myWebView loadHTMLString:self.webContentStr baseURL:nil];
    } else {
        if (![self.webUrl containsString:@"#"]) {
            self.webUrl = [self.webUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        NSURL *url = [NSURL URLWithString:self.webUrl];
        NSLog(@"web URL = %@",url);
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)addWebViewObserver {
    @weakify(self)
    
    [RACObserve(self.myWebView, estimatedProgress) subscribeNext:^(id x) {
        double estimatedProgress = [x doubleValue];
        @strongify(self)
        self.progressView.progress = estimatedProgress;
        if (estimatedProgress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                self.progressView.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
                self.progressView.hidden = YES;
            }];
        }else {
            self.progressView.hidden = NO;
        }
    }];
}

#pragma mark - WKUIDelegate
#pragma mark - WKNavigationDelegate

// 这个是决定是否Request
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    WKFrameInfo *targetFrameInfo = navigationAction.targetFrame;
    
    if (targetFrameInfo) {

        if (![navigationAction.request.URL.scheme isEqualToString:@"http"] &&
            ![navigationAction.request.URL.scheme isEqualToString:@"https"]) {
            
            //别的scheme,比如跳转外部APP，放开跳转
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:nil];
        }
        decisionHandler(WKNavigationActionPolicyAllow);

    } else {

        NSURL *url = navigationAction.request.URL;

        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];

        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    NSLog(@"createWebViewWithConfiguration");
//    if (!navigationAction.targetFrame.isMainFrame) {
//        [webView loadRequest:navigationAction.request];
//    }
    return nil;
}

// 决定是否接收响应
// 这个是决定是否接收response
// 要获取response，通过WKNavigationResponse对象获取
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 当main frame的导航开始请求时，会调用此方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

//请求结束
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
//    [_webViewBridge callHandler:@"ready"];
    //WKWebview 禁止长按(超链接、图片、文本...)弹出效果
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"completionHandler:nil];
}

// 当main frame接收到服务重定向时，会回调此方法
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

// 当main frame开始加载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}

// 当main frame的web内容开始到达时，会回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
}
// 9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
    [webView reload];
}

//信任证书
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
                completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
}

- (WKWebView *)myWebView
{
    if (_myWebView == nil) {
        NSString *injectionJSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content','width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

        WKUserScript *injectionJSStringScript = [[WKUserScript alloc] initWithSource:injectionJSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];

        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
            
        WKUserContentController *userController = [WKUserContentController new];
        [userController addUserScript:injectionJSStringScript];
        [userController addUserScript:noneSelectScript];
            
        WKWebViewConfiguration *config          = [[WKWebViewConfiguration alloc]init];
        config.preferences                      = [WKPreferences new];
        config.preferences.minimumFontSize      = 10;
        config.preferences.javaScriptEnabled    = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        config.userContentController = userController;
        _myWebView = [[WKWebView alloc] initWithFrame:self.bounds];
        _myWebView.UIDelegate = self;
        _myWebView.navigationDelegate = self;
        _myWebView.backgroundColor = [UIColor whiteColor];
        _myWebView.allowsBackForwardNavigationGestures = YES;
        _myWebView.scrollView.bounces = YES;
        _myWebView.scrollView.bouncesZoom = YES;
        _myWebView.scrollView.showsHorizontalScrollIndicator = NO;
        _myWebView.scrollView.showsVerticalScrollIndicator = NO;
        _myWebView.scrollView.directionalLockEnabled = YES;
//        _myWebView.scrollView.scrollEnabled = YES;
        _myWebView.scrollView.delegate = self;
        [_myWebView setAllowsLinkPreview:false];
        if (@available(iOS 11.0, *)) {
            _myWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
//            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return _myWebView;
}

- (YDProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[YDProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _progressView.trackTintColor = [UIColor whiteColor];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"0x72A438"];
        _progressView.transform = CGAffineTransformMakeScale(1, 3.0f);
        _progressView.progress = 0.05; //设置初始值，防止网页加载过慢时没有进度
    }
    return _progressView;
}

@end
