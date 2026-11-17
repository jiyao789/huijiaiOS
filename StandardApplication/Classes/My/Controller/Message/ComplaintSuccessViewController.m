#import "ComplaintSuccessViewController.h"
#import "MacroDefine.h"
#import "MyComplaintListViewController.h"

// 复用你提供的颜色宏，如果 MacroDefine 里没有，这里就地定义
#define kSuccessPrimaryColor  [UIColor colorWithHexString:@"#2A629A"]

@interface ComplaintSuccessViewController ()

@property (nonatomic, strong) UIImageView *successIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *viewDetailButton;
@property (nonatomic, strong) UIButton *backHomeButton;

@end

@implementation ComplaintSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self leftBarItem];
    self.navTitle = @"提交成功";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    
    // 禁用侧滑返回，防止用户回到已经提交过的表单页
    self.gk_interactivePopDisabled = YES;

    [self setupUI];
}

- (void)setupUI {
    // 1. 成功图标
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

    // 2. 主标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"提交成功";
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];

    // 3. 副标题 (按你要求的文案)
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.text = @"您的投诉将在15日内得到妥善处理\n请您耐心等候。";
    _subtitleLabel.font = [UIFont systemFontOfSize:14];
    _subtitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.numberOfLines = 0;
    [self.view addSubview:_subtitleLabel];

    // 4. 查看详情按钮
    _viewDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _viewDetailButton.backgroundColor = kSuccessPrimaryColor;
    _viewDetailButton.layer.cornerRadius = 22;
    [_viewDetailButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [_viewDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _viewDetailButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_viewDetailButton addTarget:self action:@selector(viewDetailButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_viewDetailButton];

    // 5. 返回首页按钮
    _backHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backHomeButton.backgroundColor = [UIColor whiteColor];
    _backHomeButton.layer.cornerRadius = 22;
    _backHomeButton.layer.borderWidth = 1;
    _backHomeButton.layer.borderColor = kSuccessPrimaryColor.CGColor;
    [_backHomeButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [_backHomeButton setTitleColor:kSuccessPrimaryColor forState:UIControlStateNormal];
    _backHomeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_backHomeButton addTarget:self action:@selector(backHomeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backHomeButton];

    // --- Masonry 布局 ---
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
    // 逻辑占空，目前跳转到列表页作为替代
    MyComplaintListViewController *vc = [[MyComplaintListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backHomeButtonTapped {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end