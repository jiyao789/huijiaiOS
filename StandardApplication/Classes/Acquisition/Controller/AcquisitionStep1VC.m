//
//  AcquisitionStep1VC.m
//  StandardApplication
//
//  Property acquisition declaration - Step 1: Basic Information
//

#import "AcquisitionStep1VC.h"
#import "MacroDefine.h"
#import "AcquisitionFormData.h"
#import "AcquisitionStep2VC.h"

// Colors matching prototype
#define kAcqGreenColor        [UIColor colorWithHexString:@"#2A629A"]
#define kAcqTextPrimary       [UIColor colorWithHexString:@"#333333"]
#define kAcqTextSecondary     [UIColor colorWithHexString:@"#666666"]
#define kAcqTextHint          [UIColor colorWithHexString:@"#999999"]
#define kAcqBgColor           [UIColor colorWithHexString:@"#F5F5F5"]
#define kAcqDivider           [UIColor colorWithHexString:@"#EEEEEE"]
#define kAcqInputBg           [UIColor colorWithHexString:@"#F7F7F7"]

@interface AcquisitionStep1VC () <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

// Form fields
@property (nonatomic, strong) UITextField *ownerNameField;
@property (nonatomic, strong) NSMutableArray<UIButton *> *typeButtons;
@property (nonatomic, strong) UITextField *typeOtherField;
@property (nonatomic, strong) UITextField *certificateNumberField;
@property (nonatomic, strong) UITextField *addressRoadField;
@property (nonatomic, strong) UITextField *addressNongField;
@property (nonatomic, strong) UITextField *addressHaoField;
@property (nonatomic, strong) UITextField *addressShiField;
@property (nonatomic, strong) UITextField *sizeField;
@property (nonatomic, strong) NSMutableArray<UIButton *> *ownershipTypeButtons;
@property (nonatomic, strong) UITextField *ownershipShareField;
@property (nonatomic, strong) UIView *ownershipShareContainer;
@property (nonatomic, strong) NSMutableArray<UIButton *> *exceptionStatusButtons;
@property (nonatomic, strong) NSMutableArray<UIButton *> *liveStatusButtons;
@property (nonatomic, strong) UITextField *liveInfoField;
@property (nonatomic, strong) UIView *liveInfoContainer;
@property (nonatomic, strong) NSMutableArray<UIButton *> *mortgageStatusButtons;
@property (nonatomic, strong) UITextField *mortgageInfoField;
@property (nonatomic, strong) UIView *mortgageInfoContainer;
@property (nonatomic, strong) NSMutableArray<UIButton *> *hukouStatusButtons;
@property (nonatomic, strong) UITextField *hukouNumField;
@property (nonatomic, strong) UIView *hukouNumContainer;
@property (nonatomic, strong) UITextField *requesterNameField;
@property (nonatomic, strong) UITextField *requesterPhoneField;
@property (nonatomic, strong) NSMutableArray<UIButton *> *relationshipButtons;
@property (nonatomic, strong) UITextField *relationshipOtherField;
@property (nonatomic, strong) UIView *relationshipOtherContainer;

@property (nonatomic, strong) UIButton *nextButton;

// Selected values
@property (nonatomic, assign) NSInteger selectedType;
@property (nonatomic, assign) NSInteger selectedOwnershipType;
@property (nonatomic, assign) NSInteger selectedExceptionStatus;
@property (nonatomic, assign) NSInteger selectedLiveStatus;
@property (nonatomic, assign) NSInteger selectedMortgageStatus;
@property (nonatomic, assign) NSInteger selectedHukouStatus;
@property (nonatomic, assign) NSInteger selectedRelationship;

@end

@implementation AcquisitionStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self leftBarItem];
    self.navTitle = @"房源收购意向申报";
    self.view.backgroundColor = [UIColor whiteColor];

    // Initialize
    _selectedType = -1;
    _selectedOwnershipType = -1;
    _selectedExceptionStatus = -1;
    _selectedLiveStatus = -1;
    _selectedMortgageStatus = -1;
    _selectedHukouStatus = -1;
    _selectedRelationship = -1;

    _typeButtons = [NSMutableArray array];
    _ownershipTypeButtons = [NSMutableArray array];
    _exceptionStatusButtons = [NSMutableArray array];
    _liveStatusButtons = [NSMutableArray array];
    _mortgageStatusButtons = [NSMutableArray array];
    _hukouStatusButtons = [NSMutableArray array];
    _relationshipButtons = [NSMutableArray array];

    [self setupUI];
    [self loadFormData];
    [self applyViewModeIfNeeded];
}

- (void)setupUI {
    // Scroll view
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_scrollView];

    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_contentView];

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAVBAR_HEIGHT);
    }];

    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];

    // Section title
    UILabel *sectionTitle = [[UILabel alloc] init];
    sectionTitle.text = @"一、不动产权属信息";
    sectionTitle.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    sectionTitle.textColor = kAcqGreenColor;
    [_contentView addSubview:sectionTitle];

    [sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.top.equalTo(_contentView).offset(20);
    }];

    UIView *lastView = sectionTitle;

    // 1. Owner Name
    _ownerNameField = [self createTextField:@"请输入姓名"];
    lastView = [self addTextFieldSection:@"1. 不动产权利人姓名（若有共有，需填写全体权利人姓名）" field:_ownerNameField afterView:lastView];

    // 2. Property Type (without divider since we have conditional input)
    lastView = [self addRadioSection:@"2. 不动产权利类型" options:@[@"商品房", @"公有住房出售", @"其他"] buttons:_typeButtons baseTag:100 afterView:lastView addDivider:NO];

    // Type Other field - appears above divider
    _typeOtherField = [self createTextField:@"请输入其他类型"];
    _typeOtherField.hidden = YES;
    [_contentView addSubview:_typeOtherField];
    [_typeOtherField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(lastView.mas_bottom);
        make.height.mas_equalTo(0);
    }];

    // Divider after type section (including conditional field)
    UIView *typeOtherDivider = [[UIView alloc] init];
    typeOtherDivider.backgroundColor = kAcqDivider;
    [_contentView addSubview:typeOtherDivider];
    [typeOtherDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(_typeOtherField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    lastView = typeOtherDivider;

    // 3. Certificate Number
    _certificateNumberField = [self createTextField:@"请输入证书编号"];
    lastView = [self addTextFieldSection:@"3. 不动产权证书编号" field:_certificateNumberField afterView:lastView];

    // 4. Address
    lastView = [self addAddressSection:lastView];

    // 5. Size
    _sizeField = [self createTextField:@"请输入面积"];
    _sizeField.keyboardType = UIKeyboardTypeDecimalPad;
    lastView = [self addTextFieldSectionWithSuffix:@"5. 不动产建筑面积（以权属证书登记数据为准）" field:_sizeField suffix:@"m²" afterView:lastView];

    // 6. Ownership Type (without divider since we have conditional input)
    lastView = [self addRadioSection:@"6. 不动产共有情况" options:@[@"单独所有", @"共同共有", @"按份共有"] buttons:_ownershipTypeButtons baseTag:200 afterView:lastView addDivider:NO];

    // Ownership share field - appears above divider
    _ownershipShareContainer = [[UIView alloc] init];
    _ownershipShareContainer.hidden = YES;
    _ownershipShareField = [self createTextField:@"请输入各自分额"];
    [_ownershipShareContainer addSubview:_ownershipShareField];
    [_contentView addSubview:_ownershipShareContainer];
    [_ownershipShareContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(lastView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    [_ownershipShareField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_ownershipShareContainer);
    }];

    // Divider after ownership section (including conditional field)
    UIView *shareDivider = [[UIView alloc] init];
    shareDivider.backgroundColor = kAcqDivider;
    [_contentView addSubview:shareDivider];
    [shareDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(_ownershipShareContainer.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    lastView = shareDivider;

    // 7. Exception Status (no conditional input, with divider)
    lastView = [self addRadioSection:@"7. 不动产查封/异议登记状况" options:@[@"无", @"有"] buttons:_exceptionStatusButtons baseTag:300 afterView:lastView addDivider:YES];

    // 8. Live Status (Residence Right) - without divider since we have conditional input
    lastView = [self addRadioSection:@"8. 不动产居住权状况（选填）" options:@[@"无", @"有"] buttons:_liveStatusButtons baseTag:400 afterView:lastView addDivider:NO];

    // Live info field - appears above divider
    _liveInfoContainer = [[UIView alloc] init];
    _liveInfoContainer.hidden = YES;
    _liveInfoField = [self createTextField:@"请输入居住权人及期限"];
    [_liveInfoContainer addSubview:_liveInfoField];
    [_contentView addSubview:_liveInfoContainer];
    [_liveInfoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(lastView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    [_liveInfoField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_liveInfoContainer);
    }];

    // Divider after live status section
    UIView *liveInfoDivider = [[UIView alloc] init];
    liveInfoDivider.backgroundColor = kAcqDivider;
    [_contentView addSubview:liveInfoDivider];
    [liveInfoDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(_liveInfoContainer.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    lastView = liveInfoDivider;

    // 9. Mortgage Status - without divider since we have conditional input
    lastView = [self addRadioSection:@"9. 不动产抵押状况（选填）" options:@[@"无", @"有"] buttons:_mortgageStatusButtons baseTag:500 afterView:lastView addDivider:NO];

    // Mortgage info field - appears above divider
    _mortgageInfoContainer = [[UIView alloc] init];
    _mortgageInfoContainer.hidden = YES;
    _mortgageInfoField = [self createTextField:@"请输入抵押权人及抵押金额"];
    [_mortgageInfoContainer addSubview:_mortgageInfoField];
    [_contentView addSubview:_mortgageInfoContainer];
    [_mortgageInfoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(lastView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    [_mortgageInfoField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mortgageInfoContainer);
    }];

    // Divider after mortgage section
    UIView *mortgageInfoDivider = [[UIView alloc] init];
    mortgageInfoDivider.backgroundColor = kAcqDivider;
    [_contentView addSubview:mortgageInfoDivider];
    [mortgageInfoDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(_mortgageInfoContainer.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    lastView = mortgageInfoDivider;

    // 10. Hukou Status - without divider since we have conditional input
    lastView = [self addRadioSection:@"10. 不动产内是否有户口（选填）" options:@[@"无", @"有"] buttons:_hukouStatusButtons baseTag:600 afterView:lastView addDivider:NO];

    // Hukou num field - appears above divider
    _hukouNumContainer = [[UIView alloc] init];
    _hukouNumContainer.hidden = YES;
    _hukouNumField = [self createTextField:@"请输入户口登记人数"];
    _hukouNumField.keyboardType = UIKeyboardTypeNumberPad;
    [_hukouNumContainer addSubview:_hukouNumField];
    [_contentView addSubview:_hukouNumContainer];
    [_hukouNumContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(lastView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    [_hukouNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_hukouNumContainer);
    }];

    // Divider after hukou section
    UIView *hukouNumDivider = [[UIView alloc] init];
    hukouNumDivider.backgroundColor = kAcqDivider;
    [_contentView addSubview:hukouNumDivider];
    [hukouNumDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(_hukouNumContainer.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    lastView = hukouNumDivider;

    // 11. Requester Name and Phone (combined as in Android layout)
    UILabel *requesterLabel = [[UILabel alloc] init];
    requesterLabel.text = @"11. 填报人姓名及联系方式";
    requesterLabel.font = [UIFont systemFontOfSize:15];
    requesterLabel.textColor = kAcqTextPrimary;
    requesterLabel.numberOfLines = 0;
    [_contentView addSubview:requesterLabel];
    [requesterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(lastView.mas_bottom).offset(15);
    }];

    _requesterNameField = [self createTextField:@"请输入姓名"];
    [_contentView addSubview:_requesterNameField];
    [_requesterNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(requesterLabel.mas_bottom);
        make.height.mas_equalTo(40);
    }];

    UIView *nameDivider = [[UIView alloc] init];
    nameDivider.backgroundColor = kAcqDivider;
    [_contentView addSubview:nameDivider];
    [nameDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(_requesterNameField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    _requesterPhoneField = [self createTextField:@"请输入联系方式"];
    _requesterPhoneField.keyboardType = UIKeyboardTypePhonePad;
    [_contentView addSubview:_requesterPhoneField];
    [_requesterPhoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(nameDivider.mas_bottom);
        make.height.mas_equalTo(40);
    }];

    UIView *phoneDivider = [[UIView alloc] init];
    phoneDivider.backgroundColor = kAcqDivider;
    [_contentView addSubview:phoneDivider];
    [phoneDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(_requesterPhoneField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    lastView = phoneDivider;

    // 12. Relationship - without divider since we have conditional input
    lastView = [self addRadioSection:@"12. 申报人与权利人关系" options:@[@"本人", @"配偶", @"子女", @"兄弟姐妹", @"其他"] buttons:_relationshipButtons baseTag:700 afterView:lastView addDivider:NO];

    // Relationship other field - appears above divider
    _relationshipOtherContainer = [[UIView alloc] init];
    _relationshipOtherContainer.hidden = YES;
    _relationshipOtherField = [self createTextField:@"请具体说明"];
    [_relationshipOtherContainer addSubview:_relationshipOtherField];
    [_contentView addSubview:_relationshipOtherContainer];
    [_relationshipOtherContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(lastView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    [_relationshipOtherField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_relationshipOtherContainer);
    }];

    // Divider after relationship section
    UIView *relationshipOtherDivider = [[UIView alloc] init];
    relationshipOtherDivider.backgroundColor = kAcqDivider;
    [_contentView addSubview:relationshipOtherDivider];
    [relationshipOtherDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(_relationshipOtherContainer.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    lastView = relationshipOtherDivider;

    // Next Button
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.backgroundColor = kAcqGreenColor;
    _nextButton.layer.cornerRadius = 4;
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [_nextButton addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_nextButton];

    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(lastView.mas_bottom).offset(40);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(_contentView).offset(-40);
    }];
}

#pragma mark - UI Helpers

- (UITextField *)createTextField:(NSString *)placeholder {
    UITextField *field = [[UITextField alloc] init];
    field.placeholder = placeholder;
    field.font = [UIFont systemFontOfSize:14];
    field.textColor = kAcqTextPrimary;
    field.backgroundColor = [UIColor clearColor];
    field.borderStyle = UITextBorderStyleNone;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.delegate = self;
    return field;
}


- (UIView *)addTextFieldSection:(NSString *)title field:(UITextField *)field afterView:(UIView *)lastView {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = kAcqTextPrimary;
    label.numberOfLines = 0;
    [_contentView addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(lastView.mas_bottom).offset(15);
    }];

    [_contentView addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(label.mas_bottom).offset(0);
        make.height.mas_equalTo(40);
    }];

    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = kAcqDivider;
    [_contentView addSubview:divider];
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(field.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    return divider;
}

- (UIView *)addTextFieldSectionWithSuffix:(NSString *)title field:(UITextField *)field suffix:(NSString *)suffix afterView:(UIView *)lastView {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = kAcqTextPrimary;
    label.numberOfLines = 0;
    [_contentView addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(lastView.mas_bottom).offset(15);
    }];

    UIView *inputContainer = [[UIView alloc] init];
    [_contentView addSubview:inputContainer];

    [inputContainer addSubview:field];

    UILabel *suffixLabel = [[UILabel alloc] init];
    suffixLabel.text = suffix;
    suffixLabel.font = [UIFont systemFontOfSize:15];
    suffixLabel.textColor = kAcqTextPrimary;
    [inputContainer addSubview:suffixLabel];

    [inputContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(label.mas_bottom);
        make.height.mas_equalTo(40);
    }];

    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputContainer);
        make.top.bottom.equalTo(inputContainer);
        make.right.equalTo(suffixLabel.mas_left).offset(-8);
    }];

    [suffixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputContainer);
        make.centerY.equalTo(inputContainer);
    }];

    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = kAcqDivider;
    [_contentView addSubview:divider];
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(inputContainer.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    return divider;
}

- (UITextField *)createAndroidStyleInput:(NSString *)placeholder {
    UITextField *field = [[UITextField alloc] init];
    field.placeholder = placeholder;
    field.font = [UIFont systemFontOfSize:14];
    field.textColor = kAcqTextPrimary;
    field.backgroundColor = [UIColor clearColor];
    field.borderStyle = UITextBorderStyleNone;
    field.delegate = self;
    return field;
}


- (UIView *)addRadioSection:(NSString *)title options:(NSArray<NSString *> *)options buttons:(NSMutableArray<UIButton *> *)buttons baseTag:(NSInteger)baseTag afterView:(UIView *)lastView {
    return [self addRadioSection:title options:options buttons:buttons baseTag:baseTag afterView:lastView addDivider:YES];
}

- (UIView *)addRadioSection:(NSString *)title options:(NSArray<NSString *> *)options buttons:(NSMutableArray<UIButton *> *)buttons baseTag:(NSInteger)baseTag afterView:(UIView *)lastView addDivider:(BOOL)addDivider {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = kAcqTextPrimary;
    label.numberOfLines = 0;
    [_contentView addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(lastView.mas_bottom).offset(15);
    }];

    UIView *prevView = label;

    for (NSInteger i = 0; i < options.count; i++) {
        UIButton *btn = [self createRadioButton:options[i] tag:baseTag + i];
        [btn addTarget:self action:@selector(radioButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:btn];

        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView).offset(16);
            make.top.equalTo(prevView.mas_bottom).offset(10);
            make.height.mas_equalTo(24);
        }];

        [buttons addObject:btn];
        prevView = btn;
    }

    if (addDivider) {
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = kAcqDivider;
        [_contentView addSubview:divider];
        [divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView).offset(16);
            make.right.equalTo(_contentView).offset(-16);
            make.top.equalTo(prevView.mas_bottom).offset(10);
            make.height.mas_equalTo(0.5);
        }];
        return divider;
    }

    return prevView;
}

- (UIButton *)createRadioButton:(NSString *)title tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;

    UIImage *uncheckedImage = [self circleImageWithColor:[UIColor clearColor] borderColor:kAcqTextHint size:20];
    UIImage *checkedImage = [self circleImageWithColor:kAcqGreenColor borderColor:kAcqGreenColor size:20];

    [btn setImage:uncheckedImage forState:UIControlStateNormal];
    [btn setImage:checkedImage forState:UIControlStateSelected];

    [btn setTitle:[NSString stringWithFormat:@"  %@", title] forState:UIControlStateNormal];
    [btn setTitleColor:kAcqTextPrimary forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    return btn;
}

- (UIImage *)circleImageWithColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor size:(CGFloat)size {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextSetLineWidth(ctx, 1.5);
    CGContextAddEllipseInRect(ctx, CGRectMake(1, 1, size - 2, size - 2));
    CGContextStrokePath(ctx);

    if (fillColor != [UIColor clearColor]) {
        CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
        CGContextAddEllipseInRect(ctx, CGRectMake(4, 4, size - 8, size - 8));
        CGContextFillPath(ctx);
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIView *)addAddressSection:(UIView *)lastView {
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"4. 不动产坐落（精确到室号）（与产证一致）";
    addressLabel.font = [UIFont systemFontOfSize:15];
    addressLabel.textColor = kAcqTextPrimary;
    [_contentView addSubview:addressLabel];

    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(lastView.mas_bottom).offset(20);
    }];

    UIView *addressContainer = [[UIView alloc] init];
    [_contentView addSubview:addressContainer];

    _addressRoadField = [self createSmallTextField];
    _addressNongField = [self createSmallTextField];
    _addressHaoField = [self createSmallTextField];
    _addressShiField = [self createSmallTextField];

    UILabel *roadLabel = [self createUnitLabel:@"路"];
    UILabel *nongLabel = [self createUnitLabel:@"弄"];
    UILabel *haoLabel = [self createUnitLabel:@"号"];
    UILabel *shiLabel = [self createUnitLabel:@"室"];

    [addressContainer addSubview:_addressRoadField];
    [addressContainer addSubview:roadLabel];
    [addressContainer addSubview:_addressNongField];
    [addressContainer addSubview:nongLabel];
    [addressContainer addSubview:_addressHaoField];
    [addressContainer addSubview:haoLabel];
    [addressContainer addSubview:_addressShiField];
    [addressContainer addSubview:shiLabel];

    [addressContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(addressLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(32);
    }];

    CGFloat fieldWidth = (SCREEN_WIDTH - 32 - 4 * 30 - 3 * 8) / 4;

    [_addressRoadField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressContainer);
        make.top.bottom.equalTo(addressContainer);
        make.width.mas_equalTo(fieldWidth);
    }];

    [roadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressRoadField.mas_right).offset(4);
        make.centerY.equalTo(addressContainer);
        make.width.mas_equalTo(26);
    }];

    [_addressNongField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roadLabel.mas_right).offset(4);
        make.top.bottom.equalTo(addressContainer);
        make.width.mas_equalTo(fieldWidth);
    }];

    [nongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressNongField.mas_right).offset(4);
        make.centerY.equalTo(addressContainer);
        make.width.mas_equalTo(26);
    }];

    [_addressHaoField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nongLabel.mas_right).offset(4);
        make.top.bottom.equalTo(addressContainer);
        make.width.mas_equalTo(fieldWidth);
    }];

    [haoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressHaoField.mas_right).offset(4);
        make.centerY.equalTo(addressContainer);
        make.width.mas_equalTo(26);
    }];

    [_addressShiField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(haoLabel.mas_right).offset(4);
        make.top.bottom.equalTo(addressContainer);
        make.width.mas_equalTo(fieldWidth);
    }];

    [shiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressShiField.mas_right).offset(4);
        make.centerY.equalTo(addressContainer);
    }];

    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = kAcqDivider;
    [_contentView addSubview:divider];
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(addressContainer.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];

    return divider;
}

- (UITextField *)createSmallTextField {
    UITextField *field = [[UITextField alloc] init];
    field.font = [UIFont systemFontOfSize:15];
    field.textColor = kAcqTextPrimary;
    field.textAlignment = NSTextAlignmentCenter;
    field.borderStyle = UITextBorderStyleNone;
    field.backgroundColor = [UIColor whiteColor];
    field.layer.borderWidth = 0.5;
    field.layer.borderColor = kAcqDivider.CGColor;
    field.layer.cornerRadius = 4;
    field.delegate = self;
    return field;
}

- (UILabel *)createUnitLabel:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = kAcqTextPrimary;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIView *)addDividerAfter:(UIView *)lastView {
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = kAcqDivider;
    [_contentView addSubview:divider];
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(lastView.mas_bottom).offset(16);
        make.height.mas_equalTo(0.5);
    }];
    return divider;
}

- (UIView *)addAndroidDividerBelow:(UIView *)view {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kAcqDivider;
    [_contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(view.mas_bottom).offset(4);
        make.height.mas_equalTo(0.5);
    }];
    return line;
}


#pragma mark - Radio Button Actions

- (void)radioButtonTapped:(UIButton *)sender {
    NSInteger tag = sender.tag;

    if (tag >= 100 && tag < 200) {
        _selectedType = tag - 100 + 1;
        [self selectButton:sender inArray:_typeButtons];

        BOOL showOther = (_selectedType == 3);
        _typeOtherField.hidden = !showOther;
        [_typeOtherField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(showOther ? 44 : 0);
        }];
    } else if (tag >= 200 && tag < 300) {
        // API: 1=单独所有, 2=共同所有, 3=按份所有
        _selectedOwnershipType = tag - 200 + 1;
        [self selectButton:sender inArray:_ownershipTypeButtons];

        BOOL showShare = (_selectedOwnershipType == 3);
        _ownershipShareContainer.hidden = !showShare;
        [_ownershipShareContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(showShare ? 44 : 0);
        }];
    } else if (tag >= 300 && tag < 400) {
        // API: 1=无异常, 2=有异常
        _selectedExceptionStatus = tag - 300 + 1;
        [self selectButton:sender inArray:_exceptionStatusButtons];
    } else if (tag >= 400 && tag < 500) {
        // API: 1=无居住, 2=有居住 (选填，支持取消选择)
        NSInteger newValue = tag - 400 + 1;
        if (_selectedLiveStatus == newValue) {
            // 点击已选中项，取消选择
            _selectedLiveStatus = -1;
            [self deselectAllButtons:_liveStatusButtons];
        } else {
            _selectedLiveStatus = newValue;
            [self selectButton:sender inArray:_liveStatusButtons];
        }

        BOOL showInfo = (_selectedLiveStatus == 2);
        _liveInfoContainer.hidden = !showInfo;
        [_liveInfoContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(showInfo ? 44 : 0);
        }];
    } else if (tag >= 500 && tag < 600) {
        // API: 1=无抵押, 2=有抵押 (选填，支持取消选择)
        NSInteger newValue = tag - 500 + 1;
        if (_selectedMortgageStatus == newValue) {
            // 点击已选中项，取消选择
            _selectedMortgageStatus = -1;
            [self deselectAllButtons:_mortgageStatusButtons];
        } else {
            _selectedMortgageStatus = newValue;
            [self selectButton:sender inArray:_mortgageStatusButtons];
        }

        BOOL showInfo = (_selectedMortgageStatus == 2);
        _mortgageInfoContainer.hidden = !showInfo;
        [_mortgageInfoContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(showInfo ? 44 : 0);
        }];
    } else if (tag >= 600 && tag < 700) {
        // API: 1=无户口, 2=有户口 (选填，支持取消选择)
        NSInteger newValue = tag - 600 + 1;
        if (_selectedHukouStatus == newValue) {
            // 点击已选中项，取消选择
            _selectedHukouStatus = -1;
            [self deselectAllButtons:_hukouStatusButtons];
        } else {
            _selectedHukouStatus = newValue;
            [self selectButton:sender inArray:_hukouStatusButtons];
        }

        BOOL showNum = (_selectedHukouStatus == 2);
        _hukouNumContainer.hidden = !showNum;
        [_hukouNumContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(showNum ? 44 : 0);
        }];
    } else if (tag >= 700 && tag < 800) {
        _selectedRelationship = tag - 700 + 1;
        [self selectButton:sender inArray:_relationshipButtons];

        BOOL showOther = (_selectedRelationship == 5);
        _relationshipOtherContainer.hidden = !showOther;
        [_relationshipOtherContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(showOther ? 44 : 0);
        }];
    }

    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)selectButton:(UIButton *)selectedBtn inArray:(NSArray<UIButton *> *)buttons {
    for (UIButton *btn in buttons) {
        btn.selected = (btn == selectedBtn);
    }
}

- (void)deselectAllButtons:(NSArray<UIButton *> *)buttons {
    for (UIButton *btn in buttons) {
        btn.selected = NO;
    }
}

#pragma mark - Actions

- (void)nextButtonTapped {
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];

    // In view mode, skip validation and just navigate
    if (!formData.isViewMode) {
        if (![self validateForm]) {
            return;
        }
        [self saveFormData];
    }

    AcquisitionStep2VC *vc = [[AcquisitionStep2VC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Form Validation

- (BOOL)validateForm {
    if (IsStrEmpty(_ownerNameField.text)) {
        [MBProgressHUD showMessag:@"请输入权利人姓名" toView:self.view];
        return NO;
    }
    if (_selectedType < 1) {
        [MBProgressHUD showMessag:@"请选择权利类型" toView:self.view];
        return NO;
    }
    if (_selectedType == 3 && IsStrEmpty(_typeOtherField.text)) {
        [MBProgressHUD showMessag:@"请输入其他类型说明" toView:self.view];
        return NO;
    }
    if (IsStrEmpty(_certificateNumberField.text)) {
        [MBProgressHUD showMessag:@"请输入证书编号" toView:self.view];
        return NO;
    }
    if (IsStrEmpty(_addressRoadField.text) && IsStrEmpty(_addressNongField.text) && IsStrEmpty(_addressHaoField.text)) {
        [MBProgressHUD showMessag:@"请输入房屋坐落地址" toView:self.view];
        return NO;
    }
    if (IsStrEmpty(_sizeField.text)) {
        [MBProgressHUD showMessag:@"请输入建筑面积" toView:self.view];
        return NO;
    }
    double areaValue = [_sizeField.text doubleValue]; // 将字符串转为 double，若无法转换则默认为 0.0 
    if (areaValue <= 0) {
         [MBProgressHUD showMessag:@"建筑面积必须大于0" toView:self.view];
        return NO; 
    }
    if (_selectedOwnershipType < 1) {
        [MBProgressHUD showMessag:@"请选择共有情况" toView:self.view];
        return NO;
    }
    if (_selectedOwnershipType == 3 && IsStrEmpty(_ownershipShareField.text)) {
        [MBProgressHUD showMessag:@"请输入份额" toView:self.view];
        return NO;
    }
    if (_selectedExceptionStatus < 1) {
        [MBProgressHUD showMessag:@"请选择查封/异议状态" toView:self.view];
        return NO;
    }
    if (_selectedLiveStatus == 2 && IsStrEmpty(_liveInfoField.text)) {
        [MBProgressHUD showMessag:@"请输入居住权详情" toView:self.view];
        return NO;
    }
    if (_selectedMortgageStatus == 2 && IsStrEmpty(_mortgageInfoField.text)) {
        [MBProgressHUD showMessag:@"请输入抵押详情" toView:self.view];
        return NO;
    }
    if (_selectedHukouStatus == 2 && IsStrEmpty(_hukouNumField.text)) {
        [MBProgressHUD showMessag:@"请输入户口人数" toView:self.view];
        return NO;
    }
    if (IsStrEmpty(_requesterNameField.text)) {
        [MBProgressHUD showMessag:@"请输入申报人姓名" toView:self.view];
        return NO;
    }
    if (IsStrEmpty(_requesterPhoneField.text)) {
        [MBProgressHUD showMessag:@"请输入申报人联系方式" toView:self.view];
        return NO;
    }
    if (_selectedRelationship < 1) {
        [MBProgressHUD showMessag:@"请选择与权利人关系" toView:self.view];
        return NO;
    }
    if (_selectedRelationship == 5 && IsStrEmpty(_relationshipOtherField.text)) {
        [MBProgressHUD showMessag:@"请输入其他关系说明" toView:self.view];
        return NO;
    }

    return YES;
}

#pragma mark - Form Data

- (void)saveFormData {
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];

    formData.ownerName = _ownerNameField.text;
    formData.type = _selectedType;
    formData.typeOther = _typeOtherField.text;
    formData.certificateNumber = _certificateNumberField.text;
    formData.addressRoad = _addressRoadField.text;
    formData.addressNong = _addressNongField.text;
    formData.addressHao = _addressHaoField.text;
    formData.addressShi = _addressShiField.text;
    formData.size = _sizeField.text;
    formData.ownershipType = @(_selectedOwnershipType);
    formData.ownershipShare = _ownershipShareField.text;
    formData.exceptionStatus = @(_selectedExceptionStatus);
    formData.liveStatus = @(_selectedLiveStatus);
    formData.liveInfo = _liveInfoField.text;
    formData.mortgageStatus = @(_selectedMortgageStatus);
    formData.mortgageInfo = _mortgageInfoField.text;
    formData.hukouStatus = @(_selectedHukouStatus);
    if (_hukouNumField.text.length > 0) {
        formData.hukouNum = @([_hukouNumField.text integerValue]);
    }
    formData.requesterName = _requesterNameField.text;
    formData.requesterPhoneNum = _requesterPhoneField.text;
    formData.relationship = _selectedRelationship;
    formData.relationshipOther = _relationshipOtherField.text;
}

- (void)loadFormData {
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];

    if (formData.ownerName.length > 0) {
        _ownerNameField.text = formData.ownerName;
    }
    if (formData.type > 0) {
        _selectedType = formData.type;
        NSInteger idx = _selectedType - 1;
        if (idx < _typeButtons.count) {
            [self selectButton:_typeButtons[idx] inArray:_typeButtons];
        }
        if (_selectedType == 3) {
            _typeOtherField.hidden = NO;
            _typeOtherField.text = formData.typeOther;
            [_typeOtherField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44);
            }];
        }
    }
    if (formData.certificateNumber.length > 0) {
        _certificateNumberField.text = formData.certificateNumber;
    }
    _addressRoadField.text = formData.addressRoad;
    _addressNongField.text = formData.addressNong;
    _addressHaoField.text = formData.addressHao;
    _addressShiField.text = formData.addressShi;
    if (formData.size.length > 0) {
        _sizeField.text = formData.size;
    }
    if (formData.ownershipType) {
        // API: 1=单独所有, 2=共同所有, 3=按份所有
        _selectedOwnershipType = [formData.ownershipType integerValue];
        NSInteger ownershipIdx = _selectedOwnershipType - 1;
        if (ownershipIdx >= 0 && ownershipIdx < _ownershipTypeButtons.count) {
            [self selectButton:_ownershipTypeButtons[ownershipIdx] inArray:_ownershipTypeButtons];
        }
        if (_selectedOwnershipType == 3) {
            _ownershipShareContainer.hidden = NO;
            _ownershipShareField.text = formData.ownershipShare;
            [_ownershipShareContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44);
            }];
        }
    }
    if (formData.exceptionStatus) {
        // API: 1=无异常, 2=有异常
        _selectedExceptionStatus = [formData.exceptionStatus integerValue];
        NSInteger exceptionIdx = _selectedExceptionStatus - 1;
        if (exceptionIdx >= 0 && exceptionIdx < _exceptionStatusButtons.count) {
            [self selectButton:_exceptionStatusButtons[exceptionIdx] inArray:_exceptionStatusButtons];
        }
    }
    if (formData.liveStatus) {
        // API: 1=无居住, 2=有居住
        _selectedLiveStatus = [formData.liveStatus integerValue];
        NSInteger liveIdx = _selectedLiveStatus - 1;
        if (liveIdx >= 0 && liveIdx < _liveStatusButtons.count) {
            [self selectButton:_liveStatusButtons[liveIdx] inArray:_liveStatusButtons];
        }
        if (_selectedLiveStatus == 2) {
            _liveInfoContainer.hidden = NO;
            _liveInfoField.text = formData.liveInfo;
            [_liveInfoContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44);
            }];
        }
    }
    if (formData.mortgageStatus) {
        // API: 1=无抵押, 2=有抵押
        _selectedMortgageStatus = [formData.mortgageStatus integerValue];
        NSInteger mortgageIdx = _selectedMortgageStatus - 1;
        if (mortgageIdx >= 0 && mortgageIdx < _mortgageStatusButtons.count) {
            [self selectButton:_mortgageStatusButtons[mortgageIdx] inArray:_mortgageStatusButtons];
        }
        if (_selectedMortgageStatus == 2) {
            _mortgageInfoContainer.hidden = NO;
            _mortgageInfoField.text = formData.mortgageInfo;
            [_mortgageInfoContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44);
            }];
        }
    }
    if (formData.hukouStatus) {
        // API: 1=无户口, 2=有户口
        _selectedHukouStatus = [formData.hukouStatus integerValue];
        NSInteger hukouIdx = _selectedHukouStatus - 1;
        if (hukouIdx >= 0 && hukouIdx < _hukouStatusButtons.count) {
            [self selectButton:_hukouStatusButtons[hukouIdx] inArray:_hukouStatusButtons];
        }
        if (_selectedHukouStatus == 2) {
            _hukouNumContainer.hidden = NO;
            if (formData.hukouNum) {
                _hukouNumField.text = [NSString stringWithFormat:@"%@", formData.hukouNum];
            }
            [_hukouNumContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44);
            }];
        }
    }
    if (formData.requesterName.length > 0) {
        _requesterNameField.text = formData.requesterName;
    }
    if (formData.requesterPhoneNum.length > 0) {
        _requesterPhoneField.text = formData.requesterPhoneNum;
    }
    if (formData.relationship > 0) {
        _selectedRelationship = formData.relationship;
        NSInteger idx = _selectedRelationship - 1;
        if (idx < _relationshipButtons.count) {
            [self selectButton:_relationshipButtons[idx] inArray:_relationshipButtons];
        }
        if (_selectedRelationship == 5) {
            _relationshipOtherContainer.hidden = NO;
            _relationshipOtherField.text = formData.relationshipOther;
            [_relationshipOtherContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44);
            }];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Limit name fields to 32 characters
    if (textField == _ownerNameField || textField == _requesterNameField) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newString.length > 32) {
            return NO;
        }
    }
    return YES;
}

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

    // Disable all text fields
    _ownerNameField.enabled = NO;
    _typeOtherField.enabled = NO;
    _certificateNumberField.enabled = NO;
    _addressRoadField.enabled = NO;
    _addressNongField.enabled = NO;
    _addressHaoField.enabled = NO;
    _addressShiField.enabled = NO;
    _sizeField.enabled = NO;
    _ownershipShareField.enabled = NO;
    _liveInfoField.enabled = NO;
    _mortgageInfoField.enabled = NO;
    _hukouNumField.enabled = NO;
    _requesterNameField.enabled = NO;
    _requesterPhoneField.enabled = NO;
    _relationshipOtherField.enabled = NO;

    // Set text color to indicate disabled state
    UIColor *disabledColor = [UIColor colorWithHexString:@"#666666"];
    _ownerNameField.textColor = disabledColor;
    _typeOtherField.textColor = disabledColor;
    _certificateNumberField.textColor = disabledColor;
    _addressRoadField.textColor = disabledColor;
    _addressNongField.textColor = disabledColor;
    _addressHaoField.textColor = disabledColor;
    _addressShiField.textColor = disabledColor;
    _sizeField.textColor = disabledColor;
    _ownershipShareField.textColor = disabledColor;
    _liveInfoField.textColor = disabledColor;
    _mortgageInfoField.textColor = disabledColor;
    _hukouNumField.textColor = disabledColor;
    _requesterNameField.textColor = disabledColor;
    _requesterPhoneField.textColor = disabledColor;
    _relationshipOtherField.textColor = disabledColor;

    // Disable all radio buttons
    for (UIButton *btn in _typeButtons) {
        btn.userInteractionEnabled = NO;
    }
    for (UIButton *btn in _ownershipTypeButtons) {
        btn.userInteractionEnabled = NO;
    }
    for (UIButton *btn in _exceptionStatusButtons) {
        btn.userInteractionEnabled = NO;
    }
    for (UIButton *btn in _liveStatusButtons) {
        btn.userInteractionEnabled = NO;
    }
    for (UIButton *btn in _mortgageStatusButtons) {
        btn.userInteractionEnabled = NO;
    }
    for (UIButton *btn in _hukouStatusButtons) {
        btn.userInteractionEnabled = NO;
    }
    for (UIButton *btn in _relationshipButtons) {
        btn.userInteractionEnabled = NO;
    }

    // Change next button to "下一步" for navigation in view mode
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
}

@end
