#import "MyComplaintListViewController.h"
#import "MyComplaintCell.h"
#import "ComplaintDetailViewController.h"

// --- 关键：导入你项目原有的宏定义文件 ---
#import "MacroDefine.h" 

// 注意：如果 MacroDefine.h 里没有包含 UIColor+HEX.h，
// 且编译依然报 colorWithHexString 错误，请取消下面这行的注释
// #import "UIColor+HEX.h" 

@interface MyComplaintListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation MyComplaintListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self leftBarItem];
    self.navTitle = @"我的投诉";
    
    // 1. 设置背景色：使用你项目中已有的 colorWithHexString 方法
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    // 2. 适配导航栏高度：使用 MacroDefine.h 里的宏
    self.viewLayoutTop.constant = NAVBAR_HEIGHT;
    
    // 3. 注册 Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MyComplaintCell" bundle:nil] forCellReuseIdentifier:@"MyComplaintCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor]; // 确保 tableview 透明以显示底色
    
    [self loadMockData];
}

- (void)loadMockData {
    // 模拟数据
    self.dataList = [@[@{@"id":@"1001", @"type":@"物业服务", @"time":@"2023-10-25 14:20"},
                       @{@"id":@"1002", @"type":@"设施报修", @"time":@"2023-10-26 09:30"}] mutableCopy];
    [self.tableView reloadData];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyComplaintCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyComplaintCell" forIndexPath:indexPath];
    NSDictionary *item = self.dataList[indexPath.row];
    
    // 这里的 typeLabel 和 timeLabel 对应你 Cell.h 里的声明
    cell.typeLabel.text = [NSString stringWithFormat:@"投诉类型：%@", item[@"type"]];
    cell.timeLabel.text = [NSString stringWithFormat:@"投诉时间：%@", item[@"time"]];
    
    return cell;
}
#pragma mark - UITableViewDelegate (3. 跳转逻辑写在这里)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1. 修正数组变量名为 dataList
    NSDictionary *item = self.dataList[indexPath.row]; 
    
    // 2. 修正类名（去掉多余的 My）
    ComplaintDetailViewController *detailVC = [[ComplaintDetailViewController alloc] init];
    
    // 3. 传入 ID
    detailVC.complaintId = [NSString stringWithFormat:@"%@", item[@"id"]];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110; // 稍微给高一点，确保卡片间距美观
}

@end