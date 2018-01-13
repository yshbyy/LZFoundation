//
//  AppDelegate.m
//  LZFoundation
//
//  Created by yshbyy on 2017/12/13.
//  Copyright © 2017年 counter. All rights reserved.
//

#import "AppDelegate.h"
#import <JPUSHService.h>

#import "LZWebViewController.h"
#import "LoadingController.h"
#import "API.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic, strong) UIViewController *appController;
@property (nonatomic, strong) LZWebViewController *webViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化API
    [API initAPI];
    
    self.window = [[UIWindow alloc] init];
    
    [self resetRootViewController:[[LoadingController alloc] init]];
    
    [self.window makeKeyAndVisible];
    
    // 获取上架信息
    [API requestOnlineStatus:^(APIResult *result) {
        if (result && result.isOnline) {
            [self resetRootViewController:[self webViewControllerWithURLString:result.urlString]];
            [self registerRemoteNotification:launchOptions withAppKey:result.jpushAppKey];
        } else {
            [self resetRootViewController:self.appController];
        }
    }];
    
//    [self registerRemoteNotification:launchOptions ];
    
    return YES;
}

// 注册通知
- (void)registerRemoteNotification:(NSDictionary *)options withAppKey:(NSString *)appKey {
//#warning 极光key
//    NSString *appKey = @"";
    NSString *channelId = @"App Store";
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 10.0, *)) {
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
    } else {
        // Fallback on earlier versions
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:options
                           appKey:appKey
                          channel:channelId
                 apsForProduction:YES];
}

- (LZWebViewController *)webViewControllerWithURLString:(NSString *)urlString {
    self.webViewController.urlString = urlString;
    return self.webViewController;
}

- (void)resetRootViewController:(UIViewController *)newRootController {
    if (self.window.rootViewController!=newRootController) {
        self.window.rootViewController = newRootController;
    }
//    [UIView transitionWithView:self.window duration:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        BOOL oldState = [UIView areAnimationsEnabled];
//        [UIView setAnimationsEnabled:NO];
//        if (self.window.rootViewController!=newRootController) {
//            self.window.rootViewController = newRootController;
//        }
//        [UIView setAnimationsEnabled:oldState];
//    } completion:nil];
}

#pragma mark- JPUSHRegisterDelegate

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    Configration *config = [Configration sharedInstance];
//    if (config.umengAppKey.length>0) {
//        //获取deviceToken
//        [RCTUmengPush application:application didRegisterDeviceToken:deviceToken];
//    }
//
//    if (config.jpushAppKey.length>0) {
//        /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
//    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    Configration *config = [Configration sharedInstance];
//    if (config.umengAppKey.length>0) {
//        //获取远程推送消息
//        [RCTUmengPush application:application didReceiveRemoteNotification:userInfo];
//    }
//
//    if (config.jpushAppKey.length>0) {
    [JPUSHService handleRemoteNotification:userInfo];
//    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    Configration *config = [Configration sharedInstance];
//    if (config.jpushAppKey.length>0) {
//        // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
//    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - getter

- (UIViewController *)appController {
    if (!_appController) {
        _appController = [[UIViewController alloc] init];
        _appController.view.backgroundColor = [UIColor whiteColor];
    }
    return _appController;
}
- (LZWebViewController *)webViewController {
    if (!_webViewController) {
        _webViewController = [[LZWebViewController alloc] init];
    }
    return _webViewController;
}
@end
