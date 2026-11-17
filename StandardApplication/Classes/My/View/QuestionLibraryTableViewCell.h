//
//  QuestionLibraryTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionLibraryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *questionLab;

@end

NS_ASSUME_NONNULL_END
