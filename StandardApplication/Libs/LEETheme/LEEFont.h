//
//  LEEFont.h
//  StandardApplication
//
//  Created by liyuanbo on 2021/7/14.
//  Copyright © 2021 DTiOS. All rights reserved.
//

//魔改LEETheme使之支持font
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 字体变换通知
 */
static NSString * const LEEFontDidChangeStyleNotification = @"LEEFontDidChangeStyleNotification";

typedef NS_ENUM(NSInteger,LEEFontWeight) {
    LEEFontWeightLight = 0,
    LEEFontWeightRegular,
    LEEFontWeightMedium,
    LEEFontWeightBold,
    LEEFontWeightSemiBold
};

@class LEEFontConfigModel;
typedef void(^LEEFontConfigBlock)(id item);
typedef void(^LEEFontConfigBlockToValue)(id item , id value);
typedef void(^LEEFontChangingBlock)(NSString *tag , id item);
typedef LEEFontConfigModel * _Nonnull (^LEEConfigFontToTag)(NSString *tag);
typedef LEEFontConfigModel * _Nonnull (^LEEConfigFontToChangingBlock)(LEEFontChangingBlock);
typedef LEEFontConfigModel * _Nonnull (^LEEConfigFontToIdentifierAndWeight)(NSString *identifier,LEEFontWeight weight);
typedef LEEFontConfigModel * _Nonnull (^LEEConfigFontToSelectorAndIdentifier)(SEL sel , NSString *identifier);
typedef LEEFontConfigModel * _Nonnull (^LEEConfigFontToSelectorAndValues)(SEL sel , NSArray *values);
typedef LEEFontConfigModel * _Nonnull (^LEEConfigFontToT_SelectorAndValueArray)(NSString *tag , SEL sel , NSArray *values);
typedef LEEFontConfigModel * _Nonnull (^LEEConfigFontToT_KeyPathAndValue)(NSString *tag , NSString *keyPath , id value);
typedef LEEFontConfigModel * _Nonnull (^LEEConfigFontToKeyPathAndIdentifierAndWeight)(NSString *keyPath , NSString *identifier, LEEFontWeight weight);

@interface LEEFont : NSObject

/**
 *  启动主题
 *
 *  @param tag 主题标签
 */
+ (void)startFontStyle:(NSString *)tag;

/**
 *  默认主题 (必设置 , 应用程序最少需要一个默认主题)
 *
 *
 *  @param tag 主题标签
 */
+ (void)defaultFontStyle:(NSString *)tag;

/**
 *  当前主题标签
 *
 *  @return 主题标签 tag
 */
+ (NSString *)currentFontStyleTag;

/**
 *  全部主题标签
 *
 *  @return 主题标签集合
 */
+ (NSArray *)allFontStyleTag;

/**
 获取字体
 
 只能获取字体，不会自动根据identifer替换
 */
+ (UIFont *)fontWithIdentifier:(NSString *)identifier weight:(LEEFontWeight)weight;

@end

@interface LEEFont (JsonModeExtend)

/**
 *  添加主题设置Json
 *
 *  @param json json字符串
 *  @param tag 主题标签
 *  @param path 资源路径 (在Documents目录下的路径 如果资源不在Documents目录下应传入nil 例: ResourcesPath:@@"themeResources/day/")
 */
+ (void)addFontConfigWithJson:(NSString *)json Tag:(NSString *)tag ResourcesPath:(NSString * _Nullable)path;

/**
 *  移除主题设置
 *
 *  @param tag 主题标签
 */
+ (void)removeFontConfigWithTag:(NSString *)tag;

/**
 *  获取指定主题标签的资源路径
 *
 *  @param tag 主题标签
 *
 *  @return 资源路径 (如为不存在则返回mainBundle路径)
 */
+ (NSString *)getResourcesPathWithTag:(NSString *)tag;

/**
 *  获取值
 *
 *  @param tag          主题标签
 *  @param identifier   标识符
 *
 *  @return 值对象 (UIColor或UIImage或NSString 如为不存在则返回nil)
 */
+ (id)getValueWithTag:(NSString *)tag Identifier:(NSString *)identifier;

@end

@interface LEEFontConfigModel : NSObject

/** Block */

/** 主题改变Block -> 格式: .LEEConfigFontToChangingBlock(^(NSString *tag , id item){ code... }) */
@property (nonatomic , copy , readonly ) LEEConfigFontToChangingBlock LeeFontChangingBlock;

/** 设置Font标识符 -> 格式: .LeeConfigFont(@@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigFontToIdentifierAndWeight LeeConfigFont;

/** 移除标签全部的设置 -> 格式: .LeeClearAllConfig_Tag(@@"tag") */
@property (nonatomic , copy , readonly ) LEEConfigFontToTag LeeClearAllConfig_Tag;

/** 设置路径标识符 -> 格式: .LeeConfigKeyPathAndIdentifier(@@"keyPath" , @@"identifier") */
@property (nonatomic , copy , readonly ) LEEConfigFontToKeyPathAndIdentifierAndWeight LeeConfigKeyPathAndIdentifier;

@end

@interface LEEFontIdentifier : NSString

+ (LEEFontIdentifier *)ident:(NSString *)ident;

@end

@interface NSObject (LEEFontConfigObject)

@property (nonatomic , strong ) LEEFontConfigModel *lee_font;

@end

NS_ASSUME_NONNULL_END
