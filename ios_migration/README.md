# 房源收购意向申报模块 - iOS 迁移指南

## 文档目录

| 文档 | 说明 |
|------|------|
| [ACQUISITION_MODULE_MIGRATION.md](./ACQUISITION_MODULE_MIGRATION.md) | 完整迁移文档（核心） |
| [UI_DESIGN_SPEC.md](./UI_DESIGN_SPEC.md) | UI 设计规范 |
| [API_SPECIFICATION.md](./API_SPECIFICATION.md) | API 接口规范 |

---

## 快速开始

### 1. 创建文件结构

```
Classes/Acquisition/
├── Model/          # 数据模型
├── View/           # 视图组件
├── Controller/     # 视图控制器
└── API/            # 接口封装
```

### 2. 添加接口定义

在 `YDInterfaceDefinition.h` 中添加：

```objc
#pragma mark - 房源收购意向申报
#define kAPI_AcquisitionDeclaration_Add      @"user/AcquisitionDeclaration/add"
#define kAPI_AcquisitionDeclaration_Get      @"user/acquisitionDeclaration/get"
#define kAPI_AcquisitionDeclaration_List     @"user/acquisitionDeclaration/list"
#define kAPI_AcquisitionDeclaration_Cancel   @"user/acquisitionDeclaration/cancel"
#define kAPI_AcquisitionDeclaration_Count    @"user/acquisitionDeclaration/count"
#define kAPI_AcquisitionDeclaration_Progress @"user/acquisitionDeclaration/progress"
```

### 3. 实现顺序建议

1. **Model 层**：按顺序实现数据模型
   - AcquisitionListItemModel
   - AcquisitionDetailModel
   - AcquisitionProgressModel
   - AcquisitionFormData (单例)

2. **API 层**：实现接口封装
   - AcquisitionAPI

3. **View 层**：实现通用组件
   - ImageUploadGroupView (图片上传组)
   - ProgressStepView (进度步骤)
   - AcquisitionListCell (列表Cell)

4. **Controller 层**：按流程顺序实现
   - MineAcquisitionListVC (我的申报列表)
   - AcquisitionStep5VC (申报详情)
   - AcquisitionStep1VC (基本信息)
   - AcquisitionStep2VC (上传材料)
   - AcquisitionStep3VC (意向报价)
   - AcquisitionStep4VC (提交成功)

---

## 核心功能清单

### 新建申报流程

- [ ] Step1：基本信息表单（12项）
- [ ] Step2：图片上传（5组，每组最多12张）
- [ ] Step3：意向报价输入
- [ ] Step4：提交成功页
- [ ] Step5：申报详情页

### 我的申报

- [ ] 列表页（分页加载）
- [ ] 申报详情查看
- [ ] 申报进度展示
- [ ] 撤销申报
- [ ] 重新提交

### 通用组件

- [ ] 图片上传组件
- [ ] 进度步骤视图
- [ ] 表单单选按钮组
- [ ] 底部操作按钮栏

---

## 技术要点

### 表单数据传递

使用单例 `AcquisitionFormData` 在多个 ViewController 之间传递数据：

```objc
// 保存数据
AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];
formData.ownerName = self.ownerNameTextField.text;

// 读取数据
NSString *ownerName = [AcquisitionFormData sharedInstance].ownerName;

// 清空数据（提交成功后）
[[AcquisitionFormData sharedInstance] clear];
```

### 图片URL存储

多张图片的 URL 用逗号分隔存储：

```objc
// 保存
formData.certificateFile = [self.imageUrls componentsJoinedByString:@","];

// 解析
NSArray *urls = [formData.certificateFile componentsSeparatedByString:@","];
```

### 只读模式

查看详情时禁用所有输入：

```objc
if (self.isViewMode) {
    self.ownerNameTextField.enabled = NO;
    self.nextButton.hidden = YES;
    // ...
}
```

### 重新提交

预填充数据并允许编辑：

```objc
AcquisitionStep1VC *vc = [[AcquisitionStep1VC alloc] init];
vc.isViewMode = NO;  // 可编辑
vc.detailModel = self.detailModel;  // 预填充数据
[self.navigationController pushViewController:vc animated:YES];
```

---

## 颜色速查

| 变量名 | 色值 | 用途 |
|--------|------|------|
| primaryColor | #2A629A | 主题色、按钮 |
| textPrimary | #333333 | 主要文字 |
| textSecondary | #666666 | 次要文字 |
| textHint | #999999 | 提示文字 |
| bgMain | #F8F8F8 | 页面背景 |
| divider | #EEEEEE | 分割线 |
| errorColor | #FF4444 | 错误状态 |

---

## 状态码速查

### 进度状态 (progress)

| 值 | 含义 |
|----|------|
| 0 | 已撤销 |
| 1 | 预审中（正常） |

### 审核状态 (status)

| 值 | 含义 | 操作 |
|----|------|------|
| 0 | 待审核 | 可撤回 |
| 1 | 预审通过 | 可撤回 |
| 2 | 预审不通过(转市场) | 可撤回、可重新提交 |
| 3 | 预审否决 | 可撤回、可重新提交 |

### 进度项状态 (progressStatus)

| 值 | 含义 |
|----|------|
| 0 | 待审核 |
| 1 | 预审通过 |
| 2 | 预审不通过(转市场) |
| 3 | 预审否决 |
| 4 | 申报已被撤回 |

---

## 注意事项

1. **图片上传**：使用七牛云，参考项目现有的 `UploadFileManager`
2. **请求签名**：按照项目现有规则处理
3. **登录态**：处理 10001 和 302 响应码
4. **下拉刷新**：使用 MJRefresh
5. **图片加载**：使用 SDWebImage
6. **布局**：使用 Masonry

---

## 更新日志

- **2026-02-02**：初始版本

