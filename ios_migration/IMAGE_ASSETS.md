# 房源收购意向申报模块 - 图片资源清单

> 本文档列出所有需要迁移到 iOS 的图片资源，包含 Android 源文件路径和 iOS 实现建议。

---

## 资源汇总

| 资源名 | Android 路径 | 类型 | iOS 建议 |
|--------|-------------|------|----------|
| back_black | drawable-xxhdpi | PNG | SF Symbol 或导出 |
| ic_add_a_photo_black_24dp | drawable | Vector XML | SF Symbol |
| ic_close_white_24dp | drawable | Vector XML | SF Symbol |
| common_icon_success | drawable | Vector XML | SF Symbol |
| ic_info_gray | drawable | Vector XML | SF Symbol |
| shape_circle_gray | drawable | Shape XML | 代码绘制 |
| shape_circle_red | drawable | Shape XML | 代码绘制 |
| shape_bg_circle_red | drawable | Shape XML | 代码绘制 |

---

## 1. 返回按钮 (back_black)

### Android 源文件
```
app/src/main/res/drawable-xxhdpi/back_black.png
app/src/main/res/drawable-xxxhdpi/back_black.png
```

### iOS 实现建议

**方案1: 使用 SF Symbol (推荐)**
```objc
UIImage *backIcon = [UIImage systemImageNamed:@"chevron.left"];
// 或
UIImage *backIcon = [UIImage systemImageNamed:@"arrow.left"];
```

**方案2: 导出 PNG 资源**
- 从 Android 项目导出 `back_black.png`
- 添加到 iOS Assets.xcassets
- 提供 @2x 和 @3x 版本

---

## 2. 添加图片按钮 (ic_add_a_photo_black_24dp)

### Android 源文件
```
app/src/main/res/drawable/ic_add_a_photo_black_24dp.xml
```

### Android Vector 内容
```xml
<vector android:width="24dp" android:height="24dp" viewportWidth="24.0" viewportHeight="24.0">
    <path
        android:fillColor="#FF333333"
        android:pathData="M3,4V1h2v3h3v2H5v3H3V6H0V4h3zM6,10V7h3V4h7l1.83,2H21c1.1,0 2,0.9 2,2v12c0,1.1 -0.9,2 -2,2H5c-1.1,0 -2,-0.9 -2,-2V10h3zM13,19c2.76,0 5,-2.24 5,-5s-2.24,-5 -5,-5 -5,2.24 -5,5 2.24,5 5,5zM13,9c-2.76,0 -5,2.24 -5,5s2.24,5 5,5 5,-2.24 5,-5 -2.24,-5 -5,-5z"/>
</vector>
```

### iOS 实现建议

**方案1: 使用 SF Symbol (推荐)**
```objc
UIImage *addPhotoIcon = [UIImage systemImageNamed:@"plus"];
// 或使用更具体的
UIImage *addPhotoIcon = [UIImage systemImageNamed:@"photo.badge.plus"];
// 或简单的加号
UIImage *addPhotoIcon = [UIImage systemImageNamed:@"plus.circle"];
```

**方案2: 简单绘制加号**
```objc
// 直接使用简单的加号文字
UILabel *addLabel = [[UILabel alloc] init];
addLabel.text = @"+";
addLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightLight];
addLabel.textColor = [UIColor colorWithHexString:@"999999"];
addLabel.textAlignment = NSTextAlignmentCenter;
```

---

## 3. 关闭/删除按钮 (ic_close_white_24dp)

### Android 源文件
```
app/src/main/res/drawable/ic_close_white_24dp.xml
```

### Android Vector 内容
```xml
<vector android:width="24dp" android:height="24dp" viewportWidth="24" viewportHeight="24">
    <path
        android:fillColor="#FFFFFF"
        android:pathData="M19,6.41L17.59,5 12,10.59 6.41,5 5,6.41 10.59,12 5,17.59 6.41,19 12,13.41 17.59,19 19,17.59 13.41,12z" />
</vector>
```

### iOS 实现建议

**使用 SF Symbol (推荐)**
```objc
UIImage *closeIcon = [UIImage systemImageNamed:@"xmark"];
UIImageView *closeImageView = [[UIImageView alloc] initWithImage:closeIcon];
closeImageView.tintColor = [UIColor whiteColor];
```

---

## 4. 成功图标 (common_icon_success)

### Android 源文件
```
app/src/main/res/drawable/common_icon_success.xml
```

### Android Vector 内容
```xml
<vector android:width="80dp" android:height="80dp" viewportWidth="24" viewportHeight="24">
    <path
        android:fillColor="#2A629A"
        android:pathData="M12,2C6.48,2 2,6.48 2,12s4.48,10 10,10 10,-4.48 10,-10S17.52,2 12,2zM10,17l-5,-5 1.41,-1.41L10,14.17l7.59,-7.59L19,8l-9,9z"/>
</vector>
```

**说明**: 蓝色圆形背景 + 白色对勾，颜色为 `#2A629A`

### iOS 实现建议

**使用 SF Symbol (推荐)**
```objc
UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:80 weight:UIImageSymbolWeightRegular];
UIImage *successIcon = [UIImage systemImageNamed:@"checkmark.circle.fill" withConfiguration:config];

UIImageView *successImageView = [[UIImageView alloc] initWithImage:successIcon];
successImageView.tintColor = [UIColor colorWithHexString:@"2A629A"];
```

---

## 5. 信息图标 (ic_info_gray)

### Android 源文件
```
app/src/main/res/drawable/ic_info_gray.xml
```

### Android Vector 内容
```xml
<vector android:width="16dp" android:height="16dp" viewportWidth="32" viewportHeight="32">
    <path
        android:fillColor="#646464"
        android:pathData="M16 2.66699C23.364 2.66699 ... [完整path省略]" />
</vector>
```

**说明**: 灰色信息图标（圆圈内有 i），颜色为 `#646464`

### iOS 实现建议

**使用 SF Symbol (推荐)**
```objc
UIImage *infoIcon = [UIImage systemImageNamed:@"info.circle"];
UIImageView *infoImageView = [[UIImageView alloc] initWithImage:infoIcon];
infoImageView.tintColor = [UIColor colorWithHexString:@"646464"];
```

---

## 6. 灰色圆形背景 (shape_circle_gray)

### Android 源文件
```
app/src/main/res/drawable/shape_circle_gray.xml
```

### Android Shape 内容
```xml
<shape android:shape="oval">
    <solid android:color="#CCCCCC"/>
</shape>
```

**说明**: 进度图标"待审核"状态，灰色圆形，颜色 `#CCCCCC`

### iOS 实现建议

**代码绘制**
```objc
UIView *grayCircle = [[UIView alloc] init];
grayCircle.backgroundColor = [UIColor colorWithHexString:@"CCCCCC"];
grayCircle.layer.cornerRadius = 5;  // 设置为宽高的一半
grayCircle.clipsToBounds = YES;
```

---

## 7. 红色圆形背景 (shape_circle_red)

### Android 源文件
```
app/src/main/res/drawable/shape_circle_red.xml
```

### Android Shape 内容
```xml
<shape android:shape="oval">
    <solid android:color="#F25643" />
</shape>
```

**说明**: 进度图标"失败"状态，红色圆形，颜色 `#F25643`

### iOS 实现建议

**代码绘制**
```objc
UIView *redCircle = [[UIView alloc] init];
redCircle.backgroundColor = [UIColor colorWithHexString:@"F25643"];
redCircle.layer.cornerRadius = 8;  // 设置为宽高的一半
redCircle.clipsToBounds = YES;
```

---

## 8. 红色圆形背景-删除按钮 (shape_bg_circle_red)

### Android 源文件
```
app/src/main/res/drawable/shape_bg_circle_red.xml
```

### Android Shape 内容
```xml
<shape android:shape="oval">
    <solid android:color="#E53935" />
</shape>
```

**说明**: 图片删除按钮背景，红色圆形，颜色 `#E53935`

### iOS 实现建议

**代码绘制**
```objc
UIView *deleteButtonBg = [[UIView alloc] init];
deleteButtonBg.backgroundColor = [UIColor colorWithHexString:@"E53935"];
deleteButtonBg.layer.cornerRadius = 10;  // 20/2 = 10
deleteButtonBg.clipsToBounds = YES;
```

---

## iOS Assets 目录结构建议

如果选择导出 PNG 资源而非使用 SF Symbol，建议的 Assets.xcassets 结构：

```
Assets.xcassets/
├── Acquisition/
│   ├── back_black.imageset/
│   │   ├── back_black@2x.png
│   │   └── back_black@3x.png
│   ├── ic_add_photo.imageset/
│   │   ├── ic_add_photo@2x.png
│   │   └── ic_add_photo@3x.png
│   └── ...
```

---

## SF Symbol 完整映射表

| Android 资源 | SF Symbol 名称 | 备注 |
|-------------|----------------|------|
| back_black | chevron.left | 返回箭头 |
| ic_add_a_photo_black_24dp | plus / photo.badge.plus | 添加图片 |
| ic_close_white_24dp | xmark | 关闭/删除 |
| common_icon_success | checkmark.circle.fill | 成功图标 |
| ic_info_gray | info.circle | 信息提示 |
| radio_selected | checkmark.circle.fill | 单选选中 |
| radio_unselected | circle | 单选未选中 |

---

## 单选按钮实现

Android 使用系统默认的 RadioButton，iOS 建议：

```objc
// 选中状态
UIImage *selectedImage = [UIImage systemImageNamed:@"checkmark.circle.fill"];

// 未选中状态
UIImage *unselectedImage = [UIImage systemImageNamed:@"circle"];

// 使用 UIButton
UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
[radioButton setImage:unselectedImage forState:UIControlStateNormal];
[radioButton setImage:selectedImage forState:UIControlStateSelected];
radioButton.tintColor = [UIColor colorWithHexString:@"2A629A"];
```

---

## 颜色速查

| 用途 | 色值 |
|------|------|
| 主题色 (按钮/链接/成功图标) | #2A629A |
| 灰色状态 | #CCCCCC |
| 红色状态 | #F25643 |
| 删除按钮红色 | #E53935 |
| 信息图标灰色 | #646464 |
| 添加图标灰色 | #333333 |
| 输入框背景 | #F5F5F5 |

---

## 推荐做法

1. **优先使用 SF Symbol**：iOS 13+ 内置，无需额外资源，支持动态颜色和尺寸
2. **Shape 用代码实现**：圆形、圆角矩形等简单形状直接用 CALayer 实现
3. **仅导出必要的 PNG**：如 back_black 等无法用 SF Symbol 替代的资源

---

## 更新日志

- **2026-02-02**：初始版本

