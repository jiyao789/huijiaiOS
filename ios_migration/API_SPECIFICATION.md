# 房源收购意向申报模块 - API 接口规范

> 本文档详细描述房源收购意向申报模块的所有 API 接口。

---

## 通用说明

### Base URL

```
生产环境: https://alpha.huichenghuijia.com/
测试环境: https://pre.fujuhaofang.com/
```

### 响应格式

```json
{
    "code": 200,           // 状态码
    "msg": "success",      // 提示信息
    "data": { ... }        // 业务数据
}
```

### 响应码说明

| 响应码 | 说明 | 处理方式 |
|--------|------|----------|
| 200 | 成功 | 正常处理 |
| 10001 | 需要登录 | 跳转登录页 |
| 302 | Session 过期 | 清除登录状态，跳转登录页 |
| 其他 | 业务错误 | 显示 msg 提示 |

### 请求签名

所有请求需要按照项目现有的签名规则添加签名参数。

---

## 1. 新增申报

### 请求

```
POST /user/AcquisitionDeclaration/add
Content-Type: multipart/form-data
```

### 请求参数

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| declareTime | String | ✓ | 申报日期，格式：yyyy-MM-dd |
| requesterPhoneNum | String | ✓ | 申报人联系电话 |
| requesterName | String | ✓ | 申报人姓名 |
| address | String | ✓ | 不动产完整地址，如："XX路XX弄XX号XX室" |
| ownerName | String | ✓ | 产权人姓名（多人用逗号分隔） |
| type | Integer | ✓ | 产权类型：1=商品房，2=公有住房出售，3=其他 |
| typeOther | String | - | 其他类型说明（type=3时必填） |
| certificateNumber | String | ✓ | 产权证书编号 |
| size | String | ✓ | 产权面积（平方米） |
| ownershipType | Integer | - | 共有情况：1=单独所有，2=共同所有，3=按份所有 |
| ownershipShare | String | - | 份额比例（ownershipType=3时填写） |
| exceptionStatus | Integer | - | 查封/异议登记状况：1=无异常，2=有异常 |
| liveStatus | Integer | - | 居住权状况：1=无居住，2=有居住 |
| liveInfo | String | - | 居住权人及期限（liveStatus=2时填写） |
| mortgageStatus | Integer | - | 抵押状况：1=无抵押，2=有抵押 |
| mortgageInfo | String | - | 抵押人及金额（mortgageStatus=2时填写） |
| hukouStatus | Integer | - | 户口状况：1=无户口，2=有户口 |
| hukouNum | Integer | - | 户口人数（hukouStatus=2时填写） |
| relationship | Integer | ✓ | 申报人与权利人关系：1=本人，2=配偶，3=子女，4=兄弟姐妹，5=其他 |
| relationshipOther | String | - | 其他关系说明（relationship=5时必填） |
| certificateFile | String | ✓ | 权证文件URL，多个用逗号分隔 |
| registerFile | String | ✓ | 不动产登记簿URL，多个用逗号分隔 |
| ownerIdcardFile | String | ✓ | 产权人身份证URL，多个用逗号分隔 |
| requesterIdcardFile | String | - | 申报人身份证URL，多个用逗号分隔 |
| hukouFile | String | - | 户口本URL，多个用逗号分隔 |
| floorPrice | String | ✓ | 最低报价（万元） |
| ceilingPrice | String | ✓ | 最高报价（万元） |

### 响应

```json
{
    "code": 200,
    "msg": "success",
    "data": {
        "id": 12345    // 新创建的申报ID
    }
}
```

### iOS 实现示例

```objc
+ (void)addDeclarationWithFormData:(AcquisitionFormData *)formData
                           success:(void(^)(AddDeclarationResultModel *result))success
                           failure:(void(^)(NSString *errorMsg))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    // 必填参数
    params[@"declareTime"] = [formData getDeclareTime];
    params[@"requesterPhoneNum"] = formData.requesterPhoneNum;
    params[@"requesterName"] = formData.requesterName;
    params[@"address"] = [formData getFullAddress];
    params[@"ownerName"] = formData.ownerName;
    params[@"type"] = @(formData.type);
    params[@"certificateNumber"] = formData.certificateNumber;
    params[@"size"] = formData.size;
    params[@"relationship"] = @(formData.relationship);
    params[@"certificateFile"] = formData.certificateFile;
    params[@"registerFile"] = formData.registerFile;
    params[@"ownerIdcardFile"] = formData.ownerIdcardFile;
    params[@"requesterIdcardFile"] = formData.requesterIdcardFile ?: @"";
    params[@"floorPrice"] = formData.floorPrice;
    params[@"ceilingPrice"] = formData.ceilingPrice;

    // 可选参数
    if (formData.typeOther.length > 0) {
        params[@"typeOther"] = formData.typeOther;
    }
    if (formData.ownershipType) {
        params[@"ownershipType"] = formData.ownershipType;
    }
    if (formData.ownershipShare.length > 0) {
        params[@"ownershipShare"] = formData.ownershipShare;
    }
    // ... 其他可选参数

    [HttpRequest postMultipartWithUrl:kAPI_AcquisitionDeclaration_Add
                               params:params
                              success:^(id responseObject) {
        // 处理响应...
    } failure:^(NSError *error) {
        // 处理错误...
    }];
}
```

---

## 2. 查询申报详情

### 请求

```
GET /user/acquisitionDeclaration/get
```

### 请求参数

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| id | Integer | ✓ | 申报ID |

### 响应

```json
{
    "code": 200,
    "msg": "success",
    "data": {
        "id": 12345,
        "bh": "BH20260202001",
        "declare_time": "2026-02-02",
        "phone_number": "13800138000",
        "name": "张三",
        "address": "XX路XX弄XX号XX室",
        "progress": 1,
        "status": 0,
        "owner_name": "李四",
        "type": 1,
        "type_other": null,
        "certificate_number": "沪(2024)浦东新区不动产权第123456号",
        "size": "89.5",
        "ownership_type": 1,
        "ownership_share": null,
        "exception_status": 1,
        "live_status": 1,
        "live_info": null,
        "mortgage_status": 1,
        "mortgage_info": null,
        "hukou_status": 2,
        "hukou_num": 3,
        "relationship": 1,
        "relationship_other": null,
        "certificate_file": "https://xxx.com/1.jpg,https://xxx.com/2.jpg",
        "register_file": "https://xxx.com/3.jpg",
        "owner_idcard_file": "https://xxx.com/4.jpg,https://xxx.com/5.jpg",
        "requester_idcard_file": null,
        "hukou_file": "https://xxx.com/6.jpg",
        "floor_price": "300",
        "ceiling_price": "350"
    }
}
```

### 字段说明

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Integer | 申报ID |
| bh | String | 申报编号 |
| declare_time | String | 申报时间 |
| phone_number | String | 联系电话 |
| name | String | 申报人姓名 |
| address | String | 不动产地址 |
| progress | Integer | 进度状态：0=已撤销，1=预审中 |
| status | Integer | 审核状态：0=待审核，1=预审通过，2=预审不通过(转市场)，3=预审否决 |
| owner_name | String | 权利人姓名 |
| type | Integer | 权利类型：1=商品房，2=公有住房出售，3=其他 |
| type_other | String | 其他类型说明 |
| certificate_number | String | 证书编号 |
| size | String | 建筑面积 |
| ownership_type | Integer | 共有情况：1=单独，2=共同，3=按份 |
| ownership_share | String | 份额比例 |
| exception_status | Integer | 查封/异议：1=无，2=有 |
| live_status | Integer | 居住权：1=无，2=有 |
| live_info | String | 居住权详情 |
| mortgage_status | Integer | 抵押：1=无，2=有 |
| mortgage_info | String | 抵押详情 |
| hukou_status | Integer | 户口：1=无，2=有 |
| hukou_num | Integer | 户口人数 |
| relationship | Integer | 关系：1=本人，2=配偶，3=子女，4=兄弟姐妹，5=其他 |
| relationship_other | String | 其他关系说明 |
| certificate_file | String | 权证文件URL（逗号分隔） |
| register_file | String | 登记簿URL（逗号分隔） |
| owner_idcard_file | String | 产权人身份证URL（逗号分隔） |
| requester_idcard_file | String | 申报人身份证URL（逗号分隔） |
| hukou_file | String | 户口本URL（逗号分隔） |
| floor_price | String | 最低报价（万元） |
| ceiling_price | String | 最高报价（万元） |

---

## 3. 我的申报列表

### 请求

```
GET /user/acquisitionDeclaration/list
```

### 请求参数

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| page | Integer | ✓ | 页码，从1开始 |
| rows | Integer | ✓ | 每页条数，默认10 |

### 响应

```json
{
    "code": 200,
    "msg": "success",
    "data": {
        "list": [
            {
                "id": 12345,
                "bh": "BH20260202001",
                "declare_time": "2026-02-02"
            },
            {
                "id": 12346,
                "bh": "BH20260201001",
                "declare_time": "2026-02-01"
            }
        ],
        "page": {
            "hasMore": true,
            "total": 25,
            "pageSize": 10,
            "currentPage": 1
        }
    }
}
```

### iOS 实现示例

```objc
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

            NSArray<AcquisitionListItemModel *> *list =
                [AcquisitionListItemModel mj_objectArrayWithKeyValuesArray:listArray];
            BOOL hasMore = [pageInfo[@"hasMore"] boolValue];

            if (success) success(list, hasMore);
        } else {
            if (failure) failure(responseObject[@"msg"] ?: @"获取失败");
        }
    } failure:^(NSError *error) {
        if (failure) failure(error.localizedDescription);
    }];
}
```

---

## 4. 撤销申报

### 请求

```
POST /user/acquisitionDeclaration/cancel
```

### 请求参数

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| id | Integer | ✓ | 申报ID |

### 响应

```json
{
    "code": 200,
    "msg": "撤销成功",
    "data": null
}
```

### 错误响应

```json
{
    "code": 400,
    "msg": "该申报不可撤销",
    "data": null
}
```

---

## 5. 申报统计

### 请求

```
GET /user/acquisitionDeclaration/count
```

### 请求参数

无

### 响应

```json
{
    "code": 200,
    "msg": "success",
    "data": {
        "count": 5
    }
}
```

---

## 6. 申报进度查询

### 请求

```
GET /user/acquisitionDeclaration/progress
```

### 请求参数

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| id | Integer | ✓ | 申报ID |

### 响应

```json
{
    "code": 200,
    "msg": "success",
    "data": {
        "reviewProgress": [
            {
                "progress_type": 1,
                "progress_status": 0,
                "create_time": 1706860800000
            },
            {
                "progress_type": 1,
                "progress_status": 1,
                "create_time": 1706947200000
            }
        ],
        "cancelProgress": [
          {
             "progress_type": 0,
             "progress_status": 0,
             "create_time": 1770103134
          }
       ]
    }
}
```

### 进度状态说明

reviewProgress 表示正常申报进度，cancelProgress表示撤销进度，cancelProgress内progress_type=0，progress_status=0表示撤销状态

| progress_status | 说明 |
|-----------------|------|
| 0 | 待审核 |
| 1 | 预审通过 |
| 2 | 预审不通过，转市场业务 |
| 3 | 预审否决 |
| 4 | 申报已被撤回 |

### 进度类型说明

| progress_type | 说明 |
|---------------|------|
| 1 | 审批程序 |

---

## 7. 图片上传（通用）

> 图片上传使用七牛云服务，具体实现请参考项目现有的 `UploadFileManager`。

### 上传流程

1. 调用后端接口获取七牛上传 Token
2. 使用七牛 SDK 上传图片
3. 上传成功后获取图片 URL
4. 将 URL 存入表单数据

### iOS 示例

```objc
// 使用项目现有的上传管理器
[UploadFileManager uploadImageWithData:imageData
                               success:^(NSString *imageUrl) {
    // 上传成功，保存 URL
    [self.imageUrls addObject:imageUrl];
    [self refreshImageView];
} failure:^(NSError *error) {
    // 上传失败
    [self showToast:@"图片上传失败"];
}];
```

---

## 8. 业务场景说明

### 8.1 新建申报流程

```
Step1 (填写基本信息)
    ↓ 验证通过
Step2 (上传证明材料)
    ↓ 必填项上传完成
Step3 (填写意向报价)
    ↓ 调用 addDeclaration API
Step4 (提交成功页)
    ↓ 点击查看详情
Step5 (申报详情页)
```

### 8.2 查看申报流程

```
我的申报列表 (调用 getDeclarationList API)
    ↓ 点击某条申报
申报详情页 (调用 getDeclaration + getDeclarationProgress API)
    ├── 查看详情 → Step1~Step3 (只读模式)
    ├── 撤回 → 调用 cancelDeclaration API
    └── 重新提交 → Step1~Step3 (编辑模式)
```

### 8.3 撤回后的处理

当用户撤回申报后：
1. `progress` 变为 0
2. 隐藏撤回按钮
3. 显示重新提交按钮
4. 进度列表末尾添加"申报已被撤回"状态

### 8.4 重新提交

当 `status = 2` (预审不通过) 或 `status = 3` (预审否决) 时：
1. 显示重新提交按钮
2. 点击后跳转到 Step1，预填充原有数据
3. 修改后重新提交，调用 addDeclaration API 创建新的申报

---

## 更新日志

- **2026-02-02**：初始版本

