//
//  DateScrollView.h
//  EveryoneNews
//
//  Created by apple on 15/5/6.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DateScrollView;

@protocol DateScrollViewDelegate <NSObject>

@optional

- (void)dateScrollView:(DateScrollView *)dateScrollView didSelectDate:(NSString *)date withType:(BOOL)type tag:(int)tag;

@end

@interface DateScrollView : UIScrollView


// 0: 当前是夜里 1：白天
@property (nonatomic, assign) BOOL type;

@property (nonatomic, weak) id<DateScrollViewDelegate> delegate;

@property (nonatomic, assign) int selectedTag;

@end