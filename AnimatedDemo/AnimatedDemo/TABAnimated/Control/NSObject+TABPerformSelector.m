//
//  NSObject+TABPerformSelector.m
//  AnimatedDemo
//
//  Created by 安文虎 on 2020/6/11.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "NSObject+TABPerformSelector.h"
#import "TABTableProtocolRoute.h"

@implementation NSObject (TABPerformSelector)

- (id)tab_performSelector:(SEL)selector withObject:(id)object {

    if (selector == nil) return nil;
    if (![self respondsToSelector:selector]) return nil;
    
    NSMethodSignature* signature = [[self class] instanceMethodSignatureForSelector:selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature: signature];
    invocation.selector = selector;
    invocation.target = self;
    [invocation setArgument:&object atIndex:2];
    [invocation invoke];
    
    id returnVal;
    if (strcmp(signature.methodReturnType, "@") == 0) {
        [invocation getReturnValue:&returnVal];
    }
    // 需要做返回类型判断。比如返回值为常量需要包装成对象，这里仅以最简单的`@`为例
    return returnVal;
}

- (id)tab_performSelector:(SEL)selector withObject:(id)object withArg:(void *)arg {
    
    if (selector == nil) return nil;
    if (![self respondsToSelector:selector]) return nil;
    
    NSMethodSignature* signature = [[self class] instanceMethodSignatureForSelector:selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = selector;
    invocation.target = self;
    [invocation setArgument:&object atIndex:2];
    [invocation setArgument:arg atIndex:3];
    [invocation invoke];
    
    id returnVal;
    if (strcmp(signature.methodReturnType, "@") == 0) {
        [invocation getReturnValue:&returnVal];
    }
    // 需要做返回类型判断。比如返回值为常量需要包装成对象，这里仅以最简单的`@`为例
    return returnVal;
}

- (void *)sendMessageBySel:(SEL)selector object1:(void *)object1 object2:(void *)object2 object3:(void *)object3 {
    
    if (selector == nil) return nil;
    if (![self respondsToSelector:selector]) return nil;
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation setArgument:object1 atIndex:2];
    [invocation setArgument:object2 atIndex:3];
    [invocation setArgument:object3 atIndex:4];
    [invocation invoke];
    
    NSUInteger returnValueLength = signature.methodReturnLength;
    void *returnValue = (void *)malloc(returnValueLength);
    [invocation getReturnValue:returnValue];
    return returnValue;
}

- (void *)sendMessageBySel:(SEL)selector object1:(void *)object1 object2:(void *)object2 {
    
    if (selector == nil) return nil;
    if (![self respondsToSelector:selector]) return nil;
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation setArgument:object1 atIndex:2];
    [invocation setArgument:object2 atIndex:3];
    [invocation invoke];
    
    NSUInteger returnValueLength = signature.methodReturnLength;
    void *returnValue = (void *)malloc(returnValueLength);
    [invocation getReturnValue:returnValue];
    return returnValue;
}

@end
