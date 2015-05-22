//
//  CenterCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/27.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "CenterCell.h"
#import "UIColor+HexToRGB.h"
#import "Time.h"

@interface CenterCell ()

@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *weekday;

@end
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
       
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(timeX, compassImg.center.y - timeH - 2, 100, timeH)];
        self.timeLab = timeLab;

        _timeLab.font = [UIFont fontWithName:kFont size:12.5];
        _timeLab.textColor = [UIColor blackColor];
        _timeLab.text = @"今天";
        [backView addSubview:_timeLab];
        

        CGFloat cutlineX = CGRectGetMaxX(compassImg.frame) + 5;
        UIView *cutline = [[UIView alloc] initWithFrame:CGRectMake(cutlineX, 0, screenW - cutlineX, 1)];
        cutline.center = CGPointMake(cutline.center.x, compassImg.center.y);
        cutline.backgroundColor = [UIColor colorFromHexString:@"#e2e2e2"];
        [backView addSubview:cutline];
        
        UILabel *weekday = [[UILabel alloc] init];
        self.weekday = weekday;
        _weekday.frame = CGRectMake(timeX, cutline.frame.origin.y + 2, 100, timeH);
        _weekday.font = [UIFont fontWithName:kFont size:12.5];

        _weekday.textColor = [UIColor blackColor];

        [backView addSubview:_weekday];
        
        _cellH = backView.frame.size.height;
 
    }
    
    return self;
}



- (void)setTime:(Time *)time
{
    
    self.timeLab.text = nil;
    self.weekday.text = nil;
    _time = time;
    self.time.timeStr = time.timeStr;
    self.time.type = time.type;
    if (!time) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //           dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        
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
            }  else if ([dayStr substringWithRange:r2].intValue == 0) {
                dayStr = [NSString stringWithFormat:@"%@十", s1];
            }

            else {
                dayStr = [NSString stringWithFormat:@"%@十%@", s1, s2];
            }
            
        }
        _timeLab.text = [NSString stringWithFormat:@"%@月%@日", monthStr, dayStr];
        
        
        [dateFormatter setDateFormat:@"h"];
        NSString *apStr = [dateFormatter stringFromDate:[NSDate date]];
        if (apStr.intValue <= 17 && apStr.intValue >= 6) {
            apStr = @"白天";
        } else {
            apStr = @"晚上";
        }
        
        
        [dateFormatter setDateFormat:@"c"];
        NSString *weekdayStr = [dateFormatter stringFromDate:[NSDate date]];
        if (weekdayStr.intValue > 0) {
            weekdayStr = [self arabicNumberToChinese:[NSString stringWithFormat:@"%d", weekdayStr.intValue - 1]];
        } else {
            weekdayStr = @"日";
        }
        
        apStr = [NSString stringWithFormat:@"星期%@ %@", weekdayStr, apStr];
        _weekday.text = apStr;
        
    

    } else
    {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [fmt dateFromString:_time.timeStr];

        fmt.dateFormat = @"M";
        
        NSString *monthStr = [fmt stringFromDate:date];
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
        
        fmt.dateFormat = @"d";
        
        NSString *dayStr = [fmt stringFromDate:date];
        if (dayStr.length == 1) {
            dayStr = [self arabicNumberToChinese:dayStr];
        } else {
            NSRange r1 = {0, 1};
            NSRange r2 = {1, 1};
            NSString *s1 = [self arabicNumberToChinese:[dayStr substringWithRange:r1]];
            NSString *s2 = [self arabicNumberToChinese:[dayStr substringWithRange:r2]];
            if ([dayStr substringWithRange:r1].intValue == 1) {
                dayStr = [NSString stringWithFormat:@"十%@", s2];
            } else if ([dayStr substringWithRange:r2].intValue == 0) {
                dayStr = [NSString stringWithFormat:@"%@十", s1];
            }
            else {
                dayStr = [NSString stringWithFormat:@"%@十%@", s1, s2];
            }
            
        }
        _timeLab.text = [NSString stringWithFormat:@"%@月%@日", monthStr, dayStr];
        
        
        NSString *apStr = @"";
        if (_time.type.intValue) {
            apStr = @"白天";
        } else {
            apStr = @"晚上";
        }
        
        
        fmt.dateFormat = @"c";
        NSString *weekdayStr = [fmt stringFromDate:date];
        NSLog(@"weekday = %@", weekdayStr);
        if (weekdayStr.intValue > 0) {
            weekdayStr = [self arabicNumberToChinese:[NSString stringWithFormat:@"%d", weekdayStr.intValue - 1]];
            NSLog(@"weekday = %@", weekdayStr);
        } else {
            weekdayStr = @"日";
        }
     
        apStr = [NSString stringWithFormat:@"星期%@ %@", weekdayStr, apStr];
        _weekday.text = apStr;


    }
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
