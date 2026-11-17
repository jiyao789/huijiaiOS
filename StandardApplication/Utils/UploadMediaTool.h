//
//  UploadMediaTool.h
//  StandardApplication
//
//  Created by liyuanbo on 2020/4/7.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, UploadMediaSupportType) {
    UploadMediaSupportTypeImage = 1 << 1, // 图片
    UploadMediaSupportTypeVideo = 1 << 2, // 视频
    UploadMediaSupportTypeAll   = ~0UL    //全部
};

@interface UploadMediaToolConfig : NSObject

/**
 视频时长限制，单位分钟；0表示任意 default is 0
 */
@property (nonatomic, assign) NSInteger video;
/**
 图片尺寸限制，单位M；0表示任意 defalut is 0
 */
@property (nonatomic, assign) NSInteger image;
/**
 video/image/all default is all
 */
@property (nonatomic, copy)   NSString *type;

@end

@interface UploadMediaTool : NSObject

+ (void)uploadWithConfig:(void (^) (UploadMediaToolConfig * mediaConfig))config
          finishedHandle:(void (^) (NSArray * mediaUrls,NSString * errorMsg))finishedHandle;

@end


