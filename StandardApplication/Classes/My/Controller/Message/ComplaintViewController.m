//
//  ComplaintViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ComplaintViewController.h"
#import "MacroDefine.h"
#import "ComplaintTypeCollectionViewCell.h"
#import "CommitReserveViewController.h"
#import "MyComplaintListViewController.h"
#import "ComplaintSuccessViewController.h"

@interface ComplaintViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet UICollectionView *complaintCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *textCountLab;
@property (weak, nonatomic) IBOutlet UITextView *complaintTextView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (assign, nonatomic) NSInteger selectIndex;
@property (strong, nonatomic) NSArray *feedbackArr;
@end

@implementation ComplaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"投诉";
    if (@available(iOS 13.0, *)) {
        UIImage *historyImg = [UIImage systemImageNamed:@"clock.arrow.circlepath"];
        
        // 使用自定义视图方法添加到 GK 导航栏
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setImage:historyImg forState:UIControlStateNormal];
        [rightBtn setFrame:CGRectMake(0, 0, 44, 44)];
        // 记得设置颜色，否则可能是透明或白色
        rightBtn.tintColor = [UIColor blackColor]; 
        [rightBtn addTarget:self action:@selector(historyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 调用 Base 里的这个方法
        [self setupCustomNavBarButton:rightBtn leftOrRight:NO];
    } else {
        // 如果需要兼容极老版本(iOS 12及以下)，系统没有原生图标库，建议用文字代替
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的投诉" 
                                                                                  style:UIBarButtonItemStylePlain 
                                                                                 target:self 
                                                                                 action:@selector(historyBtnClick)];
    }

    _selectIndex = -1;
    _viewLayoutTop.constant = NAVBAR_HEIGHT + 20;
    
    _complaintCollectionView.delegate = self;
    _complaintCollectionView.dataSource = self;
    _complaintTextView.delegate = self;
    _layout.minimumLineSpacing = 10;
    _layout.minimumInteritemSpacing = 10;
    _layout.itemSize = CGSizeMake((SCREEN_WIDTH - 32 - 30) / 4, 28);
    [_complaintCollectionView registerNib:[UINib nibWithNibName:@"ComplaintTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ComplaintTypeCollectionViewCell"];
    
    [self getFeedbackTypesDate];
}

- (void)getFeedbackTypesDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:BaseURL urlPath:feedback_get_typesURL parameters:@{} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.feedbackArr = arr;
            [self.complaintCollectionView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _feedbackArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ComplaintTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ComplaintTypeCollectionViewCell" forIndexPath:indexPath];
    cell.titleLab.backgroundColor = _selectIndex == indexPath.row ? [UIColor colorWithHexString:@"#2A629A"] : [UIColor clearColor];
    cell.titleLab.textColor = _selectIndex == indexPath.row ? [UIColor whiteColor] : [UIColor colorWithHexString:@"#717071"];
    NSDictionary *dic = _feedbackArr[indexPath.row];
    cell.titleLab.text = NONullString(dic[@"name"]);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    [self.complaintCollectionView reloadData];
}

- (void)textViewDidChange:(UITextView *)textView
{
    //字数限制
    if (textView.text.length >= 200) {
        textView.text = [textView.text substringToIndex:200];
    }
    
    if (textView.text.length > 0)  {
        _tipLab.hidden = YES;
        _textCountLab.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
    } else {
        _tipLab.hidden = NO;
        _textCountLab.text = @"0/200";
    }
}
- (void)historyBtnClick {
    MyComplaintListViewController *vc = [[MyComplaintListViewController alloc] init];
    // 如果你有 GKNavigation，通常直接 push 即可
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)commitBtnClick:(id)sender
{
    if (_selectIndex == -1) {
        [MBProgressHUD showMessag:@"请选择投诉类型" toView:self.view];
        return;
    }
    NSDictionary *dic = _feedbackArr[_selectIndex];
    NSInteger type = [dic[@"key"] integerValue];
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:feedback_addURL parameters:@{@"type":@(type),@"content":NONullString(_complaintTextView.text)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        [MBProgressHUD showMessag:msg toView:self.view];
        if (status == 1 || status == 2) {
            // --- 替换这里 ---
            ComplaintSuccessViewController *vc = [[ComplaintSuccessViewController alloc] init];
            // 如果后端返回了ID，可以传过去：vc.complaintId = NONullString(dic[@"id"]); 
            [self.navigationController pushViewController:vc animated:YES];
            // ---------------
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }

    }];
}

@end
