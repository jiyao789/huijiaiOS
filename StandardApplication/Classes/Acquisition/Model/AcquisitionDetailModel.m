//
//  AcquisitionDetailModel.m
//  StandardApplication
//
//  Property acquisition declaration detail model
//

#import "AcquisitionDetailModel.h"
#import "MJExtension.h"

@implementation AcquisitionDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"itemId": @"id",
        @"declareTime": @"declare_time",
        // Basic info
        @"ownerName": @"owner_name",
        @"typeOther": @"type_other",
        @"certificateNumber": @"certificate_number",
        @"addressRoad": @"address_road",
        @"addressNong": @"address_nong",
        @"addressHao": @"address_hao",
        @"addressShi": @"address_shi",
        @"ownershipType": @"ownership_type",
        @"ownershipShare": @"ownership_share",
        @"exceptionStatus": @"exception_status",
        @"liveStatus": @"live_status",
        @"liveInfo": @"live_info",
        @"mortgageStatus": @"mortgage_status",
        @"mortgageInfo": @"mortgage_info",
        @"hukouStatus": @"hukou_status",
        @"hukouNum": @"hukou_num",
        @"requesterName": @"name",
        @"requesterPhoneNum": @"phone_number",
        @"relationshipOther": @"relationship_other",
        // Documents
        @"certificateFile": @"certificate_file",
        @"registerFile": @"register_file",
        @"ownerIdcardFile": @"owner_idcard_file",
        @"requesterIdcardFile": @"requester_idcard_file",
        @"hukouFile": @"hukou_file",
        // Price
        @"floorPrice": @"floor_price",
        @"ceilingPrice": @"ceiling_price",
        // Status
        @"rejectReason": @"reject_reason"
    };
}

- (NSString *)getTypeString {
    switch (_type) {
        case 1:
            return @"商品房";
        case 2:
            return @"公有住房";
        case 3:
            return _typeOther.length > 0 ? _typeOther : @"其他";
        default:
            return @"";
    }
}

- (NSString *)getFullAddress {
    // If we have the full address from API, return it
    if (_address.length > 0) {
        return _address;
    }
    // Otherwise build from components
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

- (void)parseAddressComponents {
    // If components are already set, don't override
    if (_addressRoad.length > 0 || _addressNong.length > 0 || _addressHao.length > 0 || _addressShi.length > 0) {
        return;
    }

    // Parse full address string like "XX路XX弄XX号XX室"
    if (_address.length == 0) {
        return;
    }

    NSString *addr = _address;

    // Extract road (路)
    NSRange roadRange = [addr rangeOfString:@"路"];
    if (roadRange.location != NSNotFound) {
        _addressRoad = [addr substringToIndex:roadRange.location];
        addr = [addr substringFromIndex:roadRange.location + roadRange.length];
    }

    // Extract nong (弄)
    NSRange nongRange = [addr rangeOfString:@"弄"];
    if (nongRange.location != NSNotFound) {
        _addressNong = [addr substringToIndex:nongRange.location];
        addr = [addr substringFromIndex:nongRange.location + nongRange.length];
    }

    // Extract hao (号)
    NSRange haoRange = [addr rangeOfString:@"号"];
    if (haoRange.location != NSNotFound) {
        _addressHao = [addr substringToIndex:haoRange.location];
        addr = [addr substringFromIndex:haoRange.location + haoRange.length];
    }

    // Extract shi (室)
    NSRange shiRange = [addr rangeOfString:@"室"];
    if (shiRange.location != NSNotFound) {
        _addressShi = [addr substringToIndex:shiRange.location];
    } else if (addr.length > 0) {
        // If no 室, the remaining part might be the room number
        _addressShi = addr;
    }
}

- (NSString *)getOwnershipTypeString {
    if (_ownershipType == 0) {
        return @"单独所有";
    } else if (_ownershipType == 1) {
        return [NSString stringWithFormat:@"共同共有 %@", _ownershipShare ?: @""];
    }
    return @"";
}

- (NSString *)getRelationshipString {
    switch (_relationship) {
        case 1:
            return @"本人";
        case 2:
            return @"配偶";
        case 3:
            return @"父母";
        case 4:
            return @"子女";
        case 5:
            return _relationshipOther.length > 0 ? _relationshipOther : @"其他";
        default:
            return @"";
    }
}

- (NSString *)getStatusString {
    switch (_status) {
        case 0:
            return @"待审核";
        case 1:
            return @"已通过";
        case 2:
            return @"未通过";
        case 3:
            return @"已否决";
        case 4:
            return @"已撤回";
        default:
            return @"";
    }
}

@end
