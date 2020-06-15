//
//  TABProtocolRouteManager.h
//  AnimatedDemo
//
//  Created by 安文虎 on 2020/6/11.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TABProtocolRouteType) {
    // 方法交换，AOP
    TABProtocolRouteMethodSwizzling,
    // 切换代理
    TABProtocolRouteSwitchDelegate,
};

@interface TABProtocolRouteManager : NSObject

+ (instancetype)shareInstance;

// 路由类型
@property (nonatomic, assign) TABProtocolRouteType routeType;

- (void)startRouteWithView:(UIView *)view;
- (void)stopRouteWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
