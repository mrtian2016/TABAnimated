//
//  TABProtocolRouteManager.m
//  AnimatedDemo
//
//  Created by 安文虎 on 2020/6/11.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABProtocolRouteManager.h"
#import "TABTableProtocolRoute.h"

@interface TABProtocolRouteManager()

@property (nonatomic, strong) TABTableProtocolRoute *tableRoute;

@end

@implementation TABProtocolRouteManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static id object = nil;
    dispatch_once(&onceToken, ^{
        object = [[self.class alloc] init];
    });
    return object;
}

- (void)startRouteWithView:(UIView *)view {
    [self.tableRoute startRouteWithRouteType:_routeType tableView:(UITableView *)view];
}

- (void)stopRouteWithView:(UIView *)view {
    [self.tableRoute stopRouteWithRouteType:_routeType tableView:(UITableView *)view];
}

#pragma mark - Getter/Setter

- (TABTableProtocolRoute *)tableRoute {
    if (!_tableRoute) {
        _tableRoute = TABTableProtocolRoute.new;
    }
    return _tableRoute;
}

@end
