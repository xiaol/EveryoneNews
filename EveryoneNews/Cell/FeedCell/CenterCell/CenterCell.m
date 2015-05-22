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
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
        backView.backgroundColor = [UIColor colorFromHexString:@"#ebeded"];
        [self.contentView addSubview:backView];
        
        UIImageView *compassImg = [[UIImageView alloc] initWithFrame:CGRectMake(24, 0, 10, 17)];
        compassImg.center = CGPointMake(compassImg.center.x, backView.center.y);
        compassImg.image = [UIImage imageNamed:@"compass.png"];
        [backView addSubview:compassImg];
        
        CGFloat timeX = CGRectGetMaxX(compassImg.frame) + 8;
        CGFloat timeH = 13.0;
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(timeX, compassImg.center.y - timeH - 2, 100, timeH)];
        _timeLab.font = [UIFont fontWithName:kFont size:12.5];
        _timeLab.textColor = [UIColor blackColor];
        _timeLab.text = @"今天";
        [backView addSubview:_timeLab];
        

        CGFloat cutlineX = CGRectGetMaxX(compassImg.frame) + 5;
        UIView *cutline = [[UIView alloc] initWithFrame:CGRectMake(cutlineX, 0, screenW - cutlineX, 1)];
        cutline.center = CGPointMake(cutline.center.x, compassImg.center.y);
        cutline.backgroundColor = [UIColor colorFromHexString:@"#e2e2e2"];
        [backView addSubview:cutline];
        
        _weekday = [[UILabel alloc] init];
        _weekday.frame = CGRectMake(timeX, cutline.frame.origin.y + 2, 100, timeH);
        _weekday.font = [UIFont fontWithName:kFont size:12.5];

        _weekday.textColor = [UIColor blackColor];

        [backView addSubview:_weekday];
        
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
        [dateFormatter setDateFormat:@"'公元前/后:'G  '年份:'u'='yyyy'='yy '季度:'q'='qqq'='qqqq '月份:'M'='MMM'='MMMM '今天是今年第几周:'w '今天是本月第几周:'W  '今天是今年第几天:'D'今天是本月第几天:'d '星期:'c'='ccc'='cccc '上午/下午:'a '小时:'h'='H '分钟:'m '秒:'s '毫秒:'SSS  '这一天已过多少毫秒:'A  '时区名称:'zzzz'='vvvv '时区编号:'Z "];
        NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
        
        [dateFormatter setDateFormat:@"M"];
        
        NSString *monthStr = [dateFormatter stringFromDate:[NSDate date]];
        if (monthStr.length == 1) {
            monthStr = [self arabicNumberToChinese:monthStr];
        } else {
            NSRange r = {1, 1};
            if ([monthStr substringWithRange:r].intValue == 0) {
                monthStr = @"十";
            } else {
                NSString *s = [self arabicNumberToChinese:[monthStr substringWithRange:r]];
                monthStr = [NSString stringWithFormat:@"十%@", s];
            }
        }

        
        
        [dateFormatter setDateFormat:@"d"];
        
        NSString *dayStr = [dateFormatter stringFromDate:[NSDate date]];
        if (dayStr.length == 1) {
            dayStr = [self arabicNumberToChinese:dayStr];
        } else {
            NSRange r1 = {0, 1};
            NSRange r2 = {1, 1};
            NSString *s1 = [self arabicNumberToChinese:[dayStr substringWithRange:r1]];
            NSString *s2 = [self arabicNumberToChinese:[dayStr substringWithRange:r2]];
            if ([dayStr substringWithRange:r1].intValue == 1) {
                dayStr = [NSString stringWithFormat:@"十%@", s2];
            } else {
                dayStr = [NSString stringWithFormat:@"%@十%@", s1, s2];
            }
            
        }
        _timeLab.text = [NSString stringWithFormat:@"%@月%@日", monthStr, dayStr];
//        if (<#condition#>) {
//            <#statements#>
//        }
        //
        
        [dateFormatter setDateFormat:@"h"];
        NSString *apStr = [dateFormatter stringFromDate:[NSDate date]];
//        if ([apStr isEqualToString:@"AM"]) {
//            apStr = @"上午";
//        } else if ([apStr isEqualToString:@"PM"]) {
//            apStr = @"下午";
//        }
        if (apStr.intValue < 12) {
            apStr = @"上午";
        } else {
            apStr = @"下午";
        }

        
        [dateFormatter setDateFormat:@"c"];
        NSString *weekdayStr = [dateFormatter stringFromDate:[NSDate date]];
        weekdayStr = [self arabicNumberToChinese:weekdayStr];
        apStr = [NSString stringWithFormat:@"星期%@ %@", weekdayStr, apStr];
        _weekday.text = apStr;
        

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

- (NSString *)arabicNumberToChinese:(NSString *)num
{
    switch (num.intValue) {
        case 1:
            return @"一";
            break;
        case 2:
            return @"二";
            break;
        case 3:
            return @"三";
            break;
        case 4:
            return @"四";
            break;
        case 5:
            return @"五";
            break;
        case 6:
            return @"六";
            break;
        case 7:
            return @"七";
            break;
        case 8:
            return @"八";
            break;
        case 9:
            return @"九";
            break;
        case 0:
            return @"十";
            break;
            
        default:
            return @"";
            break;
    }
}

@end
