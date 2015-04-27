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
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 41)];
        backView.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:backView];
        
        UIImageView *compassImg = [[UIImageView alloc] initWithFrame:CGRectMake(24, 0, 10, 17)];
        compassImg.center = CGPointMake(compassImg.center.x, backView.center.y);
        compassImg.image = [UIImage imageNamed:@"compass.png"];
        [backView addSubview:compassImg];
        
        CGFloat timeX = CGRectGetMaxX(compassImg.frame) + 5;
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(timeX, 0, 34, 17)];
        timeLab.center = CGPointMake(timeLab.center.x, backView.center.y);
        timeLab.font = [UIFont fontWithName:kFont size:16];
        timeLab.textColor = [UIColor colorFromHexString:@"#bbbbbb"];
        timeLab.text = @"今天";
        [backView addSubview:timeLab];
        
        CGFloat cutlineX = CGRectGetMaxX(timeLab.frame) + 5;
        UIView *cutline = [[UIView alloc] initWithFrame:CGRectMake(cutlineX, 0, screenW - cutlineX, 1)];
        cutline.center = CGPointMake(cutline.center.x, backView.center.y);
        cutline.backgroundColor = [UIColor colorFromHexString:@"#e2e2e2"];
        [backView addSubview:cutline];
        
        _cellH = backView.frame.size.height;
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
