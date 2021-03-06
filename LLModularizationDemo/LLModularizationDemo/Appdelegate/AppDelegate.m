//
//  AppDelegate.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/7.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "AppDelegate.h"
#import "LLTabBarController.h"

#import "NSObject+CrashCatch.h"
#import <LLModularization/LLModule.h>
#import "callStackManager.h"

@interface AppDelegate ()

@property (nonatomic, assign) NSInteger callStackSamplingNum;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[LLTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    
    [NSObject initCrashCatchHandler];
    [callStackManager sendIfNeedWhenLanuch];
    [self initModularization];
    
    return YES;
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
    // save + 一定条件的send(即最简单的取样)
    [callStackManager saveCallStackWithType:callStackSubmitTypeSampling];
    if (_callStackSamplingNum%10 == 0) {
        [callStackManager sendCallStack];
    }
}

#pragma mark - Private Method

- (void)initModularization {
    [self checkModularization];
    [self generateRandomNumber];
}

- (void)checkModularization {
    NSArray *missingServices = [[LLModule sharedInstance] checkRelyService];
    if (missingServices.count > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未注册的服务" message:[missingServices description] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)generateRandomNumber {
    _callStackSamplingNum = arc4random() % 10;
}

@end
