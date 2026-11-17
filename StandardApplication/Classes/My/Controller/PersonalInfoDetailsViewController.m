#import "PersonalInfoDetailsViewController.h"
#import "MacroDefine.h" // 引入你的宏定义头文件，确保 leftBarItem 等方法可用
#import "MyContractListViewController.h" 
#import "MapSearchHouseViewController.h"
// =========================================================
// 自定义 Cell：用于展示每一条收集清单卡片
// =========================================================
@interface PersonalInfoItemCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *purposeValueLab;
@property (nonatomic, strong) UILabel *scenarioValueLab;
@property (nonatomic, strong) UILabel *statusValueLab;
@property (nonatomic, strong) UIButton *contentValueBtn;
@property (nonatomic, strong) UILabel *contentValueDashLab; // 用于展示 "-"

// 点击信息内容（如“我的订单”）的回调
@property (nonatomic, copy) void(^linkBtnClickBlock)(void);

- (void)configData:(NSDictionary *)dict;

@end

@implementation PersonalInfoItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]; // 浅灰背景
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 白色卡片背景
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:bgView];
    
    // 标题
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    _titleLab.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    _titleLab.translatesAutoresizingMaskIntoConstraints = NO;
    [bgView addSubview:_titleLab];
    
    // 键值对左侧 Keys
    NSArray *keys = @[@"使用目的", @"使用场景", @"收集情况", @"信息内容"];
    NSMutableArray *keyLabels = [NSMutableArray array];
    
    for (int i = 0; i < keys.count; i++) {
        UILabel *keyLab = [[UILabel alloc] init];
        keyLab.text = keys[i];
        keyLab.font = [UIFont systemFontOfSize:14];
        keyLab.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]; // 深灰色
        keyLab.translatesAutoresizingMaskIntoConstraints = NO;
        [bgView addSubview:keyLab];
        [keyLabels addObject:keyLab];
    }
    
    // 实例化右侧 Values
    _purposeValueLab = [self createValueLabel];
    _scenarioValueLab = [self createValueLabel];
    _statusValueLab = [self createValueLabel];
    
    _contentValueDashLab = [self createValueLabel];
    _contentValueDashLab.text = @"-";
    
    _contentValueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contentValueBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.6 blue:0.8 alpha:1.0] forState:UIControlStateNormal]; // 蓝色链接
    _contentValueBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _contentValueBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_contentValueBtn addTarget:self action:@selector(contentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _contentValueBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [bgView addSubview:_purposeValueLab];
    [bgView addSubview:_scenarioValueLab];
    [bgView addSubview:_statusValueLab];
    [bgView addSubview:_contentValueDashLab];
    [bgView addSubview:_contentValueBtn];
    
    // === 设置 AutoLayout 约束 ===
    [bgView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10].active = YES; // 卡片顶部留白
    [bgView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
    [bgView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
    [bgView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    
    [_titleLab.topAnchor constraintEqualToAnchor:bgView.topAnchor constant:15].active = YES;
    [_titleLab.leftAnchor constraintEqualToAnchor:bgView.leftAnchor constant:16].active = YES;
    
    CGFloat keyWidth = 70.0; // 统一左侧 Key 的宽度，确保右侧整齐对齐
    CGFloat rowSpacing = 12.0;
    
    for (int i = 0; i < keyLabels.count; i++) {
        UILabel *keyLab = keyLabels[i];
        [keyLab.leftAnchor constraintEqualToAnchor:bgView.leftAnchor constant:16].active = YES;
        [keyLab.widthAnchor constraintEqualToConstant:keyWidth].active = YES;
        
        if (i == 0) {
            [keyLab.topAnchor constraintEqualToAnchor:_titleLab.bottomAnchor constant:16].active = YES;
            [_purposeValueLab.centerYAnchor constraintEqualToAnchor:keyLab.centerYAnchor].active = YES;
            [_purposeValueLab.leftAnchor constraintEqualToAnchor:keyLab.rightAnchor constant:15].active = YES;
            [_purposeValueLab.rightAnchor constraintEqualToAnchor:bgView.rightAnchor constant:-16].active = YES;
        } else if (i == 1) {
            [keyLab.topAnchor constraintEqualToAnchor:((UILabel *)keyLabels[0]).bottomAnchor constant:rowSpacing].active = YES;
            [_scenarioValueLab.centerYAnchor constraintEqualToAnchor:keyLab.centerYAnchor].active = YES;
            [_scenarioValueLab.leftAnchor constraintEqualToAnchor:keyLab.rightAnchor constant:15].active = YES;
            [_scenarioValueLab.rightAnchor constraintEqualToAnchor:bgView.rightAnchor constant:-16].active = YES;
        } else if (i == 2) {
            [keyLab.topAnchor constraintEqualToAnchor:((UILabel *)keyLabels[1]).bottomAnchor constant:rowSpacing].active = YES;
            [_statusValueLab.centerYAnchor constraintEqualToAnchor:keyLab.centerYAnchor].active = YES;
            [_statusValueLab.leftAnchor constraintEqualToAnchor:keyLab.rightAnchor constant:15].active = YES;
            [_statusValueLab.rightAnchor constraintEqualToAnchor:bgView.rightAnchor constant:-16].active = YES;
        } else if (i == 3) {
            [keyLab.topAnchor constraintEqualToAnchor:((UILabel *)keyLabels[2]).bottomAnchor constant:rowSpacing].active = YES;
            [keyLab.bottomAnchor constraintEqualToAnchor:bgView.bottomAnchor constant:-20].active = YES; // 撑起整个卡片高度
            
            // 按钮（带下划线/蓝色）
            [_contentValueBtn.centerYAnchor constraintEqualToAnchor:keyLab.centerYAnchor].active = YES;
            [_contentValueBtn.leftAnchor constraintEqualToAnchor:keyLab.rightAnchor constant:15].active = YES;
            
            // 纯文本的短横线（-）
            [_contentValueDashLab.centerYAnchor constraintEqualToAnchor:keyLab.centerYAnchor].active = YES;
            [_contentValueDashLab.leftAnchor constraintEqualToAnchor:keyLab.rightAnchor constant:15].active = YES;
        }
    }
}

- (UILabel *)createValueLabel {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]; // 近黑色
    lab.numberOfLines = 0;
    lab.translatesAutoresizingMaskIntoConstraints = NO;
    return lab;
}

- (void)contentBtnClicked {
    if (self.linkBtnClickBlock) {
        self.linkBtnClickBlock();
    }
}

- (void)configData:(NSDictionary *)dict {
    _titleLab.text = dict[@"title"];
    _purposeValueLab.text = dict[@"purpose"];
    _scenarioValueLab.text = dict[@"scenario"];
    _statusValueLab.text = dict[@"status"];
    
    BOOL hasLink = [dict[@"hasLink"] boolValue];
    if (hasLink) {
        _contentValueBtn.hidden = NO;
        _contentValueDashLab.hidden = YES;
        
        // 设置带下划线的蓝色文字
        NSString *contentStr = dict[@"content"];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [attrStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, contentStr.length)];
        [_contentValueBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    } else {
        _contentValueBtn.hidden = YES;
        _contentValueDashLab.hidden = NO;
    }
}

@end


// =========================================================
// 控制器
// =========================================================
@interface PersonalInfoDetailsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation PersonalInfoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 使用通用导航栏模板
    [self leftBarItem];
    self.navTitle = @"个人信息收集清单";
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    
    [self initData];
    [self setupTableView];
}

- (void)initData {
    // 提取页面所需的数据模型
    self.dataArray = @[
        @{
            @"title": @"订单记录",
            @"purpose": @"用于订单交易履约",
            @"scenario": @"使用点餐服务、购买商品时",
            @"status": @"已收集",
            @"content": @"我的合同",
            @"hasLink": @YES,
            @"actionType": @"order"
        },
        @{
            @"title": @"送餐地址及联系人信息",
            @"purpose": @"用于订单交易履约",
            @"scenario": @"添加和管理送餐地址及联系人信息时",
            @"status": @"已收集",
            @"content": @"地图找房",
            @"hasLink": @YES,
            @"actionType": @"address"
        },
        @{
            @"title": @"配送地址及联系人信息",
            @"purpose": @"用于订单交易履约",
            @"scenario": @"添加和管理配送地址及联系人信息时",
            @"status": @"未收集",
            @"content": @"-",
            @"hasLink": @NO,
            @"actionType": @"none"
        }
    ];
}

- (void)setupTableView {
    // 根据你的导航栏高度调整 Y 轴起点，这里默认以导航栏下方开始
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT + 20, self.view.frame.size.width, self.view.frame.size.height - NAVBAR_HEIGHT - 20) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 去掉默认分割线
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // 自适应高度
    self.tableView.estimatedRowHeight = 160;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerClass:[PersonalInfoItemCell class] forCellReuseIdentifier:@"PersonalInfoItemCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalInfoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInfoItemCell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    [cell configData:dict];
    
    __weak typeof(self) weakSelf = self;
    cell.linkBtnClickBlock = ^{
        [weakSelf handleLinkClick:dict[@"actionType"]];
    };
    
    return cell;
}

#pragma mark - 处理点击事件

- (void)handleLinkClick:(NSString *)actionType {
    if ([actionType isEqualToString:@"order"]) {
        // 跳转到：我的合同
        MyContractListViewController *vc = [MyContractListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([actionType isEqualToString:@"address"]) {
        // 跳转到：地图找房
        MapSearchHouseViewController *vc = [MapSearchHouseViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end