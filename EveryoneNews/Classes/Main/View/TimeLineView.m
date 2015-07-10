//
//  TimeLineView.m
//  Test
//
//  Created by Feng on 15/7/7.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import "TimeLineView.h"
#import "UIColor+LP.h"
#import "LPPressFrame.h"

#define kTimeLabelLeftPadding 6
#define kTimeLabelRightPadding 5
#define kMonthAndDayFont [UIFont systemFontOfSize:34]
@interface TimeLineView()

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *weekLabel;
@property (nonatomic,strong) UIView *containerView;

@end
@implementation TimeLineView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加中间的横线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorFromHexString:@"dadada"];
        [self addSubview:lineView];
        self.lineView = lineView;
        
        //添加日期标签
        NSString *monthAndDay = [self getMonthAndDay];
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = kMonthAndDayFont;
        timeLabel.text = monthAndDay;
        timeLabel.textColor = [UIColor colorFromHexString:@"2b2b2b"];
        self.timeLabel = timeLabel;
        
        //添加周几标签
        NSString *weekdayAndTimeZone = [self getweekDayAndTimeZoneAndTimeZone];
        UILabel *weekLabel = [[UILabel alloc] init];
        weekLabel.text = weekdayAndTimeZone;
        weekLabel.font = [UIFont systemFontOfSize:11];
        weekLabel.textColor = [UIColor colorFromHexString:@"2b2b2b"];
        self.weekLabel = weekLabel;
        
        //横线之上的父容器
         UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor whiteColor];
        [containerView addSubview:timeLabel];
        [containerView addSubview:weekLabel];
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    return self;
}
- (void)setPressFrame:(LPPressFrame *)pressFrame{
    _pressFrame = pressFrame;
    self.frame = pressFrame.timeLineViewF;
    
    //lineView
    self.lineView.frame = CGRectMake(0, self.frame.size.height * 0.5, self.frame.size.width, 0.5);
    //timeLabel
    NSString *monthAndDay = [self getMonthAndDay];
    CGRect timeRect = [self boundingRectWithSize:monthAndDay font:kMonthAndDayFont];
    self.timeLabel.frame = CGRectMake(kTimeLabelLeftPadding, 0, timeRect.size.width, timeRect.size.height);

    //weekLabel
    NSString *weekdayAndTimeZone = [self getweekDayAndTimeZoneAndTimeZone];
      CGRect weekdayRect = [self boundingRectWithSize:weekdayAndTimeZone font:[UIFont systemFontOfSize:11]];
    self.weekLabel.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame) + 8,(timeRect.size.height - weekdayRect.size.height) * 0.5, weekdayRect.size.width, weekdayRect.size.height);

    //containerView
    self.containerView.frame = CGRectMake(kTimeLabelLeftPadding, self.frame.size.height * 0.5 -timeRect.size.height * 0.5, timeRect.size.width +weekdayRect.size.width + kTimeLabelRightPadding +kTimeLabelLeftPadding * 2, timeRect.size.height);

}
//测量文字的CGRect
- (CGRect)boundingRectWithSize:(NSString*)data font:(UIFont*)font{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGRect rect = [data boundingRectWithSize:CGSizeMake(250, 0) options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    return rect;
}
//获取日期组件
- (NSDateComponents*)getDateComponents{
    NSDate *now = [NSDate new];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday ;
   return  [calendar components:unitFlags fromDate:now];
}

//获取周几、早间或者晚间
- (NSString*)getweekDayAndTimeZoneAndTimeZone{
    NSDateComponents *dateComponent = [self getDateComponents];
    NSInteger weekday = [dateComponent weekday];
    NSInteger hour = [dateComponent hour];
    NSMutableString *weekDayAndTimeZoneAndTimeZone = [[NSMutableString alloc] init];
    switch (weekday) {
        case 1:
            [weekDayAndTimeZoneAndTimeZone appendString: @"周天"];
            break;
        case 2:
            [weekDayAndTimeZoneAndTimeZone appendString: @"周一"];
            break;
        case 3:
            [weekDayAndTimeZoneAndTimeZone appendString: @"周二"];
            break;
        case 4:
            [weekDayAndTimeZoneAndTimeZone appendString: @"周三"];
            break;
        case 5:
            [weekDayAndTimeZoneAndTimeZone appendString: @"周四"];
            break;
        case 6:
            [weekDayAndTimeZoneAndTimeZone appendString: @"周五"];
            break;
        case 7:
            [weekDayAndTimeZoneAndTimeZone appendString: @"周六"];
            break;
    }
    
    if (hour >= 6&& hour < 18) {
        [weekDayAndTimeZoneAndTimeZone appendString:@" 早间"];
    }else{
        [weekDayAndTimeZoneAndTimeZone appendString:@" 晚间"];
    }
    
    return weekDayAndTimeZoneAndTimeZone;
}
//获取相应的月日
- (NSString*)getMonthAndDay{
    NSDateComponents *dateComponent = [self getDateComponents];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    return [NSString stringWithFormat:@"%02ld·%02ld",month,day];
}
@end
