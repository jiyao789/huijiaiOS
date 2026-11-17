# 房源收购意向申报模块 - UI 设计规范

> 本文档提供详细的 UI 设计规范，用于 iOS 迁移时保持视觉一致性。

---

## 1. 全局样式

### 1.1 颜色规范

```objc
// UIColor+Acquisition.h
@interface UIColor (Acquisition)

// 主题色
+ (UIColor *)acq_primaryColor;       // #2A629A - 按钮、链接、重点文字
+ (UIColor *)acq_titleColor;         // #0F3058 - 导航标题

// 文字色
+ (UIColor *)acq_textPrimary;        // #333333 - 主要文字
+ (UIColor *)acq_textSecondary;      // #666666 - 次要文字
+ (UIColor *)acq_textHint;           // #999999 - 提示文字

// 背景色
+ (UIColor *)acq_bgMain;             // #F8F8F8 - 页面背景
+ (UIColor *)acq_bgCard;             // #FFFFFF - 卡片背景

// 分割线
+ (UIColor *)acq_divider;            // #EEEEEE - 分割线

// 状态色
+ (UIColor *)acq_errorColor;         // #FF4444 - 错误/失败
+ (UIColor *)acq_successColor;       // #2A629A - 成功（同主题色）
+ (UIColor *)acq_grayStatus;         // #CCCCCC - 待审核状态

// 输入框
+ (UIColor *)acq_inputBorder;        // #DDDDDD - 边框

@end
```

```objc
// UIColor+Acquisition.m
@implementation UIColor (Acquisition)

+ (UIColor *)acq_primaryColor {
    return [UIColor colorWithHexString:@"2A629A"];
}

+ (UIColor *)acq_titleColor {
    return [UIColor colorWithHexString:@"0F3058"];
}

+ (UIColor *)acq_textPrimary {
    return [UIColor colorWithHexString:@"333333"];
}

+ (UIColor *)acq_textSecondary {
    return [UIColor colorWithHexString:@"666666"];
}

+ (UIColor *)acq_textHint {
    return [UIColor colorWithHexString:@"999999"];
}

+ (UIColor *)acq_bgMain {
    return [UIColor colorWithHexString:@"F8F8F8"];
}

+ (UIColor *)acq_bgCard {
    return [UIColor whiteColor];
}

+ (UIColor *)acq_divider {
    return [UIColor colorWithHexString:@"EEEEEE"];
}

+ (UIColor *)acq_errorColor {
    return [UIColor colorWithHexString:@"FF4444"];
}

+ (UIColor *)acq_successColor {
    return [UIColor colorWithHexString:@"2A629A"];
}

+ (UIColor *)acq_grayStatus {
    return [UIColor colorWithHexString:@"CCCCCC"];
}

+ (UIColor *)acq_inputBorder {
    return [UIColor colorWithHexString:@"DDDDDD"];
}

@end
```

### 1.2 字体规范

```objc
// 标题
UIFont *titleFont = [UIFont boldSystemFontOfSize:16];      // 分区标题
UIFont *navTitleFont = [UIFont boldSystemFontOfSize:18];   // 导航栏标题

// 正文
UIFont *bodyFont = [UIFont systemFontOfSize:14];           // 表单标签、正文
UIFont *smallFont = [UIFont systemFontOfSize:12];          // 辅助文字、返回按钮
UIFont *tinyFont = [UIFont systemFontOfSize:13];           // 列表项辅助文字

// 按钮
UIFont *buttonFont = [UIFont systemFontOfSize:16];         // 主按钮
UIFont *linkFont = [UIFont systemFontOfSize:12];           // 链接文字
```

### 1.3 间距规范

```objc
// 页面边距
#define ACQ_PADDING_HORIZONTAL  15.0f   // 左右边距

// 组件间距
#define ACQ_SPACING_SECTION     20.0f   // 分区之间
#define ACQ_SPACING_ITEM        15.0f   // 表单项之间
#define ACQ_SPACING_LABEL       10.0f   // 标签与输入框之间
#define ACQ_SPACING_SMALL       5.0f    // 小间距

// 卡片
#define ACQ_CARD_PADDING        15.0f   // 卡片内边距
#define ACQ_CARD_MARGIN_TOP     15.0f   // 卡片顶部外边距
#define ACQ_CARD_CORNER_RADIUS  8.0f    // 卡片圆角
```

### 1.4 组件尺寸

```objc
// 导航栏
#define ACQ_NAV_HEIGHT          46.0f   // 导航栏高度（不含状态栏）

// 输入框
#define ACQ_INPUT_HEIGHT        40.0f   // 标准输入框高度
#define ACQ_INPUT_HEIGHT_SMALL  36.0f   // 小输入框高度
#define ACQ_INPUT_HEIGHT_SHORT  30.0f   // 短输入框（地址路弄号室）

// 按钮
#define ACQ_BUTTON_HEIGHT       44.0f   // 按钮高度
#define ACQ_BUTTON_CORNER       4.0f    // 按钮圆角

// 图片上传
#define ACQ_IMAGE_COLUMNS       4       // 图片列数
#define ACQ_IMAGE_SPACING       10.0f   // 图片间距

// 分割线
#define ACQ_DIVIDER_HEIGHT      0.5f    // 分割线高度

// 进度图标
#define ACQ_PROGRESS_ICON_SIZE  16.0f   // 进度图标尺寸
#define ACQ_PROGRESS_LINE_WIDTH 1.0f    // 进度线宽度
#define ACQ_PROGRESS_LINE_HEIGHT 40.0f  // 进度线高度
```

---

## 2. 导航栏样式

### 2.1 布局

```
┌───────────────────────────────────────────────────────┐
│ ← 返回                    标题                        │
│                                                       │
│  19pt  12sp              18sp                        │
│  paddingStart           center                        │
└───────────────────────────────────────────────────────┘
       高度: 46pt
```

### 2.2 实现

```objc
- (UIView *)setupNavBar {
    UIView *navBar = [[UIView alloc] init];
    navBar.backgroundColor = [UIColor whiteColor];

    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithHexString:@"0E2F55"] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:12];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navBar).offset(19);
        make.centerY.equalTo(navBar);
    }];

    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"房源收购意向申报";
    titleLabel.textColor = [UIColor colorWithHexString:@"0F3058"];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [navBar addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(navBar);
    }];

    return navBar;
}
```

---

## 3. 表单组件样式

### 3.1 表单标签

```objc
// 创建表单标签
- (UILabel *)createFormLabel:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor acq_textPrimary];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    return label;
}

// 分区标题
- (UILabel *)createSectionTitle:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor acq_primaryColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    return label;
}
```

### 3.2 输入框

```objc
// 标准输入框
- (UITextField *)createTextField:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.textColor = [UIColor acq_textPrimary];
    textField.font = [UIFont systemFontOfSize:14];

    // 设置占位符颜色
    textField.attributedPlaceholder = [[NSAttributedString alloc]
        initWithString:placeholder
        attributes:@{NSForegroundColorAttributeName: [UIColor acq_textHint]}];

    return textField;
}

// 带边框的输入框
- (UITextField *)createBorderedTextField:(NSString *)placeholder {
    UITextField *textField = [self createTextField:placeholder];
    textField.layer.borderColor = [UIColor acq_inputBorder].CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 4;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}
```

### 3.3 单选按钮

```
┌──────────────────────────────────┐
│ ◉ 商品房                          │  ← 选中状态
│ ○ 公有住房出售                    │  ← 未选中状态
│ ○ 其他                            │
└──────────────────────────────────┘
```

```objc
// 单选按钮实现
- (UIButton *)createRadioButton:(NSString *)title selected:(BOOL)selected {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setTitle:[NSString stringWithFormat:@"  %@", title] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor acq_textPrimary] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    // 图标资源：radio_unselected, radio_selected
    [button setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateSelected];

    button.selected = selected;

    return button;
}
```

### 3.4 分割线

```objc
- (UIView *)createDivider {
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor acq_divider];
    return divider;
}

// 约束
[divider mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(superview);
    make.height.mas_equalTo(0.5);
}];
```

---

## 4. 按钮样式

### 4.1 主按钮（蓝底白字）

```objc
- (UIButton *)createPrimaryButton:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.backgroundColor = [UIColor acq_primaryColor];
    button.layer.cornerRadius = 4;
    return button;
}
```

### 4.2 次按钮（边框样式）

```objc
- (UIButton *)createSecondaryButton:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor acq_textHint] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = [UIColor acq_textHint].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 4;
    return button;
}
```

### 4.3 链接按钮（无背景）

```objc
- (UIButton *)createLinkButton:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor acq_primaryColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    return button;
}
```

### 4.4 底部按钮栏

```
┌─────────────────────────────────────────────────────────┐
│  ┌─────────────┐    ┌─────────────┐                     │
│  │ 返回上一步   │    │   下一步    │                     │
│  │   (灰边框)  │    │  (蓝底白字)  │                     │
│  └─────────────┘    └─────────────┘                     │
│       左右各占 1/2 宽度，间距 20pt                        │
└─────────────────────────────────────────────────────────┘
         高度: 44pt + 底部安全区域
         内边距: 15pt
```

```objc
- (UIView *)createBottomButtonBar {
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor whiteColor];

    UIButton *backBtn = [self createSecondaryButton:@"返回上一步"];
    UIButton *nextBtn = [self createPrimaryButton:@"下一步"];

    [container addSubview:backBtn];
    [container addSubview:nextBtn];

    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(15);
        make.top.equalTo(container).offset(10);
        make.height.mas_equalTo(44);
    }];

    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backBtn.mas_right).offset(20);
        make.right.equalTo(container).offset(-15);
        make.top.height.equalTo(backBtn);
        make.width.equalTo(backBtn);
    }];

    return container;
}
```

---

## 5. 卡片样式

### 5.1 基础卡片

```objc
- (UIView *)createCard {
    UIView *card = [[UIView alloc] init];
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 8;
    // iOS 不需要阴影，保持扁平化设计
    return card;
}
```

### 5.2 列表项卡片

```
┌──────────────────────────────────────────────────────┐
│  房源收购意向申报                      查看详情 >    │
│  ─────────────────────────────────────────────────   │
│  意向编码：BH20260202001                             │
│  申报时间：2026-02-02                                │
└──────────────────────────────────────────────────────┘
     圆角: 8pt
     内边距: 15pt
     左右外边距: 15pt
     顶部外边距: 15pt
```

---

## 6. 图片上传组件

### 6.1 布局规则

```
┌────────────────────────────────────────────────────────┐
│  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐                   │
│  │ img │  │ img │  │ img │  │  +  │                   │
│  └─────┘  └─────┘  └─────┘  └─────┘                   │
│                                                        │
│  4 列网格布局                                           │
│  间距: 10pt                                            │
│  图片尺寸: (屏幕宽 - 30 - 30) / 4 = 正方形              │
└────────────────────────────────────────────────────────┘
```

### 6.2 添加按钮样式

```objc
// AddImageCell
- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderStyle = /* 虚线，如需要 */;

    UIImageView *addIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_add_gray"]];
    [self.contentView addSubview:addIcon];
    [addIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.height.mas_equalTo(24);
    }];
}
```

### 6.3 图片项样式

```objc
// ImageUploadCell
- (void)setupUI {
    // 图片视图
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 4;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    // 删除按钮（右上角）
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[UIImage imageNamed:@"ic_delete_white"] forState:UIControlStateNormal];
    self.deleteButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.deleteButton.layer.cornerRadius = 10;
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(4, 0, 0, 4));
        make.width.height.mas_equalTo(20);
    }];
}
```

---

## 7. 进度视图

### 7.1 布局结构

```
┌──────────────────────────────────────────────────────┐
│  ●──── 2026-02-02 10:30:00                          │
│  │     待审核                                        │
│  │                                                   │
│  ●──── 2026-02-02 15:45:00                          │
│  │     预审通过                                      │
│  │                                                   │
│  ●     2026-02-02 16:00:00                          │
│        预审否决                                      │
└──────────────────────────────────────────────────────┘
   ┌──┬──┐
   │20│10│  ← 图标区域宽度: 20pt, 间距: 10pt
   └──┴──┘
```

### 7.2 状态图标样式

| 状态 | 样式 |
|------|------|
| 待审核 (0) | 灰色圆点 #CCCCCC |
| 预审通过 (1) | 蓝色对勾 #2A629A |
| 预审不通过 (2) | 红色X #FF4444 |
| 预审否决 (3) | 红色X #FF4444 |
| 已撤回 (4) | 红色X #FF4444 |

```objc
- (UIView *)createStatusIcon:(NSInteger)status {
    UIView *container = [[UIView alloc] init];
    container.layer.cornerRadius = 8;

    switch (status) {
        case 0: {
            // 灰色圆点
            container.backgroundColor = [UIColor acq_grayStatus];
            break;
        }
        case 1: {
            // 蓝色对勾
            container.backgroundColor = [UIColor acq_primaryColor];
            UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_check_white"]];
            [container addSubview:checkmark];
            [checkmark mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(container);
                make.width.height.mas_equalTo(10);
            }];
            break;
        }
        case 2:
        case 3:
        case 4: {
            // 红色X
            container.backgroundColor = [UIColor acq_errorColor];
            UIImageView *cross = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_close_white"]];
            [container addSubview:cross];
            [cross mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(container);
                make.width.height.mas_equalTo(10);
            }];
            break;
        }
    }

    return container;
}
```

---

## 8. 空状态视图

```
┌──────────────────────────────────────────────────────┐
│                                                       │
│                                                       │
│                                                       │
│                    暂无申报记录                        │
│                       #999999                         │
│                       14sp                            │
│                                                       │
│                                                       │
└──────────────────────────────────────────────────────┘
```

```objc
- (UIView *)createEmptyView:(NSString *)text {
    UIView *container = [[UIView alloc] init];

    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor acq_textHint];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;

    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(container);
    }];

    return container;
}
```

---

## 9. 成功页面

### 9.1 布局

```
┌──────────────────────────────────────────────────────┐
│                                                       │
│                        ✓                              │
│                     80x80pt                           │
│                                                       │
│                    提交成功                           │
│                  24sp bold #2A629A                    │
│                                                       │
│     请关注申报详情，并保持电话畅通，                   │
│     工作人员将在初审通过后尽快与您联系                 │
│                                                       │
│     后续可在"我的"-"我的申报"中查看进度               │
│                  14sp #999999                         │
│                                                       │
│               ┌─────────────────┐                     │
│               │  查看申报详情   │                     │
│               │   200x44pt      │                     │
│               └─────────────────┘                     │
│                                                       │
└──────────────────────────────────────────────────────┘
```

### 9.2 成功图标

需要一个绿色/蓝色对勾的成功图标，尺寸 80x80pt。

如果项目中没有，可以使用 SF Symbols 或创建：

```objc
// 使用 SF Symbols (iOS 13+)
UIImage *successIcon = [UIImage systemImageNamed:@"checkmark.circle.fill"
                                   withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:80 weight:UIImageSymbolWeightRegular]];
// 设置颜色
UIImageView *iconView = [[UIImageView alloc] initWithImage:successIcon];
iconView.tintColor = [UIColor acq_primaryColor];
```

---

## 10. 需要的图片资源

| 资源名称 | 尺寸 | 用途 |
|---------|------|------|
| back_black | 24x24 | 返回箭头 |
| radio_selected | 20x20 | 选中的单选按钮 |
| radio_unselected | 20x20 | 未选中的单选按钮 |
| ic_add_gray | 24x24 | 添加图片按钮 |
| ic_delete_white | 12x12 | 删除图片按钮 |
| ic_check_white | 10x10 | 成功状态对勾 |
| ic_close_white | 10x10 | 失败状态叉号 |
| ic_info_gray | 14x14 | 信息图标（登记簿引导） |
| common_icon_success | 80x80 | 提交成功图标 |
| shape_circle_gray | - | 灰色圆形背景 |
| shape_circle_red | - | 红色圆形背景 |

---

## 11. Step1 地址输入特殊布局

```
┌──────────────────────────────────────────────────────┐
│  4. 不动产坐落（精确到室号）（与产证一致）            │
│                                                       │
│  ┌────┐ 路 ┌────┐ 弄 ┌────┐ 号 ┌────┐ 室            │
│  │    │    │    │    │    │    │    │               │
│  └────┘    └────┘    └────┘    └────┘               │
│                                                       │
│  每个输入框等宽，高度 30pt，带边框                     │
│  后缀文字：路/弄/号/室，间距 5pt                      │
└──────────────────────────────────────────────────────┘
```

```objc
- (UIView *)createAddressInputRow {
    UIView *container = [[UIView alloc] init];

    NSArray *suffixes = @[@"路", @"弄", @"号", @"室"];
    UIView *lastField = nil;

    for (NSString *suffix in suffixes) {
        UITextField *field = [self createBorderedTextField:@""];
        field.textAlignment = NSTextAlignmentCenter;
        [container addSubview:field];

        UILabel *suffixLabel = [[UILabel alloc] init];
        suffixLabel.text = suffix;
        suffixLabel.font = [UIFont systemFontOfSize:14];
        suffixLabel.textColor = [UIColor acq_textPrimary];
        [container addSubview:suffixLabel];

        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastField) {
                make.left.equalTo(lastField.mas_right).offset(25); // 包含后缀label
            } else {
                make.left.equalTo(container);
            }
            make.centerY.equalTo(container);
            make.height.mas_equalTo(30);
        }];

        [suffixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(field.mas_right).offset(5);
            make.centerY.equalTo(container);
        }];

        lastField = suffixLabel;
    }

    // 使所有输入框等宽
    // 需要在布局后更新约束

    return container;
}
```

---

## 更新日志

- **2026-02-02**：初始版本

