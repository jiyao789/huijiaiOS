//
//  YBWaterFlowLayout.h
//  StandardApplication
//
//  Created by liyuanbo on 2020/7/18.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBWaterFlowLayout;
@protocol YBWaterFlowLayoutDelegate <NSObject>

@required
- (CGFloat)waterflowLayout:(YBWaterFlowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGSize)waterflowLayout:(YBWaterFlowLayout *)waterflowLayout sizeOfHeaderInSection:(NSInteger)section;

@end

@interface YBWaterFlowLayout : UICollectionViewLayout

@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 段头的size */
@property (nonatomic, assign) CGSize headerReferenceSize;
/** 每一列之间的间距 */
@property (nonatomic, assign) CGFloat columnMargin;
/** 每一行之间的间距 */
@property (nonatomic, assign) CGFloat rowMargin;
/** 显示多少列 */
@property (nonatomic, assign) int columnsCount;

@property (nonatomic, weak) id<YBWaterFlowLayoutDelegate> delegate;

@end


