//
//  MoreCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/27.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "MoreCell.h"

@implementation MoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 70)];
        backView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:backView];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.text = @"继续阅读";
        titleLab.font = [UIFont fontWithName:kFont size:20];
        titleLab.center = backView.center;
        [backView addSubview:titleLab];
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(screenW - 50, 0, 32, 32)];
        arrowImg.center = CGPointMake(arrowImg.center.x, backView.center.y);
        arrowImg.image = [UIImage imageNamed:@"arrowInCircle.png"];
        [backView addSubview:arrowImg];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:backView.frame];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(btnPress) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
        
        _cellH = CGRectGetMaxY(backView.frame);
        
        
        //时间戳
        NSDate *now = [NSDate date];
        NSLog(@"now date is: %@", now);
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        NSInteger year = [dateComponent year];
        NSInteger month = [dateComponent month];
        NSInteger day = [dateComponent day];
        NSInteger hour = [dateComponent hour];
        NSInteger minute = [dateComponent minute];
        NSInteger second = [dateComponent second];
        
        NSLog(@"year:%ld M:%ld D:%ld H:%ld M:%ld S:%ld", year, month, day, hour, minute, second);
    }
    return self;
}

- (void)btnPress
{
    NSLog(@"btnPress -------------");
    if ([self.delegate respondsToSelector:@selector(scrollToPosition)]) {
        [self.delegate scrollToPosition];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
