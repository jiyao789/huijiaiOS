//
//  AcquisitionProgressModel.h
//  StandardApplication
//
//  Property acquisition declaration progress model
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AcquisitionProgressItem : NSObject

/// Progress type: 1-Initial Review, 2-Final Review, 3-Completed
@property (nonatomic, assign) NSInteger progressType;
/// Progress status: 0-Pending, 1-Approved, 2-Rejected, 3-Vetoed, 4-Withdrawn
@property (nonatomic, assign) NSInteger progressStatus;
/// Create time (milliseconds timestamp)
@property (nonatomic, assign) long long createTime;
/// Remark/Reason
@property (nonatomic, copy) NSString *remark;
/// 审核意见
@property (nonatomic, copy) NSString *postscript;
/// 上传材料（英文逗号分隔的img_id）
@property (nonatomic, copy) NSString *attachment;
/// 解析后的附件URL数组
@property (nonatomic, strong) NSArray<NSString *> *attachmentUrls;

/// Get progress type string
- (NSString *)getProgressTypeString;
/// Get progress status string
- (NSString *)getProgressStatusString;
/// Get formatted time string
- (NSString *)getFormattedTime;

@end

@interface AcquisitionProgressModel : NSObject

/// Progress items array
@property (nonatomic, strong) NSArray<AcquisitionProgressItem *> *progressList;

@end

NS_ASSUME_NONNULL_END
