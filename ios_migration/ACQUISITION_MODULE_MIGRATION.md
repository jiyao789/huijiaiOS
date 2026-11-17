# 房源收购意向申报模块 - iOS 迁移文档

> 本文档基于 Android 项目 `android_huijia3.0` 中的房源收购意向申报模块，为 iOS (Objective-C) 项目提供完整的迁移指南。

## 目录

1. [模块概述](#1-模块概述)
2. [功能流程图](#2-功能流程图)
3. [数据模型](#3-数据模型)
4. [API 接口](#4-api-接口)
5. [视图控制器结构](#5-视图控制器结构)
6. [UI 布局详解](#6-ui-布局详解)
7. [业务逻辑实现](#7-业务逻辑实现)
8. [文件结构建议](#8-文件结构建议)

---

## 1. 模块概述

### 1.1 功能描述

房源收购意向申报模块允许用户提交房源收购意向，包含以下核心功能：

- **新建申报**：多步骤表单填写（基本信息 → 上传证明材料 → 意向报价 → 提交成功）
- **我的申报**：查看申报列表，支持分页加载
- **申报详情**：查看申报信息和审核进度
- **撤销申报**：撤回已提交的申报
- **重新提交**：预审不通过时可重新编辑提交

### 1.2 页面流程

```
在首页点击“房源收购意向申报”卡片后跳转到ios_migration/image/declaration_add_step1.jpg，有以下流程：
（step1-3对应原型图declaration_add_step1-3）
新建申报流程:
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Step1     │───▶│   Step2     │───▶│   Step3     │───▶│   Step4     │───▶│   Step5     │
│  基本信息   │    │  上传材料   │    │  意向报价   │    │  提交成功   │    │  申报详情   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘

查看申报流程:
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  我的申报   │───▶│  申报详情   │───▶│  查看/重新  │
│   列表页    │    │  (Step5)    │    │  提交表单   │
└─────────────┘    └─────────────┘    └─────────────┘
```
我的申报列表页：ios_migration/image/declaration_detail.jpg
申报详情：ios_migration/image/declaration_detail_progress.jpg
---

## 2. 功能流程图

### 2.1 状态流转

```
申报状态 (status):
┌─────────┐
│ 0-待审核 │ ──────┬───────────────────────┐
└────┬────┘       │                       │
     │            ▼                       ▼
     │    ┌─────────────┐        ┌─────────────┐
     │    │ 1-预审通过  │        │ 2-预审不通过│ → 可重新提交
     │    └─────────────┘        │ (转市场业务)│
     │                           └─────────────┘
     │                                  │
     ▼                                  ▼
┌─────────────┐                 ┌─────────────┐
│ 3-预审否决  │ ← ─ ─ ─ ─ ─ ─ ─│    可重新   │
│             │                 │    提交     │
└─────────────┘                 └─────────────┘

进度状态 (progress):
0 = 已撤销
1 = 预审中（正常状态）
```

---

## 3. 数据模型

### 3.1 申报列表项模型

```objc
// AcquisitionListItemModel.h
@interface AcquisitionListItemModel : NSObject

@property (nonatomic, assign) NSInteger itemId;           // 申报ID
@property (nonatomic, copy) NSString *bh;                 // 申报编号
@property (nonatomic, copy) NSString *declareTime;        // 申报时间 (格式: yyyy-MM-dd)

@end

// AcquisitionListItemModel.m
@implementation AcquisitionListItemModel

// MJExtension 映射（如果使用 MJExtension）
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"itemId": @"id",
        @"declareTime": @"declare_time"
    };
}

@end
```

### 3.2 申报详情模型

```objc
// AcquisitionDetailModel.h
@interface AcquisitionDetailModel : NSObject

// 基础信息
@property (nonatomic, assign) NSInteger itemId;           // 申报ID
@property (nonatomic, copy) NSString *bh;                 // 申报编号
@property (nonatomic, copy) NSString *declareTime;        // 申报时间
@property (nonatomic, copy) NSString *phoneNumber;        // 联系电话
@property (nonatomic, copy) NSString *name;               // 申报人姓名
@property (nonatomic, copy) NSString *address;            // 不动产地址
@property (nonatomic, assign) NSInteger progress;         // 进度状态 (0=已撤销, 1=预审中)
@property (nonatomic, assign) NSInteger status;           // 审核状态 (0-3)

// 产权信息
@property (nonatomic, copy) NSString *ownerName;          // 权利人姓名
@property (nonatomic, assign) NSInteger type;             // 权利类型 (1=商品房, 2=公有住房, 3=其他)
@property (nonatomic, copy) NSString *typeOther;          // 其他类型说明
@property (nonatomic, copy) NSString *certificateNumber;  // 产权证书编号
@property (nonatomic, copy) NSString *size;               // 建筑面积

// 共有情况
@property (nonatomic, assign) NSInteger ownershipType;    // 共有情况 (1=单独, 2=共同, 3=按份)
@property (nonatomic, copy) NSString *ownershipShare;     // 份额比例

// 产权负担情况
@property (nonatomic, assign) NSInteger exceptionStatus;  // 查封/异议 (1=无, 2=有)
@property (nonatomic, assign) NSInteger liveStatus;       // 居住权 (1=无, 2=有)
@property (nonatomic, copy) NSString *liveInfo;           // 居住权人及期限
@property (nonatomic, assign) NSInteger mortgageStatus;   // 抵押状况 (1=无, 2=有)
@property (nonatomic, copy) NSString *mortgageInfo;       // 抵押人及金额
@property (nonatomic, assign) NSInteger hukouStatus;      // 户口 (1=无, 2=有)
@property (nonatomic, assign) NSInteger hukouNum;         // 户口人数

// 申报人与权利人关系
@property (nonatomic, assign) NSInteger relationship;     // 关系 (1=本人, 2=配偶, 3=子女, 4=兄弟姐妹, 5=其他)
@property (nonatomic, copy) NSString *relationshipOther;  // 其他关系说明

// 证明文件URL (多个URL用逗号分隔)
@property (nonatomic, copy) NSString *certificateFile;    // 权证文件
@property (nonatomic, copy) NSString *registerFile;       // 登记簿文件
@property (nonatomic, copy) NSString *ownerIdcardFile;    // 产权人身份证
@property (nonatomic, copy) NSString *requesterIdcardFile;// 申报人身份证
@property (nonatomic, copy) NSString *hukouFile;          // 户口本

// 意向报价
@property (nonatomic, copy) NSString *floorPrice;         // 最低报价(万元)
@property (nonatomic, copy) NSString *ceilingPrice;       // 最高报价(万元)

#pragma mark - 格式化方法

/** 获取权利类型文本 */
- (NSString *)typeText;

/** 获取共有情况文本 */
- (NSString *)ownershipTypeText;

/** 获取审核状态文本 */
- (NSString *)statusText;

/** 获取进度状态文本 */
- (NSString *)progressText;

/** 获取关系文本 */
- (NSString *)relationshipText;

@end
```

```objc
// AcquisitionDetailModel.m
@implementation AcquisitionDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"itemId": @"id",
        @"declareTime": @"declare_time",
        @"phoneNumber": @"phone_number",
        @"ownerName": @"owner_name",
        @"typeOther": @"type_other",
        @"certificateNumber": @"certificate_number",
        @"ownershipType": @"ownership_type",
        @"ownershipShare": @"ownership_share",
        @"exceptionStatus": @"exception_status",
        @"liveStatus": @"live_status",
        @"liveInfo": @"live_info",
        @"mortgageStatus": @"mortgage_status",
        @"mortgageInfo": @"mortgage_info",
        @"hukouStatus": @"hukou_status",
        @"hukouNum": @"hukou_num",
        @"relationshipOther": @"relationship_other",
        @"certificateFile": @"certificate_file",
        @"registerFile": @"register_file",
        @"ownerIdcardFile": @"owner_idcard_file",
        @"requesterIdcardFile": @"requester_idcard_file",
        @"hukouFile": @"hukou_file",
        @"floorPrice": @"floor_price",
        @"ceilingPrice": @"ceiling_price"
    };
}

- (NSString *)typeText {
    switch (self.type) {
        case 1: return @"商品房";
        case 2: return @"公有住房出售";
        case 3: return self.typeOther ?: @"其他";
        default: return @"";
    }
}

- (NSString *)ownershipTypeText {
    switch (self.ownershipType) {
        case 1: return @"单独所有";
        case 2: return @"共同所有";
        case 3: return @"按份所有";
        default: return @"";
    }
}

- (NSString *)statusText {
    switch (self.status) {
        case 0: return @"待审核";
        case 1: return @"预审通过";
        case 2: return @"预审不通过，转市场业务";
        case 3: return @"预审否决";
        default: return @"";
    }
}

- (NSString *)progressText {
    switch (self.progress) {
        case 0: return @"已撤销";
        case 1: return @"预审中";
        default: return @"";
    }
}

- (NSString *)relationshipText {
    switch (self.relationship) {
        case 1: return @"本人";
        case 2: return @"配偶";
        case 3: return @"子女";
        case 4: return @"兄弟姐妹";
        case 5: return self.relationshipOther ?: @"其他";
        default: return @"";
    }
}

@end
```

### 3.3 申报进度模型

```objc
// AcquisitionProgressModel.h
@interface AcquisitionProgressItem : NSObject

@property (nonatomic, assign) NSInteger progressType;     // 进度类型 (1=审批程序)
@property (nonatomic, assign) NSInteger progressStatus;   // 进度状态
@property (nonatomic, assign) long long createTime;       // 创建时间戳(毫秒)

/** 获取进度类型文本 */
- (NSString *)progressTypeText;

/** 获取进度状态文本 */
- (NSString *)progressStatusText;

/** 获取格式化的时间字符串 */
- (NSString *)formattedTime;

@end

@interface AcquisitionProgressModel : NSObject

@property (nonatomic, strong) NSArray<AcquisitionProgressItem *> *reviewProgress;

@end
```

```objc
// AcquisitionProgressModel.m
@implementation AcquisitionProgressItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"progressType": @"progress_type",
        @"progressStatus": @"progress_status",
        @"createTime": @"create_time"
    };
}

- (NSString *)progressTypeText {
    switch (self.progressType) {
        case 1: return @"审批程序";
        default: return @"";
    }
}

- (NSString *)progressStatusText {
    switch (self.progressStatus) {
        case 0: return @"待审核";
        case 1: return @"预审通过";
        case 2: return @"预审不通过，转市场业务";
        case 3: return @"预审否决";
        case 4: return @"申报已被撤回";
        default: return @"";
    }
}

- (NSString *)formattedTime {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.createTime / 1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

@end

@implementation AcquisitionProgressModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"reviewProgress": [AcquisitionProgressItem class]};
}

@end
```

### 3.4 统计模型

```objc
// AcquisitionCountModel.h
@interface AcquisitionCountModel : NSObject

@property (nonatomic, assign) NSInteger count;  // 申报总数

@end
```

### 3.5 新增申报结果模型

```objc
// AddDeclarationResultModel.h
@interface AddDeclarationResultModel : NSObject

@property (nonatomic, assign) NSInteger itemId;  // 新创建的申报ID

@end

// 实现
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"itemId": @"id"};
}
```

### 3.6 表单数据单例 (跨页面数据传递)

```objc
// AcquisitionFormData.h
@interface AcquisitionFormData : NSObject

#pragma mark - Step1: 基础信息

@property (nonatomic, copy) NSString *ownerName;          // 权利人姓名
@property (nonatomic, assign) NSInteger type;             // 权利类型 (1/2/3)
@property (nonatomic, copy) NSString *typeOther;          // 其他类型说明
@property (nonatomic, copy) NSString *certificateNumber;  // 证书编号
@property (nonatomic, copy) NSString *address;            // 完整地址
@property (nonatomic, copy) NSString *size;               // 建筑面积

// 地址拆分字段（用于表单编辑）
@property (nonatomic, copy) NSString *addressRoad;        // 路
@property (nonatomic, copy) NSString *addressNong;        // 弄
@property (nonatomic, copy) NSString *addressHao;         // 号
@property (nonatomic, copy) NSString *addressShi;         // 室

@property (nonatomic, strong) NSNumber *ownershipType;    // 共有情况 (可为nil)
@property (nonatomic, copy) NSString *ownershipShare;     // 份额

@property (nonatomic, strong) NSNumber *exceptionStatus;  // 查封/异议
@property (nonatomic, strong) NSNumber *liveStatus;       // 居住权
@property (nonatomic, copy) NSString *liveInfo;           // 居住权信息
@property (nonatomic, strong) NSNumber *mortgageStatus;   // 抵押状况
@property (nonatomic, copy) NSString *mortgageInfo;       // 抵押信息
@property (nonatomic, strong) NSNumber *hukouStatus;      // 户口
@property (nonatomic, strong) NSNumber *hukouNum;         // 户口人数

@property (nonatomic, copy) NSString *requesterName;      // 申报人姓名
@property (nonatomic, copy) NSString *requesterPhoneNum;  // 申报人电话
@property (nonatomic, assign) NSInteger relationship;     // 关系 (1-5)
@property (nonatomic, copy) NSString *relationshipOther;  // 其他关系说明

#pragma mark - Step2: 图片URL (多个URL用逗号分隔)

@property (nonatomic, copy) NSString *certificateFile;    // 权证文件
@property (nonatomic, copy) NSString *registerFile;       // 登记簿
@property (nonatomic, copy) NSString *ownerIdcardFile;    // 产权人身份证
@property (nonatomic, copy) NSString *requesterIdcardFile;// 申报人身份证
@property (nonatomic, copy) NSString *hukouFile;          // 户口本

#pragma mark - Step3: 报价

@property (nonatomic, copy) NSString *floorPrice;         // 最低报价
@property (nonatomic, copy) NSString *ceilingPrice;       // 最高报价

#pragma mark - 提交结果

@property (nonatomic, assign) NSInteger declarationId;    // 申报ID
@property (nonatomic, copy) NSString *declarationCode;    // 申报编号

#pragma mark - 单例

+ (instancetype)sharedInstance;

#pragma mark - 方法

/** 获取申报日期 (当天日期 yyyy-MM-dd) */
- (NSString *)getDeclareTime;

/** 组装完整地址 */
- (NSString *)getFullAddress;

/** 重置所有字段 */
- (void)clear;

/** 验证Step1必填项 */
- (BOOL)isStep1Complete;

/** 验证Step2必填项 */
- (BOOL)isStep2Complete;

/** 验证Step3必填项 */
- (BOOL)isStep3Complete;

/** 验证所有必填项 */
- (BOOL)isComplete;

@end
```

```objc
// AcquisitionFormData.m
@implementation AcquisitionFormData

+ (instancetype)sharedInstance {
    static AcquisitionFormData *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AcquisitionFormData alloc] init];
    });
    return instance;
}

- (NSString *)getDeclareTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)getFullAddress {
    return [NSString stringWithFormat:@"%@路%@弄%@号%@室",
            self.addressRoad ?: @"",
            self.addressNong ?: @"",
            self.addressHao ?: @"",
            self.addressShi ?: @""];
}

- (void)clear {
    self.ownerName = nil;
    self.type = 0;
    self.typeOther = nil;
    self.certificateNumber = nil;
    self.address = nil;
    self.size = nil;
    self.addressRoad = nil;
    self.addressNong = nil;
    self.addressHao = nil;
    self.addressShi = nil;
    self.ownershipType = nil;
    self.ownershipShare = nil;
    self.exceptionStatus = nil;
    self.liveStatus = nil;
    self.liveInfo = nil;
    self.mortgageStatus = nil;
    self.mortgageInfo = nil;
    self.hukouStatus = nil;
    self.hukouNum = nil;
    self.requesterName = nil;
    self.requesterPhoneNum = nil;
    self.relationship = 0;
    self.relationshipOther = nil;
    self.certificateFile = nil;
    self.registerFile = nil;
    self.ownerIdcardFile = nil;
    self.requesterIdcardFile = nil;
    self.hukouFile = nil;
    self.floorPrice = nil;
    self.ceilingPrice = nil;
    self.declarationId = 0;
    self.declarationCode = nil;
}

- (BOOL)isStep1Complete {
    if (!self.ownerName.length) return NO;
    if (self.type == 0) return NO;
    if (self.type == 3 && !self.typeOther.length) return NO;
    if (!self.certificateNumber.length) return NO;
    if (!self.addressRoad.length && !self.addressNong.length &&
        !self.addressHao.length && !self.addressShi.length) return NO;
    if (!self.size.length) return NO;
    if (!self.requesterName.length) return NO;
    if (!self.requesterPhoneNum.length) return NO;
    if (self.relationship == 0) return NO;
    if (self.relationship == 5 && !self.relationshipOther.length) return NO;
    return YES;
}

- (BOOL)isStep2Complete {
    if (!self.certificateFile.length) return NO;
    if (!self.registerFile.length) return NO;
    if (!self.ownerIdcardFile.length) return NO;
    return YES;
}

- (BOOL)isStep3Complete {
    if (!self.floorPrice.length) return NO;
    if (!self.ceilingPrice.length) return NO;
    return YES;
}

- (BOOL)isComplete {
    return [self isStep1Complete] && [self isStep2Complete] && [self isStep3Complete];
}

@end
```

---

## 4. API 接口

### 4.1 接口定义

在 `YDInterfaceDefinition.h` 中添加:

```objc
#pragma mark - 房源收购意向申报

/** 新增申报 POST multipart/form-data */
#define kAPI_AcquisitionDeclaration_Add      @"user/AcquisitionDeclaration/add"

/** 查询申报详情 GET ?id=xxx */
#define kAPI_AcquisitionDeclaration_Get      @"user/acquisitionDeclaration/get"

/** 我的申报列表 GET ?page=x&rows=x */
#define kAPI_AcquisitionDeclaration_List     @"user/acquisitionDeclaration/list"

/** 撤销申报 POST ?id=xxx */
#define kAPI_AcquisitionDeclaration_Cancel   @"user/acquisitionDeclaration/cancel"

/** 申报统计 GET */
#define kAPI_AcquisitionDeclaration_Count    @"user/acquisitionDeclaration/count"

/** 申报进度查询 GET ?id=xxx */
#define kAPI_AcquisitionDeclaration_Progress @"user/acquisitionDeclaration/progress"
```

### 4.2 API 请求封装

```objc
// AcquisitionAPI.h
@interface AcquisitionAPI : NSObject

#pragma mark - 新增申报

/**
 * 提交房源收购意向申报
 * @param formData 表单数据单例
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)addDeclarationWithFormData:(AcquisitionFormData *)formData
                           success:(void(^)(AddDeclarationResultModel *result))success
                           failure:(void(^)(NSString *errorMsg))failure;

#pragma mark - 查询详情

/**
 * 获取申报详情
 * @param declarationId 申报ID
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)getDeclarationWithId:(NSInteger)declarationId
                     success:(void(^)(AcquisitionDetailModel *detail))success
                     failure:(void(^)(NSString *errorMsg))failure;

#pragma mark - 我的申报列表

/**
 * 获取我的申报列表
 * @param page 页码 (从1开始)
 * @param rows 每页条数 (默认10)
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)getDeclarationListWithPage:(NSInteger)page
                              rows:(NSInteger)rows
                           success:(void(^)(NSArray<AcquisitionListItemModel *> *list, BOOL hasMore))success
                           failure:(void(^)(NSString *errorMsg))failure;

#pragma mark - 撤销申报

/**
 * 撤销申报
 * @param declarationId 申报ID
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)cancelDeclarationWithId:(NSInteger)declarationId
                        success:(void(^)(void))success
                        failure:(void(^)(NSString *errorMsg))failure;

#pragma mark - 申报统计

/**
 * 获取申报统计
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)getDeclarationCountWithSuccess:(void(^)(NSInteger count))success
                               failure:(void(^)(NSString *errorMsg))failure;

#pragma mark - 申报进度

/**
 * 获取申报进度
 * @param declarationId 申报ID
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)getDeclarationProgressWithId:(NSInteger)declarationId
                             success:(void(^)(NSArray<AcquisitionProgressItem *> *progressList))success
                             failure:(void(^)(NSString *errorMsg))failure;

@end
```

```objc
// AcquisitionAPI.m
#import "AcquisitionAPI.h"
#import "HttpRequest.h"
#import <MJExtension/MJExtension.h>

@implementation AcquisitionAPI

#pragma mark - 新增申报

+ (void)addDeclarationWithFormData:(AcquisitionFormData *)formData
                           success:(void(^)(AddDeclarationResultModel *result))success
                           failure:(void(^)(NSString *errorMsg))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    // 必填参数
    params[@"declareTime"] = [formData getDeclareTime];
    params[@"requesterPhoneNum"] = formData.requesterPhoneNum ?: @"";
    params[@"requesterName"] = formData.requesterName ?: @"";
    params[@"address"] = [formData getFullAddress];
    params[@"ownerName"] = formData.ownerName ?: @"";
    params[@"type"] = @(formData.type);
    params[@"certificateNumber"] = formData.certificateNumber ?: @"";
    params[@"size"] = formData.size ?: @"";
    params[@"relationship"] = @(formData.relationship);
    params[@"certificateFile"] = formData.certificateFile ?: @"";
    params[@"registerFile"] = formData.registerFile ?: @"";
    params[@"ownerIdcardFile"] = formData.ownerIdcardFile ?: @"";
    params[@"requesterIdcardFile"] = formData.requesterIdcardFile ?: @"";
    params[@"floorPrice"] = formData.floorPrice ?: @"";
    params[@"ceilingPrice"] = formData.ceilingPrice ?: @"";

    // 可选参数
    if (formData.typeOther.length) {
        params[@"typeOther"] = formData.typeOther;
    }
    if (formData.ownershipType) {
        params[@"ownershipType"] = formData.ownershipType;
    }
    if (formData.ownershipShare.length) {
        params[@"ownershipShare"] = formData.ownershipShare;
    }
    if (formData.exceptionStatus) {
        params[@"exceptionStatus"] = formData.exceptionStatus;
    }
    if (formData.liveStatus) {
        params[@"liveStatus"] = formData.liveStatus;
    }
    if (formData.liveInfo.length) {
        params[@"liveInfo"] = formData.liveInfo;
    }
    if (formData.mortgageStatus) {
        params[@"mortgageStatus"] = formData.mortgageStatus;
    }
    if (formData.mortgageInfo.length) {
        params[@"mortgageInfo"] = formData.mortgageInfo;
    }
    if (formData.hukouStatus) {
        params[@"hukouStatus"] = formData.hukouStatus;
    }
    if (formData.hukouNum) {
        params[@"hukouNum"] = formData.hukouNum;
    }
    if (formData.relationshipOther.length) {
        params[@"relationshipOther"] = formData.relationshipOther;
    }
    if (formData.hukouFile.length) {
        params[@"hukouFile"] = formData.hukouFile;
    }

    // 使用 multipart/form-data 方式提交
    [HttpRequest postWithUrl:kAPI_AcquisitionDeclaration_Add
                      params:params
                     success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            AddDeclarationResultModel *result = [AddDeclarationResultModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (success) success(result);
        } else {
            if (failure) failure(responseObject[@"msg"] ?: @"提交失败");
        }
    } failure:^(NSError *error) {
        if (failure) failure(error.localizedDescription ?: @"网络请求失败");
    }];
}

#pragma mark - 查询详情

+ (void)getDeclarationWithId:(NSInteger)declarationId
                     success:(void(^)(AcquisitionDetailModel *detail))success
                     failure:(void(^)(NSString *errorMsg))failure {

    NSDictionary *params = @{@"id": @(declarationId)};

    [HttpRequest getWithUrl:kAPI_AcquisitionDeclaration_Get
                     params:params
                    success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            AcquisitionDetailModel *detail = [AcquisitionDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (success) success(detail);
        } else {
            if (failure) failure(responseObject[@"msg"] ?: @"获取失败");
        }
    } failure:^(NSError *error) {
        if (failure) failure(error.localizedDescription ?: @"网络请求失败");
    }];
}

#pragma mark - 我的申报列表

+ (void)getDeclarationListWithPage:(NSInteger)page
                              rows:(NSInteger)rows
                           success:(void(^)(NSArray<AcquisitionListItemModel *> *list, BOOL hasMore))success
                           failure:(void(^)(NSString *errorMsg))failure {

    NSDictionary *params = @{
        @"page": @(page),
        @"rows": @(rows)
    };

    [HttpRequest getWithUrl:kAPI_AcquisitionDeclaration_List
                     params:params
                    success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *listArray = data[@"list"];
            NSDictionary *pageInfo = data[@"page"];

            NSArray<AcquisitionListItemModel *> *list = [AcquisitionListItemModel mj_objectArrayWithKeyValuesArray:listArray];
            BOOL hasMore = [pageInfo[@"hasMore"] boolValue];

            if (success) success(list, hasMore);
        } else {
            if (failure) failure(responseObject[@"msg"] ?: @"获取失败");
        }
    } failure:^(NSError *error) {
        if (failure) failure(error.localizedDescription ?: @"网络请求失败");
    }];
}

#pragma mark - 撤销申报

+ (void)cancelDeclarationWithId:(NSInteger)declarationId
                        success:(void(^)(void))success
                        failure:(void(^)(NSString *errorMsg))failure {

    NSDictionary *params = @{@"id": @(declarationId)};

    [HttpRequest postWithUrl:kAPI_AcquisitionDeclaration_Cancel
                      params:params
                     success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            if (success) success();
        } else {
            if (failure) failure(responseObject[@"msg"] ?: @"撤销失败");
        }
    } failure:^(NSError *error) {
        if (failure) failure(error.localizedDescription ?: @"网络请求失败");
    }];
}

#pragma mark - 申报统计

+ (void)getDeclarationCountWithSuccess:(void(^)(NSInteger count))success
                               failure:(void(^)(NSString *errorMsg))failure {

    [HttpRequest getWithUrl:kAPI_AcquisitionDeclaration_Count
                     params:nil
                    success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            NSInteger count = [responseObject[@"data"][@"count"] integerValue];
            if (success) success(count);
        } else {
            if (failure) failure(responseObject[@"msg"] ?: @"获取失败");
        }
    } failure:^(NSError *error) {
        if (failure) failure(error.localizedDescription ?: @"网络请求失败");
    }];
}

#pragma mark - 申报进度

+ (void)getDeclarationProgressWithId:(NSInteger)declarationId
                             success:(void(^)(NSArray<AcquisitionProgressItem *> *progressList))success
                             failure:(void(^)(NSString *errorMsg))failure {

    NSDictionary *params = @{@"id": @(declarationId)};

    [HttpRequest getWithUrl:kAPI_AcquisitionDeclaration_Progress
                     params:params
                    success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            NSArray *progressArray = responseObject[@"data"][@"reviewProgress"];
            NSArray<AcquisitionProgressItem *> *list = [AcquisitionProgressItem mj_objectArrayWithKeyValuesArray:progressArray];
            if (success) success(list);
        } else {
            if (failure) failure(responseObject[@"msg"] ?: @"获取失败");
        }
    } failure:^(NSError *error) {
        if (failure) failure(error.localizedDescription ?: @"网络请求失败");
    }];
}

@end
```

### 4.3 API 响应码说明

| 响应码 | 说明 |
|--------|------|
| 200 | 成功 |
| 10001 | 需要登录认证 |
| 302 | Session 过期，需重新登录 |

---

## 5. 视图控制器结构

### 5.1 控制器列表

| 控制器 | 功能 | 对应Android |
|--------|------|-------------|
| `AcquisitionStep1VC` | 基本信息表单 | HouseAcquisitionActivity |
| `AcquisitionStep2VC` | 上传证明材料 | HouseAcquisitionStep2Activity |
| `AcquisitionStep3VC` | 意向报价 | HouseAcquisitionStep3Activity |
| `AcquisitionStep4VC` | 提交成功 | HouseAcquisitionStep4Activity |
| `AcquisitionStep5VC` | 申报详情 | HouseAcquisitionStep5Activity |
| `MineAcquisitionListVC` | 我的申报列表 | MineAcquisitionListActivity |
| `RegisterGuideVC` | 不动产登记簿引导 | RegisterGuideActivity |

### 5.2 基类继承

所有控制器继承自 `BaseViewController`：

```objc
@interface AcquisitionStep1VC : BaseViewController
// 是否为只读模式
@property (nonatomic, assign) BOOL isViewMode;
// 用于编辑/查看时传入的详情数据
@property (nonatomic, strong) AcquisitionDetailModel *detailModel;
@end
```

---

## 6. UI 布局详解

### 6.1 Step1 - 基本信息表单

#### 表单字段列表

| 序号 | 字段名 | 类型 | 必填 | 说明 |
|------|--------|------|------|------|
| 1 | 权利人姓名 | 文本输入 | ✓ | 若有共有需填全体权利人 |
| 2 | 权利类型 | 单选 | ✓ | 商品房/公有住房出售/其他 |
| 3 | 证书编号 | 文本输入 | ✓ | 不动产权证书编号 |
| 4 | 坐落 | 四段输入 | ✓ | 路/弄/号/室 |
| 5 | 建筑面积 | 数字输入 | ✓ | 单位：㎡ |
| 6 | 共有情况 | 单选 | ✓ | 单独/共同/按份所有 |
| 7 | 查封/异议 | 单选 | ✓ | 有/无 |
| 8 | 居住权 | 单选 | - | 有/无，选有需填详情 |
| 9 | 抵押状况 | 单选 | - | 有/无，选有需填详情 |
| 10 | 户口 | 单选 | - | 有/无，选有需填人数 |
| 11 | 填报人信息 | 文本输入 | ✓ | 姓名+联系电话 |
| 12 | 与权利人关系 | 单选 | ✓ | 本人/配偶/子女/兄弟姐妹/其他 |

#### 布局结构 (Masonry)

```objc
// AcquisitionStep1VC.m - viewDidLoad 中的布局示例

// 创建滚动视图
UIScrollView *scrollView = [[UIScrollView alloc] init];
scrollView.showsVerticalScrollIndicator = NO;
[self.view addSubview:scrollView];
[scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.navBar.mas_bottom);
    make.left.right.equalTo(self.view);
    make.bottom.equalTo(self.bottomButtonView.mas_top);
}];

UIView *contentView = [[UIView alloc] init];
[scrollView addSubview:contentView];
[contentView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(scrollView);
    make.width.equalTo(scrollView);
}];

// 标题
UILabel *sectionTitle = [[UILabel alloc] init];
sectionTitle.text = @"一、不动产权属信息";
sectionTitle.textColor = [UIColor colorWithHexString:@"2A629A"];
sectionTitle.font = [UIFont boldSystemFontOfSize:16];
[contentView addSubview:sectionTitle];
[sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(contentView).offset(15);
    make.left.equalTo(contentView).offset(15);
}];

// 1. 权利人姓名
UILabel *ownerNameLabel = [self createFormLabel:@"1. 不动产权利人姓名（若有共有，需填写全体权利人姓名）"];
[contentView addSubview:ownerNameLabel];
[ownerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(sectionTitle.mas_bottom).offset(15);
    make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
}];

self.ownerNameTextField = [self createTextField:@"请输入姓名"];
[contentView addSubview:self.ownerNameTextField];
[self.ownerNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(ownerNameLabel.mas_bottom).offset(10);
    make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    make.height.mas_equalTo(40);
}];

// ... 依此类推添加其他表单项

// 底部固定的按钮区域
UIView *bottomButtonView = [[UIView alloc] init];
[self.view addSubview:bottomButtonView];
[bottomButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.equalTo(self.view);
    make.height.mas_equalTo(64 + SAFE_AREA_BOTTOM);
}];

// 返回上一步按钮
UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
[backButton setTitle:@"返回上一步" forState:UIControlStateNormal];
backButton.backgroundColor = [UIColor whiteColor];
backButton.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
backButton.layer.borderWidth = 1;
backButton.layer.cornerRadius = 4;
[backButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
[bottomButtonView addSubview:backButton];

// 下一步按钮
UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
[nextButton setTitle:@"下一步" forState:UIControlStateNormal];
nextButton.backgroundColor = [UIColor colorWithHexString:@"2A629A"];
nextButton.layer.cornerRadius = 4;
[nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
[bottomButtonView addSubview:nextButton];
```

#### 单选按钮组实现

```objc
// 创建单选按钮组
- (UIView *)createRadioGroupWithOptions:(NSArray<NSString *> *)options
                           selectedIndex:(NSInteger)selectedIndex
                          selectionBlock:(void(^)(NSInteger index))selectionBlock {

    UIView *container = [[UIView alloc] init];
    __block UIButton *lastButton = nil;

    [options enumerateObjectsUsingBlock:^(NSString *option, NSUInteger idx, BOOL *stop) {
        UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [radioButton setTitle:[NSString stringWithFormat:@"  %@", option] forState:UIControlStateNormal];
        [radioButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        radioButton.titleLabel.font = [UIFont systemFontOfSize:14];
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        // 设置选中/未选中图标
        [radioButton setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
        [radioButton setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateSelected];

        radioButton.selected = (idx == selectedIndex);
        radioButton.tag = idx;

        [radioButton addTarget:self action:@selector(radioButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        [container addSubview:radioButton];
        [radioButton mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastButton) {
                make.top.equalTo(lastButton.mas_bottom).offset(10);
            } else {
                make.top.equalTo(container);
            }
            make.left.right.equalTo(container);
            make.height.mas_equalTo(30);
        }];

        lastButton = radioButton;
    }];

    [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(container);
    }];

    return container;
}
```

### 6.2 Step2 - 上传证明材料

#### 图片上传组说明

| 序号 | 类型 | 必填 | 最大数量 |
|------|------|------|----------|
| 1 | 房屋所有权证/房地产权证/不动产权证书 | ✓ | 12张 |
| 2 | 不动产登记簿 | ✓ | 12张 |
| 3 | 产权人身份证 | ✓ | 12张 |
| 4 | 申报人身份证 | - | 12张 |
| 5 | 户口登记人户口本 | - | 12张 |

#### 图片上传组件

```objc
// ImageUploadGroupView.h
@protocol ImageUploadGroupDelegate <NSObject>
- (void)imageUploadGroupDidTapAdd:(NSInteger)groupIndex;
- (void)imageUploadGroupDidTapPreview:(NSString *)imageUrl;
- (void)imageUploadGroupDidTapDelete:(NSInteger)groupIndex imageIndex:(NSInteger)imageIndex;
@end

@interface ImageUploadGroupView : UIView

@property (nonatomic, weak) id<ImageUploadGroupDelegate> delegate;
@property (nonatomic, assign) NSInteger groupIndex;
@property (nonatomic, assign) BOOL isViewMode;  // 只读模式
@property (nonatomic, assign) NSInteger maxCount;  // 最大图片数量

- (void)setImageUrls:(NSArray<NSString *> *)urls;
- (NSArray<NSString *> *)getImageUrls;
- (void)addImageWithUrl:(NSString *)url;

@end
```

```objc
// ImageUploadGroupView.m
@interface ImageUploadGroupView ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<NSString *> *imageUrls;
@end

@implementation ImageUploadGroupView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxCount = 12;
        self.imageUrls = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width - 30;
    CGFloat itemWidth = (screenWidth - 30) / 4;  // 4列
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;

    [self.collectionView registerClass:[ImageUploadCell class] forCellWithReuseIdentifier:@"ImageUploadCell"];
    [self.collectionView registerClass:[AddImageCell class] forCellWithReuseIdentifier:@"AddImageCell"];

    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 如果不是只读模式且未达到最大数量，显示添加按钮
    if (!self.isViewMode && self.imageUrls.count < self.maxCount) {
        return self.imageUrls.count + 1;
    }
    return self.imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.imageUrls.count && !self.isViewMode) {
        // 添加按钮
        AddImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddImageCell" forIndexPath:indexPath];
        return cell;
    } else {
        // 图片Cell
        ImageUploadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageUploadCell" forIndexPath:indexPath];
        cell.imageUrl = self.imageUrls[indexPath.item];
        cell.isViewMode = self.isViewMode;
        cell.deleteBlock = ^{
            if ([self.delegate respondsToSelector:@selector(imageUploadGroupDidTapDelete:imageIndex:)]) {
                [self.delegate imageUploadGroupDidTapDelete:self.groupIndex imageIndex:indexPath.item];
            }
        };
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.imageUrls.count && !self.isViewMode) {
        // 点击添加
        if ([self.delegate respondsToSelector:@selector(imageUploadGroupDidTapAdd:)]) {
            [self.delegate imageUploadGroupDidTapAdd:self.groupIndex];
        }
    } else {
        // 点击预览
        if ([self.delegate respondsToSelector:@selector(imageUploadGroupDidTapPreview:)]) {
            [self.delegate imageUploadGroupDidTapPreview:self.imageUrls[indexPath.item]];
        }
    }
}

@end
```

### 6.3 Step3 - 意向报价

```objc
// AcquisitionStep3VC.m

- (void)setupUI {
    // 标题
    UILabel *sectionTitle = [[UILabel alloc] init];
    sectionTitle.text = @"三、意向报价";
    sectionTitle.textColor = [UIColor colorWithHexString:@"2A629A"];
    sectionTitle.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:sectionTitle];
    [sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
    }];

    // 报价输入区域
    UIView *priceContainer = [[UIView alloc] init];
    [self.view addSubview:priceContainer];
    [priceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionTitle.mas_bottom).offset(20);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];

    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"意向报价";
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [priceContainer addSubview:priceLabel];

    self.minPriceTextField = [[UITextField alloc] init];
    self.minPriceTextField.placeholder = @"";
    self.minPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.minPriceTextField.textAlignment = NSTextAlignmentCenter;
    self.minPriceTextField.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    self.minPriceTextField.layer.borderWidth = 1;
    self.minPriceTextField.layer.cornerRadius = 4;
    [priceContainer addSubview:self.minPriceTextField];

    UILabel *toLabel = [[UILabel alloc] init];
    toLabel.text = @"至";
    toLabel.font = [UIFont systemFontOfSize:14];
    toLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [priceContainer addSubview:toLabel];

    self.maxPriceTextField = [[UITextField alloc] init];
    self.maxPriceTextField.placeholder = @"";
    self.maxPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.maxPriceTextField.textAlignment = NSTextAlignmentCenter;
    self.maxPriceTextField.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    self.maxPriceTextField.layer.borderWidth = 1;
    self.maxPriceTextField.layer.cornerRadius = 4;
    [priceContainer addSubview:self.maxPriceTextField];

    UILabel *unitLabel = [[UILabel alloc] init];
    unitLabel.text = @"万元";
    unitLabel.font = [UIFont systemFontOfSize:14];
    unitLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [priceContainer addSubview:unitLabel];

    // 布局
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(priceContainer);
    }];

    [self.minPriceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.mas_right).offset(10);
        make.centerY.equalTo(priceContainer);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(36);
    }];

    [toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minPriceTextField.mas_right).offset(10);
        make.centerY.equalTo(priceContainer);
    }];

    [self.maxPriceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toLabel.mas_right).offset(10);
        make.centerY.equalTo(priceContainer);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(36);
    }];

    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maxPriceTextField.mas_right).offset(10);
        make.centerY.equalTo(priceContainer);
    }];

    [priceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
    }];
}
```

### 6.4 Step4 - 提交成功

```objc
// AcquisitionStep4VC.m

- (void)setupUI {
    UIView *contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(50);
        make.left.right.equalTo(self.view);
    }];

    // 成功图标
    UIImageView *successIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_success"]];
    [contentView addSubview:successIcon];
    [successIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView);
        make.width.height.mas_equalTo(80);
    }];

    // 提交成功文字
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.text = @"提交成功";
    successLabel.textColor = [UIColor colorWithHexString:@"2A629A"];
    successLabel.font = [UIFont boldSystemFontOfSize:24];
    [contentView addSubview:successLabel];
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(successIcon.mas_bottom).offset(20);
    }];

    // 提示文字
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"请关注申报详情，并保持电话畅通，工作人员将在初审通过后尽快与您联系\n\n后续可在"我的"-"我的申报"中查看进度";
    tipLabel.textColor = [UIColor colorWithHexString:@"999999"];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    [contentView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successLabel.mas_bottom).offset(20);
        make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 40, 0, 40));
    }];

    // 查看详情按钮
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailButton setTitle:@"查看申报详情" forState:UIControlStateNormal];
    detailButton.backgroundColor = [UIColor colorWithHexString:@"2A629A"];
    detailButton.layer.cornerRadius = 4;
    [detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    detailButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [detailButton addTarget:self action:@selector(viewDetailButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:detailButton];
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(40);
        make.centerX.equalTo(contentView);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(contentView);
    }];
}
```

### 6.5 Step5 - 申报详情

#### 进度视图组件

```objc
// ProgressStepView.h
@interface ProgressStepView : UIView

@property (nonatomic, strong) AcquisitionProgressItem *progressItem;
@property (nonatomic, assign) BOOL isLast;

@end

// ProgressStepView.m
@implementation ProgressStepView

- (void)setProgressItem:(AcquisitionProgressItem *)progressItem {
    _progressItem = progressItem;
    [self setupUI];
}

- (void)setupUI {
    // 清除旧视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // 左侧状态图标
    UIView *iconContainer = [[UIView alloc] init];
    [self addSubview:iconContainer];
    [iconContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.mas_equalTo(20);
    }];

    UIView *statusIcon = [[UIView alloc] init];
    statusIcon.layer.cornerRadius = 8;
    [iconContainer addSubview:statusIcon];
    [statusIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconContainer);
        make.top.equalTo(iconContainer);
        make.width.height.mas_equalTo(16);
    }];

    // 根据状态设置图标样式
    switch (self.progressItem.progressStatus) {
        case 0:  // 待审核 - 灰色圆点
            statusIcon.backgroundColor = [UIColor colorWithHexString:@"CCCCCC"];
            break;
        case 1:  // 预审通过 - 蓝色对勾
            statusIcon.backgroundColor = [UIColor colorWithHexString:@"2A629A"];
            // 添加对勾图标...
            break;
        case 2:  // 预审不通过
        case 3:  // 预审否决
        case 4:  // 已撤回
            statusIcon.backgroundColor = [UIColor colorWithHexString:@"FF4444"];
            // 添加X图标...
            break;
    }

    // 连接线
    if (!self.isLast) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
        [iconContainer addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(iconContainer);
            make.top.equalTo(statusIcon.mas_bottom);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(40);
        }];
    }

    // 右侧内容
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconContainer.mas_right).offset(10);
        make.top.right.equalTo(self);
    }];

    // 时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = [self.progressItem formattedTime];
    timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(contentView);
    }];

    // 状态文本
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.text = [self.progressItem progressStatusText];
    statusLabel.textColor = [UIColor colorWithHexString:@"333333"];
    statusLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.top.equalTo(timeLabel.mas_bottom).offset(5);
        make.bottom.equalTo(contentView).offset(-20);
    }];
}

@end
```

### 6.6 我的申报列表

```objc
// MineAcquisitionListVC.m

- (void)setupUI {
    // 列表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self.tableView registerClass:[AcquisitionListCell class] forCellReuseIdentifier:@"AcquisitionListCell"];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    // 配置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithRefresh:YES];
    }];

    // 配置上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadDataWithRefresh:NO];
    }];

    // 空状态视图
    self.emptyView = [[NoMsgView alloc] init];
    self.emptyView.tipText = @"暂无申报记录";
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];
}
```

### 6.7 列表项 Cell

```objc
// AcquisitionListCell.h
@interface AcquisitionListCell : UITableViewCell

@property (nonatomic, strong) AcquisitionListItemModel *model;

@end

// AcquisitionListCell.m
@implementation AcquisitionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 卡片容器
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 8;
    [self.contentView addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView);
    }];

    // 标题行
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"房源收购意向申报";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [cardView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(15);
        make.top.equalTo(cardView).offset(15);
    }];

    self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.detailButton setTitle:@"查看详情 >" forState:UIControlStateNormal];
    [self.detailButton setTitleColor:[UIColor colorWithHexString:@"2A629A"] forState:UIControlStateNormal];
    self.detailButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [cardView addSubview:self.detailButton];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView).offset(-15);
        make.centerY.equalTo(self.titleLabel);
    }];

    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    [cardView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cardView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];

    // 意向编码
    self.codeLabel = [[UILabel alloc] init];
    self.codeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.codeLabel.font = [UIFont systemFontOfSize:13];
    [cardView addSubview:self.codeLabel];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(15);
        make.top.equalTo(line.mas_bottom).offset(10);
    }];

    // 申报时间
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    [cardView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(15);
        make.top.equalTo(self.codeLabel.mas_bottom).offset(5);
        make.bottom.equalTo(cardView).offset(-15);
    }];
}

- (void)setModel:(AcquisitionListItemModel *)model {
    _model = model;
    self.codeLabel.text = [NSString stringWithFormat:@"意向编码：%@", model.bh ?: @""];
    self.timeLabel.text = [NSString stringWithFormat:@"申报时间：%@", model.declareTime ?: @""];
}

@end
```

---

## 7. 业务逻辑实现

### 7.1 表单验证逻辑

```objc
// AcquisitionStep1VC.m

- (BOOL)validateForm {
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];

    // 1. 权利人姓名
    if (!formData.ownerName.length) {
        [self showToast:@"请输入权利人姓名"];
        return NO;
    }

    // 2. 权利类型
    if (formData.type == 0) {
        [self showToast:@"请选择权利类型"];
        return NO;
    }
    if (formData.type == 3 && !formData.typeOther.length) {
        [self showToast:@"请输入其他权利类型"];
        return NO;
    }

    // 3. 证书编号
    if (!formData.certificateNumber.length) {
        [self showToast:@"请输入证书编号"];
        return NO;
    }

    // 4. 坐落
    if (!formData.addressRoad.length && !formData.addressNong.length &&
        !formData.addressHao.length && !formData.addressShi.length) {
        [self showToast:@"请至少填写一项不动产坐落信息"];
        return NO;
    }

    // 5. 建筑面积
    if (!formData.size.length) {
        [self showToast:@"请输入建筑面积"];
        return NO;
    }

    // 6. 共有情况
    if (!formData.ownershipType) {
        [self showToast:@"请选择不动产共有情况"];
        return NO;
    }
    if ([formData.ownershipType integerValue] == 3 && !formData.ownershipShare.length) {
        [self showToast:@"请输入各自份额"];
        return NO;
    }

    // 7. 查封/异议
    if (!formData.exceptionStatus) {
        [self showToast:@"请选择不动产查封/异议登记状况"];
        return NO;
    }

    // 8. 居住权（选填，但选"有"需填详情）
    if ([formData.liveStatus integerValue] == 2 && !formData.liveInfo.length) {
        [self showToast:@"请输入居住权人及期限"];
        return NO;
    }

    // 9. 抵押（选填，但选"有"需填详情）
    if ([formData.mortgageStatus integerValue] == 2 && !formData.mortgageInfo.length) {
        [self showToast:@"请输入抵押权人及金额"];
        return NO;
    }

    // 10. 户口（选填，但选"有"需填人数）
    if ([formData.hukouStatus integerValue] == 2 && !formData.hukouNum) {
        [self showToast:@"请输入户口登记人数"];
        return NO;
    }

    // 11. 填报人
    if (!formData.requesterName.length) {
        [self showToast:@"请输入填报人姓名"];
        return NO;
    }
    if (!formData.requesterPhoneNum.length) {
        [self showToast:@"请输入填报人联系方式"];
        return NO;
    }

    // 12. 关系
    if (formData.relationship == 0) {
        [self showToast:@"请选择申报人与权利人关系"];
        return NO;
    }
    if (formData.relationship == 5 && !formData.relationshipOther.length) {
        [self showToast:@"请说明具体关系"];
        return NO;
    }

    return YES;
}
```

### 7.2 图片上传逻辑

```objc
// AcquisitionStep2VC.m

#pragma mark - 图片选择

- (void)showImagePicker {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (!image) return;

    // 压缩图片
    NSData *imageData = [self compressImage:image];

    // 上传到七牛
    [self uploadImageData:imageData groupIndex:self.currentGroupIndex];
}

#pragma mark - 图片上传

- (void)uploadImageData:(NSData *)imageData groupIndex:(NSInteger)groupIndex {
    [self showLoading:@"上传中..."];

    // 使用七牛上传
    [UploadFileManager uploadImageWithData:imageData
                                   success:^(NSString *imageUrl) {
        [self hideLoading];

        // 添加到对应的图片组
        switch (groupIndex) {
            case 1:
                [self.certificateImages addObject:imageUrl];
                break;
            case 2:
                [self.registerImages addObject:imageUrl];
                break;
            case 3:
                [self.ownerIdImages addObject:imageUrl];
                break;
            case 4:
                [self.requesterIdImages addObject:imageUrl];
                break;
            case 5:
                [self.hukouImages addObject:imageUrl];
                break;
        }

        // 刷新对应的图片组视图
        [self refreshImageGroupView:groupIndex];

    } failure:^(NSError *error) {
        [self hideLoading];
        [self showToast:@"上传失败，请重试"];
    }];
}

#pragma mark - 保存到 FormData

- (void)saveToFormData {
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];

    formData.certificateFile = [self.certificateImages componentsJoinedByString:@","];
    formData.registerFile = [self.registerImages componentsJoinedByString:@","];
    formData.ownerIdcardFile = [self.ownerIdImages componentsJoinedByString:@","];
    formData.requesterIdcardFile = [self.requesterIdImages componentsJoinedByString:@","];
    formData.hukouFile = self.hukouImages.count > 0 ? [self.hukouImages componentsJoinedByString:@","] : nil;
}
```

### 7.3 提交申报逻辑

```objc
// AcquisitionStep3VC.m

- (void)submitDeclaration {
    // 验证报价
    if (!self.minPriceTextField.text.length || !self.maxPriceTextField.text.length) {
        [self showToast:@"请输入完整的意向报价区间"];
        return;
    }

    double minPrice = [self.minPriceTextField.text doubleValue];
    double maxPrice = [self.maxPriceTextField.text doubleValue];

    if (minPrice > maxPrice) {
        [self showToast:@"最低价不能高于最高价"];
        return;
    }

    // 保存到 FormData
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];
    formData.floorPrice = self.minPriceTextField.text;
    formData.ceilingPrice = self.maxPriceTextField.text;

    // 验证表单完整性
    if (![formData isComplete]) {
        [self showToast:@"表单数据不完整，请返回检查"];
        return;
    }

    // 提交
    [self showLoading:@"提交中..."];

    [AcquisitionAPI addDeclarationWithFormData:formData
                                       success:^(AddDeclarationResultModel *result) {
        [self hideLoading];
        [self showToast:@"申报提交成功"];

        // 跳转到成功页
        AcquisitionStep4VC *vc = [[AcquisitionStep4VC alloc] init];
        vc.declarationId = result.itemId;
        [self.navigationController pushViewController:vc animated:YES];

    } failure:^(NSString *errorMsg) {
        [self hideLoading];
        [self showToast:errorMsg ?: @"提交失败，请稍后重试"];
    }];
}
```

### 7.4 撤销申报逻辑

```objc
// AcquisitionStep5VC.m

- (void)cancelDeclaration {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认撤销"
                                                                   message:@"确定要撤销此申报吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self doCancel];
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)doCancel {
    [self showLoading:@"处理中..."];

    [AcquisitionAPI cancelDeclarationWithId:self.declarationId
                                    success:^{
        [self hideLoading];
        [self showToast:@"撤销成功"];

        // 刷新页面
        [self loadDetailData];

    } failure:^(NSString *errorMsg) {
        [self hideLoading];
        [self showToast:errorMsg ?: @"撤销失败"];
    }];
}
```

### 7.5 加载申报详情和进度

```objc
// AcquisitionStep5VC.m

- (void)loadDetailData {
    [self showLoading:nil];

    [AcquisitionAPI getDeclarationWithId:self.declarationId
                                 success:^(AcquisitionDetailModel *detail) {
        [self hideLoading];
        self.detailModel = detail;
        [self updateUI];

        // 加载进度
        [self loadProgressData];

    } failure:^(NSString *errorMsg) {
        [self hideLoading];
        [self showToast:errorMsg];
    }];
}

- (void)loadProgressData {
    [AcquisitionAPI getDeclarationProgressWithId:self.declarationId
                                         success:^(NSArray<AcquisitionProgressItem *> *progressList) {
        NSMutableArray *mutableList = [progressList mutableCopy];

        // 如果已撤销，添加撤回状态项
        if (self.detailModel.progress == 0) {
            AcquisitionProgressItem *cancelItem = [[AcquisitionProgressItem alloc] init];
            cancelItem.progressType = 1;
            cancelItem.progressStatus = 4;  // 申报已被撤回
            cancelItem.createTime = [[NSDate date] timeIntervalSince1970] * 1000;
            [mutableList addObject:cancelItem];
        }

        self.progressList = [mutableList copy];
        [self updateProgressUI];

    } failure:^(NSString *errorMsg) {
        // 进度加载失败不影响主要展示
    }];
}

- (void)updateUI {
    AcquisitionDetailModel *detail = self.detailModel;

    self.nameLabel.text = detail.name;
    self.phoneLabel.text = detail.phoneNumber;
    self.codeLabel.text = detail.bh;

    // 撤回按钮可见性
    // progress=0（已撤销）：隐藏撤回，显示重新提交
    // progress=1（正常）：显示撤回；status=2或3时也显示重新提交
    if (detail.progress == 0) {
        self.cancelButton.hidden = YES;
        self.resubmitButton.hidden = NO;
    } else {
        self.cancelButton.hidden = NO;
        self.resubmitButton.hidden = !(detail.status == 2 || detail.status == 3);
    }
}
```

---

## 8. 文件结构建议

```
StandardApplication/
├── Classes/
│   └── Acquisition/                      # 房源收购模块
│       ├── Model/
│       │   ├── AcquisitionListItemModel.h/m
│       │   ├── AcquisitionDetailModel.h/m
│       │   ├── AcquisitionProgressModel.h/m
│       │   ├── AcquisitionCountModel.h/m
│       │   ├── AddDeclarationResultModel.h/m
│       │   └── AcquisitionFormData.h/m
│       ├── View/
│       │   ├── ImageUploadGroupView.h/m
│       │   ├── ImageUploadCell.h/m
│       │   ├── AddImageCell.h/m
│       │   ├── ProgressStepView.h/m
│       │   └── AcquisitionListCell.h/m
│       ├── Controller/
│       │   ├── AcquisitionStep1VC.h/m    # 基本信息
│       │   ├── AcquisitionStep2VC.h/m    # 上传材料
│       │   ├── AcquisitionStep3VC.h/m    # 意向报价
│       │   ├── AcquisitionStep4VC.h/m    # 提交成功
│       │   ├── AcquisitionStep5VC.h/m    # 申报详情
│       │   ├── MineAcquisitionListVC.h/m # 我的申报
│       │   └── RegisterGuideVC.h/m       # 登记簿引导
│       └── API/
│           └── AcquisitionAPI.h/m
└── Common/
    └── YDInterfaceDefinition.h            # 添加接口定义
```

---

## 9. 颜色定义

在项目中使用的主要颜色：

| 颜色值 | 用途 |
|--------|------|
| `#2A629A` | 主题色、按钮背景、链接文字 |
| `#0F3058` | 标题文字 |
| `#333333` | 主要文字 |
| `#666666` | 次要文字 |
| `#999999` | 辅助文字、提示文字 |
| `#EEEEEE` | 分割线 |
| `#F8F8F8` | 页面背景 |
| `#FFFFFF` | 卡片背景 |
| `#DDDDDD` | 输入框边框 |
| `#FF4444` | 错误/失败状态 |
| `#CCCCCC` | 待审核状态图标 |

---

## 10. 注意事项

1. **图片上传**：使用七牛云上传，上传后获取的URL用逗号分隔存储
2. **表单数据传递**：使用单例 `AcquisitionFormData` 在多个步骤间传递数据
3. **只读模式**：查看详情时所有输入框设为 `enabled = NO`
4. **重新提交**：从详情页跳转到Step1时，预填充已有数据，`isViewMode = NO`
5. **API签名**：注意参数需要按照现有项目的签名规则处理
6. **错误处理**：所有API调用需处理 10001 (需登录) 和 302 (Session过期) 的情况

---

## 更新日志

- **2026-02-02**：初始版本，完整迁移文档

