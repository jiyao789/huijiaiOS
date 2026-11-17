//
//  AcquisitionFormData.h
//  StandardApplication
//
//  Property acquisition declaration form data singleton
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AcquisitionFormData : NSObject

+ (instancetype)sharedInstance;
- (void)clear;
- (NSString *)getDeclareTime;
- (NSString *)getFullAddress;
- (NSDictionary *)toRequestParams;

#pragma mark - Step1: Basic Info
/// Property owner name
@property (nonatomic, copy) NSString *ownerName;
/// Property type: 1-Commercial Housing, 2-Public Housing, 3-Other
@property (nonatomic, assign) NSInteger type;
/// Other type description
@property (nonatomic, copy) NSString *typeOther;
/// Certificate number
@property (nonatomic, copy) NSString *certificateNumber;
/// Address - Road
@property (nonatomic, copy) NSString *addressRoad;
/// Address - Nong (Lane)
@property (nonatomic, copy) NSString *addressNong;
/// Address - Hao (Number)
@property (nonatomic, copy) NSString *addressHao;
/// Address - Shi (Room)
@property (nonatomic, copy) NSString *addressShi;
/// Building area (square meters)
@property (nonatomic, copy) NSString *size;
/// Ownership type: 1-Sole ownership, 2-Shared ownership, 3-By share
@property (nonatomic, strong) NSNumber *ownershipType;
/// Ownership share (required when ownershipType=3)
@property (nonatomic, copy) NSString *ownershipShare;
/// Exception status (seized/objection): 1-No, 2-Yes
@property (nonatomic, strong) NSNumber *exceptionStatus;
/// Residence right: 1-No, 2-Yes
@property (nonatomic, strong) NSNumber *liveStatus;
/// Residence right details (required when liveStatus=2)
@property (nonatomic, copy) NSString *liveInfo;
/// Mortgage status: 1-No, 2-Yes
@property (nonatomic, strong) NSNumber *mortgageStatus;
/// Mortgage details (required when mortgageStatus=2)
@property (nonatomic, copy) NSString *mortgageInfo;
/// Household registration status: 1-No, 2-Yes
@property (nonatomic, strong) NSNumber *hukouStatus;
/// Number of people registered
@property (nonatomic, strong) NSNumber *hukouNum;
/// Applicant name
@property (nonatomic, copy) NSString *requesterName;
/// Applicant phone number
@property (nonatomic, copy) NSString *requesterPhoneNum;
/// Relationship: 1-Self, 2-Spouse, 3-Parent, 4-Child, 5-Other
@property (nonatomic, assign) NSInteger relationship;
/// Other relationship description
@property (nonatomic, copy) NSString *relationshipOther;

#pragma mark - Step2: Documents (File IDs separated by comma)
/// Property certificate files (img_id, comma-separated)
@property (nonatomic, copy) NSString *certificateFile;
/// Registration record (img_id, comma-separated)
@property (nonatomic, copy) NSString *registerFile;
/// Owner ID card (img_id, comma-separated)
@property (nonatomic, copy) NSString *ownerIdcardFile;
/// Applicant ID card (img_id, comma-separated)
@property (nonatomic, copy) NSString *requesterIdcardFile;
/// Household registration book (img_id, comma-separated)
@property (nonatomic, copy) NSString *hukouFile;

#pragma mark - Step3: Price
/// Minimum price
@property (nonatomic, copy) NSString *floorPrice;
/// Maximum price
@property (nonatomic, copy) NSString *ceilingPrice;

#pragma mark - Edit Mode
/// Declaration ID (for editing existing declaration)
@property (nonatomic, assign) NSInteger declarationId;
/// Is edit mode (for resubmitting)
@property (nonatomic, assign) BOOL isEditMode;
/// Is view mode (read-only, all inputs disabled)
@property (nonatomic, assign) BOOL isViewMode;

@end

NS_ASSUME_NONNULL_END
