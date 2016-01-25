//
//  LPSearchItemFrame.m
//  EveryoneNews
//
//  Created by dongdan on 16/1/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSearchItemFrame.h"
#import "LPSearchItem.h"

static const CGFloat PaddingHorizontal = 15;
static const CGFloat PaddingVertical = 15;
@implementation LPSearchItemFrame

- (void)setSearchItem:(LPSearchItem *)searchItem {
    _searchItem = searchItem;
    NSString *title = searchItem.title;    
    CGFloat titleW = ScreenWidth - PaddingHorizontal * 2;
    CGFloat titleH = [title sizeWithFont:[UIFont systemFontOfSize:ConcernPressTitleFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
    _titleFrame = CGRectMake(PaddingHorizontal, PaddingVertical, titleW, titleH);
    
    CGFloat updateTimeY = CGRectGetMaxY(_titleFrame) + 10;
    CGFloat updateTimeH = [@"123" sizeWithFont:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
    _sourceFrame = CGRectMake(PaddingHorizontal, updateTimeY, titleW, updateTimeH);
    
    CGFloat seperatorLineY = CGRectGetMaxY(_sourceFrame) + PaddingVertical;
    _seperatorLineFrame = CGRectMake(PaddingHorizontal, seperatorLineY, titleW, 0.5);
    
    _cellHeight = CGRectGetMaxY(_seperatorLineFrame);
}

@end
