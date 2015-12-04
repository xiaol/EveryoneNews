//
//  LPPagingView.m
//  EveryoneNews
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPPagingView.h"
#import "UIView+LPReusePage.h"


#pragma mark - delegate trampoline

// 蹦床接收所有pv代理方法, 实现其中一部分, 并把余下未实现的方法转发给自己的代理
@interface LPPagingViewDelegateTrampline : NSObject <UIScrollViewDelegate>

@property (nonatomic, weak) LPPagingView *pagingView;
@property (nonatomic, weak) id<LPPagingViewDelegate> delegate;

@end

@implementation LPPagingViewDelegateTrampline

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.delegate respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.delegate];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pagingView scrollViewDidScroll:scrollView];
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.pagingView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pagingView scrollViewDidEndDecelerating:scrollView];
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self.pagingView scrollViewDidEndScrollingAnimation:scrollView];
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

@end


#pragma mark - paging helper

@interface LPPagingViewHelper : NSObject

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) CGFloat pageWidth;
@property (nonatomic, assign) CGFloat pageHeight;
@property (nonatomic, assign) CGFloat gutter;

- (CGSize)contentSize;
@end

@implementation LPPagingViewHelper

- (CGSize)contentSize {
    return CGSizeMake((self.pageWidth + self.gutter) * self.numberOfPages, self.pageHeight);
}

@end

#pragma mark - paging view implementation

@interface LPPagingView ()

@property (nonatomic, strong) NSMutableDictionary *registeredClasses;
@property (nonatomic, strong) NSMutableDictionary *reusablePages;
@property (nonatomic, strong) NSMutableSet *visiblePages;
@property (nonatomic, strong) LPPagingViewHelper *helper;
@property (nonatomic, strong) LPPagingViewDelegateTrampline *delegateTrampoline;

// private methods
//- (CGRect)frameForPageIndex:(NSInteger)pageIndex;
//- (void)didScrollToPageIndex:(NSInteger)pageIndex;
//- (BOOL)isPageInScreenWithFrame:(CGRect)pageFrame;
@end

@implementation LPPagingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = YES;
    }
    return self;
}

// lazy loading
- (NSMutableDictionary *)registeredClasses {
    if (_registeredClasses == nil) {
        _registeredClasses = [NSMutableDictionary dictionary];
    }
    return _registeredClasses;
}

- (NSMutableDictionary *)reusablePages {
    if (_reusablePages == nil) {
        _reusablePages = [NSMutableDictionary dictionary];
    }
    return _reusablePages;
}

- (NSMutableSet *)visiblePages {
    if (_visiblePages == nil) {
        _visiblePages = [NSMutableSet set];
    }
    return _visiblePages;
}

// view helper
- (LPPagingViewHelper *)helper {
    if (_helper == nil) {
        _helper = [[LPPagingViewHelper alloc] init];
        _helper.numberOfPages = [self.dataSource numberOfPagesInPagingView:self];
        _helper.pageHeight = self.bounds.size.height;
        _helper.pageWidth = self.bounds.size.width;
        _helper.gutter = 0.0f;
        
        self.contentSize = _helper.contentSize;

        CGRect frame = self.frame;
        frame.size.width += _helper.gutter;
        frame.origin.x -= _helper.gutter / 2;
        self.frame = frame;
    }
    return _helper;
}

// delegate trampoline
- (LPPagingViewDelegateTrampline *)delegateTrampoline {
    if (_delegateTrampoline == nil) {
        _delegateTrampoline = [[LPPagingViewDelegateTrampline alloc] init];
        _delegateTrampoline.pagingView = self;
    }
    return _delegateTrampoline;
}

// page frame as stablized
- (CGRect)frameForPageIndex:(NSInteger)pageIndex {
    CGFloat pageW = self.helper.pageWidth;
    CGFloat pageH = self.helper.pageHeight;
    CGFloat gutter = self.helper.gutter;
    
    CGRect frame = CGRectZero;
    frame.origin.x = (pageW + gutter) * pageIndex + floorf(gutter / 2.0f);
    frame.size.width = pageW;
    frame.size.height = pageH;
    
    return frame;
}

// current page
- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {
    [self setCurrentPageIndex:currentPageIndex animated:NO];
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex animated:(BOOL)animated {
    CGRect frame = [self frameForPageIndex:currentPageIndex];
    CGPoint offset = frame.origin;
    offset.x -= self.helper.gutter / 2;
    [self setContentOffset:offset animated:animated];
}

- (NSInteger)currentPageIndex {
    NSInteger currentPageIndex = floorf(CGRectGetMinX(self.bounds) / (self.helper.pageWidth + self.helper.gutter));
//    NSLog(@"%.2f -- %@", CGRectGetMinX(self.bounds), NSStringFromCGRect(self.bounds));
//    NSInteger currentPageIndex = floorf(self.contentOffset.x / (self.helper.pageWidth + self.helper.gutter));
    currentPageIndex = MAX(currentPageIndex, 0);
    currentPageIndex = MIN(currentPageIndex, self.helper.numberOfPages - 1);
    return currentPageIndex;
}

// reload data
- (void)reloadData {
//    [self.visiblePages makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (UIView *page in self.visiblePages) {
        [page removeFromSuperview];
    }
    [self.visiblePages removeAllObjects];
    [self.reusablePages removeAllObjects];
    
    self.helper = nil;
    
    [self setNeedsLayout];
}

// scroll view delegate trampoline method components
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self didScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self didScrollToPageIndex:self.currentPageIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self didScrollToPageIndex:self.currentPageIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self didScrollToPageIndex:self.currentPageIndex];
}

- (void)didScroll {
    CGFloat pageLength = self.helper.pageWidth + self.helper.gutter;
    CGFloat offset = self.contentOffset.x;
    CGFloat ratio = offset / pageLength;
    if (offset > 0 && ratio <= self.helper.numberOfPages - 1) {
//        ratio -= floorf(ratio);
        if ([self.delegate respondsToSelector:@selector(pagingView:didScrollWithRatio:)]) {
            [self.delegate pagingView:self didScrollWithRatio:ratio];
        }
    }
    if ([self.delegate respondsToSelector:@selector(pagingView:didScrollToOffsetX:)]) {
        [self.delegate pagingView:self didScrollToOffsetX:offset];
    }
}

// scroll ending call back
- (void)didScrollToPageIndex:(NSInteger)pageIndex {
    if ([self.delegate respondsToSelector:@selector(pagingView:didScrollToPageIndex:)]) {
        [self.delegate pagingView:self didScrollToPageIndex:pageIndex];
    }
}

// delegate setter / getter
- (void)setDelegate:(id<LPPagingViewDelegate>)delegate {
    self.delegateTrampoline.delegate = delegate; // 将蹦床代理设为现代理, 蹦床未实现的代理方法, 转发给现代理实现
    [super setDelegate:self.delegateTrampoline]; // 将自己的代理设为蹦床, 由蹦床拦截一些方法并实现
}

- (id<LPPagingViewDelegate>)delegate {
    return self.delegateTrampoline.delegate;
}

- (BOOL)isPageVisibleAtPageIndex:(NSInteger)index {
    BOOL visible = NO;
    for (UIView *page in self.visiblePages) {
        if (page.tag == index) {
            visible = YES;
            break;
        }
    }
    return visible;
}

// dequeue a reusable page
- (id)dequeueReusablePageWithIdentifier:(NSString *)identifier {
    NSParameterAssert(identifier != nil);
    
    NSMutableSet *set = [self reusablePagesWithIdentifier:identifier];
    UIView *page = [set anyObject];
    
    if (page != nil) {
        [page prepareForReuse];
        [set removeObject:page];
    
        return page;
    }
    
    NSAssert([self.registeredClasses.allKeys containsObject:identifier], @"NO REGISTERED CLASS !");
    
    Class pageClass = [self.registeredClasses objectForKey:identifier];
    page = [[pageClass alloc] initWithFrame:CGRectZero];
    page.pageReuseIdentifier = identifier;
    
    return page;
}

// reusable pool getter
- (NSMutableSet *)reusablePagesWithIdentifier:(NSString *)identifier {
    if (identifier == nil) return nil;
    
    NSMutableSet *set = [self.reusablePages objectForKey:identifier];
    if (set == nil) {
        set = [NSMutableSet set];
        [self.reusablePages setObject:set forKey:identifier];
    }
    return set;
}

// queue a page
- (void)queueReusablePage:(UIView *)page {
    if (page.pageReuseIdentifier == nil) return;
    
    [[self reusablePagesWithIdentifier:page.pageReuseIdentifier] addObject:page];
}

// layout subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.contentOffset.x < 0 || self.contentOffset.x > self.helper.contentSize.width) return;
    CGFloat numberOfPages = self.helper.numberOfPages;
    if (numberOfPages == 0) return;
    CGRect visibleBounds = self.clipsToBounds ? self.bounds : [self convertRect:self.superview.bounds fromView:self.superview];
    CGFloat pageLength = self.helper.pageWidth + self.helper.gutter;
    CGFloat minX = CGRectGetMinX(visibleBounds) + self.helper.gutter / 2;
    CGFloat maxX = CGRectGetMaxX(visibleBounds) - self.helper.gutter / 2;
//    maxX ++;
    
    NSInteger firstIndex = floorf(minX / pageLength);
    firstIndex = MAX(firstIndex, 0);
    NSInteger lastIndex = floorf(maxX / pageLength);
    lastIndex = MIN(lastIndex, numberOfPages - 1);
    
    // remove non-visible pages & queue reusable pages
    NSMutableSet *removedPages = [NSMutableSet set];
    
    for (UIView *page in self.visiblePages) {
        if (page.tag < firstIndex || page.tag > lastIndex) {
            [page removeFromSuperview];
            [removedPages addObject:page];
            [self queueReusablePage:page];
        }
    }
    [self.visiblePages minusSet:removedPages];
    
    // layout visible pages
    for (NSInteger index = firstIndex; index <= lastIndex; index ++) {
        if (![self isPageVisibleAtPageIndex:index]) {
            UIView *page = [self.dataSource pagingView:self pageForPageIndex:index];
            page.frame = [self frameForPageIndex:index];
            page.tag = index;
            [self insertSubview:page atIndex:0];
            [self.visiblePages addObject:page];
        }
    }
    
//    for (NSInteger index = 0; index < self.pageFrames.count; index++) {
//        CGRect pageFrame = [self.pageFrames[index] CGRectValue];
//        LPPagingViewPage *page = self.visiblePages[@(index)]; // 1. 从可视pages数组中取出对应的page
//        if ([self isPageInScreenWithFrame:pageFrame]) {
//            if (page == nil) { // 2. 若数组中不存在相应page, 由数据源创建相应
//                // 2.1 创建一个page
//                page = [self.dataSource pagingView:self pageForPageIndex:index];
//                // 2.2 设置其frame并添加至self
//                page.frame = pageFrame;
//                [self addSubview:page];
//                // 2.3 存入可视字典
//                self.visiblePages[@(index)] = page;
//            }
//            // 3. 若page可见且存于字典, nothing to do
//        } else {
//            if (page) { // 4. 若page不可见但存于字典, 扔进复用缓存池中以避免大量创建 (like table / collection view)
//            // 4.1 清理工作 removed from super view & delete from visible dictionary
//                [page removeFromSuperview];
//                [self.visiblePages removeObjectForKey:@(index)];
//            // 4.2 added into 缓存池
//                [self.reusablePages addObject:page];
//            }
//        }
//    }
}

- (void)registerClass:(Class)pageClass forPageWithReuseIdentifier:(NSString *)identifier {
    NSParameterAssert(identifier != nil);
    
    [self.registeredClasses setValue:pageClass forKey:identifier];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [self reloadData];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.clipsToBounds == NO) {
        CGPoint newPoint = [self.superview convertPoint:point fromView:self];
        return CGRectContainsPoint(self.superview.bounds, newPoint);
    }
    else {
        return [super pointInside:point withEvent:event];
    }
}

@end

