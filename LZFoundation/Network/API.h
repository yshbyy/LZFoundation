//
//  API.h
//  LZFoundation
//
//  Created by yshbyy on 2017/12/13.
//  Copyright © 2017年 counter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject

+ (void)initAPI;
+ (void)requestOnlineStatus:(void(^)(BOOL isOnline, NSString *urlString))completionHandler;

@end
