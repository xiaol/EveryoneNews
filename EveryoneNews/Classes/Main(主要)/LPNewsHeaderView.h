//
//  LPNewsHeaderView.h
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPNewsHeaderView : UITableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier headerViewHeight:(CGFloat)headerViewHeight lineColor:(nullable UIColor *)lineColor lineFrame:(CGRect)lineFrame;

@end

NS_ASSUME_NONNULL_END
