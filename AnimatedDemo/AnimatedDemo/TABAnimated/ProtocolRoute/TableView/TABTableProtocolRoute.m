//
//  TABTableProtocolRoute.m
//  AnimatedDemo
//
//  Created by 安文虎 on 2020/6/11.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABTableProtocolRoute.h"
#import "NSObject+TABPerformSelector.h"
#import <objc/runtime.h>

@interface TABTableProtocolRoute()

@property (nonatomic, assign) BOOL classIsPrepare;

@end

@implementation TABTableProtocolRoute

#pragma mark -

- (void)startRouteWithRouteType:(TABProtocolRouteType)routeType tableView:(UITableView *)tableView {
    if (routeType == TABProtocolRouteMethodSwizzling) {
        
    }else if (routeType == TABProtocolRouteSwitchDelegate) {
        [self _prepareRoute:tableView];
        tableView.tabAnimated.oldDelegate = tableView.delegate;
        tableView.tabAnimated.oldDataSource = tableView.dataSource;
        id newObject = tableView.tabAnimated.exchangeClas.new;
        tableView.delegate = newObject;
        tableView.dataSource = newObject;
    }
}

- (void)stopRouteWithRouteType:(TABProtocolRouteType)routeType tableView:(UITableView *)tableView {
    if (routeType == TABProtocolRouteMethodSwizzling) {
        
    }else if (routeType == TABProtocolRouteSwitchDelegate) {
        tableView.delegate = tableView.tabAnimated.oldDelegate;
        tableView.dataSource = tableView.tabAnimated.oldDataSource;
    }
}

- (void)_prepareRoute:(UITableView *)tableView {
    TABViewAnimated *tabAnimated = tableView.tabAnimated;
    NSString *className = [NSString stringWithFormat:@"%@%@",@"TABAnimated_",tabAnimated.targetControllerClassName];
    const char *classNameChars = [className UTF8String];
    Class class = objc_getClass(classNameChars);
    if(!class){
        Class superClass = [NSObject class];
        class = objc_allocateClassPair(superClass, classNameChars, 0);
    }
    
    if (!class) return;
    
    tabAnimated.exchangeClas = class;

    if ([tableView.delegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        [self addMethodWithSel:@selector(numberOfSectionsInTableView:) targetClass:class];
    }
    if ([tableView.delegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        [self addMethodWithSel:@selector(tableView:numberOfRowsInSection:) targetClass:class];
    }
    if ([tableView.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        [self addMethodWithSel:@selector(tableView:heightForRowAtIndexPath:) targetClass:class];
    }
    if ([tableView.delegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        [self addMethodWithSel:@selector(tableView:cellForRowAtIndexPath:) targetClass:class];
    }
    if ([tableView.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self addMethodWithSel:@selector(tableView:willDisplayCell:forRowAtIndexPath:) targetClass:class];
    }
    if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self addMethodWithSel:@selector(tableView:didSelectRowAtIndexPath:) targetClass:class];
    }
    if ([tableView.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        [self addMethodWithSel:@selector(tableView:heightForHeaderInSection:) targetClass:class];
    }
    if ([tableView.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        [self addMethodWithSel:@selector(tableView:heightForFooterInSection:) targetClass:class];
    }
    if ([tableView.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        [self addMethodWithSel:@selector(tableView:viewForHeaderInSection:) targetClass:class];
    }
    if ([tableView.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        [self addMethodWithSel:@selector(tableView:viewForFooterInSection:) targetClass:class];
    }
//    self.classIsPrepare = YES;
}

- (void)addMethodWithSel:(SEL)sel targetClass:(Class)targetClass {
    Method newMethod = class_getInstanceMethod([self class], sel);
    IMP newIMP = method_getImplementation(newMethod);
    class_addMethod(targetClass, sel, newIMP, method_getTypeEncoding(newMethod));
}

#pragma mark - SwitchDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tableView.tabAnimated.state != TABViewAnimationStart) {
        return (NSInteger)[tabAnimated.oldDelegate performSelector:_cmd withObject:tableView];
    }

    if (tabAnimated.animatedSectionCount > 0) {
        return tabAnimated.animatedSectionCount;
    }
    
    NSInteger count = 0;
    count = (NSInteger)[tabAnimated.oldDelegate performSelector:_cmd withObject:tableView];
    if (count == 0) {
        count = tabAnimated.cellClassArray.count;
    }
    if (count == 0) return 1;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tableView.tabAnimated.state != TABViewAnimationStart || tabAnimated.runMode == TABAnimatedRunByRow) {
        NSInteger count = 0;
        void *reutrnValue = [tabAnimated.oldDelegate sendMessageBySel:_cmd object1:&tableView object2:&section];
        if (reutrnValue != nil) {
            count = *((NSInteger *)reutrnValue);
        }
        return count;
    }
    
    if (tabAnimated.animatedCount > 0) {
        return tabAnimated.animatedCount;
    }
    
    NSInteger index = [tabAnimated getIndexWithIndex:section];
    if (index < 0) {
        NSInteger count = 0;
        void *reutrnValue = [tabAnimated.oldDelegate sendMessageBySel:_cmd object1:&tableView object2:&section];
        if (reutrnValue != nil) {
            count = *((NSInteger *)reutrnValue);
        }
        return count;
    }
    return [tabAnimated.cellCountArray[index] integerValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        CGFloat count = 0;
        void *reutrnValue = [tabAnimated.oldDelegate sendMessageBySel:_cmd object1:&tableView object2:&indexPath];
        if (reutrnValue != nil) {
            count = *((CGFloat *)reutrnValue);
        }
        return count;
    }
    
    NSInteger index = [tabAnimated getIndexWithIndexPath:indexPath];
    if (index < 0) {
        CGFloat count = 0;
        void *reutrnValue = [tabAnimated.oldDelegate sendMessageBySel:_cmd object1:&tableView object2:&indexPath];
        if (reutrnValue != nil) {
            count = *((CGFloat *)reutrnValue);
        }
        return count;
    }
    return [tabAnimated.cellHeightArray[index] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        return [(NSObject *)tabAnimated.oldDelegate performSelector:@selector(tableView:cellForRowAtIndexPath:) withObject:tableView withObject:indexPath];
    }
    
    NSInteger index = [tabAnimated getIndexWithIndexPath:indexPath];
    if (index < 0) {
        return [(NSObject *)tabAnimated.oldDelegate performSelector:@selector(tableView:cellForRowAtIndexPath:) withObject:tableView withObject:indexPath];
    }
    
    Class currentClass = tabAnimated.cellClassArray[index];
    // 启动加工层
    UITableViewCell *cell = [tabAnimated.producter productWithControlView:tableView currentClass:currentClass indexPath:indexPath origin:TABAnimatedProductOriginTableViewCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        [(NSObject *)tabAnimated.oldDelegate performSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:) withObject:tableView withObject:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        [(NSObject *)tabAnimated.oldDelegate performSelector:@selector(tableView:didSelectRowAtIndexPath:) withObject:tableView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        CGFloat count = 0;
        void *reutrnValue = [tabAnimated.oldDelegate sendMessageBySel:_cmd object1:&tableView object2:&section];
        if (reutrnValue != nil) {
            count = *((CGFloat *)reutrnValue);
        }
        return count;
    }
    
    NSInteger index = [tabAnimated getHeaderIndexWithIndex:section];
    if (index < 0) {
        CGFloat count = 0;
        void *reutrnValue = [tabAnimated.oldDelegate sendMessageBySel:_cmd object1:&tableView object2:&section];
        if (reutrnValue != nil) {
            count = *((CGFloat *)reutrnValue);
        }
        return count;
    }
    return [tableView.tabAnimated.headerHeightArray[index] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        CGFloat count = 0;
        void *reutrnValue = [tabAnimated.oldDelegate sendMessageBySel:_cmd object1:&tableView object2:&section];
        if (reutrnValue != nil) {
            count = *((CGFloat *)reutrnValue);
        }
        return count;
    }
    
    NSInteger index = [tabAnimated getFooterIndexWithIndex:section];
    if (index < 0) {
        CGFloat count = 0;
        void *reutrnValue = [tabAnimated.oldDelegate sendMessageBySel:_cmd object1:&tableView object2:&section];
        if (reutrnValue != nil) {
            count = *((CGFloat *)reutrnValue);
        }
        return count;
    }
    return [tableView.tabAnimated.footerHeightArray[index] floatValue];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        return [(NSObject *)tabAnimated.oldDelegate performSelector:@selector(tableView:viewForHeaderInSection:) withObject:tableView withObject:@(section)];
    }
    
    NSInteger index = [tabAnimated getHeaderIndexWithIndex:section];
    if (index < 0) {
        return [(NSObject *)tabAnimated.oldDelegate performSelector:@selector(tableView:viewForHeaderInSection:) withObject:tableView withObject:@(section)];
    }
    
    Class class = tableView.tabAnimated.headerClassArray[index];
    
    UIView *hfView;
    // 启动加工层
    TABAnimatedProductOrigin origin = [class isSubclassOfClass:[UITableViewHeaderFooterView class]] ? TABAnimatedProductOriginTableHeaderFooterViewCell : TABAnimatedProductOriginTableHeaderFooterView;
    hfView = [tabAnimated.producter productWithControlView:tableView currentClass:class indexPath:nil origin:origin];
    
    return hfView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        return [(NSObject *)tabAnimated.oldDelegate performSelector:@selector(tableView:viewForFooterInSection:) withObject:tableView withObject:@(section)];
    }
    
    NSInteger index = [tabAnimated getFooterIndexWithIndex:section];
    if (index < 0) {
        return [(NSObject *)tabAnimated.oldDelegate performSelector:@selector(tableView:viewForFooterInSection:) withObject:tableView withObject:@(section)];
    }
    
    Class class = tableView.tabAnimated.footerClassArray[index];
    
    UIView *hfView;
    // 启动加工层
    TABAnimatedProductOrigin origin = [class isSubclassOfClass:[UITableViewHeaderFooterView class]] ? TABAnimatedProductOriginTableHeaderFooterViewCell : TABAnimatedProductOriginTableHeaderFooterView;
    hfView = [tabAnimated.producter productWithControlView:tableView currentClass:class indexPath:nil origin:origin];
    
    return hfView;
}


#pragma mark - MethodSwizzling

- (NSInteger)tab_numberOfSectionsInTableView:(UITableView *)tableView {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tableView.tabAnimated.state != TABViewAnimationStart) {
        return [self tab_numberOfSectionsInTableView:tableView];
    }

    if (tabAnimated.animatedSectionCount > 0) {
        return tabAnimated.animatedSectionCount;
    }
    
    NSInteger count = [self tab_numberOfSectionsInTableView:tableView];
    if (count == 0) {
        count = tabAnimated.cellClassArray.count;
    }
    if (count == 0) return 1;
    return count;
}

- (NSInteger)tab_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tableView.tabAnimated.state != TABViewAnimationStart || tabAnimated.runMode == TABAnimatedRunByRow) {
        return [self tab_tableView:tableView numberOfRowsInSection:section];
    }
    
    if (tabAnimated.animatedCount > 0) {
        return tabAnimated.animatedCount;
    }
    
    NSInteger index = [tabAnimated getIndexWithIndex:section];
    if (index < 0) {
        return [self tab_tableView:tableView numberOfRowsInSection:section];
    }
    return [tabAnimated.cellCountArray[index] integerValue];
}

- (CGFloat)tab_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tabAnimated.state != TABViewAnimationStart) {
        return [self tab_tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    NSInteger index = [tabAnimated getIndexWithIndexPath:indexPath];
    if (index < 0) {
        return [self tab_tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return [tabAnimated.cellHeightArray[index] floatValue];
}

- (UITableViewCell *)tab_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tabAnimated.state != TABViewAnimationStart) {
        return [self tab_tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    NSInteger index = [tabAnimated getIndexWithIndexPath:indexPath];
    if (index < 0) {
        return [self tab_tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    Class currentClass = tabAnimated.cellClassArray[index];
    // 启动加工层
    UITableViewCell *cell = [tabAnimated.producter productWithControlView:tableView currentClass:currentClass indexPath:indexPath origin:TABAnimatedProductOriginTableViewCell];
    return cell;
}

- (void)tab_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tabAnimated.state != TABViewAnimationStart) {
        [self tab_tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tab_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tabAnimated.state != TABViewAnimationStart) {
        [self tab_tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tab_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView.tabAnimated.state != TABViewAnimationStart) {
        return [self tab_tableView:tableView heightForHeaderInSection:section];
    }
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    NSInteger index = [tabAnimated getHeaderIndexWithIndex:section];
    if (index < 0) {
        return [self tab_tableView:tableView heightForHeaderInSection:section];
    }
    return [tableView.tabAnimated.headerHeightArray[index] floatValue];
}

- (CGFloat)tab_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (tableView.tabAnimated.state != TABViewAnimationStart) {
        return [self tab_tableView:tableView heightForFooterInSection:section];
    }
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    NSInteger index = [tabAnimated getFooterIndexWithIndex:section];
    if (index < 0) {
        return [self tab_tableView:tableView heightForFooterInSection:section];
    }
    return [tableView.tabAnimated.footerHeightArray[index] floatValue];
}

- (nullable UIView *)tab_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView.tabAnimated.state != TABViewAnimationStart) {
        return [self tab_tableView:tableView viewForHeaderInSection:section];
    }
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    NSInteger index = [tabAnimated getHeaderIndexWithIndex:section];
    if (index < 0) {
        return [self tab_tableView:tableView viewForHeaderInSection:section];
    }
    
    Class class = tableView.tabAnimated.headerClassArray[index];
    
    UIView *hfView;
    // 启动加工层
    TABAnimatedProductOrigin origin = [class isSubclassOfClass:[UITableViewHeaderFooterView class]] ? TABAnimatedProductOriginTableHeaderFooterViewCell : TABAnimatedProductOriginTableHeaderFooterView;
    hfView = [tabAnimated.producter productWithControlView:tableView currentClass:class indexPath:nil origin:origin];
    
    return hfView;
}

- (nullable UIView *)tab_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (tableView.tabAnimated.state != TABViewAnimationStart) {
        return [self tab_tableView:tableView viewForFooterInSection:section];
    }
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    NSInteger index = [tabAnimated getFooterIndexWithIndex:section];
    if (index < 0) {
        return [self tab_tableView:tableView viewForFooterInSection:section];
    }
    
    Class class = tableView.tabAnimated.footerClassArray[index];
    
    UIView *hfView;
    // 启动加工层
    TABAnimatedProductOrigin origin = [class isSubclassOfClass:[UITableViewHeaderFooterView class]] ? TABAnimatedProductOriginTableHeaderFooterViewCell : TABAnimatedProductOriginTableHeaderFooterView;
    hfView = [tabAnimated.producter productWithControlView:tableView currentClass:class indexPath:nil origin:origin];
    
    return hfView;
}


@end
