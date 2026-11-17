//
//  UIImage+ECExtension.m
//  StandardApplication
//
//  Created by chao on 2019/11/22.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "UIImage+ECExtension.h"



@implementation UIImage (ECExtension)

+ (UIImage *)compressImageWith:(UIImage *)image
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = 320;
    float height = imageHeight/(imageWidth/width);
    
    float widthScale = imageWidth / width;
    float heightScale = imageHeight / height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    if (widthScale > heightScale)
    {
        [image drawInRect:CGRectMake(0, 0, imageWidth/heightScale, height)];
        
    }else
    {
        [image drawInRect:CGRectMake(0, 0, width, imageHeight/ widthScale)];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}



@end
