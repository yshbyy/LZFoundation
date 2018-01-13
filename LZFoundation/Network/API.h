//
//  API.h
//  LZFoundation
//
//  Created by yshbyy on 2017/12/13.
//  Copyright © 2017年 counter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APIResult;

@interface API : NSObject

+ (void)initAPI;
+ (void)requestOnlineStatus:(void(^)(APIResult *result))completionHandler;

@end

@interface APIResult : NSObject

@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *jpushAppKey;

@end
