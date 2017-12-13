//
//  API.m
//  LZFoundation
//
//  Created by yshbyy on 2017/12/13.
//  Copyright © 2017年 counter. All rights reserved.
//

#import "API.h"
#import <AVOSCloud.h>

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
    
#warning 这个id每次上传前确认
    [query getObjectInBackgroundWithId:@"5a30ed88756571004327c73f" block:^(AVObject * _Nullable object, NSError * _Nullable error) {
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
}

@end
