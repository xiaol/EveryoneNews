//
//  insetsLabel.h
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface insetsLabel : UILabel
@property (nonatomic) UIEdgeInsets insets;

- (id)initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets)insets;

- (id)initWithInsets: (UIEdgeInsets)insets;

@end
