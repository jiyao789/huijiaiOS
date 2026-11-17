//
//  WorkOrderDetailViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "WorkOrderDetailViewController.h"
#import "MacroDefine.h"
#import "WorkOrderDetailTextTableViewCell.h"
#import "WorkOrderEvaluateTableViewCell.h"
#import "WorkOrderDetailMyTextTableViewCell.h"
#import "WorkOrderDetailModel.h"
#import <IQKeyboardManager.h>
#import "UploadFileManager.h"
#import <Photos/Photos.h>
#import "MBProgressHUD+YBDownload.h"

#define BottomView_HEIGHT       (IS_IPhoneX ? 83.0f : 62.0f)

@interface WorkOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic , strong) UIImagePickerController *imagePicerController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *orderDetailTableView;
@property (weak, nonatomic) IBOutlet UITextField *orderTextField;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomListView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addBtnLayoutWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addBtnLayoutLeft;

@property (strong, nonatomic) NSMutableArray *workOrderArr;
@property (strong, nonatomic) NSMutableArray *imageArr;
@end

@implementation WorkOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = _orderTitleStr;
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    
    self.orderTextField.delegate = self;
    [self setTextFieldInfo];
    
    if (_work_status == 3 || _work_status == 4 || _work_status == 5) {
        self.bottomViewLayoutHeight.constant = 0;
    } else {
        self.bottomViewLayoutHeight.constant = BottomView_HEIGHT;
    }
    
    if (_isCommitWork) {
        _addBtn.hidden = YES;
        _addBtnLayoutLeft.constant = 0;
        _addBtnLayoutWidth.constant = 0;
    } else {
        _addBtn.hidden = NO;
        _addBtnLayoutLeft.constant = 10;
        _addBtnLayoutWidth.constant = 33;
        [self getWorkOrderEvaluationListDate];
    }

    //监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)getWorkOrderEvaluationListDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:BaseURL urlPath:workOrder_workOrderEvaluationListURL parameters:@{@"work_id":@(_work_number)} type:HttpRequestTypePost result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            self.workOrderArr = [WorkOrderDetailModel mj_objectArrayWithKeyValuesArray:arr];
            [self.orderDetailTableView reloadData];
            [self scrollTableViewToBottom];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_work_status == 3 || _work_status == 4 || _work_status == 5) {
        return self.workOrderArr.count + 1;
    }
    return self.workOrderArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _workOrderArr.count && (_work_status == 3 || _work_status == 4)) {
        static NSString *cellID = @"WorkOrderEvaluateTableViewCell";
        WorkOrderEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (WorkOrderEvaluateTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.work_id = _work_id;
        cell.work_status = _work_status;
        return cell;
    }else if (indexPath.row == _workOrderArr.count && _work_status == 5) {
        static NSString *cellID = @"WorkOrderEvaluateTableViewCell";
        WorkOrderEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (WorkOrderEvaluateTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.work_id = _work_id;
        cell.work_status = _work_status;
        return cell;
    }
    WorkOrderDetailModel *model = _workOrderArr[indexPath.row];
    if (model.commit_client == 1) {
        static NSString *cellID = @"WorkOrderDetailMyTextTableViewCell";
        WorkOrderDetailMyTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (WorkOrderDetailMyTextTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = model;
        return cell;
    } else if (model.commit_client == 2) {
        static NSString *cellID = @"WorkOrderDetailTextTableViewCell";
        WorkOrderDetailTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (WorkOrderDetailTextTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = model;
        return cell;
    }
    return [UITableViewCell new];
}


- (IBAction)addMessageBtnClick:(UIButton *)sender
{
    [self.orderTextField resignFirstResponder];
    KWeakSelf
    _addBtn.tag = _addBtn.tag == 0 ? 1 : 0;
    _bottomListView.hidden = !_bottomListView.hidden;
    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.bottomViewLayoutHeight.constant = weakSelf.addBtn.tag == 1 ? 162 : BottomView_HEIGHT;
    }];
}
- (IBAction)photoCameraBtnClick:(UIButton *)sender
{
    if (sender.tag == 1) {
       // 判断是否能拍照
       if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
       {
           self.imagePicerController.sourceType = UIImagePickerControllerSourceTypeCamera;
           self.imagePicerController.showsCameraControls = YES;//takePicture
           [self presentViewController:self.imagePicerController animated:YES completion:nil];
       }
       else
       {
           NSLog(@"设备不支持");
       }
    }
    else if (sender.tag == 0) {
        self.imagePicerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicerController animated:YES completion:nil];
    }
}

- (void)changeBottomListView
{
    KWeakSelf
    _addBtn.tag = 0;
    _bottomListView.hidden = YES;
    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.bottomViewLayoutHeight.constant = BottomView_HEIGHT;
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self changeBottomListView];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_isCommitWork) {
        [self getWorkOrderAddTicketDate];
    } else {
        [self getWorkOrderReplyToATicketDate:[NSMutableArray new]];
    }
    return YES;
}

// 提交工单
- (void)getWorkOrderAddTicketDate
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:NONullString(_orderTextField.text) forKey:@"message"];
    [para setObject:NONullString([User shareUser].getUserId) forKey:@"u_id"];
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:workOrder_addTicketURL parameters:para type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            self.orderTextField.text = @"";
            [self.orderTextField resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showMessag:@"创建成功" toView:nil];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

// 回复
- (void)getWorkOrderReplyToATicketDate:(NSMutableArray *)imageArr
{
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(_work_id) forKey:@"id"];
    if (_workOrderArr.count > 0) {
        WorkOrderDetailModel *model = _workOrderArr[_workOrderArr.count - 1];
        [para setObject:@(model.id) forKey:@"work_id"];
    }
    [para setObject:NONullString(_orderTextField.text) forKey:@"msg"];
    [para setObject:@"1" forKey:@"commit_client"];
    [para setObject:NONullString([User shareUser].getUserId) forKey:@"user_id"];
    if (imageArr.count > 0) {
        [para setObject:[imageArr mj_JSONString] forKey:@"images"];
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:workOrder_replyToATicketURL parameters:para type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            self.orderTextField.text = @"";
            [self.orderTextField resignFirstResponder];
            [self getWorkOrderEvaluationListDate];
            [MBProgressHUD showMessag:@"发送成功" toView:nil];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)setTextFieldInfo
{
    UIView *firstPasswordBlankView = [[UIView alloc] initWithFrame:CGRectMake(_orderTextField.frame.origin.x,_orderTextField.frame.origin.y,10.0, _orderTextField.frame.size.height)];
    _orderTextField.leftView = firstPasswordBlankView;
    _orderTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (NSMutableArray *)workOrderArr
{
    if (!_workOrderArr) {
        _workOrderArr = [NSMutableArray array];
    }
    return _workOrderArr;
}

/**
 *  当键盘改变了frame(位置和尺寸)的时候调用
 */
-(void)keyboardWillChangeFrameNotify:(NSNotification*)notify {

    // 0.取出键盘动画的时间
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.orderDetailTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + transformY - BottomView_HEIGHT);
        self.tableViewBottomConstraint.constant = -transformY;// tableView的bottom距父视图bottom的距离
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, transformY);
        [self scrollTableViewToBottom];

    }];
}

/**
 *  tableView快速滚动到底部
 */
- (void)scrollTableViewToBottom {
    if (self.workOrderArr.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.workOrderArr.count - 1) inSection:0];
       [self.orderDetailTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (UIImagePickerController *)imagePicerController
{
    if (!_imagePicerController)
    {
        _imagePicerController = [[UIImagePickerController alloc]init];
        _imagePicerController.navigationBar.tintColor = [UIColor colorWithHexString:@"#2B2B2B"];
        _imagePicerController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#0E2F55"];
        [_imagePicerController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2B2B2B"]}];
        _imagePicerController.delegate = self;
    }
    return _imagePicerController;
}

#pragma mark - UIImagePickerControllerDelegate & UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if ([info.allKeys containsObject:@"UIImagePickerControllerOriginalImage"]) {
        UIImage *optionImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self uploadImageInfo:@[optionImage]];
    } else if ([info.allKeys containsObject:@"UIImagePickerControllerImageURL"]) {
        NSURL *imageUrl = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        PHFetchResult*result = [PHAsset fetchAssetsWithALAssetURLs:@[imageUrl] options:nil];
        PHAsset *asset = [result firstObject];
        if (IsNilOrNull(asset)) {
            [MBProgressHUD showMessag:@"请换一张图片尝试" toView:nil];
            return;
        }
        PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
        phImageRequestOptions.networkAccessAllowed = YES;
        __block UIImage *returnImage = nil;
        KWeakSelf
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:phImageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            returnImage = [UIImage imageWithData:imageData];
            [weakSelf uploadImageInfo:@[returnImage]];
        }];
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImageInfo:(NSArray *)fileArr
{
    __block MBProgressHUD *hud = [MBProgressHUD showDownloadHudAddTo:self.view animated:YES];
    hud.detailsLabel.text = @"\n正在上传图片...";
    
    KWeakSelf
    [HttpRequest uploadFileName:@{@"key":@"header"} data:fileArr[0] progress:^(double progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
            if (progress == 1) {
                hud.detailsLabel.text = @"正在处理...";
            }
        });
    } complete:^(NSDictionary * _Nonnull dic) {
        [hud hideAnimated:YES];
        if (weakSelf.imageArr.count > 0) {
            [weakSelf.imageArr removeAllObjects];
        }
        [weakSelf.imageArr addObject:NONullString(dic[@"img_id"])];
        if (!_isCommitWork) {
            [weakSelf getWorkOrderReplyToATicketDate:weakSelf.imageArr];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
