//
//  AcquisitionDetailModel.h
//  StandardApplication
//
//  Property acquisition declaration detail model
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AcquisitionDetailModel : NSObject

/// Declaration ID
@property (nonatomic, assign) NSInteger itemId;
/// Declaration number
@property (nonatomic, copy) NSString *bh;
/// Declaration time
@property (nonatomic, copy) NSString *declareTime;

#pragma mark - Basic Info
/// Property owner name
@property (nonatomic, copy) NSString *ownerName;
/// Property type: 1-Commercial Housing, 2-Public Housing, 3-Other
@property (nonatomic, assign) NSInteger type;
/// Other type description
@property (nonatomic, copy) NSString *typeOther;
/// Certificate number
@property (nonatomic, copy) NSString *certificateNumber;
/// Full address from API
@property (nonatomic, copy) NSString *address;
/// Address - Road
@property (nonatomic, copy) NSString *addressRoad;
/// Address - Nong (Lane)
@property (nonatomic, copy) NSString *addressNong;
/// Address - Hao (Number)
@property (nonatomic, copy) NSString *addressHao;
/// Address - Shi (Room)
@property (nonatomic, copy) NSString *addressShi;
/// Building area
@property (nonatomic, copy) NSString *size;
/// Ownership type
@property (nonatomic, assign) NSInteger ownershipType;
/// Ownership share
@property (nonatomic, copy) NSString *ownershipShare;
/// Exception status
@property (nonatomic, assign) NSInteger exceptionStatus;
/// Residence right
@property (nonatomic, assign) NSInteger liveStatus;
/// Residence right details
@property (nonatomic, copy) NSString *liveInfo;
/// Mortgage status
@property (nonatomic, assign) NSInteger mortgageStatus;
/// Mortgage details
@property (nonatomic, copy) NSString *mortgageInfo;
/// Household registration status
@property (nonatomic, assign) NSInteger hukouStatus;
/// Number of people registered
@property (nonatomic, assign) NSInteger hukouNum;
/// Applicant name
@property (nonatomic, copy) NSString *requesterName;
/// Applicant phone number
@property (nonatomic, copy) NSString *requesterPhoneNum;
/// Relationship
@property (nonatomic, assign) NSInteger relationship;
/// Other relationship description
@property (nonatomic, copy) NSString *relationshipOther;

#pragma mark - Documents
/// Property certificate files
@property (nonatomic, copy) NSString *certificateFile;
/// Registration record
@property (nonatomic, copy) NSString *registerFile;
/// Owner ID card
@property (nonatomic, copy) NSString *ownerIdcardFile;
/// Applicant ID card
@property (nonatomic, copy) NSString *requesterIdcardFile;
/// Household registration book
@property (nonatomic, copy) NSString *hukouFile;

#pragma mark - Price
/// Minimum price
@property (nonatomic, copy) NSString *floorPrice;
/// Maximum price
@property (nonatomic, copy) NSString *ceilingPrice;

#pragma mark - Status
/// Status: 0-Pending, 1-Approved, 2-Rejected, 3-Vetoed
@property (nonatomic, assign) NSInteger status;
/// Progress: 1-Initial Review, 2-Final Review, 3-Completed
@property (nonatomic, assign) NSInteger progress;
/// Reject reason
@property (nonatomic, copy) NSString *rejectReason;

#pragma mark - Helper Methods
/// Get property type string
- (NSString *)getTypeString;
/// Get full address
- (NSString *)getFullAddress;
/// Parse address string into components (road, nong, hao, shi)
- (void)parseAddressComponents;
/// Get ownership type string
- (NSString *)getOwnershipTypeString;
/// Get relationship string
- (NSString *)getRelationshipString;
/// Get status string
- (NSString *)getStatusString;

@end

NS_ASSUME_NONNULL_END
