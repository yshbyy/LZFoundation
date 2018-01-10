//
//  API.m
//  LZFoundation
//
//  Created by yshbyy on 2017/12/13.
//  Copyright © 2017年 counter. All rights reserved.
//

#import "API.h"
#import <AVOSCloud.h>

#define kKey_objectId @"objectId"
#define kKey_isOnline @"isOnline"
#define kKey_build    @"build"
#define kKey_version  @"version"
#define kKey_bundleID @"bundleID"

NSString *const kAVOSCloudAppID = @"2yDU5AvbmMIv5PkXd9Tz89d5-gzGzoHsz";
NSString *const kAVOSCloudClientKey = @"xGYbC3f4ssgmFCAYPI5bGLnY";

@implementation API

+ (void)initAPI {
    [AVOSCloud setApplicationId:kAVOSCloudAppID
                      clientKey:kAVOSCloudClientKey];
    [AVOSCloud setAllLogsEnabled:NO];
//    [AVOSCloud setlo]
}
+ (void)requestOnlineStatus:(void (^)(BOOL, NSString *))completionHandler {
    
    AVQuery *query = [AVQuery queryWithClassName:@"Lottery"];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppInfo" ofType:@"plist"];
//    NSDictionary *appInfo = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleId = [bundleInfo objectForKey:@"CFBundleIdentifier"];
    NSString *version = [bundleInfo objectForKey:@"CFBundleShortVersionString"];
    NSInteger build = [[bundleInfo objectForKey:@"CFBundleVersion"] integerValue];
    
    [query whereKey:kKey_bundleID equalTo:bundleId];
    [query whereKey:kKey_version equalTo:version];
    [query whereKey:kKey_build greaterThan:@(build)];
    
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (completionHandler) {
            if (error) {
                completionHandler(NO, nil);
            } else {
                BOOL isOnline = [object[@"isOnline"] boolValue];
                NSString *urlString = object[@"url"];
                completionHandler(isOnline, urlString);
            }
        }
    }];
//    [query getObjectInBackgroundWithId:appInfo[@"AppID"] block:^(AVObject * _Nullable object, NSError * _Nullable error) {
//
//
//    }];
}

@end
