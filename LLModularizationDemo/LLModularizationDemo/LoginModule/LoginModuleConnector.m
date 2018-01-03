//
//  LoginModuleConnector.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LoginModuleConnector.h"
#import "LoginModuleMainViewController.h"

@interface LoginModuleConnector()

@end

@implementation LoginModuleConnector

#pragma mark - sharedConnector

+ (instancetype)sharedConnector {
    static dispatch_once_t onceToken;
    static LoginModuleConnector *sharedConnector = nil;
    
    dispatch_once(&onceToken, ^{
        sharedConnector = [[LoginModuleConnector alloc] init];
    });
    
    return sharedConnector;
}

#pragma mark - register

+ (void)load {
    [[LLModule sharedInstance] registerServiceWithServiceName:NSStringFromSelector(@selector(openLoginModuleWithParams:)) URLPattern:@"ll://login/:query.html" instance:NSStringFromClass(self)];
}


#pragma mark - LLModuleProtocol

- (void)initModule {
    NSLog(@"init Login Module.");
}

- (void)destroyModule {
    NSLog(@"destroy Login Module.");
}

- (void)callServiceWithURL:(NSString *)url
                parameters:(NSDictionary *)params
            navigationMode:(LLModuleNavigationMode)mode
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure {
    
}

+ (NSArray *)relyService {
//    return @[@"ll://login/:query.html"];
    return @[];
}

#pragma mark - LoginModuleProtocol

+ (UIViewController *)openLoginModuleWithParams:(NSDictionary *)params {
    LoginModuleMainViewController *loginVC = [[LoginModuleMainViewController alloc] init];
    
    NSLog(@"params : %@", params);
    NSString *username = params[LoginModule_UserName];
    NSString *password = params[LoginModule_Password];
    [loginVC updateWithUserName:username password:password];
    
    return loginVC;
}

@end
