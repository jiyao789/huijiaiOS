//
//  PersonInfoViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "MacroDefine.h"
#import "ModifyNickNameViewController.h"
#import "JXTAlertManagerHeader.h"
#import "UploadFileManager.h"
#import <Photos/Photos.h>
#import "MBProgressHUD+YBDownload.h"
#import "ModifyPasswordViewController.h"

@interface PersonInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic , strong) UIImagePickerController *imagePicerController;
@property (weak, nonatomic) IBOutlet UIView *nickNameView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLayoutTop;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *mobileLab;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) UserModel *userModel;
@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"个人信息";
    
    _imageLayoutTop.constant = NAVBAR_HEIGHT + 80;
    [self setupOtherBarButtomItemWithTitle:@"保存" target:self action:@selector(saveBtnEvent) leftOrRight:NO];
    
    KWeakSelf
    [_nickNameView whenTapped:^{
        KStrongSelf(weakSelf)
        ModifyNickNameViewController *vc = [ModifyNickNameViewController new];
        vc.saveNickNameBlock = ^(NSString * _Nonnull nickNameStr) {
            strongSelf.userModel.nickname = nickNameStr;
            strongSelf.nickNameLab.text = nickNameStr;
        };
        [strongSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [_avaterImageView whenTapped:^{
        [weakSelf selectPhoto];
    }];
    
    [_passwordView whenTapped:^{
        ModifyPasswordViewController *vc = [ModifyPasswordViewController new];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self getUserDateInfo];
}

- (void)getUserDateInfo
{
    [HttpRequest requestUrlPath:BaseURL urlPath:setting_profileURL parameters:@{} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            self.userModel = [UserModel mj_objectWithKeyValues:dic];
            
            self.nickNameLab.text = NONullString(self.userModel.nickname);
            self.mobileLab.text = NONullString(self.userModel.phone);
            [self.avaterImageView setImageUrl:NONullString(self.userModel.avatar) placeholderImage:defaultIconName];
            
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)saveBtnEvent
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:setting_profileURL parameters:@{@"avatar":NONullString(self.userModel.avatar),@"nickname":NONullString(self.userModel.nickname)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            [MBProgressHUD showMessag:@"保存成功" toView:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showMessag:NONullString(msg) toView:nil];
        }
    }];
}

- (IBAction)exitBtnClick:(id)sender
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:login_logoutURL parameters:@{} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            [MBProgressHUD showMessag:@"退出登录" toView:nil];
            [[User shareUser] removeToken];
            [[User shareUser] removeMobile];
            [[User shareUser] removeUserId];
            [[User shareUser] removeApp_key];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageMarkNotification" object:nil userInfo:@{@"mark":@(0)}];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showMessag:NONullString(msg) toView:nil];
        }
    }];
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

- (void)selectPhoto
{
    [self jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionDefaultTitle(@"拍一张").
        addActionDefaultTitle(@"相册选择").
        addActionCancelTitle(@"取消");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        
        if ([action.title isEqualToString:@"拍一张"]) {
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
        else if ([action.title isEqualToString:@"相册选择"]) {
            self.imagePicerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicerController animated:YES completion:nil];
        }
        else if ([action.title isEqualToString:@"取消"]) {
            NSLog(@"按钮2");
        }
    }];
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
        weakSelf.avaterImageView.image = fileArr[0];
        weakSelf.userModel.avatar = NONullString(dic[@"url"]);
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
