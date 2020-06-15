//
//  TABTableAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABTableAnimated.h"

#import "TABViewAnimated.h"
#import "UIView+TABControlModel.h"
#import "UIView+TABControlAnimation.h"
#import <objc/runtime.h>
#import "NSObject+TABPerformSelector.h"

@interface TABTableAnimated()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readwrite) NSMutableArray <NSNumber *> *headerHeightArray;
@property (nonatomic, strong, readwrite) NSMutableArray <NSNumber *> *footerHeightArray;

@end

@implementation TABTableAnimated

#pragma mark - Section Mode

+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight {
    TABTableAnimated *obj = [self _animatedWithCellClass:cellClass cellHeight:cellHeight animatedCount:ceilf([UIScreen mainScreen].bounds.size.height/cellHeight*1.0) toIndex:0 runMode:TABAnimatedRunBySection];
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight
                        animatedCount:(NSInteger)animatedCount {
    TABTableAnimated *obj = [self _animatedWithCellClass:cellClass cellHeight:cellHeight animatedCount:animatedCount toIndex:0 runMode:TABAnimatedRunBySection];
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight
                            toSection:(NSInteger)section {
    TABTableAnimated *obj = [self _animatedWithCellClass:cellClass cellHeight:cellHeight animatedCount:ceilf([UIScreen mainScreen].bounds.size.height/cellHeight*1.0) toIndex:section runMode:TABAnimatedRunBySection];
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight
                        animatedCount:(NSInteger)animatedCount
                            toSection:(NSInteger)section {
    TABTableAnimated *obj = [self _animatedWithCellClass:cellClass cellHeight:cellHeight animatedCount:animatedCount toIndex:section runMode:TABAnimatedRunBySection];
    return obj;
}

+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                           cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray {
    TABTableAnimated *obj = [TABTableAnimated _animatedWithCellClassArray:cellClassArray
                                                          cellHeightArray:cellHeightArray
                                                       animatedCountArray:animatedCountArray
                                                               indexArray:nil
                                                                  runMode:TABAnimatedRunBySection];
    return obj;
}

+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                           cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray
                      animatedSectionArray:(NSArray <NSNumber *> *)animatedSectionArray {
    TABTableAnimated *obj = [TABTableAnimated _animatedWithCellClassArray:cellClassArray
                                                          cellHeightArray:cellHeightArray
                                                       animatedCountArray:animatedCountArray
                                                               indexArray:animatedSectionArray
                                                                  runMode:TABAnimatedRunBySection];
    return obj;
}

#pragma mark - Row Mode

+ (instancetype)animatedInRowModeWithCellClassArray:(NSArray <Class> *)cellClassArray
                                    cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray {
    TABTableAnimated *obj = [TABTableAnimated _animatedWithCellClassArray:cellClassArray
                                                          cellHeightArray:cellHeightArray
                                                       animatedCountArray:nil
                                                               indexArray:nil
                                                                  runMode:TABAnimatedRunByRow];
    return obj;
}

+ (instancetype)animatedInRowModeWithCellClassArray:(NSArray <Class> *)cellClassArray
                                    cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                                           rowArray:(NSArray <NSNumber *> *)rowArray {
    TABTableAnimated *obj = [TABTableAnimated _animatedWithCellClassArray:cellClassArray
                                                          cellHeightArray:cellHeightArray
                                                       animatedCountArray:nil
                                                               indexArray:rowArray
                                                                  runMode:TABAnimatedRunByRow];
    return obj;
}

+ (instancetype)animatedInRowModeWithCellClass:(Class)cellClass
                                    cellHeight:(CGFloat)cellHeight
                                         toRow:(NSInteger)row {
    TABTableAnimated *obj = [self _animatedWithCellClass:cellClass cellHeight:cellHeight animatedCount:1 toIndex:row runMode:TABAnimatedRunByRow];
    return obj;
}

#pragma mark - 自适应高度

+ (instancetype)animatedWithCellClass:(Class)cellClass {
    TABTableAnimated *obj = [[TABTableAnimated alloc] init];
    obj.cellClassArray = @[cellClass];
    obj.cellIndexArray = @[@(0)].mutableCopy;
    obj.cellCountArray = @[@(10)];
    return obj;
}

#pragma mark -

+ (instancetype)_animatedWithCellClass:(Class)cellClass
                            cellHeight:(CGFloat)cellHeight
                         animatedCount:(NSInteger)animatedCount
                               toIndex:(NSInteger)toIndex
                               runMode:(TABAnimatedRunMode)runMode {
    TABTableAnimated *obj = [[TABTableAnimated alloc] init];
    obj.runMode = runMode;
    obj.cellClassArray = @[cellClass];
    obj.cellHeightArray = @[@(cellHeight)];
    obj.cellCountArray = @[@(animatedCount)];
    obj.cellIndexArray = @[@(0)];
    [obj.runIndexDict setValue:@(0) forKey:[NSString stringWithFormat:@"%ld",(long)toIndex]];
    return obj;
}

+ (instancetype)_animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                            cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                         animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray
                                 indexArray:(NSArray <NSNumber *> *)indexArray
                                    runMode:(TABAnimatedRunMode)runMode {
    TABTableAnimated *obj = [[TABTableAnimated alloc] init];
    obj.runMode = runMode;
    obj.cellClassArray = cellClassArray;
    obj.cellHeightArray = cellHeightArray;
    obj.cellCountArray = animatedCountArray;
    if (cellClassArray.count > 0 && indexArray.count == 0) {
        NSMutableArray *newIndexArray = @[].mutableCopy;
        for (NSInteger i = 0; i < cellClassArray.count; i++) {
            NSInteger index = i;
            NSInteger value = i;
            [obj.runIndexDict setValue:@(value) forKey:[NSString stringWithFormat:@"%ld",(long)index]];
            [newIndexArray addObject:@(index)];
        }
        obj.cellIndexArray = newIndexArray.copy;
    }else {
        obj.cellIndexArray = indexArray;
        for (NSInteger i = 0; i < indexArray.count; i++) {
            NSInteger index = [indexArray[i] integerValue];
            NSInteger value = i;
            [obj.runIndexDict setValue:@(value) forKey:[NSString stringWithFormat:@"%ld",(long)index]];
        }
    }
    
    return obj;
}

- (instancetype)init {
    if (self = [super init]) {
        _headerHeightArray = @[].mutableCopy;
        _footerHeightArray = @[].mutableCopy;
    }
    return self;
}

- (CGFloat)cellHeight {
    if (self.cellHeightArray.count == 1) {
        return [self.cellHeightArray[0] floatValue];
    }
    return 44;
}

#pragma mark - Public Method

- (void)addHeaderViewClass:(__nonnull Class)headerViewClass
                viewHeight:(CGFloat)viewHeight {
    if (self.animatedSectionCount > 0) {
        for (NSInteger i = 0; i < self.animatedSectionCount; i++) {
            [self addHeaderViewClass:headerViewClass viewHeight:viewHeight toSection:i];
        }
    }
}

- (void)addHeaderViewClass:(__nonnull Class)headerViewClass
                viewHeight:(CGFloat)viewHeight
                 toSection:(NSInteger)section {
    [self.headerClassArray addObject:headerViewClass];
    [self.headerHeightArray addObject:@(viewHeight)];
    [self.runHeaderIndexDict setValue:@(self.headerClassArray.count-1) forKey:[self getStringWIthIndex:section]];
}

- (void)addFooterViewClass:(__nonnull Class)footerViewClass
                viewHeight:(CGFloat)viewHeight {
    if (self.animatedSectionCount > 0) {
        for (NSInteger i = 0; i < self.animatedSectionCount; i++) {
            [self addFooterViewClass:footerViewClass viewHeight:viewHeight toSection:i];
        }
    }
}

- (void)addFooterViewClass:(__nonnull Class)footerViewClass
                viewHeight:(CGFloat)viewHeight
                 toSection:(NSInteger)section {
    [self.footerClassArray addObject:footerViewClass];
    [self.footerHeightArray addObject:@(viewHeight)];
    [self.runFooterIndexDict setValue:@(self.footerClassArray.count-1) forKey:[self getStringWIthIndex:section]];
}

#pragma mark -

- (void)refreshWithIndex:(NSInteger)index controlView:(UIView *)controlView {
    
    UITableView *tableView = (UITableView *)controlView;
    
    self.oldDataSource = tableView.dataSource;
    self.oldDelegate = tableView.delegate;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    if (tableView.estimatedRowHeight != 0) {
        self.oldEstimatedRowHeight = tableView.estimatedRowHeight;
        tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        if (self.animatedCount == 0) {
            self.animatedCount = ceilf([UIScreen mainScreen].bounds.size.height/self.cellHeight*1.0);
        }
        tableView.rowHeight = self.cellHeight;
    }
    
    if (self.showTableHeaderView) {
        if (tableView.tableHeaderView.tabAnimated == nil) {
            tableView.tableHeaderView.tabAnimated = TABViewAnimated.new;
        }
        tableView.tableHeaderView.tabAnimated.superAnimationType = tableView.tabAnimated.superAnimationType;
        tableView.tableHeaderView.tabAnimated.canLoadAgain = tableView.tabAnimated.canLoadAgain;
        [tableView.tableHeaderView tab_startAnimation];
    }
    
    if (self.showTableFooterView) {
        if (tableView.tableFooterView.tabAnimated == nil) {
            tableView.tableFooterView.tabAnimated = TABViewAnimated.new;
        }
        tableView.tableFooterView.tabAnimated.superAnimationType = tableView.tabAnimated.superAnimationType;
        tableView.tableFooterView.tabAnimated.canLoadAgain = tableView.tabAnimated.canLoadAgain;
        [tableView.tableFooterView tab_startAnimation];
    }

    if (index == TABAnimatedIndexTag) {
        [tableView reloadData];
    }else if (self.runMode == TABAnimatedRunBySection) {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    }else if (self.runMode == TABAnimatedRunByRow) {
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)registerViewToReuse:(UIView *)view {
    UITableView *tableView = (UITableView *)view;
    [self _registerViewToReuse:tableView classArray:tableView.tabAnimated.cellClassArray containClass:UITableViewCell.class isHeaderFooter:NO];
    [self _registerViewToReuse:tableView classArray:tableView.tabAnimated.headerClassArray containClass:UITableViewHeaderFooterView.class isHeaderFooter:YES];
    [self _registerViewToReuse:tableView classArray:tableView.tabAnimated.footerClassArray containClass:UITableViewHeaderFooterView.class isHeaderFooter:YES];
}


- (void)_registerViewToReuse:(UITableView *)tableView classArray:(NSArray *)classArray containClass:(Class)containClass isHeaderFooter:(BOOL)isHeaderFooter {
    for (Class class in classArray) {
        if (class == [NSNull class]) continue;
        NSString *classString = NSStringFromClass(class);
        if ([classString containsString:@"."]) {
            NSRange range = [classString rangeOfString:@"."];
            classString = [classString substringFromIndex:range.location+1];
        }
        
        NSString *nibPath = [[NSBundle mainBundle] pathForResource:classString ofType:@"nib"];
        
        if (isHeaderFooter) {
            if (nil != nibPath && nibPath.length > 0) {
                [tableView registerNib:[UINib nibWithNibName:classString bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
            }else {
                [tableView registerClass:class forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
            }
            [tableView registerClass:containClass forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"tab_contain_%@",classString]];
        }else {
            NSString *nibPath = [[NSBundle mainBundle] pathForResource:classString ofType:@"nib"];
            if (nil != nibPath && nibPath.length > 0) {
                [tableView registerNib:[UINib nibWithNibName:classString bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
            }else {
                [tableView registerClass:class forCellReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
            }
             [tableView registerClass:containClass forCellReuseIdentifier:[NSString stringWithFormat:@"tab_contain_%@",classString]];
        }
    }
}

#pragma mark - TABTableViewDataSource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
<<<<<<< HEAD
    if (tabAnimated.state != TABViewAnimationStart) {
        [tabAnimated.oldDataSource performSelector:@selector(numbr) withObject:<#(id)#>]
        return [tabAnimated.oldDataSource numberOfSectionsInTableView:tableView];
=======
    if (tableView.tabAnimated.state != TABViewAnimationStart) {
        return [self tab_numberOfSectionsInTableView:tableView];
>>>>>>> master
    }

    if (tabAnimated.animatedSectionCount > 0) {
        return tabAnimated.animatedSectionCount;
    }
    
    NSInteger count = [tabAnimated.oldDataSource numberOfSectionsInTableView:tableView];
    if (count == 0) {
        count = tabAnimated.cellClassArray.count;
    }
    if (count == 0) return 1;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
<<<<<<< HEAD
    if (tabAnimated.state != TABViewAnimationStart || tabAnimated.runMode == TABAnimatedRunByRow) {
        return [tabAnimated.oldDataSource tableView:tableView numberOfRowsInSection:section];
=======
    if (tableView.tabAnimated.state != TABViewAnimationStart || tabAnimated.runMode == TABAnimatedRunByRow) {
        return [self tab_tableView:tableView numberOfRowsInSection:section];
>>>>>>> master
    }
    
    if (tabAnimated.animatedCount > 0) {
        return tabAnimated.animatedCount;
    }
    
    NSInteger index = [tabAnimated getIndexWithIndex:section];
    if (index < 0) {
        return [tabAnimated.oldDataSource tableView:tableView numberOfRowsInSection:section];
    }
    return [tabAnimated.cellCountArray[index] integerValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        return [tabAnimated.oldDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    NSInteger index = [tabAnimated getIndexWithIndexPath:indexPath];
    if (index < 0) {
        return [tabAnimated.oldDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return [tabAnimated.cellHeightArray[index] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        return [tabAnimated.oldDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    NSInteger index = [tabAnimated getIndexWithIndexPath:indexPath];
    if (index < 0) {
        return [tabAnimated.oldDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    Class currentClass = tabAnimated.cellClassArray[index];
    // 启动加工层
    UITableViewCell *cell = [tabAnimated.producter productWithControlView:tableView currentClass:currentClass indexPath:indexPath origin:TABAnimatedProductOriginTableViewCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tabAnimated.state != TABViewAnimationStart) {
        [tableView.tabAnimated.oldDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tabAnimated.state != TABViewAnimationStart) {
        [tableView.tabAnimated.oldDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - HeaderFooterView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        return [tabAnimated.oldDelegate tableView:tableView heightForHeaderInSection:section];
    }
    
    NSInteger index = [tabAnimated getHeaderIndexWithIndex:section];
    if (index < 0) {
        return [tabAnimated.oldDelegate tableView:tableView heightForHeaderInSection:section];
    }
    return [tableView.tabAnimated.headerHeightArray[index] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        return [tabAnimated.oldDelegate tableView:tableView heightForFooterInSection:section];
    }
    
    NSInteger index = [tabAnimated getFooterIndexWithIndex:section];
    if (index < 0) {
        return [tabAnimated.oldDelegate tableView:tableView heightForFooterInSection:section];
    }
    return [tableView.tabAnimated.footerHeightArray[index] floatValue];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        return [tabAnimated.oldDelegate tableView:tableView viewForHeaderInSection:section];
    }

    NSInteger index = [tabAnimated getHeaderIndexWithIndex:section];
    if (index < 0) {
        return [tabAnimated.oldDelegate tableView:tableView viewForHeaderInSection:section];
    }
    
    Class class = tabAnimated.headerClassArray[index];
    
    UIView *hfView;
    // 启动加工层
    TABAnimatedProductOrigin origin = [class isSubclassOfClass:[UITableViewHeaderFooterView class]] ? TABAnimatedProductOriginTableHeaderFooterViewCell : TABAnimatedProductOriginTableHeaderFooterView;
    hfView = [tabAnimated.producter productWithControlView:tableView currentClass:class indexPath:nil origin:origin];
    
    return hfView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        return [tabAnimated.oldDelegate tableView:tableView viewForFooterInSection:section];
    }
    
    NSInteger index = [tabAnimated getFooterIndexWithIndex:section];
    if (index < 0) {
        return [tabAnimated.oldDelegate tableView:tableView viewForFooterInSection:section];
    }
    
    Class class = tabAnimated.footerClassArray[index];
    
    UIView *hfView;
    // 启动加工层
    TABAnimatedProductOrigin origin = [class isSubclassOfClass:[UITableViewHeaderFooterView class]] ? TABAnimatedProductOriginTableHeaderFooterViewCell : TABAnimatedProductOriginTableHeaderFooterView;
    hfView = [tabAnimated.producter productWithControlView:tableView currentClass:class indexPath:nil origin:origin];
    
    return hfView;
}

@end

@implementation EstimatedTableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
