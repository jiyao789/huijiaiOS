//
//  AcquisitionStep5VC.m
//  StandardApplication
//
//  Property acquisition declaration - Detail Page (Matching prototype design)
//

#import "AcquisitionStep5VC.h"
#import "MacroDefine.h"
#import <objc/runtime.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "KNPhotoBrowser.h"
#import "YDInterfaceDefinition.h"
#import "AcquisitionDetailModel.h"
#import "AcquisitionProgressModel.h"
#import "AcquisitionFormData.h"
#import "AcquisitionStep1VC.h"

#define kAcqGreenColor        [UIColor colorWithHexString:@"#2A629A"]
#define kAcqTextPrimary       [UIColor colorWithHexString:@"#333333"]
#define kAcqTextSecondary     [UIColor colorWithHexString:@"#666666"]
#define kAcqTextHint          [UIColor colorWithHexString:@"#999999"]
#define kAcqBgMain            [UIColor colorWithHexString:@"#F5F5F5"]
#define kAcqDivider           [UIColor colorWithHexString:@"#EEEEEE"]
#define kAcqRedColor          [UIColor colorWithHexString:@"#FF3B30"]

@interface AcquisitionStep5VC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) AcquisitionDetailModel *detailModel;
@property (nonatomic, strong) NSArray<AcquisitionProgressItem *> *progressItems;
@property (nonatomic, assign) BOOL hasWithdrawnStatus;

// Basic info section
@property (nonatomic, strong) UIView *basicInfoCard;

// Progress section
@property (nonatomic, strong) UIView *progressCard;

@end

@implementation AcquisitionStep5VC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self leftBarItem];
    self.navTitle = @"房源收购意向申报";
    self.view.backgroundColor = kAcqBgMain;

    [self setupUI];
    [self loadDetailData];
}

- (void)setupUI {
    // Scroll view
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = kAcqBgMain;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = kAcqBgMain;
    [_scrollView addSubview:_contentView];

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAVBAR_HEIGHT + 10);
    }];

    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];

    // Section 1: 基本信息
    UILabel *basicInfoTitle = [[UILabel alloc] init];
    basicInfoTitle.text = @"基本信息";
    basicInfoTitle.font = [UIFont systemFontOfSize:14];
    basicInfoTitle.textColor = kAcqTextSecondary;
    [_contentView addSubview:basicInfoTitle];

    [basicInfoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.top.equalTo(_contentView).offset(16);
    }];

    _basicInfoCard = [[UIView alloc] init];
    _basicInfoCard.backgroundColor = [UIColor whiteColor];
    _basicInfoCard.layer.cornerRadius = 8;
    [_contentView addSubview:_basicInfoCard];

    [_basicInfoCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(basicInfoTitle.mas_bottom).offset(12);
    }];

    // Section 2: 申报进度
    UILabel *progressTitle = [[UILabel alloc] init];
    progressTitle.text = @"申报进度";
    progressTitle.font = [UIFont systemFontOfSize:14];
    progressTitle.textColor = kAcqTextSecondary;
    [_contentView addSubview:progressTitle];

    [progressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.top.equalTo(_basicInfoCard.mas_bottom).offset(20);
    }];

    _progressCard = [[UIView alloc] init];
    _progressCard.backgroundColor = [UIColor whiteColor];
    _progressCard.layer.cornerRadius = 8;
    [_contentView addSubview:_progressCard];

    [_progressCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.top.equalTo(progressTitle.mas_bottom).offset(12);
        make.bottom.equalTo(_contentView).offset(-30);
    }];
}

- (void)loadDetailData {
    [MBProgressHUD showStatus:nil toView:self.view];

    WeakSelf
    [HttpRequest requestUrlPath:BaseURL urlPath:acquisitionDeclaration_getURL parameters:@{@"id": @(_declarationId)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:weakSelf.view];

        if (status == 1) {
            weakSelf.detailModel = [AcquisitionDetailModel mj_objectWithKeyValues:dic];
            // Parse address components from full address string
            [weakSelf.detailModel parseAddressComponents];
            [weakSelf updateBasicInfoCard];
            [weakSelf loadProgressData];
        } else {
            [MBProgressHUD showMessag:msg toView:weakSelf.view];
        }
    }];
}

- (void)loadProgressData {
    WeakSelf
    [HttpRequest requestUrlPath:BaseURL urlPath:acquisitionDeclaration_progressURL parameters:@{@"id": @(_declarationId)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            // API returns reviewProgress and cancelProgress arrays
            NSMutableArray<AcquisitionProgressItem *> *allItems = [NSMutableArray array];

            // Parse reviewProgress (normal review progress)
            NSArray *reviewProgress = dic[@"reviewProgress"];
            if ([reviewProgress isKindOfClass:[NSArray class]] && reviewProgress.count > 0) {
                NSArray<AcquisitionProgressItem *> *reviewItems = [AcquisitionProgressItem mj_objectArrayWithKeyValuesArray:reviewProgress];
                [allItems addObjectsFromArray:reviewItems];
            }

            // Parse cancelProgress (cancellation progress)
            NSArray *cancelProgress = dic[@"cancelProgress"];
            if ([cancelProgress isKindOfClass:[NSArray class]] && cancelProgress.count > 0) {
                NSArray<AcquisitionProgressItem *> *cancelItems = [AcquisitionProgressItem mj_objectArrayWithKeyValuesArray:cancelProgress];
                [allItems addObjectsFromArray:cancelItems];
            }

            // Sort by createTime ascending (oldest first for timeline display)
            [allItems sortUsingComparator:^NSComparisonResult(AcquisitionProgressItem *obj1, AcquisitionProgressItem *obj2) {
                if (obj1.createTime < obj2.createTime) {
                    return NSOrderedAscending;
                } else if (obj1.createTime > obj2.createTime) {
                    return NSOrderedDescending;
                }
                return NSOrderedSame;
            }];

            weakSelf.progressItems = [allItems copy];

            // 检查最新进度（数组最后一个）是否是撤回状态
            weakSelf.hasWithdrawnStatus = NO;
            if (allItems.count > 0) {
                AcquisitionProgressItem *latestItem = allItems.lastObject;
                if (latestItem.progressType == 0 && latestItem.progressStatus == 0) {
                    weakSelf.hasWithdrawnStatus = YES;
                }
            }

            // 刷新基本信息卡片（更新撤回按钮显示状态）
            [weakSelf updateBasicInfoCard];

            // 解析attachment中的img_id为URL
            [weakSelf resolveAttachmentUrlsWithCompletion:^{
                [weakSelf updateProgressCard];
            }];
        }
    }];
}

- (void)resolveAttachmentUrlsWithCompletion:(void (^)(void))completion {
    // 收集所有需要解析的img_id（转为数字）
    NSMutableSet *allImgIds = [NSMutableSet set];
    for (AcquisitionProgressItem *item in _progressItems) {
        if (item.attachment.length > 0) {
            NSArray *imgIds = [item.attachment componentsSeparatedByString:@","];
            for (NSString *imgId in imgIds) {
                NSString *trimmedId = [imgId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if (trimmedId.length > 0) {
                    // 转为NSNumber以确保JSON序列化时是数字格式
                    NSNumber *imgIdNum = @([trimmedId integerValue]);
                    [allImgIds addObject:imgIdNum];
                }
            }
        }
    }

    // 如果没有需要解析的img_id，直接回调
    if (allImgIds.count == 0) {
        NSLog(@"🟡🟡🟡 [Acquisition] No attachments to resolve");
        if (completion) {
            completion();
        }
        return;
    }

    // 调用API解析img_id为URL
    // 参数格式为 "[79716,79717]"
    NSArray *imgIdArray = [allImgIds allObjects];
    NSString *imgIdsJsonString = [NSString stringWithFormat:@"[%@]", [imgIdArray componentsJoinedByString:@","]];

    NSLog(@"🟡🟡🟡 [Acquisition] Resolving img_ids: %@", imgIdsJsonString);

    WeakSelf
    // 使用 requestArrUrlPath 因为返回的 data 是数组
    [HttpRequest requestArrUrlPath:BaseURL urlPath:upload_infoURL parameters:@{@"ids": imgIdsJsonString, @"type": @"img"} type:HttpRequestTypePost result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        NSLog(@"🟡🟡🟡 [Acquisition] upload/info response - status: %ld, msg: %@", (long)status, msg);
        NSLog(@"🟡🟡🟡 [Acquisition] arr: %@", arr);

        if (status == 1 && [arr isKindOfClass:[NSArray class]]) {
            // 构建id到url的映射
            // HttpRequest 返回的 arr 就是 data 数组: [{ "id": 79716, "url": "..." }]
            NSMutableDictionary *imgIdToUrlMap = [NSMutableDictionary dictionary];

            for (NSDictionary *item in arr) {
                NSString *imgId = [NSString stringWithFormat:@"%@", item[@"id"]];
                NSString *url = item[@"url"];
                if (imgId && url) {
                    imgIdToUrlMap[imgId] = url;
                    NSLog(@"🟡🟡🟡 [Acquisition] Mapped %@ -> %@", imgId, url);
                }
            }

            // 为每个progressItem设置解析后的URL数组
            for (AcquisitionProgressItem *item in weakSelf.progressItems) {
                if (item.attachment.length > 0) {
                    NSArray *imgIds = [item.attachment componentsSeparatedByString:@","];
                    NSMutableArray *urls = [NSMutableArray array];
                    for (NSString *imgId in imgIds) {
                        NSString *trimmedId = [imgId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        NSString *url = imgIdToUrlMap[trimmedId];
                        if (url) {
                            [urls addObject:url];
                        }
                    }
                    item.attachmentUrls = [urls copy];
                    NSLog(@"🟡🟡🟡 [Acquisition] attachment: %@ -> URLs count: %lu", item.attachment, (unsigned long)item.attachmentUrls.count);
                }
            }
        } else {
            NSLog(@"🔴🔴🔴 [Acquisition] upload/info FAILED - status: %ld, msg: %@", (long)status, msg);
        }

        if (completion) {
            completion();
        }
    }];
}

- (void)updateBasicInfoCard {
    // Clear existing subviews
    for (UIView *subview in _basicInfoCard.subviews) {
        [subview removeFromSuperview];
    }

    // Title row: 房源收购意向申报 + 查看详情 >
    UILabel *cardTitle = [[UILabel alloc] init];
    cardTitle.text = @"房源收购意向申报";
    cardTitle.font = [UIFont boldSystemFontOfSize:16];
    cardTitle.textColor = kAcqTextPrimary;
    [_basicInfoCard addSubview:cardTitle];

    // 撤回按钮 - 只要最新进度不是撤回状态就显示
    UIButton *cancelBtn = nil;
    if (!_hasWithdrawnStatus) {
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"撤回" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:kAcqGreenColor forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelBtn addTarget:self action:@selector(cancelDeclarationTapped) forControlEvents:UIControlEventTouchUpInside];
        [_basicInfoCard addSubview:cancelBtn];
    }

    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn setTitle:@"查看详情 >" forState:UIControlStateNormal];
    [detailBtn setTitleColor:kAcqGreenColor forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [detailBtn addTarget:self action:@selector(viewDetailTapped) forControlEvents:UIControlEventTouchUpInside];
    [_basicInfoCard addSubview:detailBtn];

    // Divider
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = kAcqDivider;
    [_basicInfoCard addSubview:divider];

    // Info rows
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = [NSString stringWithFormat:@"申报人姓名：%@", _detailModel.requesterName ?: @""];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = kAcqTextSecondary;
    [_basicInfoCard addSubview:nameLabel];

    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = [NSString stringWithFormat:@"联系方式：%@", _detailModel.requesterPhoneNum ?: @""];
    phoneLabel.font = [UIFont systemFontOfSize:14];
    phoneLabel.textColor = kAcqTextSecondary;
    [_basicInfoCard addSubview:phoneLabel];

    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.text = [NSString stringWithFormat:@"意向编码：%@", _detailModel.bh ?: @""];
    codeLabel.font = [UIFont systemFontOfSize:14];
    codeLabel.textColor = kAcqTextSecondary;
    [_basicInfoCard addSubview:codeLabel];

    // Layout
    [cardTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_basicInfoCard).offset(16);
        make.top.equalTo(_basicInfoCard).offset(16);
    }];

    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_basicInfoCard).offset(-16);
        make.centerY.equalTo(cardTitle);
    }];

    if (cancelBtn) {
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(detailBtn.mas_left).offset(-16);
            make.centerY.equalTo(cardTitle);
        }];
    }

    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_basicInfoCard).offset(16);
        make.right.equalTo(_basicInfoCard).offset(-16);
        make.top.equalTo(cardTitle.mas_bottom).offset(16);
        make.height.mas_equalTo(0.5);
    }];

    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_basicInfoCard).offset(16);
        make.top.equalTo(divider.mas_bottom).offset(16);
    }];

    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_basicInfoCard).offset(16);
        make.top.equalTo(nameLabel.mas_bottom).offset(8);
    }];

    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_basicInfoCard).offset(16);
        make.top.equalTo(phoneLabel.mas_bottom).offset(8);
        make.bottom.equalTo(_basicInfoCard).offset(-16);
    }];
}

- (void)updateProgressCard {
    // Clear existing subviews
    for (UIView *subview in _progressCard.subviews) {
        [subview removeFromSuperview];
    }

    // Resubmit button (if applicable)
    // 检查是否有撤回记录（参照进度条展示的判断逻辑：progressType == 0 && progressStatus == 0）
    BOOL hasWithdrawnStatus = NO;
    for (AcquisitionProgressItem *item in _progressItems) {
        if (item.progressType == 0 && item.progressStatus == 0) {
            hasWithdrawnStatus = YES;
            break;
        }
    }
    // 被撤回或被驳回/否决时可以重新提交
    BOOL canResubmit = hasWithdrawnStatus || _detailModel.status == 2 || _detailModel.status == 3 ||
    _detailModel.status == 4;

    // 1. 声明按钮变量，去掉原来的 topAnchorView
    UIButton *resubmitBtn = nil;
    if (canResubmit) {
        resubmitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [resubmitBtn setTitle:@"重新提交 >" forState:UIControlStateNormal];
        [resubmitBtn setTitleColor:kAcqGreenColor forState:UIControlStateNormal];
        resubmitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [resubmitBtn addTarget:self action:@selector(resubmitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [_progressCard addSubview:resubmitBtn];
        [resubmitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_progressCard).offset(-16);
            // 这里设为 14，是为了让按钮文字在视觉上与左侧时间标签的中心精确对齐
            make.top.equalTo(_progressCard).offset(14); 
        }];
    }

    // Progress timeline
    UIView *lastView = nil;
    for (NSInteger i = 0; i < _progressItems.count; i++) {
        AcquisitionProgressItem *item = _progressItems[i];
        BOOL isLast = (i == _progressItems.count - 1);

        UIView *timelineItem = [self createTimelineItemWithItem:item isLast:isLast];
        [_progressCard addSubview:timelineItem];
        [timelineItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_progressCard).offset(16);
            make.right.equalTo(_progressCard).offset(-16);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            } else {
                // 【核心修改】：第一行进度条不再被按钮挤到下面，而是直接对齐卡片顶部
                make.top.equalTo(_progressCard).offset(16);
            }
        }];

        lastView = timelineItem;
    }
    
    // 【核心修改】：由于进度条和按钮现在在同一行，且 timelineItem 的宽度占满了全屏(-16)
    // 必须把按钮层级提到最前面，否则按钮会被透明的 timelineItem 盖住，导致点击失效
    if (resubmitBtn) {
        [_progressCard bringSubviewToFront:resubmitBtn];
    }

    if (lastView) {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_progressCard);
        }];
    } else {
        // No progress items, add empty state
        UILabel *emptyLabel = [[UILabel alloc] init];
        emptyLabel.text = @"暂无进度信息";
        emptyLabel.font = [UIFont systemFontOfSize:14];
        emptyLabel.textColor = kAcqTextHint;
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        [_progressCard addSubview:emptyLabel];

        [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_progressCard);
            make.left.right.equalTo(_progressCard);
            make.top.equalTo(_progressCard).offset(30);
            make.bottom.equalTo(_progressCard).offset(-30);
        }];
    }
}

- (UIView *)createTimelineItemWithItem:(AcquisitionProgressItem *)item isLast:(BOOL)isLast {
    UIView *container = [[UIView alloc] init];

    // Node circle
    UIView *nodeView = [[UIView alloc] init];

    // Check for withdrawn status first (progressType == 0 && progressStatus == 0)
    BOOL isWithdrawn = (item.progressType == 0 && item.progressStatus == 0);
    BOOL isPending = !isWithdrawn && item.progressStatus == 0;

    if (isWithdrawn || item.progressStatus == 2 || item.progressStatus == 3 || item.progressStatus == 4) {
        // Withdrawn/Rejected/Vetoed - red circle with white X (16x16)
        nodeView.layer.cornerRadius = 8;
        nodeView.backgroundColor = kAcqRedColor;
        UIImageView *crossmark = [[UIImageView alloc] init];
        crossmark.image = [self createCrossmarkImageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)];
        crossmark.contentMode = UIViewContentModeCenter;
        [nodeView addSubview:crossmark];
        [crossmark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(nodeView);
            make.width.height.mas_equalTo(10);
        }];
    } else if (item.progressStatus == 1) {
        // Approved - blue circle with white checkmark (16x16)
        nodeView.layer.cornerRadius = 8;
        nodeView.backgroundColor = kAcqGreenColor;
        UIImageView *checkmark = [[UIImageView alloc] init];
        checkmark.image = [self createCheckmarkImageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)];
        checkmark.contentMode = UIViewContentModeCenter;
        [nodeView addSubview:checkmark];
        [checkmark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(nodeView);
            make.width.height.mas_equalTo(10);
        }];
    } else {
        // Pending - smaller gray circle (10x10)
        nodeView.layer.cornerRadius = 5;
        nodeView.backgroundColor = kAcqTextHint;
    }
    [container addSubview:nodeView];

    // Connecting line (if not last)
    UIView *lineView = nil;
    if (!isLast) {
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = kAcqDivider;
        [container addSubview:lineView];
        [container sendSubviewToBack:lineView];

        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(nodeView);
            make.top.equalTo(nodeView.mas_bottom);
            make.bottom.equalTo(container);
            make.width.mas_equalTo(1);
        }];
    }

    // Time label
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = [item getFormattedTime];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = kAcqTextHint;
    [container addSubview:timeLabel];

    // Status label
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.text = [item getProgressStatusString];
    statusLabel.font = [UIFont systemFontOfSize:15];
    statusLabel.textColor = kAcqTextPrimary;
    [container addSubview:statusLabel];

    // Track the last view for bottom constraint
    UIView *lastContentView = statusLabel;

    // Remark (if any)
    if (item.remark.length > 0) {
        UILabel *remarkLabel = [[UILabel alloc] init];
        remarkLabel.text = item.remark;
        remarkLabel.font = [UIFont systemFontOfSize:12];
        remarkLabel.textColor = kAcqRedColor;
        remarkLabel.numberOfLines = 0;
        [container addSubview:remarkLabel];

        [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusLabel);
            make.top.equalTo(lastContentView.mas_bottom).offset(4);
            make.right.equalTo(container).offset(-16);
        }];
        lastContentView = remarkLabel;
    }

    // 审核意见 (postscript)
    if (item.postscript.length > 0) {
        UILabel *postscriptLabel = [[UILabel alloc] init];
        postscriptLabel.text = [NSString stringWithFormat:@"审核意见：%@", item.postscript];
        postscriptLabel.font = [UIFont systemFontOfSize:12];
        postscriptLabel.textColor = kAcqTextSecondary;
        postscriptLabel.numberOfLines = 0;
        [container addSubview:postscriptLabel];

        [postscriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusLabel);
            make.top.equalTo(lastContentView.mas_bottom).offset(6);
            make.right.equalTo(container).offset(-16);
        }];
        lastContentView = postscriptLabel;
    }

    // 上传材料 (attachment images)
    if (item.attachmentUrls.count > 0) {
        UILabel *attachmentTitleLabel = [[UILabel alloc] init];
        attachmentTitleLabel.text = @"上传材料：";
        attachmentTitleLabel.font = [UIFont systemFontOfSize:12];
        attachmentTitleLabel.textColor = kAcqTextSecondary;
        [container addSubview:attachmentTitleLabel];

        [attachmentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusLabel);
            make.top.equalTo(lastContentView.mas_bottom).offset(6);
        }];
        lastContentView = attachmentTitleLabel;

        // Use resolved attachment URLs, limited to 9 images max
        NSArray *imageUrls = item.attachmentUrls;
        NSInteger maxImages = MIN(imageUrls.count, 9);
        CGFloat imageSize = 60;
        CGFloat imageSpacing = 8;

        // Calculate available width for images
        // Container width = screen width - 16*2 (progressCard margins) - 16*2 (container margins)
        // Images start from statusLabel position, which is nodeView(16) + spacing(12) from left
        CGFloat availableWidth = SCREEN_WIDTH - 32 - 32 - 16 - 12;
        // Calculate how many images per row
        NSInteger imagesPerRow = (NSInteger)((availableWidth + imageSpacing) / (imageSize + imageSpacing));
        if (imagesPerRow < 1) imagesPerRow = 1;

        UIView *lastRowView = nil;
        NSInteger currentRow = 0;
        NSInteger currentCol = 0;

        for (NSInteger i = 0; i < maxImages; i++) {
            NSString *urlString = imageUrls[i];
            if (urlString.length == 0) continue;

            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = 4;
            imageView.backgroundColor = kAcqDivider;
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;

            // Add tap gesture for preview
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attachmentImageTapped:)];
            [imageView addGestureRecognizer:tap];

            // Store URLs in associated object for preview (store all URLs for full preview)
            objc_setAssociatedObject(imageView, "imageUrls", imageUrls, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

            [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
            [container addSubview:imageView];

            // Calculate position in grid
            currentRow = i / imagesPerRow;
            currentCol = i % imagesPerRow;

            CGFloat leftOffset = currentCol * (imageSize + imageSpacing);
            CGFloat topOffset = currentRow * (imageSize + imageSpacing);

            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(statusLabel).offset(leftOffset);
                make.top.equalTo(attachmentTitleLabel.mas_bottom).offset(6 + topOffset);
                make.width.height.mas_equalTo(imageSize);
            }];
            lastRowView = imageView;
        }

        if (lastRowView) {
            lastContentView = lastRowView;
        }
    }

    // Layout - pending status has smaller circle (10x10), others are 16x16
    CGFloat nodeSize = isPending ? 10 : 16;
    CGFloat nodeTopOffset = isPending ? 7 : 4;  // Adjust top offset to keep vertical alignment
    [nodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(isPending ? 3 : 0);  // Center smaller circle
        make.top.equalTo(container).offset(nodeTopOffset);
        make.width.height.mas_equalTo(nodeSize);
    }];

    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nodeView.mas_right).offset(12);
        make.top.equalTo(container);
    }];

    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel);
        make.top.equalTo(timeLabel.mas_bottom).offset(4);
    }];

    // Add bottom constraint to last content view
    [lastContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(container).offset(-16);
    }];

    return container;
}

- (void)attachmentImageTapped:(UITapGestureRecognizer *)gesture {
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSArray *imageUrls = objc_getAssociatedObject(imageView, "imageUrls");
    NSInteger index = imageView.tag;

    if (imageUrls.count > 0) {
        NSMutableArray *datas = [NSMutableArray array];
        for (NSString *urlString in imageUrls) {
            NSString *trimmedUrl = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (trimmedUrl.length > 0) {
                KNPhotoItems *items = [[KNPhotoItems alloc] init];
                items.sourceView = imageView;
                items.url = trimmedUrl;
                [datas addObject:items];
            }
        }

        if (datas.count > 0) {
            KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
            photoBrowser.itemsArr = datas;
            photoBrowser.isNeedPageNumView = YES;
            photoBrowser.isNeedPanGesture = YES;
            photoBrowser.currentIndex = index;
            [photoBrowser present];
        }
    }
}

#pragma mark - Actions

- (void)cancelDeclarationTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要撤回该申报吗？" preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    WeakSelf
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf doCancelDeclaration];
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)doCancelDeclaration {
    [MBProgressHUD showStatus:@"撤回中..." toView:self.view];

    WeakSelf
    [HttpRequest requestUrlPath:BaseURL urlPath:acquisitionDeclaration_cancelURL parameters:@{@"id": @(_declarationId)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:weakSelf.view];

        if (status == 1) {
            [MBProgressHUD showMessag:@"撤回成功" toView:weakSelf.view];
            // 重新加载页面获取最新的申报进度和按钮情况
            [weakSelf loadDetailData];
        } else {
            [MBProgressHUD showMessag:msg toView:weakSelf.view];
        }
    }];
}

- (void)viewDetailTapped {
    // Load detail data into form data and navigate to Step1 in view mode
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];
    [formData clear];

    // Copy data from detail model to form data
    formData.ownerName = _detailModel.ownerName;
    formData.type = _detailModel.type;
    formData.typeOther = _detailModel.typeOther;
    formData.certificateNumber = _detailModel.certificateNumber;
    formData.addressRoad = _detailModel.addressRoad;
    formData.addressNong = _detailModel.addressNong;
    formData.addressHao = _detailModel.addressHao;
    formData.addressShi = _detailModel.addressShi;
    formData.size = _detailModel.size;
    formData.ownershipType = @(_detailModel.ownershipType);
    formData.ownershipShare = _detailModel.ownershipShare;
    formData.exceptionStatus = @(_detailModel.exceptionStatus);
    formData.liveStatus = @(_detailModel.liveStatus);
    formData.liveInfo = _detailModel.liveInfo;
    formData.mortgageStatus = @(_detailModel.mortgageStatus);
    formData.mortgageInfo = _detailModel.mortgageInfo;
    formData.hukouStatus = @(_detailModel.hukouStatus);
    formData.hukouNum = @(_detailModel.hukouNum);
    formData.requesterName = _detailModel.requesterName;
    formData.requesterPhoneNum = _detailModel.requesterPhoneNum;
    formData.relationship = _detailModel.relationship;
    formData.relationshipOther = _detailModel.relationshipOther;

    formData.certificateFile = _detailModel.certificateFile;
    formData.registerFile = _detailModel.registerFile;
    formData.ownerIdcardFile = _detailModel.ownerIdcardFile;
    formData.requesterIdcardFile = _detailModel.requesterIdcardFile;
    formData.hukouFile = _detailModel.hukouFile;

    formData.floorPrice = _detailModel.floorPrice;
    formData.ceilingPrice = _detailModel.ceilingPrice;

    // Set view mode (read-only, all inputs disabled)
    formData.isViewMode = YES;
    formData.isEditMode = NO;

    // Navigate to Step1
    AcquisitionStep1VC *vc = [[AcquisitionStep1VC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)resubmitButtonTapped {
    // Pre-fill form data from detail model
    AcquisitionFormData *formData = [AcquisitionFormData sharedInstance];
    [formData clear];

    formData.ownerName = _detailModel.ownerName;
    formData.type = _detailModel.type;
    formData.typeOther = _detailModel.typeOther;
    formData.certificateNumber = _detailModel.certificateNumber;
    formData.addressRoad = _detailModel.addressRoad;
    formData.addressNong = _detailModel.addressNong;
    formData.addressHao = _detailModel.addressHao;
    formData.addressShi = _detailModel.addressShi;
    formData.size = _detailModel.size;
    formData.ownershipType = @(_detailModel.ownershipType);
    formData.ownershipShare = _detailModel.ownershipShare;
    formData.exceptionStatus = @(_detailModel.exceptionStatus);
    formData.liveStatus = @(_detailModel.liveStatus);
    formData.liveInfo = _detailModel.liveInfo;
    formData.mortgageStatus = @(_detailModel.mortgageStatus);
    formData.mortgageInfo = _detailModel.mortgageInfo;
    formData.hukouStatus = @(_detailModel.hukouStatus);
    formData.hukouNum = @(_detailModel.hukouNum);
    formData.requesterName = _detailModel.requesterName;
    formData.requesterPhoneNum = _detailModel.requesterPhoneNum;
    formData.relationship = _detailModel.relationship;
    formData.relationshipOther = _detailModel.relationshipOther;

    formData.certificateFile = _detailModel.certificateFile;
    formData.registerFile = _detailModel.registerFile;
    formData.ownerIdcardFile = _detailModel.ownerIdcardFile;
    formData.requesterIdcardFile = _detailModel.requesterIdcardFile;
    formData.hukouFile = _detailModel.hukouFile;

    formData.floorPrice = _detailModel.floorPrice;
    formData.ceilingPrice = _detailModel.ceilingPrice;

    // Set edit mode (resubmit, inputs enabled)
    formData.isEditMode = YES;
    formData.isViewMode = NO;
    formData.declarationId = _detailModel.itemId;

    AcquisitionStep1VC *vc = [[AcquisitionStep1VC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Helper Methods

- (UIImage *)createCheckmarkImageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [color setStroke];
    CGContextSetLineWidth(context, 1.5);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);

    // Draw checkmark path
    CGContextMoveToPoint(context, size.width * 0.15, size.height * 0.5);
    CGContextAddLineToPoint(context, size.width * 0.4, size.height * 0.75);
    CGContextAddLineToPoint(context, size.width * 0.85, size.height * 0.25);
    CGContextStrokePath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)createCrossmarkImageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [color setStroke];
    CGContextSetLineWidth(context, 1.5);
    CGContextSetLineCap(context, kCGLineCapRound);

    // Draw X path
    CGFloat padding = size.width * 0.2;
    CGContextMoveToPoint(context, padding, padding);
    CGContextAddLineToPoint(context, size.width - padding, size.height - padding);
    CGContextStrokePath(context);

    CGContextMoveToPoint(context, size.width - padding, padding);
    CGContextAddLineToPoint(context, padding, size.height - padding);
    CGContextStrokePath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
