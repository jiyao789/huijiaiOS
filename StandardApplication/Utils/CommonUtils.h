//
//  CommonUtils.h
//
//  Created by Admin on 2017/3/9.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MacroDefine.h"

typedef NS_ENUM(NSInteger,GradientColorType){
    gradientType_TopToBottom = 0,
    gradientType_LeftToRight = 1,
    gradientType_UpleftToLowright = 2,
    gradientType_UprightToLowleft = 3,

};
// 用于配置UI
typedef enum : NSUInteger {
    ManuscriptPageType, // 稿件类型 （分享+评论）
    ExternalLinksPageType, //外链 带分享
    ActivityPageType1, // 活动类型 带分享
    ShoppingMallPageType, // 商城 (自定义导航 + 分享)
} PageType;

typedef void(^LoginSuccessBlock) (NSString *authorization ,BOOL performLogin);
@class HouseListModel;
@class NewsInfoModel;

@interface CommonUtils : NSObject

// 是否执行登录动作 performLogin
@property (copy, nonatomic) LoginSuccessBlock loginSuccessBlock;


@property (copy, nonatomic) NSDictionary *displayDic;
@property (copy, nonatomic) NSDictionary *dataDic;

+(instancetype)sharedCommonUtils;
- (NSInteger)getDisplayType:(NSString *)playStr;

//归档
+ (void)FS_Archiver:(id)obj fileStr:(NSString*)fileStr;
//解档
+ (id)FS_UnArchiverfileStr:(NSString*)fileStr;

//  判断邮箱
- (BOOL)isValidateEmail:(NSString *)email;
/// 判断是否存在汉字
+ (BOOL)isHasChineseWithStr:(NSString *)strFrom;
//  判断手机号
- (BOOL)isValidatePhone:(NSString *)phoneStr;

+ (BOOL)isValidateRegisterPsd:(NSString *)psdStr;

///**  Json解析精度丢失处理(NSString, Double, Float)*/
- (NSString *)decimalNumberWithDouble:(CGFloat)conversionValue;
+ (UIImage *)gradientColorToImage:(NSArray *)colors startPos:(CGPoint)startPos endPos:(CGPoint)endPos imgSize:(CGSize)imgSize;
//渐变色
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientColorType)gradientType imgSize:(CGSize)imgSize;

//数字"1"转"一"
-(NSString *)returnChineseNumber:(NSUInteger)num;
 // 设置图片箭头旋转
-(void)setArrowImageViewWhitIfUnfold:(BOOL)unfold imageView:(UIImageView *)arrowImageView;
//从本地获取json
+ (id)getJsonObjectFromLocal:(NSString *)jsonStr;
//从url获取json
+ (id)getJsonObjectFromUrl:(NSString *)jsonUrl;

// 从年月日时分秒中 截取年月日
+ (NSString *)getYMDString:(NSString *)dateString;

+ (void)trackerEventCategory:(NSString *)category action:(NSString *)action siteId:(NSString *)siteId bunderId:(NSString *)bunderId;
+ (void)addTrackView:(NSArray<NSString *> *)views siteId:(NSString *)siteId bunderId:(NSString *)bunderId;
+ (void)addTrackView:(NSArray<NSString *> *)views url:(NSString *)urlStr siteId:(NSString *)siteId bunderId:(NSString *)bunderId;

+ (void)addCorner:(UIView *)view rect:(CGRect)viewRect rectCorner:(UIRectCorner )corners cornerRadii:(CGSize)size;

// 增加积分接口
- (void)addPoint:(NSString *)urlStr;

+ (CGFloat)getSpaceLabelWidth:(NSString *)str withFont:(UIFont *)font size:(CGSize)size;

+ (NSAttributedString *)getParagraphStyle:(NSString *)textStr lineSpacing:(NSInteger)spacing;


+ (NSString *)showWeatherImageInfo:(NSString *)weatherStr;

+ (void)launchMiniProgram:(NSString *)username;

// 获取单张图片的实际size
+ (CGSize)getMomentImageSize:(CGSize)size;
/**
 获取URL的query参数
 */
+ (NSMutableDictionary *)getUrlQuerysWithUrlStr:(NSString *)urlStr;
+ (NSMutableAttributedString *)formatString:(NSString *)string rangeString:(NSString *)rString textColor:(UIColor *)color;

+ (NSString *)scanQRCodeInPicture:(UIImage *)image error:(NSError **)error;
+ (NSString *)conversionString:(NSString *)inputString topicAry:(NSArray *)topicAry;

+ (NSString *)getActionUrlWebUrl:(NSString *)actionUrl;

+ (NSMutableAttributedString *)getTopicConformTitle:(NSString *)title;

+ (UIViewController *)getCurrentViewController;

+ (BOOL)isValidatePwd:(NSString *)password;

+ (CGFloat)getHeightWithModel:(HouseListModel *)model;

+ (CGFloat)getNewsHeightWithModel:(NewsInfoModel *)model;

/**
 判断是否登录并且获取回调
 */
- (void)judgeUserLoginWithCurrentController:(UIViewController *)viewController loginSuccessed:(LoginSuccessBlock) loginSucessBlock;
- (void)judgeUserLoginWithCurrentNavgationController:(UINavigationController *)navgation loginSuccessed:(LoginSuccessBlock) loginSucessBlock;
@end
