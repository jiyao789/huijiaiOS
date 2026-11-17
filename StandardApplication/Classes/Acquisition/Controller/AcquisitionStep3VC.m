//
//  AcquisitionStep3VC.m
//  StandardApplication
//
//  Property acquisition declaration - Step 3: Price Quote
//

#import "AcquisitionStep3VC.h"
#import "MacroDefine.h"
#import "YDInterfaceDefinition.h"
#import "AcquisitionFormData.h"
#import "AcquisitionStep4VC.h"

#define kAcqGreenColor        [UIColor colorWithHexString:@"#2A629A"]
#define kAcqTextPrimary       [UIColor colorWithHexString:@"#333333"]
#define kAcqTextSecondary     [UIColor colorWithHexString:@"#666666"]
#define kAcqTextHint          [UIColor colorWithHexString:@"#999999"]
#define kAcqDivider           [UIColor colorWithHexString:@"#EEEEEE"]

@interface AcquisitionStep3VC () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *floorPriceField;
@property (nonatomic, strong) UITextField *ceilingPriceField;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation AcquisitionStep3VC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self leftBarItem];
    self.navTitle = @"房源收购意向申报";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupUI];
    [self loadFormData];
    [self applyViewModeIfNeeded];
}

- (void)setupUI {
    // Section title
    UILabel *sectionTitle = [[UILabel alloc] init];
    sectionTitle.text = @"三、意向报价";
    sectionTitle.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    sectionTitle.textColor = kAcqGreenColor;
    [self.view addSubview:sectionTitle];

    [sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo(self.view).offset(NAVBAR_HEIGHT + 20);
    }];

    // Price row container
    UIView *priceRow = [[UIView alloc] init];
    [self.view addSubview:priceRow];

    [priceRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(sectionTitle.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];

    // Label: 意向报价
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"意向报价";
    priceLabel.font = [UIFont systemFontOfSize:15];
    priceLabel.textColor = kAcqTextPrimary;
    [priceRow addSubview:priceLabel];

    // Floor price field
    _floorPriceField = [self createPriceTextField];
    [priceRow addSubview:_floorPriceField];

    // "至" label
    UILabel *toLabel = [[UILabel alloc] init];
    toLabel.text = @"至";
    toLabel.font = [UIFont systemFontOfSize:15];
    toLabel.textColor = kAcqTextPrimary;
    toLabel.textAlignment = NSTextAlignmentCenter;
    [priceRow addSubview:toLabel];

    // Ceiling price field
    _ceilingPriceField = [self createPriceTextField];
    [priceRow addSubview:_ceilingPriceField];

    // Unit label
    UILabel *unitLabel = [[UILabel alloc] init];
    unitLabel.text = @"万元";
    unitLabel.font = [UIFont systemFontOfSize:15];
    unitLabel.textColor = kAcqTextPrimary;
    [priceRow addSubview:unitLabel];

    // Layout
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceRow);
        make.centerY.equalTo(priceRow);
    }];

    [_floorPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.mas_right).offset(12);
        make.centerY.equalTo(priceRow);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(36);
    }];

    [toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_floorPriceField.mas_right).offset(8);
        make.centerY.equalTo(priceRow);
        make.width.mas_equalTo(24);
    }];

    [_ceilingPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toLabel.mas_right).offset(8);
        make.centerY.equalTo(priceRow);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(36);
    }];

    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ceilingPriceField.mas_right).offset(8);
        make.centerY.equalTo(priceRow);
    }];

    // Divider
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = kAcqDivider;
    [self.view addSubview:divider];

    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(priceRow.mas_bottom).offset(16);
        make.height.mas_equalTo(0.5);
    }];

    // Submit button
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.backgroundColor = kAcqGreenColor;
    _submitButton.layer.cornerRadius = 4;
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [_submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];

    // Back button
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.backgroundColor = [UIColor whiteColor];
    _backButton.layer.cornerRadius = 4;
    _backButton.layer.borderWidth = 1;
    _backButton.layer.borderColor = kAcqDivider.CGColor;
    [_backButton setTitle:@"返回上一步" forState:UIControlStateNormal];
    [_backButton setTitleColor:kAcqTextSecondary forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];

    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.bottom.equalTo(self.view).offset(-(IS_IPhoneX ? 34 : 20));
        make.height.mas_equalTo(44);
    }];

    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.bottom.equalTo(_backButton.mas_top).offset(-12);
        make.height.mas_equalTo(44);
    }];
}

- (UITextField *)createPriceTextField {
    UITextField *field = [[UITextField alloc] init];
    field.font = [UIFont systemFontOfSize:15];
    field.textColor = kAcqTextPrimary;
    field.textAlignment = NSTextAlignmentCenter;
    field.borderStyle = UITextBorderStyleNone;
    field.backgroundColor = [UIColor whiteColor];
    field.layer.borderWidth = 0.5;
    field.layer.borderColor = kAcqDivider.CGColor;
    field.layer.cornerRadius = 4;
    field.keyboardType = UIKeyboardTypeDecimalPad;
    field.delegate = self;
    return field;
}

- (void)backAction {
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];
    
    if (formData.isViewMode) {
        // 【查看模式】：寻找列表页并返回
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"AcquisitionListVC")]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        // 如果没找到列表页，就普通的返回上一级
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // 【申报模式】：直接回首页
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - Form Data

- (void)loadFormData {
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];

    if (formData.floorPrice.length > 0) {
        _floorPriceField.text = formData.floorPrice;
    }
    if (formData.ceilingPrice.length > 0) {
        _ceilingPriceField.text = formData.ceilingPrice;
    }
}

- (void)saveFormData {
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];

    formData.floorPrice = _floorPriceField.text;
    formData.ceilingPrice = _ceilingPriceField.text;
}

#pragma mark - Validation

- (BOOL)validateForm {
    if (IsStrEmpty(_floorPriceField.text)) {
        [MBProgressHUD showMessag:@"请输入最低价" toView:self.view];
        return NO;
    }
    if (IsStrEmpty(_ceilingPriceField.text)) {
        [MBProgressHUD showMessag:@"请输入最高价" toView:self.view];
        return NO;
    }

    CGFloat floorPrice = [_floorPriceField.text floatValue];
    CGFloat ceilingPrice = [_ceilingPriceField.text floatValue];

    if (floorPrice > ceilingPrice) {
        [MBProgressHUD showMessag:@"最低价不能高于最高价" toView:self.view];
        return NO;
    }

    return YES;
}

#pragma mark - Actions

- (void)submitButtonTapped {
    if (![self validateForm]) {
        return;
    }

    [self saveFormData];
    [self submitDeclaration];
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitDeclaration {
    [MBProgressHUD showStatus:@"提交中..." toView:self.view];

    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];
    NSDictionary *params = [formData toRequestParams];

    // 根据 API 规范，重新提交也是调用 add 接口创建新的申报
    NSString *urlPath = acquisitionDeclaration_addURL;

    WeakSelf
    [HttpRequest requestUrlPath:BaseURL urlPath:urlPath parameters:params type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:weakSelf.view];

        if (status == 1) {
            // Clear form data
            [formData clear];

            // Go to success page
            AcquisitionStep4VC *vc = [[AcquisitionStep4VC alloc] init];
            if (dic[@"id"]) {
                vc.declarationId = [dic[@"id"] integerValue];
            }
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg ?: @"提交失败" toView:weakSelf.view];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - View Mode

- (void)applyViewModeIfNeeded {
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];
    if (!formData.isViewMode) {
        return;
    }

    // Disable price fields
    _floorPriceField.enabled = NO;
    _ceilingPriceField.enabled = NO;

    // Set text color to indicate disabled state
    UIColor *disabledColor = [UIColor colorWithHexString:@"#666666"];
    _floorPriceField.textColor = disabledColor;
    _ceilingPriceField.textColor = disabledColor;

    // Change submit button to "返回详情"
    // [_submitButton setTitle:@"返回详情" forState:UIControlStateNormal];
    // [_submitButton removeTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    // [_submitButton addTarget:self action:@selector(returnToDetailTapped) forControlEvents:UIControlEventTouchUpInside];

    // Hide back button in view mode
    _backButton.hidden = NO;

    // Update submit button layout
    [_submitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.bottom.equalTo(self.view).offset(-(IS_IPhoneX ? 34 : 20));
        make.height.mas_equalTo(44);
    }];
}

- (void)returnToDetailTapped {
    // Clear view mode and form data
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];
    [formData clear];

    // Pop back to detail page (Step5)
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"AcquisitionStep5VC")]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    // Fallback: pop to root
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
