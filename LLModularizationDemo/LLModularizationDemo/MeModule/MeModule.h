//
//  MeModule.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/4/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeModuleProtocol.h"

#import <LLModularization/LLModule.h>

@interface MeModule : NSObject <MeModuleProtocol>

+ (instancetype)sharedModule;

@end
