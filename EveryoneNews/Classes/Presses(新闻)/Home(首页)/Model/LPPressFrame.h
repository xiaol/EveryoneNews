//
//  LPPressFrame.h
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPPress;

@interface LPPressFrame : NSObject

@property (nonatomic, strong) LPPress *press;

///**
// *  大图 (special = 1)
// */
@property (nonatomic, assign, readonly) CGRect photoViewF;
@property (nonatomic, assign) CGRect bgImageViewF;
@property (nonatomic, assign) CGRect titleBgViewF;
/**
 *  类别
 */
@property (nonatomic, assign, readonly) CGRect categoryLabelF;
/**
 *  标题
 */
@property (nonatomic, assign, readonly) CGRect titleLabelF;

/**
 *  图文cell顶部view
 */
@property (nonatomic, assign, readonly) CGRect singleGraphTopViewF;
@property (nonatomic, assign) CGRect singleGraphMidSeparaterF;
//@property (nonatomic, assign, readonly) CGRect multiGraphTopViewF;
/**
 *  左上单张配图 (special = 400)
 */
@property (nonatomic, assign, readonly) CGRect thumbnailViewF;

/**
 *  上边多张配图 (special = 9)
 */
@property (nonatomic, assign, readonly) CGRect thumbnailsViewF;
/**
 *  多家观点
 */
@property (nonatomic, assign, readonly) CGRect pointsLabelF;
/**
 *  小图标集合
 */
@property (nonatomic, assign) CGRect smallIconsViewF;
/**
 *  图文cell下部view (special = 400)
 */
@property (nonatomic, assign, readonly) CGRect singleGraphOpinionsViewF;

///**
// *  图文cell下部view (special = 9)
// */
//@property (nonatomic, assign, readonly) CGRect multiGraphOpinionsViewF;

// @property (nonatomic, assign) CGRect dividerViewF;

/**
 *  cell高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

// + (instancetype)pressFrameWithTimeCell;

@end
