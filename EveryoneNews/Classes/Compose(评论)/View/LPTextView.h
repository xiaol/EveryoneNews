//
//  LPTextView.h
//  EveryoneNews
//
//  Created by apple on 15/6/30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPTextView : UITextView
@property (nonatomic, copy) NSString *placehoder;
@property (nonatomic, strong) UIColor *placehoderColor;
@property (nonatomic, strong) UILabel *placehoderLabel;
@end
