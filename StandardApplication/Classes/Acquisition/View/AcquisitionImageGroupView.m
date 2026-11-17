//
//  AcquisitionImageGroupView.m
//  StandardApplication
//
//  Image upload group view for property acquisition declaration
//

#import "AcquisitionImageGroupView.h"
#import "Masonry.h"
#import "UIColor+SNFoundation.h"
#import "SDWebImage.h"
#import "HttpRequest.h"
#import "YDInterfaceDefinition.h"

static const CGFloat kItemSpacing = 10;
static const CGFloat kItemsPerRow = 4;
static const CGFloat kCollectionTopPadding = 0;  // No title, so no top padding needed
static const CGFloat kCollectionBottomPadding = 0;

@interface AcquisitionImageGroupView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *requiredLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat lastCalculatedHeight;

@end

@implementation AcquisitionImageGroupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _maxCount = 9;
        _images = [NSMutableArray array];
        _imageIds = [NSMutableArray array];
        _imageUrls = [NSMutableArray array];
        _fileTypes = [NSMutableArray array];
        _lastCalculatedHeight = 0;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];

    // Title label (kept for backward compatibility but hidden by default since title is external now)
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.hidden = YES;
    [self addSubview:_titleLabel];

    // Required label
    _requiredLabel = [[UILabel alloc] init];
    _requiredLabel.font = [UIFont systemFontOfSize:14];
    _requiredLabel.textColor = [UIColor colorWithHexString:@"#FF4444"];
    _requiredLabel.text = @"*";
    _requiredLabel.hidden = YES;
    [self addSubview:_requiredLabel];

    // Collection view
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kItemSpacing;
    layout.minimumInteritemSpacing = kItemSpacing;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ImageCell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AddCell"];
    [self addSubview:_collectionView];

    // CollectionView fills the entire view (no internal title/padding)
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setRequired:(BOOL)required {
    _required = required;
    _requiredLabel.hidden = !required;
}

- (void)reloadImages {
    [_collectionView reloadData];

    // Notify delegate about height change
    CGFloat newHeight = [self calculateContentHeight];
    if (fabs(newHeight - _lastCalculatedHeight) > 1.0) {
        _lastCalculatedHeight = newHeight;
        if ([_delegate respondsToSelector:@selector(imageGroupViewDidChangeHeight:newHeight:)]) {
            [_delegate imageGroupViewDidChangeHeight:self newHeight:newHeight];
        }
    }
}

- (CGFloat)calculateContentHeight {
    // Calculate item size based on collection view width
    CGFloat collectionWidth = self.bounds.size.width;
    if (collectionWidth <= 0) {
        collectionWidth = [UIScreen mainScreen].bounds.size.width - 32; // Default with padding
    }

    CGFloat itemWidth = (collectionWidth - kItemSpacing * (kItemsPerRow - 1)) / kItemsPerRow;
    CGFloat itemHeight = itemWidth;

    // Calculate number of rows
    NSInteger itemCount = _images.count;
    if (!_isViewMode && itemCount < _maxCount) {
        itemCount += 1; // Add button
    }

    NSInteger rowCount = (itemCount + (NSInteger)kItemsPerRow - 1) / (NSInteger)kItemsPerRow;
    if (rowCount < 1) rowCount = 1;

    // Total height = rows * itemHeight + (rows-1) * spacing
    CGFloat totalHeight = rowCount * itemHeight + (rowCount - 1) * kItemSpacing;

    return totalHeight;
}

- (void)setImageIdsFromString:(NSString *)idString completion:(void (^)(void))completion {
    [_imageIds removeAllObjects];
    [_imageUrls removeAllObjects];
    [_images removeAllObjects];
    [_fileTypes removeAllObjects];

    if (idString.length == 0) {
        [self reloadImages];
        if (completion) completion();
        return;
    }

    // Try to parse as new JSON array format: [{"type":"img","id":"123"},{"type":"file","id":"456"}]
    NSData *jsonData = [idString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *fileInfoArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];

    if ([fileInfoArray isKindOfClass:[NSArray class]] && fileInfoArray.count > 0) {
        // New JSON format
        [self parseNewFormatFileInfoArray:fileInfoArray completion:completion];
    } else {
        // Legacy format: comma-separated IDs (fallback for backward compatibility)
        [self parseLegacyFormatIdString:idString completion:completion];
    }
}

/// Parse new JSON format: [{"type":"img","id":"123"},{"type":"file","id":"456"}]
- (void)parseNewFormatFileInfoArray:(NSArray *)fileInfoArray completion:(void (^)(void))completion {
    // Separate into image IDs and file IDs
    NSMutableArray *imgItems = [NSMutableArray array];
    NSMutableArray *fileItems = [NSMutableArray array];

    for (NSDictionary *item in fileInfoArray) {
        if (![item isKindOfClass:[NSDictionary class]]) continue;

        NSString *type = [NSString stringWithFormat:@"%@", item[@"type"] ?: @"img"];
        NSString *fileId = [NSString stringWithFormat:@"%@", item[@"id"] ?: @""];

        if (fileId.length == 0) continue;

        if ([type isEqualToString:@"file"]) {
            [fileItems addObject:@{@"type": type, @"id": fileId}];
        } else {
            [imgItems addObject:@{@"type": @"img", @"id": fileId}];
        }
    }

    // Initialize placeholders for all items
    NSInteger totalCount = imgItems.count + fileItems.count;
    for (NSInteger i = 0; i < totalCount; i++) {
        [_images addObject:[UIImage new]];
        [_imageIds addObject:@""];
        [_imageUrls addObject:@""];
        [_fileTypes addObject:@(AcquisitionFileTypeImage)];
    }

    // Build order map to maintain original order
    NSMutableDictionary *orderMap = [NSMutableDictionary dictionary];
    NSInteger index = 0;
    for (NSDictionary *item in fileInfoArray) {
        if (![item isKindOfClass:[NSDictionary class]]) continue;
        NSString *fileId = [NSString stringWithFormat:@"%@", item[@"id"] ?: @""];
        NSString *type = [NSString stringWithFormat:@"%@", item[@"type"] ?: @"img"];
        if (fileId.length > 0) {
            NSString *key = [NSString stringWithFormat:@"%@_%@", type, fileId];
            orderMap[key] = @(index);
            index++;
        }
    }

    dispatch_group_t loadGroup = dispatch_group_create();
    __weak typeof(self) weakSelf = self;

    // Fetch image files info
    if (imgItems.count > 0) {
        dispatch_group_enter(loadGroup);
        NSMutableArray *imgIds = [NSMutableArray array];
        for (NSDictionary *item in imgItems) {
            [imgIds addObject:@([item[@"id"] integerValue])];
        }
        NSData *imgJsonData = [NSJSONSerialization dataWithJSONObject:imgIds options:0 error:nil];
        NSString *imgIdsJsonString = [[NSString alloc] initWithData:imgJsonData encoding:NSUTF8StringEncoding];

        [HttpRequest requestArrUrlPath:BaseURL urlPath:upload_infoURL parameters:@{@"ids": imgIdsJsonString, @"type": @"img"} type:HttpRequestTypePost result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
            if (status == 1 && [arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary *item in arr) {
                    NSString *imgId = [NSString stringWithFormat:@"%@", item[@"id"]];
                    NSString *url = item[@"url"] ?: @"";
                    NSString *key = [NSString stringWithFormat:@"img_%@", imgId];
                    NSNumber *orderIndex = orderMap[key];
                    if (orderIndex) {
                        NSInteger idx = [orderIndex integerValue];
                        weakSelf.imageIds[idx] = imgId;
                        weakSelf.imageUrls[idx] = url;
                        weakSelf.fileTypes[idx] = @(AcquisitionFileTypeImage);
                    }
                }
            }
            dispatch_group_leave(loadGroup);
        }];
    }

    // Fetch PDF files info
    if (fileItems.count > 0) {
        dispatch_group_enter(loadGroup);
        NSMutableArray *fileIds = [NSMutableArray array];
        for (NSDictionary *item in fileItems) {
            [fileIds addObject:@([item[@"id"] integerValue])];
        }
        NSData *fileJsonData = [NSJSONSerialization dataWithJSONObject:fileIds options:0 error:nil];
        NSString *fileIdsJsonString = [[NSString alloc] initWithData:fileJsonData encoding:NSUTF8StringEncoding];

        [HttpRequest requestArrUrlPath:BaseURL urlPath:upload_infoURL parameters:@{@"ids": fileIdsJsonString, @"type": @"file"} type:HttpRequestTypePost result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
            if (status == 1 && [arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary *item in arr) {
                    NSString *fileId = [NSString stringWithFormat:@"%@", item[@"id"]];
                    NSString *url = item[@"url"] ?: @"";
                    NSString *key = [NSString stringWithFormat:@"file_%@", fileId];
                    NSNumber *orderIndex = orderMap[key];
                    if (orderIndex) {
                        NSInteger idx = [orderIndex integerValue];
                        weakSelf.imageIds[idx] = fileId;
                        weakSelf.imageUrls[idx] = url;
                        weakSelf.fileTypes[idx] = @(AcquisitionFileTypePDF);
                    }
                }
            }
            dispatch_group_leave(loadGroup);
        }];
    }

    dispatch_group_notify(loadGroup, dispatch_get_main_queue(), ^{
        [weakSelf reloadImages];
        if (completion) completion();
    });
}

/// Parse legacy comma-separated ID format (backward compatibility)
- (void)parseLegacyFormatIdString:(NSString *)idString completion:(void (^)(void))completion {
    NSMutableArray *ids = [NSMutableArray array];
    NSArray *idArray = [idString componentsSeparatedByString:@","];
    for (NSString *idStr in idArray) {
        NSString *trimmedId = [idStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (trimmedId.length > 0) {
            [ids addObject:trimmedId];
            [_imageIds addObject:trimmedId];
            [_images addObject:[UIImage new]]; // Placeholder
        }
    }

    if (ids.count == 0) {
        [self reloadImages];
        if (completion) completion();
        return;
    }

    // Convert to JSON array format for API: [123, 456, 789]
    NSMutableArray *numericIds = [NSMutableArray array];
    for (NSString *idStr in ids) {
        [numericIds addObject:@([idStr integerValue])];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:numericIds options:0 error:nil];
    NSString *imgIdsJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    // Call API to resolve IDs to URLs (legacy mode assumes all are images)
    __weak typeof(self) weakSelf = self;
    [HttpRequest requestArrUrlPath:BaseURL urlPath:upload_infoURL parameters:@{@"ids": imgIdsJsonString, @"type": @"img"} type:HttpRequestTypePost result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1 && [arr isKindOfClass:[NSArray class]]) {
            // Build ID to URL mapping
            NSMutableDictionary *idToUrlMap = [NSMutableDictionary dictionary];
            for (NSDictionary *item in arr) {
                NSString *imgId = [NSString stringWithFormat:@"%@", item[@"id"]];
                NSString *url = item[@"url"];
                if (imgId && url) {
                    idToUrlMap[imgId] = url;
                }
            }

            // Update URLs and file types in order
            [weakSelf.imageUrls removeAllObjects];
            [weakSelf.fileTypes removeAllObjects];
            for (NSString *imgId in weakSelf.imageIds) {
                NSString *url = idToUrlMap[imgId] ?: @"";
                [weakSelf.imageUrls addObject:url];

                // Detect file type from URL
                NSString *lowercaseUrl = [url lowercaseString];
                if ([lowercaseUrl hasSuffix:@".pdf"]) {
                    [weakSelf.fileTypes addObject:@(AcquisitionFileTypePDF)];
                } else {
                    [weakSelf.fileTypes addObject:@(AcquisitionFileTypeImage)];
                }
            }
        }

        [weakSelf reloadImages];
        if (completion) completion();
    }];
}

- (NSString *)getImageIdsString {
    // Generate new JSON array format: [{"type":"img","id":"123"},{"type":"file","id":"456"}]
    NSMutableArray *fileInfoArray = [NSMutableArray array];

    for (NSInteger i = 0; i < _imageIds.count; i++) {
        NSString *fileId = _imageIds[i];
        if (fileId.length == 0) continue;

        NSString *type = @"img"; // Default to image
        if (i < _fileTypes.count) {
            AcquisitionFileType fileType = [_fileTypes[i] integerValue];
            type = (fileType == AcquisitionFileTypePDF) ? @"file" : @"img";
        }

        [fileInfoArray addObject:@{@"type": type, @"id": fileId}];
    }

    if (fileInfoArray.count == 0) {
        return @"";
    }

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:fileInfoArray options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] ?: @"";
}

- (void)setImageUrlsFromString:(NSString *)urlString {
    [_imageIds removeAllObjects];
    [_imageUrls removeAllObjects];
    [_images removeAllObjects];
    [_fileTypes removeAllObjects];

    if (urlString.length > 0) {
        NSArray *urls = [urlString componentsSeparatedByString:@","];
        for (NSString *url in urls) {
            if (url.length > 0) {
                [_imageUrls addObject:url];
                [_images addObject:[UIImage new]]; // Placeholder

                // Detect file type from URL
                NSString *lowercaseUrl = [url lowercaseString];
                if ([lowercaseUrl hasSuffix:@".pdf"]) {
                    [_fileTypes addObject:@(AcquisitionFileTypePDF)];
                } else {
                    [_fileTypes addObject:@(AcquisitionFileTypeImage)];
                }
            }
        }
    }
    [self reloadImages];
}

- (NSString *)getImageUrlsString {
    return [_imageUrls componentsJoinedByString:@","];
}

- (void)addPDFWithId:(NSString *)fileId url:(NSString *)url {
    if (fileId.length > 0) {
        [_imageIds addObject:fileId];
        [_imageUrls addObject:url ?: @""];
        [_images addObject:[UIImage new]]; // Placeholder
        [_fileTypes addObject:@(AcquisitionFileTypePDF)];
        [self reloadImages];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = _images.count;
    // In view mode, don't show add button
    if (!_isViewMode && count < _maxCount) {
        return count + 1; // +1 for add button
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isAddCell = !_isViewMode && indexPath.row == _images.count && _images.count < _maxCount;

    if (isAddCell) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCell" forIndexPath:indexPath];
        [self configureAddCell:cell];
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        [self configureImageCell:cell atIndex:indexPath.row];
        return cell;
    }
}

- (void)configureAddCell:(UICollectionViewCell *)cell {
    // Clear previous content
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }

    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    cell.contentView.layer.cornerRadius = 4;
    cell.contentView.layer.borderWidth = 1;
    cell.contentView.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    cell.contentView.clipsToBounds = YES;

    UIImageView *addIcon = [[UIImageView alloc] init];
    addIcon.image = [UIImage imageNamed:@"icon_add_image"];
    if (!addIcon.image) {
        // Fallback: draw a plus sign with hint text
        addIcon.backgroundColor = [UIColor clearColor];

        UILabel *plusLabel = [[UILabel alloc] init];
        plusLabel.text = @"+";
        plusLabel.font = [UIFont systemFontOfSize:28];
        plusLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        plusLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:plusLabel];

        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.text = @"图片/PDF";
        hintLabel.font = [UIFont systemFontOfSize:10];
        hintLabel.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        hintLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:hintLabel];

        [plusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView);
            make.centerY.equalTo(cell.contentView).offset(-8);
        }];

        [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView);
            make.top.equalTo(plusLabel.mas_bottom).offset(2);
        }];
    } else {
        addIcon.contentMode = UIViewContentModeCenter;
        [cell.contentView addSubview:addIcon];
        [addIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
            make.width.height.mas_equalTo(24);
        }];
    }
}

- (void)configureImageCell:(UICollectionViewCell *)cell atIndex:(NSInteger)index {
    // Clear previous content
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }

    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    cell.contentView.layer.cornerRadius = 4;
    cell.contentView.clipsToBounds = YES;

    // Check if this is a PDF file
    BOOL isPDF = NO;
    if (index < _fileTypes.count) {
        isPDF = [_fileTypes[index] integerValue] == AcquisitionFileTypePDF;
    } else if (index < _imageUrls.count) {
        // Fallback: check URL extension
        NSString *urlString = [_imageUrls[index] lowercaseString];
        isPDF = [urlString hasSuffix:@".pdf"];
    }

    if (isPDF) {
        // Display PDF icon and label
        UIView *pdfContainer = [[UIView alloc] init];
        pdfContainer.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [cell.contentView addSubview:pdfContainer];

        [pdfContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];

        // PDF icon using system image or fallback
        UIImageView *pdfIcon = [[UIImageView alloc] init];
        UIImage *pdfImage = [UIImage systemImageNamed:@"doc.fill"];
        if (pdfImage) {
            pdfIcon.image = [pdfImage imageWithTintColor:[UIColor colorWithHexString:@"#E74C3C"]];
        }
        pdfIcon.contentMode = UIViewContentModeScaleAspectFit;
        [pdfContainer addSubview:pdfIcon];

        UILabel *pdfLabel = [[UILabel alloc] init];
        pdfLabel.text = @"PDF";
        pdfLabel.font = [UIFont boldSystemFontOfSize:11];
        pdfLabel.textColor = [UIColor colorWithHexString:@"#E74C3C"];
        pdfLabel.textAlignment = NSTextAlignmentCenter;
        [pdfContainer addSubview:pdfLabel];

        [pdfIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(pdfContainer);
            make.centerY.equalTo(pdfContainer).offset(-8);
            make.width.height.mas_equalTo(30);
        }];

        [pdfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(pdfContainer);
            make.top.equalTo(pdfIcon.mas_bottom).offset(4);
        }];
    } else {
        // Display image
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];

        // Load image
        if (index < _images.count) {
            UIImage *localImage = _images[index];
            if (localImage && localImage.size.width > 0) {
                imageView.image = localImage;
            } else if (index < _imageUrls.count) {
                NSString *urlString = _imageUrls[index];
                if (urlString.length > 0) {
                    NSURL *url = [NSURL URLWithString:urlString];
                    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_img"]];
                }
            }
        }
    }

    // Delete button (hidden in view mode)
    if (!_isViewMode) {
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *deleteImage = [UIImage imageNamed:@"icon_delete_image"];
        if (deleteImage) {
            [deleteBtn setImage:deleteImage forState:UIControlStateNormal];
        } else {
            [deleteBtn setTitle:@"×" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            deleteBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            deleteBtn.layer.cornerRadius = 10;
        }
        deleteBtn.tag = index;
        [deleteBtn addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deleteBtn];

        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(4);
            make.right.equalTo(cell.contentView).offset(-4);
            make.width.height.mas_equalTo(20);
        }];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.bounds.size.width - kItemSpacing * (kItemsPerRow - 1)) / kItemsPerRow;
    return CGSizeMake(width, width);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isAddCell = !_isViewMode && indexPath.row == _images.count && _images.count < _maxCount;

    if (isAddCell) {
        if ([_delegate respondsToSelector:@selector(imageGroupViewDidTapAdd:)]) {
            [_delegate imageGroupViewDidTapAdd:self];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(imageGroupViewDidTapImage:atIndex:)]) {
            [_delegate imageGroupViewDidTapImage:self atIndex:indexPath.row];
        }
    }
}

#pragma mark - Actions

- (void)deleteButtonTapped:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(imageGroupViewDidTapDelete:atIndex:)]) {
        [_delegate imageGroupViewDidTapDelete:self atIndex:sender.tag];
    }
}

@end
