//
//  LPPagingView.m
//  EveryoneNews
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPPagingView.h"
#import "UIView+LPReusePage.h"
#import <objc/runtime.h>


#pragma mark - delegate trampoline


// 蹦床接收所有pv代理方法(无法获得代理(id)的签名, 但可以知道代理可以响应的方法(协议中规定了)), 实现其中一部分, 并把余下未实现的方法转发给自己的代理
@interface LPPagingViewDelegateTrampline : NSObject <UIScrollViewDelegate>

@property (nonatomic, weak) LPPagingView *pagingView;
@property (nonatomic, weak) id<LPPagingViewDelegate> delegate;

@end

@implementation LPPagingViewDelegateTrampline

//- (BOOL)respondsToSelector:(SEL)aSelector {
//    return [super respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector];
//}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    if (sig) {
        return sig;
    }
    
    Protocol *protocol = @protocol(LPPagingViewDelegate);
    struct objc_method_description desc = protocol_getMethodDescription(protocol, aSelector, YES, YES);
    if (desc.name == NULL) {
        desc = protocol_getMethodDescription(protocol, aSelector, NO, YES);
    }
    
    if (desc.name == NULL) {
        [self doesNotRecognizeSelector:aSelector];
        return nil;
    }
    
    return [NSMethodSignature signatureWithObjCTypes:desc.types];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.delegate respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.delegate];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.pagingView) {
        [self.pagingView scrollViewDidScroll:scrollView];
    }
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.pagingView) {
        [self.pagingView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.pagingView) {
        [self.pagingView scrollViewDidEndDecelerating:scrollView];
    }
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.pagingView) {
        [self.pagingView scrollViewDidEndScrollingAnimation:scrollView];
    }
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
    NSInteger pageCount = [self.dataSource numberOfPagesInPagingView:self];
    if (pageCount && !self.dragging && !self.decelerating) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if ([self.delegate respondsToSelector:@selector(pagingView:didScrollToPageIndex:)]) {
                [self.delegate pagingView:self didScrollToPageIndex:self.currentPageIndex];
            }
        });
    }
//    [self setNeedsLayout];
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
//    UIView *page = set.count > 2 ? [set anyObject] : nil;
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
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    [super layoutSubviews];
//    if (self.contentOffset.x < 0 || self.contentOffset.x > self.helper.contentSize.width) return;
    CGFloat numberOfPages = self.helper.numberOfPages;
    if (numberOfPages == 0) return;
    CGRect visibleBounds = self.clipsToBounds ? self.bounds : [self convertRect:self.superview.bounds fromView:self.superview];
    CGFloat pageLength = self.helper.pageWidth + self.helper.gutter;
    CGFloat minX = CGRectGetMinX(visibleBounds) + self.helper.gutter / 2;
    CGFloat maxX = CGRectGetMaxX(visibleBounds) - self.helper.gutter / 2;
//    maxX ++;
    
    NSInteger firstIndex = floorf(minX / pageLength);
    firstIndex = MAX(firstIndex - 1, 0);
    NSInteger lastIndex = floorf(maxX / pageLength);
    lastIndex = MIN(lastIndex + 1, numberOfPages - 1);
    
    // 1. remove non-visible pages & queue reusable pages 在当前可视集合中将即将不可视的page从pv(1.1)和可视集合(1.2)中remove掉, 并存入缓存(1.3)
    NSMutableSet *removedPages = [NSMutableSet set];
    
    for (UIView *page in self.visiblePages) {
        if (page.tag < firstIndex || page.tag > lastIndex) {
            [page removeFromSuperview];         // 1.1
            [removedPages addObject:page];
            [self queueReusablePage:page];      // 1.3
        }
    }
    [self.visiblePages minusSet:removedPages];  // 1.2
    
    // 2. layout visible pages 如更新的可视集合中有新来的index, 从数据源获取对应的page(2.1)添加至pv(2.2), 并加入可视集合(2.3)
    for (NSInteger index = firstIndex; index <= lastIndex; index ++) {
        if (![self isPageVisibleAtPageIndex:index]) {
            UIView *page = [self.dataSource pagingView:self pageForPageIndex:index]; // 2.1
            page.frame = [self frameForPageIndex:index];
            page.tag = index;
            [self insertSubview:page atIndex:0];                                     // 2.2
            [self.visiblePages addObject:page];                                      // 2.3
        }
    }
}

- (void)reloadPageAtPageIndex:(NSInteger)pageIndex {
    // 1. 要刷新的页面可见, 从数据源获取并取代旧的
    for (UIView *page in self.visiblePages) {
        if (pageIndex == page.tag) {
            UIView *newPage = [self.dataSource pagingView:self pageForPageIndex:pageIndex];
            newPage.tag = page.tag;
            newPage.frame = page.frame;
            
            [page removeFromSuperview];
            [self.visiblePages removeObject:page];
            [self addSubview:newPage];
            [self.visiblePages addObject:newPage];
            break;
        }
    }
    // 2. 要刷新但页面不可见， 无需操作
}

//- (void)reloadPagesAtPageIndexes:(NSArray *)pageIndexes {
//    for (NSNumber *indexObj in pageIndexes) {
//        NSInteger index = indexObj.integerValue;
//        [self reloadPageAtPageIndex:index];
//    }
//}

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

