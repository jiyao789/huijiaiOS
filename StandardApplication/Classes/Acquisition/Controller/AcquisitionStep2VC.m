//
//  AcquisitionStep2VC.m
//  StandardApplication
//
//  Property acquisition declaration - Step 2: Upload Documents
//

#import "AcquisitionStep2VC.h"
#import "MacroDefine.h"
#import "AcquisitionFormData.h"
#import "AcquisitionImageGroupView.h"
#import "AcquisitionStep3VC.h"
#import "TZImagePickerController.h"
#import "RegisterGuideVC.h"
#import "ProtocolBaseWKWebViewController.h"
#import <SDWebImage/SDWebImage.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define kAcqGreenColor        [UIColor colorWithHexString:@"#2A629A"]
#define kAcqTextPrimary       [UIColor colorWithHexString:@"#333333"]
#define kAcqTextSecondary     [UIColor colorWithHexString:@"#666666"]
#define kAcqTextHint          [UIColor colorWithHexString:@"#999999"]
#define kAcqDivider           [UIColor colorWithHexString:@"#EEEEEE"]

@interface AcquisitionStep2VC () <AcquisitionImageGroupViewDelegate, TZImagePickerControllerDelegate, UIDocumentPickerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) AcquisitionImageGroupView *certificateImageGroup;
@property (nonatomic, strong) AcquisitionImageGroupView *registerImageGroup;
@property (nonatomic, strong) AcquisitionImageGroupView *ownerIdcardImageGroup;
@property (nonatomic, strong) AcquisitionImageGroupView *requesterIdcardImageGroup;
@property (nonatomic, strong) AcquisitionImageGroupView *hukouImageGroup;

@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, weak) AcquisitionImageGroupView *currentImageGroup;

/// Store hint labels for each image group to update their top constraints
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UILabel *> *hintLabels;

@end

@implementation AcquisitionStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self leftBarItem];
    
    self.navTitle = @"房源收购意向申报";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupUI];
    [self loadFormData];
    [self applyViewModeIfNeeded];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    // Update heights for all image groups after layout is complete
    [self updateImageGroupHeight:_certificateImageGroup];
    [self updateImageGroupHeight:_registerImageGroup];
    [self updateImageGroupHeight:_ownerIdcardImageGroup];
    [self updateImageGroupHeight:_requesterIdcardImageGroup];
    [self updateImageGroupHeight:_hukouImageGroup];
}

- (void)updateImageGroupHeight:(AcquisitionImageGroupView *)imageGroup {
    if (!imageGroup) return;

    CGFloat newHeight = [imageGroup calculateContentHeight];
    if (newHeight > 0) {
        [imageGroup mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(newHeight);
        }];
    }
}

- (void)setupUI {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
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
    sectionTitle.text = @"二、上传相关 证明材料";
    sectionTitle.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    sectionTitle.textColor = kAcqGreenColor;
    [_contentView addSubview:sectionTitle];

    [sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.top.equalTo(_contentView).offset(20);
    }];

    UIView *lastView = sectionTitle;

    // Use local variables to avoid ARC __autoreleasing parameter issues
    AcquisitionImageGroupView *certificateGroup = nil;
    AcquisitionImageGroupView *registerGroup = nil;
    AcquisitionImageGroupView *ownerIdcardGroup = nil;
    AcquisitionImageGroupView *requesterIdcardGroup = nil;
    AcquisitionImageGroupView *hukouGroup = nil;

    // 1. Certificate
    lastView = [self createImageSection:@"1. 房屋所有权证/房地产权证/不动产权证书（原件扫描件或照片）"
                                   hint:@"请上传原件扫描件或照片（最多12张）"
                               maxCount:12
                                    tag:1
                               lastView:lastView
                             imageGroup:&certificateGroup];
    _certificateImageGroup = certificateGroup;

    // 2. Register
    lastView = [self createImageSection:@"2. 不动产登记簿（不动产登记机构出具的官方查询结果）"
                                   hint:@"请上传查询结果（最多12张）"
                               maxCount:12
                                    tag:2
                               lastView:lastView
                             imageGroup:&registerGroup
                               showInfo:YES];
    _registerImageGroup = registerGroup;

    // 3. Owner ID Card
    lastView = [self createImageSection:@"3. 产权人身份证（正反面高清照片）"
                                   hint:@"请上传身份证正反面照片（最多12张）"
                               maxCount:12
                                    tag:3
                               lastView:lastView
                             imageGroup:&ownerIdcardGroup];
    _ownerIdcardImageGroup = ownerIdcardGroup;

    // 4. Requester ID Card (Optional)
    lastView = [self createImageSection:@"4. 申报人身份证（正反面高清照片）（选填）"
                                   hint:@"请上传身份证正反面照片（最多2张）"
                               maxCount:2
                                    tag:4
                               lastView:lastView
                             imageGroup:&requesterIdcardGroup];
    _requesterIdcardImageGroup = requesterIdcardGroup;

    // 5. Hukou (Optional)
    lastView = [self createImageSection:@"5. 户口登记人员口本原件（正反面高清照片）（选填）"
                                   hint:@"请上传户口本照片（最多12张）"
                               maxCount:12
                                    tag:5
                               lastView:lastView
                             imageGroup:&hukouGroup];
    _hukouImageGroup = hukouGroup;

    // back button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor whiteColor];
    backButton.layer.cornerRadius = 4;
    backButton.layer.borderWidth = 1;
    backButton.layer.borderColor = kAcqGreenColor.CGColor;
    [backButton setTitle:@"上一步" forState:UIControlStateNormal];
    [backButton setTitleColor:kAcqGreenColor forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:backButton];

    // Next Button
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.backgroundColor = kAcqGreenColor;
    _nextButton.layer.cornerRadius = 4;
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [_nextButton addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_nextButton];

    //  布局：让两个按钮并排
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.top.equalTo(lastView.mas_bottom).offset(30); // 距离上一个视图的间距
        make.height.mas_equalTo(44);
        make.bottom.equalTo(_contentView).offset(-40);   // 撑起 _contentView 的底部
        make.right.equalTo(_nextButton.mas_left).offset(-12); // 与下一步按钮的间距
        make.width.equalTo(_nextButton); // 两个按钮等宽
    }];

    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentView).offset(-16);
        make.top.height.bottom.equalTo(backButton); // 对齐高度、顶部和底部间距
    }];

}

- (UIView *)createImageSection:(NSString *)title hint:(NSString *)hint maxCount:(NSInteger)maxCount tag:(NSInteger)tag lastView:(UIView *)lastView imageGroup:(AcquisitionImageGroupView **)outImageGroup {
    return [self createImageSection:title hint:hint maxCount:maxCount tag:tag lastView:lastView imageGroup:outImageGroup showInfo:NO];
}

- (UIView *)createImageSection:(NSString *)title hint:(NSString *)hint maxCount:(NSInteger)maxCount tag:(NSInteger)tag lastView:(UIView *)lastView imageGroup:(AcquisitionImageGroupView **)outImageGroup showInfo:(BOOL)showInfo {
    UIView *prevView = nil;

    if (showInfo) {
        // 使用 NSAttributedString 把图标嵌入文字末尾
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.userInteractionEnabled = YES;

        // 创建带图标的富文本
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:15],
            NSForegroundColorAttributeName: kAcqTextPrimary
        }];

        // 添加空格
        [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];

        // 创建图标附件 - 使用系统 info 图标
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        UIImage *infoImage = [UIImage systemImageNamed:@"info.circle"];
        // 图标大小比文字小一点
        CGFloat iconSize = 14;
        attachment.image = [infoImage imageWithTintColor:kAcqGreenColor];
        attachment.bounds = CGRectMake(0, -2, iconSize, iconSize);

        NSAttributedString *iconStr = [NSAttributedString attributedStringWithAttachment:attachment];
        [attrStr appendAttributedString:iconStr];

        titleLabel.attributedText = attrStr;
        [_contentView addSubview:titleLabel];

        // 添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTapped:)];
        [titleLabel addGestureRecognizer:tap];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView).offset(16);
            make.right.equalTo(_contentView).offset(-16);
            make.top.equalTo(lastView.mas_bottom).offset(20);
        }];

        prevView = titleLabel;
    } else {
        // Title label (无图标)
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = kAcqTextPrimary;
        titleLabel.numberOfLines = 0;
        [_contentView addSubview:titleLabel];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView).offset(16);
            make.right.equalTo(_contentView).offset(-16);
            make.top.equalTo(lastView.mas_bottom).offset(20);
        }];

        prevView = titleLabel;
    }

    // Calculate initial height for empty state (1 row with add button)
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width - 32; // 16 padding on each side
    CGFloat itemSpacing = 10;
    CGFloat itemsPerRow = 4;
    CGFloat itemWidth = (contentWidth - itemSpacing * (itemsPerRow - 1)) / itemsPerRow;
    CGFloat initialHeight = itemWidth; // One row height

    // Image group view
    AcquisitionImageGroupView *imageGroup = [[AcquisitionImageGroupView alloc] init];
    imageGroup.title = @"";
    imageGroup.required = (tag <= 3);
    imageGroup.maxCount = maxCount;
    imageGroup.tag = tag;
    imageGroup.delegate = self;
    [_contentView addSubview:imageGroup];

    [imageGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(prevView.mas_bottom).offset(12);
        make.height.mas_equalTo(initialHeight);
    }];

    *outImageGroup = imageGroup;

    // Hint label
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = hint;
    hintLabel.font = [UIFont systemFontOfSize:13];
    hintLabel.textColor = kAcqTextHint;
    [_contentView addSubview:hintLabel];

    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.top.equalTo(imageGroup.mas_bottom).offset(8);
    }];

    // Store hint label reference for later updates
    if (!_hintLabels) {
        _hintLabels = [NSMutableDictionary dictionary];
    }
    _hintLabels[@(tag)] = hintLabel;

    return hintLabel;
}

#pragma mark - AcquisitionImageGroupViewDelegate

- (void)imageGroupViewDidTapAdd:(UIView *)groupView {
    _currentImageGroup = (AcquisitionImageGroupView *)groupView;
    NSInteger maxCount = _currentImageGroup.maxCount - _currentImageGroup.images.count;

    if (maxCount <= 0) {
        [MBProgressHUD showMessag:@"已达到最大上传数量" toView:self.view];
        return;
    }

    // Show action sheet to select upload type
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择上传类型"
                                                                          message:nil
                                                                   preferredStyle:UIAlertControllerStyleActionSheet];

    WeakSelf
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@"上传图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showImagePicker];
    }];

    UIAlertAction *pdfAction = [UIAlertAction actionWithTitle:@"上传PDF文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showDocumentPicker];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [actionSheet addAction:imageAction];
    [actionSheet addAction:pdfAction];
    [actionSheet addAction:cancelAction];

    // iPad support
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        actionSheet.popoverPresentationController.sourceView = groupView;
        actionSheet.popoverPresentationController.sourceRect = groupView.bounds;
    }

    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)showImagePicker {
    NSInteger maxCount = _currentImageGroup.maxCount - _currentImageGroup.images.count;
    if (maxCount <= 0) {
        return;
    }

    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:self];
    picker.allowPickingVideo = NO;
    picker.allowTakeVideo = NO;
    picker.allowPickingOriginalPhoto = NO;
    // 设置为 NO，最新的照片显示在最前面，这样可以看到最近拍摄的照片和截图
    picker.sortAscendingByModificationDate = NO;
    // 允许在图片选择器中直接拍照
    picker.allowTakePicture = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)showDocumentPicker {
    UIDocumentPickerViewController *picker;

    if (@available(iOS 14.0, *)) {
        UTType *pdfType = [UTType typeWithIdentifier:@"com.adobe.pdf"];
        picker = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:@[pdfType]];
    } else {
        picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"com.adobe.pdf"] inMode:UIDocumentPickerModeImport];
    }

    picker.delegate = self;
    picker.allowsMultipleSelection = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imageGroupViewDidChangeHeight:(UIView *)groupView newHeight:(CGFloat)height {
    // Update the height constraint of the image group
    [groupView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];

    // Animate the layout change
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)imageGroupViewDidTapImage:(UIView *)groupView atIndex:(NSInteger)index {
    AcquisitionImageGroupView *imageGroup = (AcquisitionImageGroupView *)groupView;

    if (index >= imageGroup.imageUrls.count) {
        return;
    }

    NSString *url = imageGroup.imageUrls[index];
    if (url.length == 0) {
        return;
    }

    // Check if it's a PDF file
    BOOL isPDF = NO;
    if (index < imageGroup.fileTypes.count) {
        isPDF = [imageGroup.fileTypes[index] integerValue] == AcquisitionFileTypePDF;
    } else {
        // Fallback: check URL extension
        isPDF = [[url lowercaseString] hasSuffix:@".pdf"];
    }

    if (isPDF) {
        // Preview PDF using WebView
        [self previewPDFWithURL:url];
    } else {
        // Preview image
        [self previewImageWithURL:url allUrls:imageGroup.imageUrls fileTypes:imageGroup.fileTypes currentIndex:index];
    }
}

- (void)previewPDFWithURL:(NSString *)url {
    ProtocolBaseWKWebViewController *webVC = [[ProtocolBaseWKWebViewController alloc] init];
    webVC.webTitle = @"PDF预览";
    webVC.webUrl = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)previewImageWithURL:(NSString *)url allUrls:(NSArray<NSString *> *)allUrls fileTypes:(NSArray<NSNumber *> *)fileTypes currentIndex:(NSInteger)currentIndex {
    // Create a simple full-screen image preview
    UIView *containerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    containerView.backgroundColor = [UIColor blackColor];
    containerView.tag = 9999;

    // Scroll view for zooming
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:containerView.bounds];
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 3.0;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.tag = 1001;
    [containerView addSubview:scrollView];

    // Image view
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tag = 1002;
    [scrollView addSubview:imageView];

    // Load image
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];

    // Close button
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(containerView.bounds.size.width - 60, 50, 44, 44);
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    closeBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    closeBtn.layer.cornerRadius = 22;
    [closeBtn addTarget:self action:@selector(closeImagePreview) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeBtn];

    // Tap to dismiss
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeImagePreview)];
    tap.numberOfTapsRequired = 1;
    [containerView addGestureRecognizer:tap];

    // Double tap to zoom
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleTap];

    [tap requireGestureRecognizerToFail:doubleTap];

    // Add to window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:containerView];

    // Animate in
    containerView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        containerView.alpha = 1;
    }];
}

- (void)closeImagePreview {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *containerView = [window viewWithTag:9999];
    if (containerView) {
        [UIView animateWithDuration:0.25 animations:^{
            containerView.alpha = 0;
        } completion:^(BOOL finished) {
            [containerView removeFromSuperview];
        }];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture {
    UIScrollView *scrollView = (UIScrollView *)gesture.view;
    if (scrollView.zoomScale > 1.0) {
        [scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint point = [gesture locationInView:scrollView];
        CGRect zoomRect = CGRectMake(point.x - 50, point.y - 50, 100, 100);
        [scrollView zoomToRect:zoomRect animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate (for image zoom)

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView.tag == 1001) {
        return [scrollView viewWithTag:1002];
    }
    return nil;
}

- (void)imageGroupViewDidTapDelete:(UIView *)groupView atIndex:(NSInteger)index {
    AcquisitionImageGroupView *imageGroup = (AcquisitionImageGroupView *)groupView;
    if (index < imageGroup.images.count) {
        [imageGroup.images removeObjectAtIndex:index];
    }
    if (index < imageGroup.imageIds.count) {
        [imageGroup.imageIds removeObjectAtIndex:index];
    }
    if (index < imageGroup.imageUrls.count) {
        [imageGroup.imageUrls removeObjectAtIndex:index];
    }
    if (index < imageGroup.fileTypes.count) {
        [imageGroup.fileTypes removeObjectAtIndex:index];
    }
    [imageGroup reloadImages];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (!_currentImageGroup || photos.count == 0) {
        return;
    }

    [MBProgressHUD showStatus:@"上传中..." toView:self.view];

    // Use dispatch_group to track all uploads
    dispatch_group_t uploadGroup = dispatch_group_create();
    NSMutableArray *uploadedIds = [NSMutableArray array];
    NSMutableArray *uploadedUrls = [NSMutableArray array];
    NSMutableArray *uploadedImages = [NSMutableArray array];
    __block NSInteger failedCount = 0;

    WeakSelf
    for (NSInteger i = 0; i < photos.count; i++) {
        UIImage *image = photos[i];
        dispatch_group_enter(uploadGroup);

        [HttpRequest uploadFileName:@{@"key":@"header"} data:image progress:^(double progress) {
            // Progress callback (optional)
        } complete:^(NSDictionary *dic) {
            if (dic && dic[@"img_id"]) {
                @synchronized (uploadedIds) {
                    NSString *fileId = [NSString stringWithFormat:@"%@", dic[@"img_id"]];
                    NSString *url = dic[@"url"] ?: @"";
                    [uploadedIds addObject:fileId];
                    [uploadedUrls addObject:url];
                    [uploadedImages addObject:image];
                }
            } else {
                @synchronized (uploadedIds) {
                    failedCount++;
                }
            }
            dispatch_group_leave(uploadGroup);
        }];
    }

    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        [MBProgressHUD dismissHUDForView:weakSelf.view];

        if (uploadedIds.count > 0) {
            [weakSelf.currentImageGroup.images addObjectsFromArray:uploadedImages];
            [weakSelf.currentImageGroup.imageIds addObjectsFromArray:uploadedIds];
            [weakSelf.currentImageGroup.imageUrls addObjectsFromArray:uploadedUrls];
            // Add file types for images
            for (NSInteger i = 0; i < uploadedIds.count; i++) {
                [weakSelf.currentImageGroup.fileTypes addObject:@(AcquisitionFileTypeImage)];
            }
            [weakSelf.currentImageGroup reloadImages];

            if (failedCount > 0) {
                [MBProgressHUD showMessag:[NSString stringWithFormat:@"%ld张上传失败", (long)failedCount] toView:weakSelf.view];
            }
        } else {
            [MBProgressHUD showMessag:@"上传失败" toView:weakSelf.view];
        }
    });
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    if (!_currentImageGroup || urls.count == 0) {
        return;
    }

    // Check max count
    NSInteger remainingCount = _currentImageGroup.maxCount - _currentImageGroup.images.count;
    if (urls.count > remainingCount) {
        [MBProgressHUD showMessag:[NSString stringWithFormat:@"最多还能上传%ld个文件", (long)remainingCount] toView:self.view];
        return;
    }

    [MBProgressHUD showStatus:@"上传PDF中..." toView:self.view];

    dispatch_group_t uploadGroup = dispatch_group_create();
    NSMutableArray *uploadedIds = [NSMutableArray array];
    NSMutableArray *uploadedUrls = [NSMutableArray array];
    __block NSInteger failedCount = 0;

    WeakSelf
    for (NSURL *url in urls) {
        dispatch_group_enter(uploadGroup);

        // Start accessing security-scoped resource
        BOOL accessing = [url startAccessingSecurityScopedResource];

        NSData *pdfData = [NSData dataWithContentsOfURL:url];
        if (accessing) {
            [url stopAccessingSecurityScopedResource];
        }

        if (!pdfData) {
            @synchronized (uploadedIds) {
                failedCount++;
            }
            dispatch_group_leave(uploadGroup);
            continue;
        }

        // Get file name
        NSString *fileName = url.lastPathComponent;
        if (fileName.length == 0) {
            fileName = @"document.pdf";
        }

        // Upload PDF data using /upload/file endpoint
        [HttpRequest uploadPDFData:pdfData fileName:fileName mimeType:@"application/pdf" progress:^(double progress) {
            // Progress callback (optional)
        } complete:^(NSDictionary *dic) {
            // Note: /upload/file returns file_id, while /upload/index returns img_id
            if (dic && dic[@"file_id"]) {
                @synchronized (uploadedIds) {
                    NSString *fileId = [NSString stringWithFormat:@"%@", dic[@"file_id"]];
                    NSString *fileUrl = dic[@"url"] ?: @"";
                    [uploadedIds addObject:fileId];
                    [uploadedUrls addObject:fileUrl];
                }
            } else {
                @synchronized (uploadedIds) {
                    failedCount++;
                }
            }
            dispatch_group_leave(uploadGroup);
        }];
    }

    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        [MBProgressHUD dismissHUDForView:weakSelf.view];

        if (uploadedIds.count > 0) {
            for (NSInteger i = 0; i < uploadedIds.count; i++) {
                [weakSelf.currentImageGroup.images addObject:[UIImage new]]; // Placeholder
                [weakSelf.currentImageGroup.imageIds addObject:uploadedIds[i]];
                [weakSelf.currentImageGroup.imageUrls addObject:uploadedUrls[i]];
                [weakSelf.currentImageGroup.fileTypes addObject:@(AcquisitionFileTypePDF)];
            }
            [weakSelf.currentImageGroup reloadImages];

            if (failedCount > 0) {
                [MBProgressHUD showMessag:[NSString stringWithFormat:@"%ld个PDF上传失败", (long)failedCount] toView:weakSelf.view];
            }
        } else {
            [MBProgressHUD showMessag:@"上传失败" toView:weakSelf.view];
        }
    });
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    // User cancelled, do nothing
}

#pragma mark - Form Data

- (void)loadFormData {
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];

    // Form data stores file IDs (comma-separated), need to resolve to URLs for display
    // Use dispatch_group to wait for all resolutions to complete
    dispatch_group_t loadGroup = dispatch_group_create();

    if (formData.certificateFile.length > 0) {
        dispatch_group_enter(loadGroup);
        [_certificateImageGroup setImageIdsFromString:formData.certificateFile completion:^{
            dispatch_group_leave(loadGroup);
        }];
    }
    if (formData.registerFile.length > 0) {
        dispatch_group_enter(loadGroup);
        [_registerImageGroup setImageIdsFromString:formData.registerFile completion:^{
            dispatch_group_leave(loadGroup);
        }];
    }
    if (formData.ownerIdcardFile.length > 0) {
        dispatch_group_enter(loadGroup);
        [_ownerIdcardImageGroup setImageIdsFromString:formData.ownerIdcardFile completion:^{
            dispatch_group_leave(loadGroup);
        }];
    }
    if (formData.requesterIdcardFile.length > 0) {
        dispatch_group_enter(loadGroup);
        [_requesterIdcardImageGroup setImageIdsFromString:formData.requesterIdcardFile completion:^{
            dispatch_group_leave(loadGroup);
        }];
    }
    if (formData.hukouFile.length > 0) {
        dispatch_group_enter(loadGroup);
        [_hukouImageGroup setImageIdsFromString:formData.hukouFile completion:^{
            dispatch_group_leave(loadGroup);
        }];
    }

    // Update layout after all images are loaded
    WeakSelf
    dispatch_group_notify(loadGroup, dispatch_get_main_queue(), ^{
        [weakSelf.view setNeedsLayout];
        [weakSelf.view layoutIfNeeded];
    });
}

- (void)saveFormData {
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];

    // Save file IDs (comma-separated) instead of URLs
    formData.certificateFile = [_certificateImageGroup getImageIdsString];
    formData.registerFile = [_registerImageGroup getImageIdsString];
    formData.ownerIdcardFile = [_ownerIdcardImageGroup getImageIdsString];
    formData.requesterIdcardFile = [_requesterIdcardImageGroup getImageIdsString];
    formData.hukouFile = [_hukouImageGroup getImageIdsString];
}

#pragma mark - Validation

- (BOOL)validateForm {
    if (_certificateImageGroup.imageUrls.count == 0) {
        [MBProgressHUD showMessag:@"请上传权证文件" toView:self.view];
        return NO;
    }
    if (_registerImageGroup.imageUrls.count == 0) {
        [MBProgressHUD showMessag:@"请上传登记簿" toView:self.view];
        return NO;
    }
    if (_ownerIdcardImageGroup.imageUrls.count == 0) {
        [MBProgressHUD showMessag:@"请上传产权人身份证" toView:self.view];
        return NO;
    }
    return YES;
}

#pragma mark - Actions

- (void)infoButtonTapped {
    RegisterGuideVC *vc = [[RegisterGuideVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)titleLabelTapped:(UITapGestureRecognizer *)gesture {
    // 点击标题区域即跳转到指引页面
    [self infoButtonTapped];
}

// 自定义返回逻辑
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


- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonTapped {
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];

    // In view mode, skip validation and just navigate
    if (!formData.isViewMode) {
        if (![self validateForm]) {
            return;
        }
        [self saveFormData];
    }

    AcquisitionStep3VC *vc = [[AcquisitionStep3VC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - View Mode

- (void)applyViewModeIfNeeded {
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];
    if (!formData.isViewMode) {
        return;
    }

    // Set view mode for all image groups
    _certificateImageGroup.isViewMode = YES;
    _registerImageGroup.isViewMode = YES;
    _ownerIdcardImageGroup.isViewMode = YES;
    _requesterIdcardImageGroup.isViewMode = YES;
    _hukouImageGroup.isViewMode = YES;

    // Reload to apply view mode
    [_certificateImageGroup reloadImages];
    [_registerImageGroup reloadImages];
    [_ownerIdcardImageGroup reloadImages];
    [_requesterIdcardImageGroup reloadImages];
    [_hukouImageGroup reloadImages];

    // Button title stays "下一步"
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
}

@end
