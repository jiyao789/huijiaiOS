//
//  ProtocolBaseWKWebViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2020/4/12.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import "ProtocolBaseWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "MacroDefine.h"
#import "WKWebViewJavascriptBridge.h"
#import "YDProgressView.h"
#import "MyContractListViewController.h"

@interface ProtocolBaseWKWebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *wkWebview;
@property (nonatomic, strong) WKWebViewJavascriptBridge* webViewBridge;
@property (nonatomic,strong) YDProgressView *progressView;

@end

@implementation ProtocolBaseWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self leftBarItem];
    self.navTitle = _webTitle;
    
    if (!IsStrEmpty(_webUrl)) {
        [self reloadUrl];
    } else if (!IsStrEmpty(_htmlStr)) {
        [self reloadHtmlStr];
    }
    
    [self addWebViewObserver];
}

// 重写返回按钮方法
- (void)backAction
{
    if (self.wkWebview.canGoBack == YES) {
        [self.wkWebview goBack];
        // 是否需要刷新
//        [self.wkWebview reload];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


// 懒加载WKWebView
- (WKWebView *)wkWebview
{
    if (_wkWebview == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];

        _wkWebview = [[WKWebView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT) configuration:configuration];
        _wkWebview.UIDelegate = self;
        _wkWebview.navigationDelegate = self;
        _wkWebview.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _wkWebview.configuration.allowsInlineMediaPlayback = YES;
        
        [self.view addSubview:_wkWebview];
    }
    return _wkWebview;
}

// 加载url
-(void)reloadUrl
{
    if (![self.webUrl containsString:@"#"]) {
        self.webUrl = [self.webUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    NSURL *url = [NSURL URLWithString:self.webUrl];
    NSLog(@"web URL = %@",url);
    [self.wkWebview loadRequest:[NSURLRequest requestWithURL:url]];
}

// 加载html
-(void)reloadHtmlStr
{
    NSString *headerString = @"<head><style>img{max-width:100vw !important;}</style></head>";
    [self.wkWebview loadHTMLString:[headerString stringByAppendingString:self.htmlStr] baseURL:nil];
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

- (void)addWebViewObserver {
    @weakify(self)
    
    [RACObserve(self.wkWebview, estimatedProgress) subscribeNext:^(id x) {
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

// 这个是决定是否Request
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    WKFrameInfo *targetFrameInfo = navigationAction.targetFrame;
    NSLog(@"webViewUrl-=-=-=-=-=-=-=-=-=%@",navigationAction.request.URL.absoluteString);
    if (targetFrameInfo) {

        if (![navigationAction.request.URL.scheme isEqualToString:@"http"] &&
            ![navigationAction.request.URL.scheme isEqualToString:@"https"]) {
            
            //别的scheme,比如跳转外部APP，放开跳转
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:nil];
        }
        
        if ([navigationAction.request.URL.absoluteString containsString:@"https://www.wdit.com.cn"]) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MyContractListViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
        
        decisionHandler(WKNavigationActionPolicyAllow);

    } else {

        NSURL *url = navigationAction.request.URL;

        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];

        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [MBProgressHUD showStatus:nil toView:self.view];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [MBProgressHUD dismissHUDForView:self.view];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [MBProgressHUD dismissHUDForView:self.view];
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setAlpha:0.0f];
}

@end
