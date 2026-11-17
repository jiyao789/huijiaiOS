//
//  ContractListModel.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/4.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ContractListModel.h"

@implementation ContractUnitModel

@end

@implementation ContractListModel

- (NSString *)rentalString
{
    float price = _rental / 100;
    NSString *rentString = [NSString stringWithFormat:@"¥%.2f/月",price];
    return rentString;
}

- (NSString *)statusString
{
    NSString *statusStr = @"";
    switch (_status) {
        case 0:
            statusStr = @"合同待审核";
            break;
        case 1:
            statusStr = _rent_again == 0 ? @"新签审批中" : @"续签审批中";
            break;
        case 2:
            statusStr = @"合同生效中";
            break;
        case 3:
            statusStr = @"合同已拒绝";
            break;
        case 4:
            statusStr = @"合同已完结";
            break;
        case 5:
            statusStr = @"合同已到期";
            break;
        case 6:
            statusStr = @"待签约";
            break;
        case 7:
            statusStr = @"合同待生效";
            break;
        default:
            break;
    }
    return statusStr;
}

- (UIColor *)statusColor
{
    UIColor *statusColorStr;
    switch (_status) {
        case 0:
            statusColorStr = [UIColor colorWithHexString:@"#66D39A"];
            break;
        case 1:
            statusColorStr = [UIColor colorWithHexString:@"#E78E28"];
            break;
        case 2:
            statusColorStr = [UIColor colorWithHexString:@"#B7B7B7"];
            break;
        case 3:
            statusColorStr = [UIColor colorWithHexString:@"#B7B7B7"];
            break;
        case 4:
            statusColorStr = [UIColor colorWithHexString:@"#B7B7B7"];
            break;
        case 5:
            statusColorStr = [UIColor colorWithHexString:@"#B7B7B7"];
            break;
        case 6:
            statusColorStr = [UIColor colorWithHexString:@"#66D39A"];
            break;
        case 7:
            statusColorStr = [UIColor colorWithHexString:@"#2F72F6"];
            break;
        default:
            break;
    }
    return statusColorStr;
}

@end
