//
//  NSObject+TABPerformSelector.h
//  AnimatedDemo
//
//  Created by 安文虎 on 2020/6/11.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TABPerformSelector)

//- (void *)tab_performSelector:(SEL)selecor target:(id)target ,...;
//- (void *)tab_performSelector:(SEL)selecor withObject:(void *)object;
//- (void *)tab_performSelector:(SEL)selecor withObject:(void *)object1 withObject:(void *)object2;

- (id)tab_performSelector:(SEL)selector withObject:(id)object;
- (id)tab_performSelector:(SEL)selector withObject:(id)object withArg:(void *)arg;

- (void *)sendMessageBySel:(SEL)selector object1:(void *)object1 object2:(void *)object2 object3:(void *)object3;
- (void *)sendMessageBySel:(SEL)selector object1:(void *)object1 object2:(void *)object2;

@end

NS_ASSUME_NONNULL_END
