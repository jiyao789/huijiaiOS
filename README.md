> 翻译自CLAUDE.md

## 项目概述

这是一个面向房产/不动产管理平台（惠家/Huijia）的 iOS 应用程序，使用 Objective-C 开发。应用提供房源信息展示、生活服务、业主委托、用户管理等功能。

**目标平台：** iOS 12.0+  
**开发语言：** Objective-C  
**依赖管理：** CocoaPods  
**构建系统：** Xcode  

## 构建与开发命令

### 初始配置
```bash
# 安装 CocoaPods 依赖
pod install

# 始终打开工作区文件（而非 .xcodeproj）
open StandardApplication.xcworkspace
```

### 构建方式

#### 使用构建脚本（推荐）
```bash
# 构建真机版本（默认）
./build.sh
# 或显式指定
./build.sh device

# 构建模拟器版本（Intel x86_64 架构）
./build.sh simulator
```

#### 手动构建命令

**真机构建：**
```bash
xcodebuild -workspace StandardApplication.xcworkspace \
           -scheme StandardApplication \
           -configuration Debug \
           -sdk iphoneos \
           build \
           ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO \
           ENABLE_DEBUG_DYLIB=NO \
           CODE_SIGN_IDENTITY="" \
           CODE_SIGNING_REQUIRED=NO \
           CODE_SIGNING_ALLOWED=NO
```

**模拟器构建（仅限 Intel x86_64）：**
```bash
xcodebuild -workspace StandardApplication.xcworkspace \
           -scheme StandardApplication \
           -configuration Debug \
           -sdk iphonesimulator \
           build \
           ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO \
           ENABLE_DEBUG_DYLIB=NO \
           ARCHS=x86_64 \
           VALID_ARCHS=x86_64 \
           ONLY_ACTIVE_ARCH=YES
```

**Release 构建：**
```bash
xcodebuild -workspace StandardApplication.xcworkspace \
           -scheme StandardApplication \
           -configuration Release \
           -sdk iphoneos \
           build \
           ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO \
           ENABLE_DEBUG_DYLIB=NO \
           CODE_SIGN_IDENTITY="" \
           CODE_SIGNING_REQUIRED=NO \
           CODE_SIGNING_ALLOWED=NO
```

**重要构建说明：**
- `ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO` - 本项目为纯 Objective-C 项目，无需嵌入 Swift 标准库
- `ENABLE_DEBUG_DYLIB=NO` - 避免生成 debug dylib 时出错
- 开发构建中禁用代码签名
- 若遇到 "Build input file cannot be found: StandardApplication.debug.dylib" 错误，请确保设置了上述标志位

**模拟器与真机差异：**
- 部分依赖库（微信 SDK、TTLock 等）仅包含面向真实 iOS 设备的 arm64 架构切片
- 在 Apple Silicon Mac 上，这些依赖**不兼容** arm64 架构的 iOS 模拟器
- **解决方案**：构建 **x86_64 架构模拟器**版本（Intel 架构），通过 Rosetta 运行
- x86_64 构建可行，因为这些 SDK 包含用于模拟器的 x86_64 架构切片

**可执行文件路径：**
- 真机：`~/Library/Developer/Xcode/DerivedData/StandardApplication-<hash>/Build/Products/Debug-iphoneos/StandardApplication.app/StandardApplication`
- 模拟器：`~/Library/Developer/Xcode/DerivedData/StandardApplication-<hash>/Build/Products/Debug-iphonesimulator/StandardApplication.app/StandardApplication`

### 测试
```bash
# 运行测试
xcodebuild test -workspace StandardApplication.xcworkspace -scheme StandardApplication -destination 'platform=iOS Simulator,name=iPhone 14'
```

### 依赖管理
```bash
# 更新 Pods
pod update

# 安装特定 Pod（更新仓库索引）
pod install --repo-update
```

## 架构与代码结构

### 主应用结构

```
StandardApplication/
├── Base/                    # 基础视图控制器与核心 UI 组件
│   ├── BaseViewController   # 所有视图控制器的父类
│   ├── BaseNavigationViewController
│   ├── BaseTabbarController # 包含 5 个主标签页的标签栏控制器
│   └── NoMsgView            # 空状态视图
├── Classes/                 # 功能模块（遵循 MVC 模式）
│   ├── Home/               # 首页与房源列表
│   ├── House/              # 房源搜索与筛选
│   ├── Life/               # 生活服务
│   ├── Owner/              # 业主委托功能
│   ├── My/                 # 用户个人中心与设置
│   ├── Login/              # 认证登录
│   ├── Wait/               # 排队/待处理功能
│   └── WaitNew/            # 新版排队功能实现
├── Common/                  # 共享配置与定义
│   ├── MacroDefine.h       # 全局宏定义、导入与常量
│   ├── YDInterfaceDefinition.h  # API 接口定义
│   ├── ECLocationManager   # 位置服务封装
│   └── ECUUIDTool          # 设备 UUID 管理
├── Utils/                   # 工具类
│   ├── HttpRequest         # 网络请求封装（基于 AFNetworking）
│   ├── CommonUtils         # 通用辅助函数
│   ├── UploadFileManager   # 文件上传管理
│   └── SNCache             # 本地缓存
├── Category/                # Objective-C Category/扩展
│   ├── Color/              # UIColor 扩展
│   ├── Image/              # UIImage 扩展
│   └── [UIView、NSString、NSDate 等各类扩展]
├── Libs/                    # 第三方库与自定义组件
└── Custom/                  # 自定义 UI 组件
    ├── BaseShadowView
    ├── PSBarButtonItem
    └── YDProgressView
```

### MVC 模式

`Classes/` 下的每个功能模块均遵循 MVC 模式：
- **Model/**: 数据模型（使用 MJExtension 进行 JSON 映射）
- **View/**: 自定义视图与 UI 组件
- **Controller/**: 管理 UI 逻辑的视图控制器

### 核心架构组件

#### 1. 导航系统
- 使用 `GKNavigationBarViewController` 实现自定义导航栏
- 所有视图控制器继承自 `BaseViewController`
- 导航控制器封装在 `BaseNavigationViewController` 中
- 支持全屏返回手势与自定义导航栏样式

#### 2. 标签栏结构
应用包含 5 个主标签页（在 `BaseTabbarController` 中定义）：
1. **首页** (`HomeViewController`) - 首页与房源列表
2. **找房** (`HouseViewController`) - 房源搜索
3. **生活** (`LifeViewController`) - 生活服务
4. **业主** (`OwnerNewBaseViewController`) - 业主委托
5. **我的** (`MyViewController`) - 个人中心

#### 3. 网络层
- `HttpRequest` 类封装 AFNetworking
- API 接口在 `YDInterfaceDefinition.h` 中统一定义
- 支持多环境基础 URL 配置（alpha/beta/pre）
- 通过 `BaseNetworkCache` 提供内置缓存支持，支持 GET/POST 请求

#### 4. 用户管理
- `User` 单例管理认证状态
- 存储 token、userId、手机号、设备 ID
- 使用本地存储实现会话持久化

#### 5. 主题系统
- 使用 `LEETheme` 支持主题切换
- `Category/Color/` 中提供自定义颜色扩展
- 支持无障碍（accessibility）模式

## 核心依赖库

### 关键 Pods
- **AFNetworking**: 网络请求
- **MJExtension/MJRefresh**: JSON 解析与下拉刷新
- **SDWebImage**: 图片加载与缓存
- **Masonry**: Auto Layout 领域特定语言（DSL）
- **ReactiveCocoa (2.1.8)**: 函数响应式编程
- **GKNavigationBarViewController**: 自定义导航栏
- **IQKeyboardManager**: 键盘自动处理

### 集成 SDK
- **AMap**（高德地图）: 地图与定位服务（使用无 IDFA 版本）
- **TTLock**: 智能门锁/蓝牙集成
- **AliPlayerSDK**: 视频播放（通过 SJVideoPlayer 封装）
- **WechatOpenSDK/AliPay_SDK**: 支付集成
- **UMShare**: 社交分享（精简版微信分享）
- **Bugly**: 崩溃上报
- **MatomoTracker**: 行为分析

### UI 组件
- **JXCategoryView**: 分类/分段视图
- **FSCalendar**: 日历组件
- **QMUIKit**: UI 工具集
- **YYText/YYModel**: 富文本渲染与模型解析

## 重要文件

### 配置文件
- **MacroDefine.h**: 全局导入文件，包含常用头文件与宏定义。提供属性、屏幕尺寸、全局 UI 常量等便捷宏。
- **YDInterfaceDefinition.h**: 所有 API 接口定义与基础 URL。通过注释/取消注释切换生产/测试环境。
- **Info.plist**: 应用配置、权限声明、URL Scheme

### 入口文件
- **AppDelegate.m**: 应用初始化、SDK 配置、导航系统设置
- **BaseTabbarController.m**: 主标签栏初始化

### 共享资源
- **User.h/m**: 用户会话管理单例
- **CommonUtils.h/m**: 通用工具方法
- **HttpRequest.h/m**: 网络请求抽象层

## 开发规范

### 新增功能
1. 在 `Classes/` 下创建新文件夹，包含 Model/View/Controller 子目录
2. 视图控制器继承自 `BaseViewController`
3. 在 `YDInterfaceDefinition.h` 中定义 API 接口
4. 使用 `HttpRequest` 进行网络请求
5. 使用 MJExtension 实现 JSON 与模型的自动映射

### 导航栏定制
`BaseViewController` 提供丰富的导航栏定制能力：
- `navTitle`, `navTitleColor`, `navTitleFont` - 标题样式
- `navBackgroundColor`, `naviBarAlpha` - 背景色与透明度
- `hideNaviBar`, `hideNavLine` - 可见性控制
- 支持添加自定义左右按钮项的方法

### 网络请求示例
```objc
[HttpRequest requestUrlPath:@"serverId"
                    urlPath:endpoint
                 parameters:params
                       type:HttpRequestTypePost
                     result:^(NSDictionary *dic, NSInteger status, NSString *msg) {
    // 处理响应
}];
```

### 下拉刷新
```objc
[self setupRefreshWithTableView:self.tableView];
// 实现 headerRefreshloadData 与 footerRefreshloadData 方法
```

## 环境配置

API 环境在 `YDInterfaceDefinition.h` 中控制：
- **生产环境**: `alpha.huichenghuijia.com`
- **Beta 环境**: `beta.fujuhaofang.com`（已注释）
- **预发布环境**: `pre.fujuhaofang.com`（已注释）

切换环境时，注释/取消注释对应的基础 URL 定义即可。

## 构建配置说明

### 代码签名
Podfile 中通过 `post_install` 钩子禁用了 CocoaPods 的代码签名，此为开发环境的有意设计。

### Swift 标准库
项目为所有 Pods 设置 `ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = NO` 以避免冲突。

### 调试工具
- **LookinServer**: UI 调试工具（仅 Debug 模式）
- **Bugly**: 崩溃监控与诊断

## 第三方服务集成

### 位置服务
- AppDelegate 中配置高德地图 API Key：`40ec7df263df9014c185bcd45a4e8f03`
- 使用无 IDFA 版本的 AMap Pods 以符合隐私合规要求

### 智能门锁
- 集成 TTLock SDK 支持蓝牙智能门锁
- 在 `application:didFinishLaunchingWithOptions:` 中初始化

### 视频播放
- 使用 SJVideoPlayer 封装 AliPlayer 作为播放后端
- 配置代码位于 AppDelegate 中

### 数据分析
- 集成 Matomo Tracker（位于 `Utils/MatomoTracker/`）
- 自定义追踪器类：`MatomoTrackerClass`
