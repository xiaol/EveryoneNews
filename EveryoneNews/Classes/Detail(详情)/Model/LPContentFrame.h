//
//  LPContentFrame.h
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^imageDownLoadCompletionBlock)();
@class LPContent;
@interface LPContentFrame : NSObject
@property (nonatomic, strong) LPContent *content;
@property (nonatomic, assign, readonly) CGRect bodyLabelF;
@property (nonatomic, assign, readonly) CGRect webViewF;
@property (nonatomic, assign, readonly) CGRect upBtnF;
@property (nonatomic, assign, readonly) CGRect userIconF;
@property (nonatomic, assign, readonly) CGRect commentLabelF;
@property (nonatomic, assign, readonly) CGRect commentsCountBtnF;
@property (nonatomic, assign, readonly) CGRect plusBtnF;
@property (nonatomic, assign, readonly) CGRect commentViewF;

@property (nonatomic ,assign, readonly) CGRect abstractSeperatorViewF;

// 针对图像cell
@property (nonatomic, assign, readonly) CGRect photoViewF;
@property (nonatomic, assign, readonly) CGRect photoDescViewF;

// opinion cell
@property (nonatomic, assign, readonly) CGRect dividerViewF;
@property (nonatomic, assign, readonly) CGRect arrowViewF;
@property (nonatomic, assign, readonly) CGRect pointerViewF;
@property (nonatomic, assign, readonly) CGRect iconViewF;
@property (nonatomic, assign, readonly) CGRect sourceViewF;
@property (nonatomic, assign, readonly) CGRect supplementViewF;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign, readonly, getter=isUpdated) BOOL updated;

//@property (nonatomic, copy) imageDownLoadCompletionBlock block;

- (void)downloadImageWithCompletionBlock:(imageDownLoadCompletionBlock)imageDownLoadCompletionBlock ;

- (void)setContentWhenFontSizeChanged:(LPContentFrame *)contentFrame;
@end
