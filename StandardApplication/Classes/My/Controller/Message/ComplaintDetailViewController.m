#import "ComplaintDetailViewController.h"

#define NAVBAR_HEIGHT 44 // 定义导航栏高度

@interface ComplaintDetailViewController ()

// 垂直排列的 UI 控件
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

// 整个滚动的视图
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

// 修复：添加缺失的 IBOutlet 属性
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet UICollectionView *complaintCollectionView;

@end

@implementation ComplaintDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitle = @"投诉详情";
    [self leftBarItem];
    
    // 关键：防止系统自动调整偏移，布局完全由 XIB 约束决定
    if (@available(iOS 11.0, *)) {
        self.mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _viewLayoutTop.constant = NAVBAR_HEIGHT + 20;
    
    _complaintCollectionView.delegate = self;
    _complaintCollectionView.dataSource = self;
    [self getDetailData];
}

- (void)getDetailData {
    // 模拟数据
    NSDictionary *mockDic = @{
        @"typeName": @"其他问题",
        @"userName": @"张先生",
        @"userPhone": @"13800138000",
        @"content": @"这是一个模拟内容。在垂直布局中，无论这里的内容多长，下方的视图都会自动向下推移。",
        @"createTime": @"2023-10-27 10:00"
    };

    self.typeLabel.text = mockDic[@"typeName"];
    self.nameLabel.text = mockDic[@"userName"];
    self.phoneLabel.text = mockDic[@"userPhone"];
    self.contentLabel.text = mockDic[@"content"];
    self.timeLabel.text = mockDic[@"createTime"];
}

@end