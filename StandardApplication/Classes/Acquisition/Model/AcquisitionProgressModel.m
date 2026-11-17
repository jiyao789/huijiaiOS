//
//  AcquisitionProgressModel.m
//  StandardApplication
//
//  Property acquisition declaration progress model
//

#import "AcquisitionProgressModel.h"
#import "MJExtension.h"

@implementation AcquisitionProgressItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"progressType": @"progress_type",
        @"progressStatus": @"progress_status",
        @"createTime": @"create_time"
    };
}

- (NSString *)getProgressTypeString {
    switch (_progressType) {
        case 1:
            return @"审批程序";
        case 2:
            return @"复审";
        case 3:
            return @"完成";
        default:
            return @"提交申报";
    }
}

- (NSString *)getProgressStatusString {
    // cancelProgress has progress_type=0 and progress_status=0 to indicate cancellation
    if (_progressType == 0 && _progressStatus == 0) {
        return @"申报已被撤回";
    }

    switch (_progressStatus) {
        case 0:
            return @"您的申报材料已提交";
        case 1:
            return @"您的材料预审已通过";
        case 2:
            return @"您的材料预审已拒绝，转市场业务";
        case 3:
            return @"否您的材料预审已拒绝";
        case 4:
            return @"申报已被撤回";
        default:
            return @"";
    }
}

- (NSString *)getFormattedTime {
    if (_createTime == 0) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_createTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:date];
}

@end

@implementation AcquisitionProgressModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"progressList": [AcquisitionProgressItem class]};
}

@end
