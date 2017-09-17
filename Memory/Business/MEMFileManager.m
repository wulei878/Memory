//
//  MEMFileManager.m
//  Memory
//
//  Created by Owen on 2017/9/17.
//  Copyright © 2017年 owen. All rights reserved.
//

#import "MEMFileManager.h"
#import <Qiniu/QiniuSDK.h>

static NSString *const kMEMDefaultFileUrl = @"http://oweyjpqg8.bkt.clouddn.com/";
@interface MEMFileManager()
@property (nonatomic, strong) QNUploadManager *upManager;
@end

@implementation MEMFileManager
+(instancetype)sharedManager{
    static MEMFileManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MEMFileManager alloc] init];
        instance.upManager = [[QNUploadManager alloc] init];
    });
    return instance;
}
@end
