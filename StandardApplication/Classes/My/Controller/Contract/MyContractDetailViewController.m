//
//  MyContractDetailViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyContractDetailViewController.h"
#import "MacroDefine.h"
#import "SurrenderViewController.h"
#import "ContinueContractViewController.h"
#import "ProtocolBaseWKWebViewController.h"
#import "PersonalInfoView.h"

@interface MyContractDetailViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *surrenderBtn;
@property (weak, nonatomic) IBOutlet UIButton *continueContractBtn;
@property (weak, nonatomic) IBOutlet UIButton *signContractBtn;

@property (strong, nonatomic) WKWebView *myWebView;

@property (nonatomic, strong) YDProgressView *progressView;
@end

@implementation MyContractDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"合同信息";
    
    [self.view addSubview:self.myWebView];
    [self.view addSubview:self.progressView];
    
    if (_contractStatus == 2) {
        _bottomViewLayoutHeight.constant = TABBAR_HEIGHT + 30;
        _bottomView.hidden = NO;
        _surrenderBtn.hidden = NO;
        _continueContractBtn.hidden = NO;
        _signContractBtn.hidden = YES;
        if (![NSDate compareOneDay:[NSDate getNextMonth:[NSDate date]] withAnotherDay:[NSDate stringToDate:NONullString(_end_date)]]) {
            [_continueContractBtn setBackgroundColor:[UIColor colorWithHexString:@"#EEEEEE"]];
            _continueContractBtn.userInteractionEnabled = NO;
        }
    } else if (_contractStatus == 6) {
        _bottomViewLayoutHeight.constant = TABBAR_HEIGHT + 30;
        _bottomView.hidden = NO;
        _surrenderBtn.hidden = YES;
        _continueContractBtn.hidden = YES;
        _signContractBtn.hidden = NO;
    } else {
        _bottomViewLayoutHeight.constant = 0;
        _bottomView.hidden = YES;
    }
    
    if (!IsStrEmpty(_webUrl)) {
        [self loadWebView];
    } else {
        [self getContractPreviewDate];
    }
    
    [self addWebViewObserver];
}

- (void)getContractPreviewDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:contract_previewURL parameters:@{@"c_id":@(_cid)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            [self.myWebView loadHTMLString:NONullString(dic[@"template"]) baseURL:nil];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)loadWebView {
    if (![self.webUrl containsString:@"#"]) {
        self.webUrl = [self.webUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    NSURL *url = [NSURL URLWithString:self.webUrl];
    NSLog(@"web URL = %@",url);
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (IBAction)contractBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            [self getReatRenewDetailDate];
            break;
        }
        case 1:
        {
            [self getReatRenewReatDetailDate];
            break;
        }
        case 2:
        {
            // 法大大用户注册
            [self getFadadaRegisterInfo];
            break;
        }
        default:
            break;
    }
}

// 退租
- (void)getReatRenewDetailDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:reatRenew_renew_detailURL parameters:@{@"contract_id":@(_cid)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            SurrenderViewController *vc = [SurrenderViewController new];
            vc.cid = _cid;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

// 续租
- (void)getReatRenewReatDetailDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:reatRenew_reat_detailURL parameters:@{@"contract_id":@(_cid)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            ContinueContractViewController *vc = [ContinueContractViewController new];
            vc.cid = _cid;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

// 法大大用户注册
- (void)getFadadaRegisterInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:faDada_registerURL parameters:@{} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            [self getFaDadaVerify_signInfo];
        } else if (status == 403) {
            
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

// 显示补充身份信息
- (void)showPersonalInfoView
{
    PersonalInfoView *personalInfoView = [PersonalInfoView createViewFromNib];
    personalInfoView.layer.cornerRadius = 10;
    personalInfoView.layer.masksToBounds = YES;
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:personalInfoView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    alertController.tapBackgroundDismissEnable = NO;
    KWeakSelf
    personalInfoView.personInfoCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    };
    personalInfoView.personInfoCommitBlock = ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
        [weakSelf getFadadaRegisterInfo];
    };
    [self presentViewController:alertController animated:YES completion:nil];
}

// 法大大电子协议签署
- (void)getFaDadaVerify_signInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:faDada_verify_signURL parameters:@{@"contract_id":NONullString(self.contract_id),@"return_url":@"https://www.wdit.com.cn"} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            ProtocolBaseWKWebViewController *webVc = [[ProtocolBaseWKWebViewController alloc] init];
            webVc.webTitle = @"电子合同签署";
            webVc.webUrl = [NSString stringWithFormat:@"%@",dic[@"url"]];
            [self.navigationController pushViewController:webVc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
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
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
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
        _myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, ((_contractStatus == 2 || _contractStatus == 6) ? (ContentHeight - 30) : (SCREEN_HEIGHT - NAVBAR_HEIGHT)))];
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
//        _myWebView.scrollView.delegate = self;
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
        _progressView = [[YDProgressView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, 1)];
        _progressView.trackTintColor = [UIColor whiteColor];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"0x72A438"];
        _progressView.transform = CGAffineTransformMakeScale(1, 3.0f);
        _progressView.progress = 0.05; //设置初始值，防止网页加载过慢时没有进度
    }
    return _progressView;
}

@end
