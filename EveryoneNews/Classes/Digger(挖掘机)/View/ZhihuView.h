//
//  ZhihuView.h
//  EveryoneNews
//
//  Created by dongdan on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZhihuView;
@protocol ZhihuViewDelegate <NSObject>
@optional
- (void)zhihuView:(ZhihuView *)zhihuView didClickURL:(NSString *)url;
@end

@interface ZhihuView : UIView
// 知乎观点
@property (nonatomic, strong) NSSet *zhihuSet;
// 计算观点集合的高度
- (CGFloat)heightWithPointsArray:(NSArray *)points;
// 知乎页面跳转
@property (nonatomic, weak) id<ZhihuViewDelegate> delegate;
@end
