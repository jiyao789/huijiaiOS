//
//  AcquisitionImageGroupView.h
//  StandardApplication
//
//  Image upload group view for property acquisition declaration
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AcquisitionImageGroupViewDelegate <NSObject>

- (void)imageGroupViewDidTapAdd:(UIView *)groupView;
- (void)imageGroupViewDidTapImage:(UIView *)groupView atIndex:(NSInteger)index;
- (void)imageGroupViewDidTapDelete:(UIView *)groupView atIndex:(NSInteger)index;

@optional
/// Called when the content height changes (for dynamic layout)
- (void)imageGroupViewDidChangeHeight:(UIView *)groupView newHeight:(CGFloat)height;

@end

/// File type enum for display
typedef NS_ENUM(NSInteger, AcquisitionFileType) {
    AcquisitionFileTypeImage = 0,
    AcquisitionFileTypePDF = 1,
};

@interface AcquisitionImageGroupView : UIView

@property (nonatomic, weak) id<AcquisitionImageGroupViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL required;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;
/// File IDs for persistence (comma-separated when saved)
@property (nonatomic, strong) NSMutableArray<NSString *> *imageIds;
/// File URLs for display (resolved from IDs)
@property (nonatomic, strong) NSMutableArray<NSString *> *imageUrls;
/// File types corresponding to imageUrls (image or PDF)
@property (nonatomic, strong) NSMutableArray<NSNumber *> *fileTypes;
@property (nonatomic, assign) NSInteger tag;
/// Is view mode (read-only, hide add/delete buttons)
@property (nonatomic, assign) BOOL isViewMode;

- (void)reloadImages;

/// Set image IDs from comma-separated string and resolve URLs via API
/// @param idString Comma-separated file IDs (e.g., "123,456,789")
/// @param completion Called after URLs are resolved and UI is updated
- (void)setImageIdsFromString:(NSString *)idString completion:(void (^_Nullable)(void))completion;

/// Get comma-separated string of file IDs for persistence
- (NSString *)getImageIdsString;

/// Legacy method for backward compatibility (treats input as URLs, not IDs)
- (void)setImageUrlsFromString:(NSString *)urlString;
- (NSString *)getImageUrlsString;

/// Calculate the required height based on current content
- (CGFloat)calculateContentHeight;

/// Add a PDF file with ID and URL
- (void)addPDFWithId:(NSString *)fileId url:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
