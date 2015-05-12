//
//  DateScrollView.m
//  EveryoneNews
//
//  Created by apple on 15/5/6.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "DateScrollView.h"
#import "NSDate+LP.h"


#define COUNT 9
#define DAY_RANGE 4

@interface DateScrollView ()

@property (nonatomic, weak) UIButton *selectedBtn;
// @property (nonatomic, weak) UIView *divider;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *itemBtns;
@property (nonatomic, strong) NSMutableArray *dividers;
@property (nonatomic, strong) NSMutableArray *dateLabels;

@end

@implementation DateScrollView



- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}


- (NSMutableArray *)dividers
{
    if (_dividers == nil) {
        _dividers = [NSMutableArray array];
    }
    return _dividers;
}

- (NSMutableArray *)itemBtns
{
    if (_itemBtns == nil) {
        _itemBtns = [NSMutableArray array];
    }
    return _itemBtns;
}

- (NSMutableArray *)dateLabels
{
    if (_dateLabels == nil) {
        _dateLabels = [NSMutableArray array];
    }
    return _dateLabels;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < COUNT; i++) {
            UIView *item = [[UIView alloc] init];
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = i;
            if (i % 2 == 0) {
                UIImageView *divider = [[UIImageView alloc] init];
                divider.image = [UIImage imageNamed:@"白线"];
                [self.dividers addObject:divider];
                [item addSubview:divider];
                
                UILabel *dateLabel = [[UILabel alloc] init];
                dateLabel.font = [UIFont systemFontOfSize:14];
                dateLabel.textColor = [UIColor whiteColor];
                [self.dateLabels addObject:dateLabel];
                [item addSubview:dateLabel];
                
                [btn setBackgroundImage:[UIImage imageNamed:@"底下太阳"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"底下看过太阳"] forState:UIControlStateSelected];
                
            } else {
                [btn setBackgroundImage:[UIImage imageNamed:@"底下月亮"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"底下看过"] forState:UIControlStateSelected];
            }
   
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            [self.itemBtns addObject:btn];
            [item addSubview:btn];
            [self addSubview:item];
            [self.items addObject:item];
            
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat itemW = self.contentSize.width / COUNT;
    CGFloat itemH = self.bounds.size.height;
    CGFloat itemY = 0;
    
    CGFloat dividerX = 0;
    CGFloat dividerY = self.bounds.size.height * 0.3;
    CGFloat dividerH = self.bounds.size.height * 0.6;
    CGFloat dividerW = 1;
    
    CGFloat dateX = 0;
    CGFloat dateY = 0;
    CGFloat dateH = dividerY;
    CGFloat dateW = itemW;
    for (int i = 0; i < COUNT; i++) {
        CGFloat itemX = i * itemW;
        UIView *item = self.items[i];
        item.frame = CGRectMake(itemX, itemY, itemW, itemH);
        
        CGFloat btnW = item.frame.size.width * 0.5;
        CGFloat btnH = btnW;
        CGFloat btnX = (item.frame.size.width - btnW) / 2;
        CGFloat btnY = (item.frame.size.height - btnH) / 2;
        UIButton *btn = self.itemBtns[i];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        if (i % 2 == 0) { // 白天
            // 分割线frame
            UIImageView *divider = self.dividers[i / 2];
            divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
            // 日期frame
            UILabel *dateLabel = self.dateLabels[i / 2];
            dateLabel.frame = CGRectMake(dateX, dateY, dateW, dateH);
            dateLabel.text = [NSDate dateStringSince:DAY_RANGE - i / 2 - 1  join:@"-"];
        }
    }
    if (self.type) {
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, -itemW);
    } else {
        self.contentInset = UIEdgeInsetsMake(0, -itemW, 0, 0);
    }
//    if (i == COUNT - 2) {
//        self.selectedBtn = btn;
//        btn.selected = YES;
//    }
    UIButton *btn = [[UIButton alloc] init];
    if (self.selectedTag) {
        btn = self.itemBtns[self.selectedTag];
    } else {
        btn = self.itemBtns[COUNT - 2 - (int)self.type];
    }
    self.selectedBtn = btn;
    btn.selected = YES;
}

- (void)btnClick:(UIButton *)btn
{
    NSLog(@"btn click!!!");
    // 通知代理 所选日期、时段
    if ([self.delegate respondsToSelector:@selector(dateScrollView:didSelectDate:withType:)]) {
        [self.delegate dateScrollView:self didSelectDate:[NSDate dateStringSince:(DAY_RANGE - btn.tag / 2 - 1)  join:@"-"] withType:!(btn.tag % 2) tag:btn.tag];
    }
    // 设置按钮状态
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
}
@end
