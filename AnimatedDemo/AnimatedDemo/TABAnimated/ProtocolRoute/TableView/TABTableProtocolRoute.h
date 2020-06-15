//
//  TABTableProtocolRoute.h
//  AnimatedDemo
//
//  Created by 安文虎 on 2020/6/11.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TABProtocolRouteManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TABTableProtocolRoute : NSObject<UITableViewDelegate, UITableViewDataSource>

- (void)startRouteWithRouteType:(TABProtocolRouteType)routeType tableView:(UITableView *)tableView;
- (void)stopRouteWithRouteType:(TABProtocolRouteType)routeType tableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
