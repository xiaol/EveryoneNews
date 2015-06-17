//
//  LPIconsView.m
//  EveryoneNews
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPIconsView.h"
#import "LPPressFrame.h"
#import "LPPress.h"

//@interface LPIconsView ()
//@property (nonatomic, strong) NSMutableArray *icons;
//@end

@implementation LPIconsView

//- (NSMutableArray *)icons
//{
//    if (_icons == nil) {
//        _icons = [NSMutableArray array];
//    }
//    return _icons;
//}

- (void)setPressFrame:(LPPressFrame *)pressFrame{
    _pressFrame = pressFrame;
    int index = 0;
    NSMutableArray *icons = [self getAllDispalyIcon:pressFrame];
    for (int i = 0; i < icons.count; i++) {
        UIImageView *subView = self.subviews[i];
        if([[icons objectAtIndex:i] isEqualToString:@"1"]){
            subView.hidden = NO;
            subView.frame = CGRectMake((index++) * (IconW + IconBorder), 0, IconW, IconW);
        }else{
            subView.hidden=YES;
        }
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < Icons.count; i++) {
            UIImage *icon = [UIImage imageNamed:[Icons objectAtIndex:i]];
            UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
            //            [self.icons addObject:iconView];
            [self addSubview:iconView];
        }
    }
    return self;
}

/**
 *  获取所有要显示的小图标icon集合
 *
 *  @param pressFrame feed流新闻集合
 *
 *  @return 返回显示小图标集合
 */
- (NSMutableArray *)getAllDispalyIcon:(LPPressFrame *)pressFrame{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",nil];
    if (pressFrame.press.isWeiboFlag.intValue != 0) {
        [array replaceObjectAtIndex:0 withObject:@"1"];
    }
    if (pressFrame.press.isBaikeFlag.intValue != 0) {
        [array replaceObjectAtIndex:1 withObject:@"1"];
    }
    if (pressFrame.press.isZhihuFlag.intValue != 0) {
        [array replaceObjectAtIndex:2 withObject:@"1"];
    }
    if (pressFrame.press.isImgWallFlag.intValue != 0) {
        [array replaceObjectAtIndex:3 withObject:@"1"];
    }
    if (pressFrame.press.isCommentsFlag.intValue != 0) {
        [array replaceObjectAtIndex:4 withObject:@"1"];
    }
    return array;
}

@end
