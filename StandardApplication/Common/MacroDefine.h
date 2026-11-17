//
//  MacroDefine.h
//  EnjoyOilBao
//
//  Created by yiye on 2018/10/15.
//  Copyright © 2018年 yiye. All rights reserved.
//


#define kPropertyBlockCopy(type , name) @property (nonatomic, copy) type name;
#define kPropertyCopy(type , name) @property (nonatomic, copy) type *name;
#define kPropertyString(name) @property(nonatomic,copy)NSString *name;
#define kPropertyAssign(type , name) @property (nonatomic, assign)type name;
#define kPropertyStrong(type,name) @property(nonatomic,strong)type *name;


#import "MJRefresh.h"
#import "UIColor+SNFoundation.h"
#import "UIView+SNFoundation.h"
#import "UIView+ECGradient.h"
#import "UIWindow+JXSafeArea.h"
#import "UIImageView+ECExtension.h"
#import "PSBarButtonItem.h"
#import "NSString+Adding.h"
#import "NSDate+Helper.h"
#import "UIImage-Extensions.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "ScottAlertController.h"
#import "UIColor+IHGradientChange.h"
#import "CommonUtils.h"
#import "SNCache.h"
#import "UIView+Tap.h"
#import "UIView+Frame.h"
#import "UIView+Extension.h"
#import "MatomoTrackerClass.h"
#import "Masonry.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "NoMsgView.h"
#import "UIColor+Helper.h"
#import "MJExtension.h"
#import "HttpRequest.h"
#import "LEETheme.h"
#import "LEEFont.h"
#import "UIButton+YDImageSelectAnimation.h"
#import "QMUIKit.h"
#import "coobjc.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import "BaseShadowView.h"
#import "ScottAlertViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "FSCalendar.h"

//获取系统对象
#define kApplication [UIApplication sharedApplication]
#define kAppWindow [UIApplication sharedApplication].delegate.window
#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define KHaveLogin      @"KHaveLogin"
#define myDotNumbers     @"0123456789.\n"   //匹配金额
#define myNumbers          @"0123456789\n"  //匹配数字

#define NAVBAR_CHANGE_POINT 50


#ifndef MacroDefine_h
#define MacroDefine_h


#define GApplication [UIApplication sharedApplication]
#define GAppWindow [UIApplication sharedApplication].delegate.window
#define GAppDelegate [UIApplication sharedApplication].delegate
#define GRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
//-------------------获取设备大小-------------------------

//判断iphone 4s
#define isIphone4s ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height < 481.0f)
//5
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)
//6
#define IS_IPhone6 (667 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
//6p
#define IS_IPhone6plus (736 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
//x
#define IS_IPhoneX (([UIApplication.sharedApplication.keyWindow jx_navigationHeight] >= 88 || [UIApplication.sharedApplication.keyWindow jx_bottomHeight] == 83) ? YES : NO)

#define WeakSelf __weak typeof(self) weakSelf = self;

// 导航栏高度与tabbar高度
#define NAVBAR_HEIGHT       (IS_IPhoneX ? 88.0f : 64.0f)
#define TABBAR_HEIGHT       (IS_IPhoneX ? 83.0f : 49.0f)
#define ContentHeight       (SCREEN_HEIGHT - NAVBAR_HEIGHT - TABBAR_HEIGHT)

// 状态栏高度
#define STATUSBAR_HEIGHT    (IS_IPhoneX ? 44.0f : 20.0f)

#define LoadNibNamed(xibName) [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil].firstObject;

//安全block
#define SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })
#define SAFE_DELEGATE(value,SEL) (value && [value respondsToSelector:SEL])


//属性快速声明（建议使用代码块）

#define kPropertyWeakDelegate(delegate,name) @property (nonatomic, weak) id<delegate> name;
#define KFrame(x,y,w,h) CGRectMake(x, y, w, h)
#define kPoint(x,y) CGPointMake(x, y)
//CGSizeMake
#define KSize(w,h) CGSizeMake(w, h)

#define KWeakSelf __weak typeof(self) weakSelf = self;
#define KStrongSelf(type) __strong __typeof__(type) strongSelf = type;

//适配uitableview uiscrollview 空白问题
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)

//为解决上拉加载更多，tableView会跳动
#define  adjustsScrollViewPullRoll_NO(scrollView)\
do { \
if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {\
scrollView.estimatedRowHeight = SCREEN_HEIGHT;\
scrollView.estimatedSectionHeaderHeight = 0;\
scrollView.estimatedSectionFooterHeight = 0;\
}else{\
}\
} while (0)

#define NONullString(key)      (IsNilOrNull(key) ? @"" : key)

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//屏幕缩放比例，以4.7寸屏为参照
#define KZOOM_SCALE_X (float)(SCREEN_WIDTH/375.0)
#define KZOOM_SCALE_Y (float)(SCREEN_HEIGHT/640.0)

//-------------------1像素宽-------------------------
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)


//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

//重写NSLog,Debug模式下打印日志和当前行数
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\n %s:%d   %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[[NSString alloc] initWithData:[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding] UTF8String]);
#else
#define NSLog(...)
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif


#define ITTDEBUG
#define ITTLOGLEVEL_INFO     10
#define ITTLOGLEVEL_WARNING  3
#define ITTLOGLEVEL_ERROR    1

#ifndef ITTMAXLOGLEVEL

#ifdef DEBUG
#define ITTMAXLOGLEVEL ITTLOGLEVEL_INFO
#else
#define ITTMAXLOGLEVEL ITTLOGLEVEL_ERROR
#endif

#endif

// The general purpose logger. This ignores logging levels.
#ifdef ITTDEBUG
#define ITTDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ITTDPRINT(xx, ...)  ((void)0)
#endif

// Prints the current method's name.
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL
#define ITTDERROR(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDERROR(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL
#define ITTDWARNING(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDWARNING(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL
#define ITTDINFO(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDINFO(xx, ...)  ((void)0)
#endif

#ifdef ITTDEBUG
#define ITTDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
ITTDPRINT(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
#define ITTDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif

#define ITTAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)

/**
 * SN_EXTERN user this as extern
 */
#if !defined(SN_EXTERN)
#  if defined(__cplusplus)
#   define SN_EXTERN extern "C"
#  else
#   define SN_EXTERN extern
#  endif
#endif

/**
 * SN_INLINE user this as static inline
 */
#if !defined(SN_INLINE)
# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define SN_INLINE static inline
# elif defined(__cplusplus)
#  define SN_INLINE static inline
# elif defined(__GNUC__)
#  define SN_INLINE static __inline__
# else
#  define SN_INLINE static
# endif
#endif

/*safe release*/
#undef TT_RELEASE_SAFELY
#define TT_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF)) \
{\
CFRelease(__REF); \
__REF = nil;\
}\
}

//view安全释放
#undef TTVIEW_RELEASE_SAFELY
#define TTVIEW_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF))\
{\
[__REF removeFromSuperview];\
CFRelease(__REF);\
__REF = nil;\
}\

//arc 支持performSelector:
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//----------------------系统----------------------------

//判断是否 Retina屏、设备是否是iphone 5、是否是iPad
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO )
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO )
#define isIPhone6AndiPhone6P (iPhone6 || iPhone6P)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//----------------------内存----------------------------
//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

#pragma mark - common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

//释放一个对象
#define SAFE_DELETE(P) if(P) { [P release], P = nil; }

#define SAFE_RELEASE(x) [x release];x=nil


//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------

//读取本地图片
#define ImageWithContentsFile(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define ImageWithContents(fileName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]


//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)


//----------------------nil----------------------------
//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isEqual:@"(null)"]) || ([(_ref) isEqual:@"<null>"]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]) || ([(_ref) isEqual:@"(null)"]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

//----------------------其他----------------------------


//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)

//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

// weakself
//#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//单例化一个类
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}

// Database
static NSString *_DatabaseDirectory;

static inline NSString* DatabaseDirectory() {
    if(!_DatabaseDirectory) {
        NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _DatabaseDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"Database"] copy];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = YES;
        BOOL isExist = [fileManager fileExistsAtPath:_DatabaseDirectory isDirectory:&isDir];
        if (!isExist)
        {
            [fileManager createDirectoryAtPath:_DatabaseDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }
    
    return _DatabaseDirectory;
}

#define defaultIconName @"default_img"

// 增加七牛的常量
#ifndef ARRAY_SIZE
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
#endif

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
block();\
} else {\
dispatch_async(queue, block);\
}
#endif

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif

//项目状态
typedef NS_ENUM(NSInteger, RefreshState)
{
    RefershStateUp,// 上拉
    RefershStateDown// 下拉
};

//1—小图；2—大图；3—多图；4—视频；5—专题；6—图集；7—直播 9 -读报 40-小图视频
//项目状态
typedef NS_ENUM(NSInteger, CustomCellType)
{
    OnlyTextCustomCellType= 0 ,
    SmallPictureCustomCellType = 1,//
    BigPictureCustomCellType = 2,//
    MorePictureCustomCellType = 3 ,
    VideoCustomCellType = 4 ,//视频
    SubjectCustomCellType = 5 ,//专题
    AtlasCustomCellType = 6 , //图集
    LiveCustomCellType = 7 , //直播
    ShortVideoCellType = 8 ,
    ReadingNewspaperCellType = 9,
    
    SmallPictureWithVideoCellType = 40 //新闻+小视频
};
//项目状态 多类型跳转
typedef NS_ENUM(NSInteger, GoToViewControllerType)
{
    GoToViewControllerType1 = 1,//新闻详情 {"url":xx}
    GoToViewControllerType2 ,//专题列表{"type":xx,"channelId":yy}
    GoToViewControllerType3 ,//专题详情{"url":xx}
    GoToViewControllerType4 ,//视频详情{"contentId":xx}
    GoToViewControllerType5 ,//图集详情{"contentId":xx}
    GoToViewControllerType6 ,////外链{"url":xx}
    GoToViewControllerType7 ,// 文本
    GoToViewControllerType8 ,// 社区文章
    GoToViewControllerType9 ,// 社区话题
    GoToViewControllerType12 = 12,// h5直播
    GoToViewControllerType13 = 13 //圈子分享
};

//圈子里面
typedef NS_ENUM(NSInteger, ListViewType)
{
    ListViewTypeTopics,// 话题
    ListViewTypeCircles,// 圈子
    ListViewTypeSubscription// 订阅
};

typedef NS_ENUM(NSInteger, AdviceType)
{
    AdviceReportType,// 爆料
    AdviceAskGovType// 问政
    
};

typedef NS_ENUM(NSUInteger, MinePageType) {

    MinePageTypeCollection = 0, //收藏
    MinePageTypeRecord,
    MinePageTypeLike
};
#endif /* MacroDefine_h */
