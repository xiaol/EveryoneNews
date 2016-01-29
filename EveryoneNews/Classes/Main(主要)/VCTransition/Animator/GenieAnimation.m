//
//  GenieAnimation.m
//  EveryoneNews
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GenieAnimation.h"
#import "DigButton.h"

static const CGFloat presentDuration = 0.45;
static const CGFloat dismissDuration = 0.5;

static const double curvesAnimationStart = 0.0;
static const double curvesAnimationEnd = 0.4;
static const double slideAnimationStart = 0.3;
static const double slideAnimationEnd = 1.0;

static const CGFloat kSliceSize = 10.0f; // height/width of a single slice
static const NSTimeInterval kFPS = 60.0; // assumed animation's FPS

static const CGFloat kRenderMargin = 2.0;

#define isEdgeVertical(d) (!((d) & 1))
#define isEdgeNegative(d) (((d) & 2))
#define axisForEdge(d) ((LPAxis)isEdgeVertical(d))
#define perpAxis(d) ((LPAxis)(!(BOOL)d))

typedef NS_ENUM(NSInteger, LPAxis) {
    LPAxisX = 0,
    LPAxisY = 1
};

typedef union LPPoint {
    struct {double x, y;};
    double v[2];
} LPPoint;


static inline LPPoint LPPointMake(double x, double y) {
    LPPoint p; p.x = x; p.y = y; return p;
}

typedef union LPTrapezoid {
    struct { LPPoint a, b, c, d; };
    LPPoint v[4];
} LPTrapezoid;


typedef struct LPSegment {
    LPPoint a;
    LPPoint b;
} LPSegment;

static inline LPSegment LPSegmentMake(LPPoint a, LPPoint b) {
    LPSegment s; s.a = a; s.b = b; return s;
}

typedef LPSegment LPBezierCurve;

static inline LPSegment bezierEndPoints(CGRect rect) {
    return LPSegmentMake(LPPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)), LPPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)));
}

static inline CGFloat progressOfSegmentWithinTotalProgress(CGFloat a, CGFloat b, CGFloat t)
{
    assert(b > a);
    return MIN(MAX(0.0, (t - a)/(b - a)), 1.0);
}

static inline CGFloat easeInOutInterpolate(float t, CGFloat a, CGFloat b)
{
    assert(t >= 0.0 && t <= 1.0);
    
    CGFloat val = a + t*t*(3.0 - 2.0*t)*(b - a);
    
    return b > a ? MAX(a,  MIN(val, b)) : MAX(b,  MIN(val, a));
}

static LPPoint bezierAxisIntersection(LPBezierCurve curve, LPAxis axis, CGFloat axisPos)
{
    assert((axisPos >= curve.a.v[axis] && axisPos <= curve.b.v[axis]) || (axisPos >= curve.b.v[axis] && axisPos <= curve.a.v[axis]));
    
    LPAxis pAxis = perpAxis(axis);
    
    LPPoint c1, c2;
    c1.v[pAxis] = curve.a.v[pAxis];
    c1.v[axis] = (curve.a.v[axis] + curve.b.v[axis])/2.0;
    
    c2.v[pAxis] = curve.b.v[pAxis];
    c2.v[axis] = (curve.a.v[axis] + curve.b.v[axis])/2.0;
    
    double t = (axisPos - curve.a.v[axis])/(curve.b.v[axis] - curve.a.v[axis]); // first approximation - treating curve as linear segment
    
    const int kIterations = 3; // Newton-Raphson iterations
    
    for (int i = 0; i < kIterations; i++) {
        double nt = 1.0 - t;
        
        double f = nt*nt*nt*curve.a.v[axis] + 3.0*nt*nt*t*c1.v[axis] + 3.0*nt*t*t*c2.v[axis] + t*t*t*curve.b.v[axis] - axisPos;
        double df = -3.0*(curve.a.v[axis]*nt*nt + c1.v[axis]*(-3.0*t*t + 4.0*t - 1.0) + t*(3.0*c2.v[axis]*t - 2.0*c2.v[axis] - curve.b.v[axis]*t));
        
        t -= f/df;
    }
    
    assert(t >= 0 && t <= 1.0);
    
    double nt = 1.0 - t;
    double intersection = nt*nt*nt*curve.a.v[pAxis] + 3.0*nt*nt*t*c1.v[pAxis] + 3.0*nt*t*t*c2.v[pAxis] + t*t*t*curve.b.v[pAxis];
    
    LPPoint ret;
    ret.v[axis] = axisPos;
    ret.v[pAxis] = intersection;
    
    return ret;
}



#pragma mark - 动画类实现
@interface GenieAnimation ()
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIViewController *dismissingVc;
@end

@implementation GenieAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
//    return self.type == ModalTypePresent ? presentDuration : dismissDuration;
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;
    
    UIView *containerView = [transitionContext containerView];
    self.containerView = containerView;
    
    CGFloat diggerRadius = DigButtonWidth / 2;
    
    CGFloat diggerRectY = ScreenHeight - DigButtonPadding - diggerRadius;
    
    if (iPhone6Plus) {
           diggerRectY = ScreenHeight - 2 * DigButtonPadding - diggerRadius;
    }
    
    
    CGRect diggerRect = CGRectMake(DigButtonPadding + diggerRadius * 0.4, diggerRectY, diggerRadius * 0.6 * 2, diggerRadius * 0.8);
   
    CGFloat originY = - DigButtonPadding - diggerRadius - 1;
    CGRect vcRect = CGRectMake(0, originY, ScreenWidth, ScreenHeight);
    
    UIViewController* destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if([destination isBeingPresented]) {
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        
        [containerView addSubview:toView];
        
        toView.frame = vcRect;
        
        [self transitionWithView:toView duration:presentDuration destRect:diggerRect reverse:YES];
    } else {
        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        //        fromView.transform = CGAffineTransformMakeTranslation(0, originY);
        fromView.frame = vcRect;
        [self transitionWithView:fromView duration:dismissDuration destRect:diggerRect reverse:NO];
    }
    
//    if (self.type == ModalTypePresent) {
//        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
//        
//        [containerView addSubview:toView];
//        
//        toView.frame = vcRect;
//        
//        [self transitionWithView:toView duration:presentDuration destRect:diggerRect reverse:YES];
//    } else if (self.type == ModalTypeDismiss) {
//         UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
////        fromView.transform = CGAffineTransformMakeTranslation(0, originY);
//        fromView.frame = vcRect;
//        [self transitionWithView:fromView duration:dismissDuration destRect:diggerRect reverse:NO];
//    }
}



- (void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration destRect:(CGRect)destRect reverse:(BOOL)reverse {
    assert(!CGRectIsNull(destRect));
    
    LPAxis axis = LPAxisY;
    LPAxis pAxis = LPAxisX;
    
    view.transform = CGAffineTransformIdentity; // ?
    
    UIImage *snapshot = [self renderSnapshotWithView:view marginForAxis:axis];
    NSArray *slices = [self sliceImage:snapshot toLayersAlongAxis:axis];
    
    CGFloat xInset = -kRenderMargin;
    CGRect marginedDestRect = CGRectInset(destRect, xInset * destRect.size.width / view.width, 0.0);
    CGFloat endRectDepth = marginedDestRect.size.height;
    CGRect marginedViewRect = CGRectInset(view.frame, xInset, 0.0);
    LPSegment aPoints = bezierEndPoints(marginedViewRect);
    LPSegment bStartPoints = aPoints;
    LPSegment bEndPoints = bezierEndPoints(marginedDestRect);
    bStartPoints.a.v[axis] = bEndPoints.a.v[axis];
    bStartPoints.b.v[axis] = bEndPoints.b.v[axis];
    
    LPBezierCurve first = {aPoints.a, bStartPoints.a};
    LPBezierCurve second = {aPoints.b, bStartPoints.b};
    
//    NSString *sumKeyPath = @"sum.bounds.size.height";
//    CGFloat totalSize = [[slices valueForKeyPath:sumKeyPath] floatValue];
    CGFloat totalSize = 0.0;
    for (CALayer *slice in slices) {
        totalSize += slice.bounds.size.height;
    }
    
    // 添加透明蒙板及按钮做动画
    __block UIView *hud = [[UIView alloc] initWithFrame:self.containerView.bounds];
    hud.backgroundColor = [UIColor clearColor];
    [self.containerView insertSubview:hud belowSubview:view];
    __block DigButton *btn = [[DigButton alloc] init];
    [self.containerView addSubview:btn];
    btn.x = DigButtonPadding;
    btn.y = ScreenHeight - DigButtonPadding - DigButtonHeight;
    
    if (iPhone6Plus) {
        btn.y = ScreenHeight - 2 * DigButtonPadding - DigButtonHeight;
    }
    
    btn.width = DigButtonWidth;
    btn.height = DigButtonHeight;
    btn.layer.cornerRadius = btn.width / 2;
    btn.alpha = 0.9;
    [self.containerView bringSubviewToFront:btn];
    btn.enabled = NO;
    
    NSMutableArray *transforms = [NSMutableArray arrayWithCapacity:[slices count]];
    
    for (CALayer *layer in slices) {
        [hud.layer addSublayer:layer];
        [layer setEdgeAntialiasingMask:0];
        [transforms addObject:[NSMutableArray array]];
    }
    view.hidden = YES;
    
    NSInteger totalIter = duration * kFPS;
    double tSignShift = reverse ? -1.0 : 1.0;
    for (int i = 0; i < totalIter; i++) {
        double progress = ((double)i) / ((double)totalIter - 1.0);
        double t = tSignShift * (progress - 0.5) + 0.5; // t:当前时间
        
        double curveP = progressOfSegmentWithinTotalProgress(curvesAnimationStart, curvesAnimationEnd, t); // 曲线运动的当前时间
        
        first.b.v[pAxis] = easeInOutInterpolate(curveP, bStartPoints.a.v[pAxis], bEndPoints.a.v[pAxis]); // 插出水平方向运动的x值(左)
        second.b.v[pAxis] = easeInOutInterpolate(curveP, bStartPoints.b.v[pAxis], bEndPoints.b.v[pAxis]); // 插出水平方向运动的x值(右)
        
        double slideP = progressOfSegmentWithinTotalProgress(slideAnimationStart, slideAnimationEnd, t); // 竖直运动的当前时间

        CGFloat axisInterpolatedValue = easeInOutInterpolate(slideP, first.a.v[axis], first.b.v[axis]);
        NSArray *trs = [self transformationsForSlices:slices startPosition:axisInterpolatedValue totalSize:totalSize firstBezier:first secondBezier:second finalRectDepth:endRectDepth];
        [trs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [(NSMutableArray *)transforms[idx] addObject:obj];
        }];
    }
    
    // 动画事务
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [hud removeFromSuperview];
        hud = nil;
        CGSize startSize = view.frame.size;
        CGSize endSize = destRect.size;
        
        CGPoint startOrigin = view.frame.origin;
        CGPoint endOrigin = destRect.origin;
        
        if (!reverse) { // dismiss
            CGAffineTransform transform = CGAffineTransformMakeTranslation(endOrigin.x - startOrigin.x, endOrigin.y - startOrigin.y);
            transform = CGAffineTransformTranslate(transform, -startSize.width/2.0, -startSize.height/2.0); // move top left corner to origin
            transform = CGAffineTransformScale(transform, endSize.width/startSize.width, endSize.height/startSize.height); // scale
            transform = CGAffineTransformTranslate(transform, startSize.width/2.0, startSize.height/2.0); // move back
            view.transform = transform;
//            view.hidden = YES;
            
            [view removeFromSuperview];
            
//            NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef) _dismissingVc));
        } else {
            view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            view.hidden = NO;
        }
        [btn removeFromSuperview];
        btn = nil;
        // 提交动画
        [_transitionContext completeTransition:YES];
    }];
    [slices enumerateObjectsUsingBlock:^(CALayer *layer, NSUInteger idx, BOOL *stop) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        anim.duration = duration;
        anim.values = transforms[idx];
        anim.calculationMode = kCAAnimationDiscrete;
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        [layer addAnimation:anim forKey:@"transform"];
    }];
    [CATransaction commit];
}

- (NSArray *)transformationsForSlices: (NSArray *) slices
                        startPosition: (CGFloat) startPosition
                            totalSize: (CGFloat) totalSize
                          firstBezier: (LPBezierCurve) first
                         secondBezier: (LPBezierCurve) second
                       finalRectDepth: (CGFloat) rectDepth {
    NSMutableArray *transformations = [NSMutableArray arrayWithCapacity:slices.count];
    LPAxis axis = LPAxisY;
    CGFloat destRectStartY = first.b.v[axis];
    assert((startPosition - destRectStartY) <= 0);
    
    __block CGFloat position = startPosition;
    __block LPTrapezoid trapezoid = {0};
    trapezoid.v[0] = bezierAxisIntersection(first, axis, position);
    trapezoid.v[1] = bezierAxisIntersection(second, axis, position);
    
    [slices enumerateObjectsUsingBlock:^(CALayer *layer, NSUInteger idx, BOOL *stop) {
        CGFloat size = layer.bounds.size.height;
        CGFloat endPosition = position + size; // slice下端y值
        double overflow = endPosition - destRectStartY;
        if (overflow <= 0.0f) { // slice仍在bezier中
            trapezoid.v[2] = bezierAxisIntersection(first, axis, endPosition);
            trapezoid.v[3] = bezierAxisIntersection(second, axis, endPosition);
        } else {
            CGFloat shrunkSliceDepth = overflow * rectDepth / (double)totalSize;
            trapezoid.v[2] = first.b;
            trapezoid.v[2].v[axis] += shrunkSliceDepth;
            trapezoid.v[3] = second.b;
            trapezoid.v[3].v[axis] += shrunkSliceDepth;
        }
        
        CATransform3D transform = [self transformRect:layer.bounds toTrapezoid:trapezoid];
        [transformations addObject:[NSValue valueWithCATransform3D:transform]];
        
         // 更新增量
         trapezoid.v[0] = trapezoid.v[2];
         trapezoid.v[1] = trapezoid.v[3];
         position = endPosition;
    }];
    
    return transformations;
}


- (UIImage *)renderSnapshotWithView:(UIView *)view marginForAxis:(LPAxis)axis
{
    CGSize contextSize = view.frame.size;
    CGFloat xOffset = 0.0f;
    CGFloat yOffset = 0.0f;
    
    if (axis == LPAxisY) {
        xOffset = kRenderMargin;
        contextSize.width += 2.0*kRenderMargin;
    } else {
        yOffset = kRenderMargin;
        contextSize.height += 2.0*kRenderMargin;
    }
    
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, 0.0); // if you want to see border added for antialiasing pass YES as second param
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, xOffset, yOffset);
    
    [view.layer renderInContext:context];
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}

- (NSArray *)sliceImage:(UIImage *)image toLayersAlongAxis:(LPAxis)axis
{
    CGFloat totalSize = axis == LPAxisY ? image.size.height : image.size.width;
    
    LPPoint origin = {0.0, 0.0};
    origin.v[axis] = kSliceSize;
    
    CGFloat scale = image.scale;
    CGSize sliceSize = axis == LPAxisY ? CGSizeMake(image.size.width, kSliceSize) : CGSizeMake(kSliceSize, image.size.height);
    
    NSInteger count = (NSInteger)ceilf(totalSize / kSliceSize);
    NSMutableArray *slices = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        CGRect rect = {i * origin.x*scale, i * origin.y * scale, sliceSize.width * scale, sliceSize.height * scale};
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
        UIImage *sliceImage = [UIImage imageWithCGImage:imageRef
                                                  scale:image.scale
                                            orientation:image.imageOrientation];
        CGImageRelease(imageRef);
        CALayer *layer = [CALayer layer];
        layer.anchorPoint = CGPointZero;
        layer.bounds = CGRectMake(0.0, 0.0, sliceImage.size.width, sliceImage.size.height);
        layer.contents = (__bridge id)(sliceImage.CGImage);
        layer.contentsScale = image.scale;
        [slices addObject:layer];
    }

    return slices;
}

- (CATransform3D)transformRect:(CGRect)rect toTrapezoid:(LPTrapezoid)trapezoid
{
    
    double W = rect.size.width;
    double H = rect.size.height;
    
    double x1a = trapezoid.a.x;
    double y1a = trapezoid.a.y;
    
    double x2a = trapezoid.b.x;
    double y2a = trapezoid.b.y;
    
    double x3a = trapezoid.c.x;
    double y3a = trapezoid.c.y;
    
    double x4a = trapezoid.d.x;
    double y4a = trapezoid.d.y;
    
    double y21 = y2a - y1a,
    y32 = y3a - y2a,
    y43 = y4a - y3a,
    y14 = y1a - y4a,
    y31 = y3a - y1a,
    y42 = y4a - y2a;
    
    
    double a = -H*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42);
    double b = W*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
    double c = - H*W*x1a*(x4a*y32 - x3a*y42 + x2a*y43);
    
    double d = H*(-x4a*y21*y3a + x2a*y1a*y43 - x1a*y2a*y43 - x3a*y1a*y4a + x3a*y2a*y4a);
    double e = W*(x4a*y2a*y31 - x3a*y1a*y42 - x2a*y31*y4a + x1a*y3a*y42);
    double f = -(W*(x4a*(H*y1a*y32) - x3a*(H)*y1a*y42 + H*x2a*y1a*y43));
    
    double g = H*(x3a*y21 - x4a*y21 + (-x1a + x2a)*y43);
    double h = W*(-x2a*y31 + x4a*y31 + (x1a - x3a)*y42);
    double i = H*(W*(-(x3a*y2a) + x4a*y2a + x2a*y3a - x4a*y3a - x2a*y4a + x3a*y4a));
    
    const double kEpsilon = 0.0001;
    
    if(fabs(i) < kEpsilon) {
        i = kEpsilon* (i > 0 ? 1.0 : -1.0);
    }
    
    CATransform3D transform = {a/i, d/i, 0, g/i, b/i, e/i, 0, h/i, 0, 0, 1, 0, c/i, f/i, 0, 1.0};
    
    return transform;
}



@end
