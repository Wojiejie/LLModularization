//
//  LLModuleCallStackManager.m
//  LLModularization
//
//  Created by 李林 on 12/19/17.
//

#import "LLModuleCallStackManager.h"
#import "LLModuleUtils.h"
#import "StackForNSObject.h"
#import "LLModuleTree.h"

#pragma mark - LLModuleTreeCallStack

@implementation LLModuleCallStackItem

- (instancetype)initWithModuleCallChain:(NSArray *)callChain
                             andService:(NSString *)service
                         andServiceType:(LLModuleTreeServiceType)serviceType {
    if (self = [super init]) {
        _moduleCallChain = callChain;
        _service = service;
        _serviceType = serviceType;
    }
    return self;
}

- (NSString *)description {
    NSString *callChainStr = [_moduleCallChain componentsJoinedByString:@"->"];
    return [NSString stringWithFormat:@"<callChain = %@, service = %@, serviceType = %@>", callChainStr, _service, [self formatToString:_serviceType]];
}

- (NSString *)formatToString:(LLModuleTreeServiceType)type {
    NSString *result = nil;
    
    switch (type) {
        case LLModuleTreeServiceTypeForeground:
            result = @"Foreground";
            break;
        case LLModuleTreeServiceTypeBackground:
            result = @"Background";
            break;
        default:
            result = @"None";
            break;
    }
    
    return result;
}

@end

@interface LLModuleCallStackManager()

@property (nonatomic, strong) StackForNSObject *stack;

@end

@implementation LLModuleCallStackManager

#pragma mark - sharedManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static LLModuleCallStackManager *sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[LLModuleCallStackManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Lazy Load

- (StackForNSObject *)stack {
    if (!_stack) {
        _stack = [[StackForNSObject alloc] init];
    }
    return _stack;
}

#pragma mark - get & append

+ (NSArray *)getModuleCallStack {
    return [[LLModuleCallStackManager sharedManager] getModuleCallStack];
}

+ (void)appendCallStackItemWithCallerConnector:(NSString *)callerConnector
                               calleeConnector:(NSString *)calleeConnector
                                 moduleService:(NSString *)service
                                   serviceType:(LLModuleTreeServiceType)type {
    [[LLModuleCallStackManager sharedManager] appendCallStackItemWithCallerConnector:callerConnector calleeConnector:calleeConnector moduleService:service serviceType:type];
}

+ (void)popPage:(NSString *)page withPopType:(LLModuleTreePopType)type{
    [[LLModuleCallStackManager sharedManager] popPage:page withPopType:type];
}

#pragma mark - Private Method

- (NSArray *)getModuleCallStack {
    return [self.stack getAllObjects];
}

- (void)appendCallStackItemWithCallerConnector:(NSString *)callerConnector
                               calleeConnector:(NSString *)calleeConnector
                                 moduleService:(NSString *)service
                                   serviceType:(LLModuleTreeServiceType)type {
    if (!callerConnector || !calleeConnector || [LLModuleUtils isNilOrEmtpyForString:service]) {
        NSLog(@"Append Failured. Connector or service is nil.");
        return ;
    }
    
    NSArray *callChainArray = [LLModuleTree appendCaller:callerConnector andCallee:calleeConnector];
    LLModuleCallStackItem *stackItem = [[LLModuleCallStackItem alloc] initWithModuleCallChain:callChainArray andService:service andServiceType:type];
    NSLog(@"%@", stackItem);
    
    [self.stack pushObj:stackItem];
}

- (void)popPage:(NSString *)page withPopType:(LLModuleTreePopType)type{
    NSArray *callChainArray = [LLModuleTree popPage:page];
    LLModuleCallStackItem *stackItem = [[LLModuleCallStackItem alloc] initWithModuleCallChain:callChainArray andService:[self formatToString:type] andServiceType:LLModuleTreeServiceTypeForeground];
    NSLog(@"%@", stackItem);
    
    [self.stack pushObj:stackItem];
}

#pragma mark - Private Method

- (NSString *)formatToString:(LLModuleTreePopType)popType {
    NSString *result = nil;
    
    switch (popType) {
        case LLModuleTreePopTypePop:
            result = @"pop";
            break;
        case LLModuleTreePopTypeDismiss:
            result = @"dismiss";
            break;
        default:
            result = @"None";
            break;
    }
    
    return result;
}

@end

