//
//  AcquisitionStep4VC.m
//  StandardApplication
//
//  Property acquisition declaration - Step 4: Success Page
//

#import "AcquisitionStep4VC.h"
#import "MacroDefine.h"
#import "AcquisitionStep5VC.h"
#import "AcquisitionListVC.h"

#define kAcqPrimaryColor      [UIColor colorWithHexString:@"#2A629A"]
#define kAcqTextPrimary       [UIColor colorWithHexString:@"#333333"]
#define kAcqTextSecondary     [UIColor colorWithHexString:@"#666666"]
#define kAcqBgMain            [UIColor colorWithHexString:@"#F8F8F8"]

@interface AcquisitionStep4VC ()

@property (nonatomic, strong) UIImageView *successIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *viewDetailButton;
@property (nonatomic, strong) UIButton *backHomeButton;

@end

@implementation AcquisitionStep4VC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self leftBarItem];
    self.navTitle = @"提交成功";
    self.view.backgroundColor = kAcqBgMain;

    // Disable back gesture
    self.gk_interactivePopDisabled = YES;

    [self setupUI];
}

- (void)setupUI {
    // Success icon
    _successIcon = [[UIImageView alloc] init];
    UIImage *successImage = [UIImage imageNamed:@"icon_success_big"];
    if (successImage) {
        _successIcon.image = successImage;
    } else {
        // Fallback: create a checkmark circle
        _successIcon.backgroundColor = [UIColor colorWithHexString:@"#34C759"];
        _successIcon.layer.cornerRadius = 40;

        UILabel *checkmark = [[UILabel alloc] init];
        checkmark.text = @"✓";
        checkmark.font = [UIFont boldSystemFontOfSize:40];
        checkmark.textColor = [UIColor whiteColor];
        checkmark.textAlignment = NSTextAlignmentCenter;
        [_successIcon addSubview:checkmark];
        [checkmark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_successIcon);
        }];
    }
    [self.view addSubview:_successIcon];

    // Title
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"提交成功";
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textColor = kAcqTextPrimary;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];

    // Subtitle
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.text = @"请关注申报详情，并保持电话畅通，工作人员将在初审通过后尽快与您联系\n后续可在“我的”-“我的申报”中查看进度";
    _subtitleLabel.font = [UIFont systemFontOfSize:14];
    _subtitleLabel.textColor = kAcqTextSecondary;
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.numberOfLines = 0;
    [self.view addSubview:_subtitleLabel];

    // View detail button
    _viewDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _viewDetailButton.backgroundColor = kAcqPrimaryColor;
    _viewDetailButton.layer.cornerRadius = 22;
    [_viewDetailButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [_viewDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _viewDetailButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_viewDetailButton addTarget:self action:@selector(viewDetailButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_viewDetailButton];

    // Back home button
    _backHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backHomeButton.backgroundColor = [UIColor whiteColor];
    _backHomeButton.layer.cornerRadius = 22;
    _backHomeButton.layer.borderWidth = 1;
    _backHomeButton.layer.borderColor = kAcqPrimaryColor.CGColor;
    [_backHomeButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [_backHomeButton setTitleColor:kAcqPrimaryColor forState:UIControlStateNormal];
    _backHomeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_backHomeButton addTarget:self action:@selector(backHomeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backHomeButton];

    // Layout
    [_successIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAVBAR_HEIGHT + 80);
        make.width.height.mas_equalTo(80);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_successIcon.mas_bottom).offset(24);
    }];

    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_titleLabel.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
    }];

    [_viewDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(32);
        make.right.equalTo(self.view).offset(-32);
        make.top.equalTo(_subtitleLabel.mas_bottom).offset(60);
        make.height.mas_equalTo(44);
    }];

    [_backHomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(32);
        make.right.equalTo(self.view).offset(-32);
        make.top.equalTo(_viewDetailButton.mas_bottom).offset(16);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - Actions

- (void)viewDetailButtonTapped {
    AcquisitionStep5VC *vc = [[AcquisitionStep5VC alloc] init];
    vc.declarationId = _declarationId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backHomeButtonTapped {
    // Find and pop to list VC or root
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[AcquisitionListVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backAction {
    [self backHomeButtonTapped];
}

@end
