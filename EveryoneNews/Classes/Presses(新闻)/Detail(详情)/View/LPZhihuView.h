//
//  LPZhihuView.h
//  EveryoneNews
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPZhihuView;

@protocol LPZhihuViewDelegate <NSObject>
@optional
- (void)zhihuView:(LPZhihuView *)zhihuView didClickURL:(NSString *)url;
@end

@interface LPZhihuView : UIView

@property (nonatomic, strong) NSArray *zhihuPoints;
@property (nonatomic, weak) id<LPZhihuViewDelegate> delegate;
- (CGFloat)heightWithPointsArray:(NSArray *)points;

@end
