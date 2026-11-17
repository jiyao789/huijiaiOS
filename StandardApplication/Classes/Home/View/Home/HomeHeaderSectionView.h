//
//  HomeHeaderSectionView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/19.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "ChooseClassifyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeHeaderSectionView : UIView
@property (weak, nonatomic) IBOutlet ChooseClassifyView *classifyView;

@end

NS_ASSUME_NONNULL_END
