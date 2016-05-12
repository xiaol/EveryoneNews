//
//  LPRelateView.h
//  EveryoneNews
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPRelateView;

@protocol LPRelateViewDelegate <NSObject>
@optional
-(void)relateView:(LPRelateView *)relateView didCliclURL:(NSString *)url;
@end

@interface LPRelateView : UIView

@property (nonatomic, strong) NSArray *relateArray;

@property (nonatomic,weak)id<LPRelateViewDelegate> delegate;

@end
