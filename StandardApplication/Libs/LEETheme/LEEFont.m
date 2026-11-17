//
//  LEEFont.m
//  StandardApplication
//
//  Created by liyuanbo on 2021/7/14.
//  Copyright © 2021 DTiOS. All rights reserved.
//


#import "LEEFont.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>

static NSString * const LEEFontChangingNotificaiton = @"LEEFontChangingNotificaiton";
static NSString * const LEEFontAddTagNotificaiton = @"LEEFontAddTagNotificaiton";
static NSString * const LEEFontRemoveTagNotificaiton = @"LEEFontRemoveTagNotificaiton";
static NSString * const LEEFontAllTags = @"LEEFontAllTags";
static NSString * const LEEFontCurrentTag = @"LEEFontCurrentTag";
static NSString * const LEEFontConfigInfo = @"LEEFontConfigInfo";

@interface LEEFont ()

@property (nonatomic , copy ) NSString *defaultTag;

@property (nonatomic , copy ) NSString *currentTag;

@property (nonatomic , strong ) NSMutableArray *allTags;

@property (nonatomic , strong ) NSMutableDictionary *configInfo;

@end

@implementation LEEFont

#if !__has_feature(objc_arc)
#error "ARC才可以  ( *・ω・)✄╰ひ╯ "
#endif

+ (LEEFont *)shared{
    
    static LEEFont *fontManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        fontManager = [[LEEFont alloc]init];
    });
    
    return fontManager;
}

#pragma mark Public

+ (void)startFontStyle:(NSString *)tag{
    
    NSAssert([[LEEFont shared].allTags containsObject:tag], @"所启用的主题不存在 - 请检查是否添加了该%@主题的设置" , tag);
    
    if (!tag) return;
    
    [LEEFont shared].currentTag = tag;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LEEFontChangingNotificaiton object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:LEEFontDidChangeStyleNotification object:nil userInfo:nil];
}

+ (void)defaultFontStyle:(NSString *)tag{
    
    if (!tag) return;
    
    [LEEFont shared].defaultTag = tag;
    
    if (![LEEFont shared].currentTag && ![[NSUserDefaults standardUserDefaults] objectForKey:LEEFontCurrentTag]) [LEEFont shared].currentTag = tag;
}

+ (NSString *)currentFontStyleTag{
    
    return [LEEFont shared].currentTag ? [LEEFont shared].currentTag : [[NSUserDefaults standardUserDefaults] objectForKey:LEEFontCurrentTag];
}

+ (NSArray *)allFontStyleTag{
    
    return [[LEEFont shared].allTags copy];
}

+ (UIFont *)fontWithIdentifier:(NSString *)identifier weight:(LEEFontWeight)weight
{
    NSString * tag = [LEEFont currentFontStyleTag];
    NSString * newIndetifer = [LEEFont getNewIdentifierWithIdentifier:identifier weight:weight];
    return [LEEFont getValueWithTag:tag Identifier:newIndetifer];
}

#pragma mark Private

- (void)setCurrentTag:(NSString *)currentTag{
    
    _currentTag = currentTag;
    
    [[NSUserDefaults standardUserDefaults] setObject:currentTag forKey:LEEFontCurrentTag];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveConfigInfo{
    
    [[NSUserDefaults standardUserDefaults] setObject:self.configInfo forKey:LEEFontConfigInfo];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)addTagToAllTags:(NSString *)tag{
    
    if (![[LEEFont shared].allTags containsObject:tag]) {
        
        [[LEEFont shared].allTags addObject:tag];
        
        [[NSUserDefaults standardUserDefaults] setObject:[LEEFont shared].allTags forKey:LEEFontAllTags];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

+ (void)removeTagToAllTags:(NSString *)tag{
    
    if ([[LEEFont shared].allTags containsObject:tag]) {
        
        [[LEEFont shared].allTags removeObject:tag];
        
        [[NSUserDefaults standardUserDefaults] setObject:[LEEFont shared].allTags forKey:LEEFontAllTags];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


+ (NSString *)getNewIdentifierWithIdentifier:(NSString *)identifier weight:(LEEFontWeight)weight
{
    NSString * newIdentifier = @"";
    switch (weight) {
        case LEEFontWeightLight:
            newIdentifier = [identifier stringByAppendingFormat:@"-Light"];
            break;
        case LEEFontWeightRegular:
            newIdentifier = [identifier stringByAppendingFormat:@"-Regular"];
            break;
        case LEEFontWeightMedium:
            newIdentifier = [identifier stringByAppendingFormat:@"-Medium"];
            break;
        case LEEFontWeightBold:
            newIdentifier = [identifier stringByAppendingFormat:@"-Bold"];
            break;
        case LEEFontWeightSemiBold:
            newIdentifier = [identifier stringByAppendingFormat:@"-SemiBold"];
            break;
        default:
            break;
    }
    return newIdentifier;
}

#pragma mark - LazyLoading

- (NSMutableArray *)allTags{
    
    if (!_allTags) _allTags = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:LEEFontAllTags]];

    return _allTags;
}

- (NSMutableDictionary *)configInfo{
    
    if (!_configInfo) _configInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:LEEFontConfigInfo]];
    
    return _configInfo;
}

@end

@implementation LEEFont (JsonModeExtend)

+ (void)addFontConfigWithJson:(NSString *)json Tag:(NSString *)tag ResourcesPath:(NSString *)path{
    
    if (json) {
        
        NSError *jsonError = nil;
        
        NSDictionary *jsonConfigInfo = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
        
        NSAssert(!jsonError, @"添加的主题json配置数据解析错误 - 错误描述");
        NSAssert(jsonConfigInfo, @"添加的主题json配置数据解析为空 - 请检查");
        NSAssert(tag, @"添加的主题json标签不能为空");
        
        if (!jsonError && jsonConfigInfo) {
        
            [[LEEFont shared].configInfo setValue:[NSMutableDictionary dictionaryWithObjectsAndKeys:jsonConfigInfo , @"info", path , @"path" , nil] forKey:tag];
            
            [[LEEFont shared] saveConfigInfo];
            
            [LEEFont addTagToAllTags:tag];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LEEFontAddTagNotificaiton object:nil userInfo:@{@"tag" : tag}];
        }
        
    }
    
}

+ (void)removeFontConfigWithTag:(NSString *)tag{
    
    if ([[LEEFont shared].allTags containsObject:tag] && ![[LEEFont shared].defaultTag isEqualToString:tag]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LEEFontRemoveTagNotificaiton object:nil userInfo:@{@"tag" : tag}];
        
        [LEEFont removeTagToAllTags:tag];
        
        [[LEEFont shared].configInfo removeObjectForKey:tag];
        
        [[LEEFont shared] saveConfigInfo];
        
        if ([[LEEFont currentFontStyleTag] isEqualToString:tag]) [LEEFont startFontStyle:[LEEFont shared].defaultTag];
    }
    
}

+ (NSString *)getResourcesPathWithTag:(NSString *)tag{
    
    NSString *path = [LEEFont shared].configInfo[tag][@"path"];
    
    return path ? path : [[NSBundle mainBundle] bundlePath];
}

+ (id)getValueWithTag:(NSString *)tag Identifier:(NSString *)identifier{
    
    id value = nil;
    
    NSArray * items = [identifier componentsSeparatedByString:@"-"];
    
    if (items.count != 2) {
        return value;
    }
    
    NSString * newIdentifier = items.firstObject;
    
    NSDictionary *configInfo = [LEEFont shared].configInfo[tag];
    
    NSDictionary *info = configInfo[@"info"];
    
    NSDictionary *fontInfo = info[@"font"];
    NSDictionary *fontObjtDic = fontInfo[newIdentifier];
    
    if (fontObjtDic) {
        CGFloat fontSize = [fontObjtDic[@"fontSize"] doubleValue];
        if ([fontObjtDic[@"fontName"] isEqualToString:@"PingFangSC"]) {
            NSString * fontWeight = items.lastObject;
            if ([fontWeight isEqualToString:@"Light"]) {
                value = [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
            }else if ([fontWeight isEqualToString:@"Regular"]) {
                value = [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
            }else if ([fontWeight isEqualToString:@"Medium"]) {
                value = [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium];
            }else if ([fontWeight isEqualToString:@"Bold"]) {
                value = [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold];
            }else if ([fontWeight isEqualToString:@"SemiBold"]) {
                value = [UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold];
            }else {
                value = [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
            }
        } else {
            NSString * fontName = [NSString stringWithFormat:@"%@-%@",fontObjtDic[@"fontName"],items.lastObject];

            if (fontName && fontSize > 0 && !value) {
                value = [UIFont fontWithName:fontName size:fontSize];
            }
        }
    }
    
    return value;
}

@end

typedef NS_ENUM(NSInteger, LEEFontIdentifierConfigType) {
    
    /** 标识符设置类型 - Block */
    
    LEEFontIdentifierConfigTypeBlock,
    
    /** 标识符设置类型 - 路径,方法 */
    
    LEEFontIdentifierConfigTypeKeyPath,
    LEEFontIdentifierConfigTypeSelector
};

@interface LEEFontConfigModel ()

@property (nonatomic , copy ) void(^modelUpdateCurrentFontConfig)(void);
@property (nonatomic , copy ) void(^modelConfigFontChangingBlock)(void);

@property (nonatomic , copy ) LEEFontChangingBlock modelChangingBlock;

@property (nonatomic , copy ) NSString *modelCurrentFontTag;

@property (nonatomic , strong ) NSMutableDictionary <NSString * , NSMutableDictionary *>*modelFontBlockConfigInfo; // @{tag : @{block : value}}
@property (nonatomic , strong ) NSMutableDictionary <NSString * , NSMutableDictionary *>*modelFontKeyPathConfigInfo; // @{keypath : @{tag : value}}
@property (nonatomic , strong ) NSMutableDictionary <NSString * , NSMutableDictionary *>*modelFontSelectorConfigInfo; // @{selector : @{tag : @[@[parameter, parameter,...] , @[...]]}}

@end

@implementation LEEFontConfigModel
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    objc_removeAssociatedObjects(self);
    
    _modelCurrentFontTag = nil;
    _modelFontBlockConfigInfo = nil;
    _modelFontKeyPathConfigInfo = nil;
    _modelFontSelectorConfigInfo = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leeFont_RemoveFontTagNotify:) name:LEEFontRemoveTagNotificaiton object:nil];
    }
    return self;
}

- (void)leeFont_RemoveFontTagNotify:(NSNotification *)notify{
    
    NSString *tag = notify.userInfo[@"tag"];
    
    self.LeeClearAllConfig_Tag(tag);
}

- (LEEConfigFontToChangingBlock)LeeFontChangingBlock{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(LEEFontChangingBlock changingBlock){
        
        if (changingBlock) {
            
            weakSelf.modelChangingBlock = changingBlock;
            
            if (weakSelf.modelConfigFontChangingBlock) weakSelf.modelConfigFontChangingBlock();
        }
            
        return weakSelf;
    };
    
}

- (LEEConfigFontToIdentifierAndWeight)LeeConfigFont {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *identifier,LEEFontWeight weight) {
        
        NSString * newIdentifier = [LEEFont getNewIdentifierWithIdentifier:identifier weight:weight];
        return weakSelf.LeeConfigSelectorAndIdentifier(@selector(setFont:), newIdentifier);
    };
}

- (LEEConfigFontToSelectorAndIdentifier)LeeConfigSelectorAndIdentifier{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(SEL sel , NSString *identifier){
        
        return weakSelf.LeeConfigSelectorAndValueArray(sel , @[[LEEFontIdentifier ident:identifier]]);
    };
    
}

- (LEEConfigFontToSelectorAndValues)LeeConfigSelectorAndValueArray{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(SEL sel , NSArray *values){
        
        for (NSString *tag in [LEEFont shared].allTags) {
            
            NSMutableArray *valueArray = [NSMutableArray array];
            
            for (id value in values) {

                id v = value;
                
                if ([value isKindOfClass:LEEFontIdentifier.class]) {
                    
                    v = [LEEFont getValueWithTag:tag Identifier:value];
                }
                
                if (v) [valueArray addObject:v];
            }
            
            if (valueArray.count == values.count && valueArray.count) weakSelf.LeeAddSelectorAndValueArray(tag, sel, valueArray);
        }
        
        NSMutableDictionary *info = weakSelf.modelFontIdentifierConfigInfo[@(LEEFontIdentifierConfigTypeSelector)];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        if (values) [info setObject:NSStringFromSelector(sel) forKey:values];
        
        [weakSelf.modelFontIdentifierConfigInfo setObject:info forKey:@(LEEFontIdentifierConfigTypeSelector)];
        
        return weakSelf;
    };
    
}

- (LEEConfigFontToT_SelectorAndValueArray)LeeAddSelectorAndValueArray{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag, SEL sel , NSArray *values){
      
        if (!tag) return weakSelf;
        
        if (!sel) return weakSelf;
        
        [LEEFont addTagToAllTags:tag];
        
        NSString *key = NSStringFromSelector(sel);
        
        NSMutableDictionary *info = weakSelf.modelFontSelectorConfigInfo[key];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        NSMutableArray *valuesArray = info[tag];
        
        if (!valuesArray) valuesArray = [NSMutableArray array];
        
        NSArray *temp = [valuesArray copy];
        
        [temp enumerateObjectsUsingBlock:^(NSArray *valueArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([valueArray isEqualToArray:values]) [valuesArray removeObject:valueArray]; // 过滤相同参数值的数组
        }];
        
        if (values && values.count) [valuesArray addObject:values];
        
        [info setObject:valuesArray forKey:tag];
        
        [weakSelf.modelFontSelectorConfigInfo setObject:info forKey:key];
        
        [weakSelf updateCurrentFontConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

- (void)updateCurrentFontConfigHandleWithTag:(NSString *)tag{
    
    if ([[LEEFont currentFontStyleTag] isEqualToString:tag]) {
        
        if ([NSThread isMainThread]) {
            
            if (self.modelUpdateCurrentFontConfig) self.modelUpdateCurrentFontConfig();
        
        } else {
        
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (self.modelUpdateCurrentFontConfig) self.modelUpdateCurrentFontConfig();
            });
        }
        
    }
    
}

- (NSMutableDictionary *)modelFontIdentifierConfigInfo{
    
    /**
     *  @{type : @{(keypath or block) : identifier}}
     *
     *  @{type : @{values : selector}}
     */
    NSMutableDictionary *dic = objc_getAssociatedObject(self, _cmd);
    
    if (!dic) {
        
        dic = [NSMutableDictionary dictionary];
        
        objc_setAssociatedObject(self, _cmd, dic , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leeFont_AddFontTagNotify:) name:LEEFontAddTagNotificaiton object:nil];
    }
    
    return dic;
}

- (void)setModelFontIdentifierConfigInfo:(NSMutableDictionary *)modelFontIdentifierConfigInfo{
    
    objc_setAssociatedObject(self, @selector(modelFontIdentifierConfigInfo), modelFontIdentifierConfigInfo , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LEEConfigFontToKeyPathAndIdentifierAndWeight)LeeConfigKeyPathAndIdentifier{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *keyPath , NSString *identifier, LEEFontWeight weight){
        
        NSString * newIdentifer = [LEEFont getNewIdentifierWithIdentifier:identifier weight:weight];
        
        for (NSString *tag in [LEEFont shared].allTags) {
            
            id value = [LEEFont getValueWithTag:tag Identifier:newIdentifer];
            
            if (value) weakSelf.LeeAddKeyPathAndValue(tag, keyPath, value);
        }
        
        NSMutableDictionary *info = weakSelf.modelFontIdentifierConfigInfo[@(LEEFontIdentifierConfigTypeKeyPath)];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:newIdentifer forKey:keyPath];
        
        [weakSelf.modelFontIdentifierConfigInfo setObject:info forKey:@(LEEFontIdentifierConfigTypeKeyPath)];
        
        return weakSelf;
    };
    
}

- (void)leeFont_AddFontTagNotify:(NSNotification *)notify{
    
    NSString *tag = notify.userInfo[@"tag"];
    
    NSDictionary *configInfo = self.modelFontIdentifierConfigInfo;
    
    for (NSNumber *type in configInfo) {
        
        NSDictionary *info = configInfo[type];
        
        for (id key in info) {
            
            switch ([type integerValue]) {
                    
                case LEEFontIdentifierConfigTypeBlock:
                {
                    NSString *identifier = info[key];
                    
                    id value = [LEEFont getValueWithTag:tag Identifier:identifier];
                    
                    if (value) {
                        
                        NSMutableDictionary *blockInfo = self.modelFontBlockConfigInfo[tag];
                        
                        if (!blockInfo) blockInfo = [NSMutableDictionary dictionary];
                        
                        [blockInfo setObject:value forKey:key];
                        
                        [self.modelFontBlockConfigInfo setObject:blockInfo forKey:tag];
                    }
                }
                    break;
                    
                case LEEFontIdentifierConfigTypeKeyPath:
                {
                    NSString *identifier = info[key];
                    
                    id value = [LEEFont getValueWithTag:tag Identifier:identifier];
                    
                    if (value) self.LeeAddKeyPathAndValue(tag, key, value);
                }
                    break;
                    
                case LEEFontIdentifierConfigTypeSelector:
                {
                    NSArray *values = key;
                    
                    NSMutableArray *valueArray = [NSMutableArray array];
                    
                    for (id value in values) {
                        
                        id v = value;
                        
                        if ([value isKindOfClass:LEEFontIdentifier.class]) {
                            
                            v = [LEEFont getValueWithTag:tag Identifier:value];
                        }
                        
                        if (v) [valueArray addObject:v];
                    }
                    
                    if (valueArray.count == values.count && valueArray.count) self.LeeAddSelectorAndValueArray(tag, NSSelectorFromString(info[key]), valueArray);
                }
                    break;
                    
                default:
                    break;
            }

        }
        
    }
    
}

- (LEEConfigFontToT_KeyPathAndValue)LeeAddKeyPathAndValue{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *tag , NSString *keyPath , id value){
        
        if (!value) return weakSelf;
        
        [LEEFont addTagToAllTags:tag];
        
        NSMutableDictionary *info = weakSelf.modelFontKeyPathConfigInfo[keyPath];
        
        if (!info) info = [NSMutableDictionary dictionary];
        
        [info setObject:value forKey:tag];
        
        [weakSelf.modelFontKeyPathConfigInfo setObject:info forKey:keyPath];
        
        [weakSelf updateCurrentFontConfigHandleWithTag:tag];
        
        return weakSelf;
    };
    
}

#pragma mark - LazyLoading

- (NSMutableDictionary *)modelFontBlockConfigInfo{
    
    if (!_modelFontBlockConfigInfo) _modelFontBlockConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelFontBlockConfigInfo;
}

- (NSMutableDictionary *)modelFontKeyPathConfigInfo{
    
    if (!_modelFontKeyPathConfigInfo) _modelFontKeyPathConfigInfo = [NSMutableDictionary dictionary];

    return _modelFontKeyPathConfigInfo;
}

- (NSMutableDictionary *)modelFontSelectorConfigInfo{
    
    if (!_modelFontSelectorConfigInfo) _modelFontSelectorConfigInfo = [NSMutableDictionary dictionary];
    
    return _modelFontSelectorConfigInfo;
}

@end

@implementation LEEFontIdentifier
{
    NSString *_backingStore;
}

+ (LEEFontIdentifier *)ident:(NSString *)ident{
    
    return [[LEEFontIdentifier alloc] initWithString:ident];
}

- (id)initWithString:(NSString *)aString
{
    if (self = [self init]) {
        
        _backingStore = [[NSString stringWithString:aString] copy];
    }
    return self;
}

- (NSUInteger)length{
    
    return [_backingStore length];
}

- (unichar)characterAtIndex:(NSUInteger)index{
    
    return [_backingStore characterAtIndex:index];
}

@end


@implementation NSObject (LEEFontConfigObject)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSArray *selStringsArray = @[@"dealloc"];

        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {

            NSString *leeSelString = [@"lee_font_" stringByAppendingString:selString];

            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));

            Method leeMethod = class_getInstanceMethod(self, NSSelectorFromString(leeSelString));

            BOOL isAddedMethod = class_addMethod(self, NSSelectorFromString(selString), method_getImplementation(leeMethod), method_getTypeEncoding(leeMethod));

            if (isAddedMethod) {

                class_replaceMethod(self, NSSelectorFromString(leeSelString), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));

            } else {

                method_exchangeImplementations(originalMethod, leeMethod);
            }

        }];

    });
    
}

- (void)lee_font_dealloc{
    
    if ([self isLeeFont]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:LEEFontChangingNotificaiton object:nil];
        
        objc_removeAssociatedObjects(self);
    }

    [self lee_font_dealloc];
}

- (BOOL)isChangeFont{
    
    return (!self.lee_font.modelCurrentFontTag || ![self.lee_font.modelCurrentFontTag isEqualToString:[LEEFont currentFontStyleTag]]) ? YES : NO;
}

- (void)leeFont_ChangeFontConfigNotify:(NSNotification *)notify{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self isChangeFont]) {
            
            if (self.lee_font.modelChangingBlock) self.lee_font.modelChangingBlock([LEEFont currentFontStyleTag] , self);
            
            [CATransaction begin];
            
            [CATransaction setDisableActions:YES];
            
            [self changeFontConfig];
            
            [CATransaction commit];
        }
        
    });
    
}

- (void)setInv:(NSInvocation *)inv Sig:(NSMethodSignature *)sig Obj:(id)obj Index:(NSInteger)index{
    
    if (sig.numberOfArguments <= index) return;
    
    char *type = (char *)[sig getArgumentTypeAtIndex:index];
    
    while (*type == 'r' || // const
           *type == 'n' || // in
           *type == 'N' || // inout
           *type == 'o' || // out
           *type == 'O' || // bycopy
           *type == 'R' || // byref
           *type == 'V') { // oneway
        type++; // cutoff useless prefix
    }
    
    BOOL unsupportedType = NO;
    
    switch (*type) {
        case 'v': // 1: void
        case 'B': // 1: bool
        case 'c': // 1: char / BOOL
        case 'C': // 1: unsigned char
        case 's': // 2: short
        case 'S': // 2: unsigned short
        case 'i': // 4: int / NSInteger(32bit)
        case 'I': // 4: unsigned int / NSUInteger(32bit)
        case 'l': // 4: long(32bit)
        case 'L': // 4: unsigned long(32bit)
        { // 'char' and 'short' will be promoted to 'int'.
            int value = [obj intValue];
            [inv setArgument:&value atIndex:index];
        } break;
            
        case 'q': // 8: long long / long(64bit) / NSInteger(64bit)
        case 'Q': // 8: unsigned long long / unsigned long(64bit) / NSUInteger(64bit)
        {
            long long value = [obj longLongValue];
            [inv setArgument:&value atIndex:index];
        } break;
            
        case 'f': // 4: float / CGFloat(32bit)
        { // 'float' will be promoted to 'double'.
            double value = [obj doubleValue];
            float valuef = value;
            [inv setArgument:&valuef atIndex:index];
        } break;
            
        case 'd': // 8: double / CGFloat(64bit)
        {
            double value = [obj doubleValue];
            [inv setArgument:&value atIndex:index];
        } break;
            
        case '*': // char *
        case '^': // pointer
        {
            if ([obj isKindOfClass:UIColor.class]) obj = (id)[obj CGColor]; //CGColor转换
            if ([obj isKindOfClass:UIImage.class]) obj = (id)[obj CGImage]; //CGImage转换
            void *value = (__bridge void *)obj;
            [inv setArgument:&value atIndex:index];
        } break;
            
        case '@': // id
        {
            id value = obj;
            [inv setArgument:&value atIndex:index];
        } break;
            
        case '{': // struct
        {
            if (strcmp(type, @encode(CGPoint)) == 0) {
                CGPoint value = [obj CGPointValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CGSize)) == 0) {
                CGSize value = [obj CGSizeValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CGRect)) == 0) {
                CGRect value = [obj CGRectValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CGVector)) == 0) {
                CGVector value = [obj CGVectorValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
                CGAffineTransform value = [obj CGAffineTransformValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CATransform3D)) == 0) {
                CATransform3D value = [obj CATransform3DValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(NSRange)) == 0) {
                NSRange value = [obj rangeValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(UIOffset)) == 0) {
                UIOffset value = [obj UIOffsetValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
                UIEdgeInsets value = [obj UIEdgeInsetsValue];
                [inv setArgument:&value atIndex:index];
            } else {
                unsupportedType = YES;
            }
        } break;
            
        case '(': // union
        {
            unsupportedType = YES;
        } break;
            
        case '[': // array
        {
            unsupportedType = YES;
        } break;
            
        default: // what?!
        {
            unsupportedType = YES;
        } break;
    }
    
    NSAssert(unsupportedType == NO, @"方法的参数类型暂不支持");
}

- (void)changeFontConfig{
    
    self.lee_font.modelCurrentFontTag = [LEEFont currentFontStyleTag];
    
    NSString *tag = [LEEFont currentFontStyleTag];
    
    // Block
    
    for (id blockKey in self.lee_font.modelFontBlockConfigInfo[tag]) {
        
        id value = self.lee_font.modelFontBlockConfigInfo[tag][blockKey];
        
        if ([value isKindOfClass:NSNull.class]) {
            
            LEEFontConfigBlock block = (LEEFontConfigBlock)blockKey;
            
            if (block) block(self);
            
        } else {
            
            LEEFontConfigBlockToValue block = (LEEFontConfigBlockToValue)blockKey;
            
            if (block) block(self , value);
        }
        
    }
    
    // KeyPath
    
    for (id keyPath in self.lee_font.modelFontKeyPathConfigInfo) {
        
        NSDictionary *info = self.lee_font.modelFontKeyPathConfigInfo[keyPath];
        
        id value = info[tag];
        
        if ([keyPath isKindOfClass:NSString.class]) {
            
            [self setValue:value forKeyPath:keyPath];
        }
        
    }
    
    // Selector
    
    for (NSString *selector in self.lee_font.modelFontSelectorConfigInfo) {
        
        NSDictionary *info = self.lee_font.modelFontSelectorConfigInfo[selector];
        
        NSArray *valuesArray = info[tag];
        
        for (NSArray *values in valuesArray) {
            
            SEL sel = NSSelectorFromString(selector);
            
            NSMethodSignature * sig = [self methodSignatureForSelector:sel];
            
            if (!sig) [self doesNotRecognizeSelector:sel];
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
            
            if (!inv) [self doesNotRecognizeSelector:sel];
            
            [inv setTarget:self];
            
            [inv setSelector:sel];
            
            if (sig.numberOfArguments == values.count + 2) {
                
                [values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSInteger index = idx + 2;
                    
                    [self setInv:inv Sig:sig Obj:obj Index:index];
                }];
                
                [inv invoke];
                
            } else {
                
                NSAssert(YES, @"参数个数与方法参数个数不匹配");
            }
            
        }
        
    }
    
}

- (LEEFontConfigModel *)lee_font{
    
    LEEFontConfigModel *model = objc_getAssociatedObject(self, _cmd);
    
    if (!model) {
        
        NSAssert(![self isKindOfClass:[LEEFontConfigModel class]], @"是不是点多了? ( *・ω・)✄╰ひ╯ ");
        
        model = [LEEFontConfigModel new];
        
        objc_setAssociatedObject(self, _cmd, model , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leeFont_ChangeFontConfigNotify:) name:LEEFontChangingNotificaiton object:nil];
        
        [self setIsLeeFont:YES];
        
        __weak typeof(self) weakSelf = self;
        
        model.modelUpdateCurrentFontConfig = ^{
            
            if (weakSelf) [weakSelf changeFontConfig];
        };
        
        model.modelConfigFontChangingBlock = ^{
            
            if (weakSelf) weakSelf.lee_font.modelChangingBlock([LEEFont currentFontStyleTag], weakSelf);
        };
        
    }
    
    return model;
}

- (void)setLee_font:(LEEFontConfigModel *)lee_font{
    
    if(self) objc_setAssociatedObject(self, @selector(lee_font), lee_font , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isLeeFont{
    
    return self ? [objc_getAssociatedObject(self, _cmd) boolValue] : NO;
}

- (void)setIsLeeFont:(BOOL)isLeeFont{
    
    if (self) objc_setAssociatedObject(self, @selector(isLeeFont), @(isLeeFont) , OBJC_ASSOCIATION_ASSIGN);
}

@end
