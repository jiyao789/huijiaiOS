//
//  HouseConfigCollectionViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "HouseConfigCollectionViewCell.h"
#import "MacroDefine.h"

@implementation HouseConfigCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setPointDic:(NSDictionary *)pointDic
{
    _pointDic = pointDic;
    _configImageView.image = [UIImage imageNamed:NONullString(_pointDic[@"name"])];
    _configNameLab.text = NONullString(_pointDic[@"name"]);
}
@end
