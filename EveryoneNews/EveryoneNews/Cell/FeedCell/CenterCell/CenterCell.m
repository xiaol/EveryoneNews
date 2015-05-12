//
//  CenterCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/27.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "CenterCell.h"
#import "UIColor+HexToRGB.h"

@implementation CenterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 38)];
        backView.backgroundColor = [UIColor colorFromHexString:@"#ebeded"];
        [self.contentView addSubview:backView];
        
        UIImageView *compassImg = [[UIImageView alloc] initWithFrame:CGRectMake(24, 0, 10, 17)];
        compassImg.center = CGPointMake(compassImg.center.x, backView.center.y);
        compassImg.image = [UIImage imageNamed:@"compass.png"];
        [backView addSubview:compassImg];
        
        CGFloat timeX = CGRectGetMaxX(compassImg.frame) + 5;
        CGFloat timeH = 12.0;
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(timeX, compassImg.center.y - timeH, 60, timeH)];
//        timeLab.center = CGPointMake(timeLab.center.x, compassImg.center.y);
        timeLab.font = [UIFont fontWithName:kFont size:timeH];
//        timeLab.textColor = [UIColor colorFromHexString:@"#bbbbbb"];
        timeLab.textColor = [UIColor blackColor];
        timeLab.text = @"今天";
        [backView addSubview:timeLab];
        
//        CGFloat cutlineX = CGRectGetMaxX(timeLab.frame) + 5;
        CGFloat cutlineX = CGRectGetMaxX(compassImg.frame) + 5;
        UIView *cutline = [[UIView alloc] initWithFrame:CGRectMake(cutlineX, 0, screenW - cutlineX, 1)];
        cutline.center = CGPointMake(cutline.center.x, compassImg.center.y);
        cutline.backgroundColor = [UIColor colorFromHexString:@"#e2e2e2"];
        [backView addSubview:cutline];
        
        UILabel *weekday = [[UILabel alloc] init];
        weekday.frame = CGRectMake(cutlineX, cutline.frame.origin.y + 1, 60, timeH);
        weekday.font = [UIFont fontWithName:kFont size:timeH];
//        weekday.textColor = [UIColor colorFromHexString:@"#bbbbbb"];
        weekday.textColor = [UIColor blackColor];
//        weekday.text = @"今天";
        [backView addSubview:weekday];
        
        _cellH = backView.frame.size.height;
        
        
//        //时间戳
//        NSDate *now = [NSDate date];
//        NSLog(@"now date is: %@", now);
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
//        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
//        NSInteger year = [dateComponent year];
//        NSInteger month = [dateComponent month];
//        NSInteger day = [dateComponent day];
//        NSInteger hour = [dateComponent hour];
//        NSInteger minute = [dateComponent minute];
//        NSInteger second = [dateComponent second];
//        NSInteger week = [dateComponent weekday];
//        NSLog(@"year:%ld M:%ld D:%ld H:%ld M:%ld S:%ld Week:%ld", year, month, day, hour, minute, second, week);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"'公元前/后:'G  '年份:'u'='yyyy'='yy '季度:'q'='qqq'='qqqq '月份:'M'='MMM'='MMMM '今天是今年第几周:'w '今天是本月第几周:'W  '今天是今天第几天:'D '今天是本月第几天:'d '星期:'c'='ccc'='cccc '上午/下午:'a '小时:'h'='H '分钟:'m '秒:'s '毫秒:'SSS  '这一天已过多少毫秒:'A  '时区名称:'zzzz'='vvvv '时区编号:'Z "];
//        NSLog(@"%@", [dateFormatter stringFromDate:[NSData date]]);
        NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
        
        [dateFormatter setDateFormat:@"MMMMd'日'"];
        timeLab.text = [dateFormatter stringFromDate:[NSDate date]];
        
        [dateFormatter setDateFormat:@"cccca"];
        weekday.text = [dateFormatter stringFromDate:[NSDate date]];
        
        [dateFormatter setDateFormat:@"MMMM DDDD dddd cccc a"];
        NSLog(@"----%@", [dateFormatter stringFromDate:[NSDate date]]);
 
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
