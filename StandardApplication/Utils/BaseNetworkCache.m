//
//  BaseNetworkCache.m
//  StandardApplication
//
//  Created by DTiOS on 2020/3/4.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import "BaseNetworkCache.h"
#import "IOSmd5.h"

@interface BaseNetworkCache ()

@end

@implementation BaseNetworkCache

+ (BOOL)saveJsonResponseToCacheFile:(id)jsonResponse andURL:(NSString *)URL
{
    NSDictionary *json = jsonResponse;
    if(json!=nil)
    {
        BOOL state =[NSKeyedArchiver archiveRootObject:jsonResponse toFile:[self cacheFilePathWithURL:URL]];
        if(state)
        {
            NSLog(@"缓存写入/更新成功");
        }
        return state;
    }
    return NO;
}


+(id)cacheJsonWithURL:(NSString *)URL
{
    NSString *path = [self cacheFilePathWithURL:URL];
    id cacheJson;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil] == YES) {
        cacheJson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    return cacheJson;
}


+ (NSString *)cacheFilePathWithURL:(NSString *)URL {
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"BaseNetworkCache"];
    [self checkDirectory:path];//check路径
    NSLog(@"path = %@",path);
    //文件名
    NSString *cacheFileNameString = [NSString stringWithFormat:@"URL:%@",URL];
    NSString *cacheFileName = [IOSmd5 md5:cacheFileNameString];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}


+ (void)checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}


+ (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"create cache directory failed, error = %@", error);
    } else {
        [self addDoNotBackupAttribute:path];
        
    }
}

+ (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"error to set do not backup attribute, error = %@", error);
    }
}

@end
