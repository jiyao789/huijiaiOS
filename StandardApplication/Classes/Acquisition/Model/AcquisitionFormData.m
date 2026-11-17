//
//  AcquisitionFormData.m
//  StandardApplication
//
//  Property acquisition declaration form data singleton
//

#import "AcquisitionFormData.h"

@implementation AcquisitionFormData

+ (instancetype)sharedInstance {
    static AcquisitionFormData *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AcquisitionFormData alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self clear];
    }
    return self;
}

- (void)clear {
    _ownerName = @"";
    _type = 0;
    _typeOther = @"";
    _certificateNumber = @"";
    _addressRoad = @"";
    _addressNong = @"";
    _addressHao = @"";
    _addressShi = @"";
    _size = @"";
    _ownershipType = nil;
    _ownershipShare = @"";
    _exceptionStatus = nil;
    _liveStatus = nil;
    _liveInfo = @"";
    _mortgageStatus = nil;
    _mortgageInfo = @"";
    _hukouStatus = nil;
    _hukouNum = nil;
    _requesterName = @"";
    _requesterPhoneNum = @"";
    _relationship = 0;
    _relationshipOther = @"";

    _certificateFile = @"";
    _registerFile = @"";
    _ownerIdcardFile = @"";
    _requesterIdcardFile = @"";
    _hukouFile = @"";

    _floorPrice = @"";
    _ceilingPrice = @"";

    _declarationId = 0;
    _isEditMode = NO;
    _isViewMode = NO;
}

- (NSString *)getDeclareTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)getFullAddress {
    NSMutableString *address = [NSMutableString string];
    if (_addressRoad.length > 0) {
        [address appendFormat:@"%@路", _addressRoad];
    }
    if (_addressNong.length > 0) {
        [address appendFormat:@"%@弄", _addressNong];
    }
    if (_addressHao.length > 0) {
        [address appendFormat:@"%@号", _addressHao];
    }
    if (_addressShi.length > 0) {
        [address appendFormat:@"%@室", _addressShi];
    }
    return address;
}

- (NSDictionary *)toRequestParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    // Basic info
    params[@"ownerName"] = _ownerName ?: @"";
    params[@"type"] = @(_type);
    if (_type == 3 && _typeOther.length > 0) {
        params[@"typeOther"] = _typeOther;
    }
    params[@"certificateNumber"] = _certificateNumber ?: @"";
    params[@"address"] = [self getFullAddress];
    params[@"size"] = _size ?: @"";

    if (_ownershipType) {
        // API: 1=单独所有, 2=共同所有, 3=按份所有
        params[@"ownershipType"] = _ownershipType;
        if ([_ownershipType integerValue] == 3 && _ownershipShare.length > 0) {
            params[@"ownershipShare"] = _ownershipShare;
        }
    }

    if (_exceptionStatus) {
        // API: 1=无异常, 2=有异常
        params[@"exceptionStatus"] = _exceptionStatus;
    }

    if (_liveStatus) {
        // API: 1=无居住, 2=有居住
        params[@"liveStatus"] = _liveStatus;
        if ([_liveStatus integerValue] == 2 && _liveInfo.length > 0) {
            params[@"liveInfo"] = _liveInfo;
        }
    }

    if (_mortgageStatus) {
        // API: 1=无抵押, 2=有抵押
        params[@"mortgageStatus"] = _mortgageStatus;
        if ([_mortgageStatus integerValue] == 2 && _mortgageInfo.length > 0) {
            params[@"mortgageInfo"] = _mortgageInfo;
        }
    }

    if (_hukouStatus) {
        // API: 1=无户口, 2=有户口
        params[@"hukouStatus"] = _hukouStatus;
        if ([_hukouStatus integerValue] == 2 && _hukouNum) {
            params[@"hukouNum"] = _hukouNum;
        }
    }

    params[@"requesterName"] = _requesterName ?: @"";
    params[@"requesterPhoneNum"] = _requesterPhoneNum ?: @"";
    params[@"relationship"] = @(_relationship);
    if (_relationship == 5 && _relationshipOther.length > 0) {
        params[@"relationshipOther"] = _relationshipOther;
    }

    // Documents
    params[@"certificateFile"] = _certificateFile ?: @"";
    params[@"registerFile"] = _registerFile ?: @"";
    params[@"ownerIdcardFile"] = _ownerIdcardFile ?: @"";
    params[@"requesterIdcardFile"] = _requesterIdcardFile ?: @"";
    if (_hukouFile.length > 0) {
        params[@"hukouFile"] = _hukouFile;
    }

    // Price
    params[@"floorPrice"] = _floorPrice ?: @"";
    params[@"ceilingPrice"] = _ceilingPrice ?: @"";

    // Declare time
    params[@"declareTime"] = [self getDeclareTime];

    return params;
}

@end
