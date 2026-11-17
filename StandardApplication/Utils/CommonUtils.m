//
//  CommonUtils.m
//  ZiWeiDai
//
//  Created by fc_curry on 2017/3/9.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "CommonUtils.h"
@import WechatOpenSDK;
#import "LoginViewController.h"

@implementation CommonUtils
static CommonUtils *commonUtils = nil;
//创建单例
+ (instancetype)sharedCommonUtils{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        commonUtils = [[super allocWithZone:NULL] init];
    });
    return commonUtils;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedCommonUtils];
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return self;
}


+ (void)FS_Archiver:(id)obj fileStr:(NSString*)fileStr{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
    NSString *accountPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileStr]];
    NSLog(@"用户存储路径 = %@",accountPath);
    [NSKeyedArchiver archiveRootObject:obj toFile:accountPath];
    
}

+ (id)FS_UnArchiverfileStr:(NSString*)fileStr{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
    NSString *accountPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileStr]];
    NSLog(@"用户存储路径 = %@",accountPath);
    return [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
    
}
- (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"^([a-z0-9A-Z]+[-_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)isValidatePhone:(NSString *)phoneStr
{
    NSString * MOBILE = @"^1[3-9]\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if ([regextestmobile evaluateWithObject:phoneStr] == YES) {
        return YES;
    }else{
        return NO;
    }
}
//  判断注册密码
+ (BOOL)isValidateRegisterPsd:(NSString *)psdStr
{
    NSString *registerStr = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *registerTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", registerStr];
    return [registerTest evaluateWithObject:psdStr];
}

+ (UIImage *)gradientColorToImage:(NSArray *)colors startPos:(CGPoint)startPos endPos:(CGPoint)endPos imgSize:(CGSize)imgSize
{
    NSMutableArray * mutableArray = [NSMutableArray array];
    
    for(UIColor * color in colors)
    {
        [mutableArray addObject:(id)color.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();//创建上下文
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);//创建色彩空间对象
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)mutableArray, NULL);//创建渐变对象
    CGContextDrawLinearGradient(context, gradient, startPos, endPos, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
    
}
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientColorType)gradientType imgSize:(CGSize)imgSize
{
    NSMutableArray * mutableArray = [NSMutableArray array];
    
    for(UIColor * color in colors)
    {
        [mutableArray addObject:(id)color.CGColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();//创建上下文
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);//创建色彩空间对象
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)mutableArray, NULL);//创建渐变对象
    CGPoint start;
    CGPoint end;
    
    switch (gradientType) {
        case gradientType_TopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case gradientType_LeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case gradientType_UpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case gradientType_UprightToLowleft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

- (NSString *)decimalNumberWithDouble:(CGFloat)conversionValue{
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    NSLog(@"decNumber====%@",decNumber.stringValue);
    return [decNumber stringValue];
}


-(NSString *)returnChineseNumber:(NSUInteger)num{
    NSString *string = @"";
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterRoundHalfDown;
    string = [formatter stringFromNumber:[NSNumber numberWithInteger:num]];
    return string;
}

/**
 *   设置图片箭头旋转
 */
-(void)setArrowImageViewWhitIfUnfold:(BOOL)unfold imageView:(UIImageView *)arrowImageView
{
    
    double degree = 0;
    if(unfold){
        degree = M_PI_2;
    }
    else{
        degree = 0;
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        arrowImageView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
    } completion:NULL];
}
+ (id)getJsonObjectFromLocal:(NSString *)jsonStr
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:jsonStr ofType:nil];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return jsonObject;
}

+ (id)getJsonObjectFromUrl:(NSString *)jsonUrl
{
    NSData *jsonData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:jsonUrl]];
    NSError *error;
    if (jsonData == nil) {
        return nil;
    }
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return jsonObject;
}

+ (void)trackerEventCategory:(NSString *)category action:(NSString *)action siteId:(NSString *)siteId bunderId:(NSString *)bunderId
{
    [[[MatomoTrackerClass sharedMatomoTrackerClass] setMatomoTrackerInfo:siteId bunderId:bunderId] trackWithEventWithCategory:category action:action name:nil number:nil url:nil];
}
+ (void)addTrackView:(NSArray<NSString *> *)views siteId:(NSString *)siteId bunderId:(NSString *)bunderId
{
    [[[MatomoTrackerClass sharedMatomoTrackerClass] setMatomoTrackerInfo:siteId bunderId:bunderId] trackWithView:views url:nil];
}
+ (void)addTrackView:(NSArray<NSString *> *)views url:(NSString *)urlStr siteId:(NSString *)siteId bunderId:(NSString *)bunderId
{
    [[[MatomoTrackerClass sharedMatomoTrackerClass] setMatomoTrackerInfo:siteId bunderId:bunderId] trackWithView:views url:[NSURL URLWithString:urlStr]];
}
//UIRectCornerTopLeft     = 1 << 0,
//UIRectCornerTopRight    = 1 << 1,
//UIRectCornerBottomLeft  = 1 << 2,
//UIRectCornerBottomRight = 1 << 3,
//UIRectCornerAllCorners  = ~0UL
+ (void)addCorner:(UIView *)view rect:(CGRect)viewRect rectCorner:(UIRectCorner )corners cornerRadii:(CGSize)size
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:viewRect byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = viewRect;
    shapeLayer.path = path.CGPath;
    view.layer.mask = shapeLayer;
}

+ (BOOL)isHasChineseWithStr:(NSString *)strFrom {
    for (int i = 0; i < strFrom.length; i ++) {
        NSRange range = NSMakeRange(i, 1);
        NSString * strFromSubStr = [strFrom substringWithRange:range];
        const char *cStringFromstr = [strFromSubStr UTF8String];
        if (strlen(cStringFromstr) == 3) {
            //汉字
            return YES;
        } else if (strlen(cStringFromstr) == 1) {
            //字母
        }
    }
    return NO;
    
}

+ (CGFloat)getSpaceLabelWidth:(NSString *)str withFont:(UIFont *)font size:(CGSize)size
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    CGSize lSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return lSize.width;
}
+ (NSAttributedString *)getParagraphStyle:(NSString *)textStr lineSpacing:(NSInteger)spacing
{
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:textStr];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
    return setString;
}

+ (NSString *)showWeatherImageInfo:(NSString *)weatherStr
{
    NSString *weatherImageStr = @"";
    
    if ([weatherStr containsString:@"暴雨"]) {
        weatherImageStr = @"暴雨";
    } else if ([weatherStr containsString:@"冰雹"]) {
        weatherImageStr = @"冰雹";
    } else if ([weatherStr containsString:@"大雪"]) {
        weatherImageStr = @"大雪";
    } else if ([weatherStr containsString:@"大雨"]) {
        weatherImageStr = @"大雨";
    } else if ([weatherStr containsString:@"多云"]) {
        weatherImageStr = @"多云";
    } else if ([weatherStr containsString:@"雷雨"]) {
        weatherImageStr = @"雷雨";
    } else if ([weatherStr containsString:@"晴"]) {
        weatherImageStr = @"晴";
    } else if ([weatherStr containsString:@"沙尘"]) {
        weatherImageStr = @"沙尘";
    } else if ([weatherStr containsString:@"霜"]) {
        weatherImageStr = @"霜";
    } else if ([weatherStr containsString:@"雾霾"]) {
        weatherImageStr = @"雾霾";
    } else if ([weatherStr containsString:@"小雪"]) {
        weatherImageStr = @"小雪";
    } else if ([weatherStr containsString:@"小雨"]) {
        weatherImageStr = @"小雨";
    } else if ([weatherStr containsString:@"小雨转晴"]) {
        weatherImageStr = @"小雨转晴";
    } else if ([weatherStr containsString:@"雪转晴"]) {
        weatherImageStr = @"雪转晴";
    } else if ([weatherStr containsString:@"夜多云"]) {
        weatherImageStr = @"夜多云";
    } else if ([weatherStr containsString:@"夜晚"]) {
        weatherImageStr = @"夜晚";
    } else if ([weatherStr containsString:@"雨加雪"]) {
        weatherImageStr = @"雨加雪";
    } else if ([weatherStr containsString:@"中雪"]) {
        weatherImageStr = @"中雪";
    } else if ([weatherStr containsString:@"中雨"]) {
        weatherImageStr = @"中雨";
    } else {
        weatherImageStr = @"阴天";
    }
    return weatherImageStr;
}
+ (void)launchMiniProgram:(NSString *)username
{
    BOOL wxIsInstalled = [WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi];
    if (wxIsInstalled == NO) {
        [MBProgressHUD showMessag:@"您未安装微信" toView:nil];
        return;
    }
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = username;//拉起的小程序的username
    //    launchMiniProgramReq.path = path;
    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
    launchMiniProgramReq.miniProgramType = 0;//拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        
    }];
}
// 获取单张图片的实际size
+ (CGSize)getMomentImageSize:(CGSize)size
{
    // 最大尺寸
    CGFloat max_width = SCREEN_WIDTH - 150;
    CGFloat max_height = SCREEN_WIDTH - 130;
    // 原尺寸
    CGFloat width = size.width;
    CGFloat height = size.height;
    // 输出
    CGFloat out_width = 0;
    CGFloat out_height = 0;
    if (height / width > 3.0) { // 细长图
        out_height = max_height;
        out_width = out_height / 2.0;
    } else  {
        out_width = max_width;
        out_height = max_width * height / width;
        if (out_height > max_height) {
            out_height = max_height;
            out_width = max_height * width / height;
        }
    }
    return CGSizeMake(out_width, out_height);
}
+ (NSMutableDictionary *)getUrlQuerysWithUrlStr:(NSString *)urlStr
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSLog(@"=====%@",urlStr);

    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"-------=====%@",urlStr);
    
    NSURLComponents * urlComponents = [[NSURLComponents alloc] initWithString:urlStr];
    
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!IsStrEmpty(obj.name) && !IsStrEmpty(obj.value)) {
            [params setObject:[obj.value stringByRemovingPercentEncoding] ?: @"" forKey:obj.name];
        }
    }];
    
    return params;
}
+ (NSMutableAttributedString *)formatString:(NSString *)string rangeString:(NSString *)rString textColor:(UIColor *)color
{
    NSRange range = [string rangeOfString:rString];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attrStr addAttribute:NSForegroundColorAttributeName
    value:color
    range:range];
    return attrStr;
}

+ (NSMutableAttributedString *)formatString:(NSMutableAttributedString *)string range:(NSRange)range textColor:(UIColor *)color
{
    NSMutableAttributedString *attrStr = string;
    [attrStr addAttribute:NSForegroundColorAttributeName
    value:color
    range:range];
    return attrStr;
}

+ (UIViewController *)getCurrentViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    
    while (true) {
        
        if (topViewController.presentedViewController) {
            
            topViewController = topViewController.presentedViewController;
            
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            
            topViewController = [(UINavigationController *)topViewController topViewController];
            
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
            
        } else {
            break;
        }
    }
    return topViewController;
}

- (void)judgeUserLoginWithCurrentNavgationController:(UINavigationController *)navgation loginSuccessed:(LoginSuccessBlock) loginSucessBlock
{
    _loginSuccessBlock = loginSucessBlock;
    
    if ([[[User shareUser] token] length] ==0) {
        //还未登录
        LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        loginVC.isUsingBlock = YES;
        [navgation pushViewController:loginVC animated:YES];
    }else {
        //已登录
        SAFE_BLOCK(self.loginSuccessBlock,[[User shareUser] token],NO);
    }
}
- (void)judgeUserLoginWithCurrentController:(UIViewController *)viewController loginSuccessed:(LoginSuccessBlock) loginSucessBlock
{
    _loginSuccessBlock = loginSucessBlock;
    
    if ([[[User shareUser] token] length] ==0) {
        //还未登录
        LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        loginVC.isUsingBlock = YES;
        UINavigationController *navigationController = IsNilOrNull(viewController.navigationController) ? [CommonUtils getCurrentViewController].navigationController : viewController.navigationController;
        [navigationController pushViewController:loginVC animated:YES];
    }else {
        //已登录
        SAFE_BLOCK(self.loginSuccessBlock,[[User shareUser] token] ,NO);
    }
}

+ (BOOL)isValidatePwd:(NSString *)password
{
    NSString *pwdRegex = @"^(?![a-zA-Z0-9]+$)(?![0-9\\W]+$)(?![A-Za-z\\W]+$)[a-zA-Z0-9\\W]{7,}$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    return [pwdTest evaluateWithObject:password];
}

+ (CGFloat)getHeightWithModel:(HouseListModel *)model
{
    if (model.rowHeight > 0) {
        NSLog(@"缓存的cellHeight = %.lf",model.rowHeight);
        return model.rowHeight;
    }
    if (model.point.count > 0) {
        model.rowHeight = 298;
        return 298;
    }
    model.rowHeight = 270;
    return 270;
}

+ (CGFloat)getNewsHeightWithModel:(NewsInfoModel *)model
{
    if (model.rowHeight > 0) {
        NSLog(@"缓存的cellHeight = %.lf",model.rowHeight);
        return model.rowHeight;
    }
    if (IsStrEmpty(model.image_url)) {
        CGSize poinsSize = [model.title sizeWithFont:[UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular] constrainedSize:CGSizeMake((SCREEN_WIDTH - 52), MAXFLOAT)];
        model.rowHeight = 50 + poinsSize.height + 5;
        return 50 + poinsSize.height + 5;
    }
    model.rowHeight = 100;
    return 100;
}

@end
