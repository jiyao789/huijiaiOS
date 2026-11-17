//
//  CustomAnnotationView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/19.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomAnnotationView : MAAnnotationView
@property (nonatomic, readonly) CustomCalloutView *calloutView;
@end

NS_ASSUME_NONNULL_END
