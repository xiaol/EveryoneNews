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
        
        _cellH = CGRectGetMaxY(backView.frame);
    
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
