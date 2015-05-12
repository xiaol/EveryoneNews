//
//  AbsCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/17.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "AbsCell.h"
#import "AutoLabelSize.h"

@implementation AbsCell
{
    UIView *backView;
    UILabel *bigTitle;
    
    CGFloat leftMarkY;
    CGFloat titleLabX;
    CGFloat screenW;
    
    UIImageView *rightMark;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        screenW = [UIScreen mainScreen].bounds.size.width;
        
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
         
        leftMarkY = 25;
        titleLabX = 20;
        if (screenW > 320) {
            titleLabX = 40;
        }
         UIImageView *leftMark = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabX, leftMarkY, 11, 15)];
         leftMark.image = [UIImage imageNamed:@"leftMark.png"];
         [backView addSubview:leftMark];
     
        
     
//         nameSize = [AutoLabelSize autoLabSizeWithStr:_titleStr Fontsize:16 SizeW:bigTitleW SizeH:0];
     
//         UILabel *bigTitle = [[UILabel alloc] initWithFrame:CGRectMake(bigTitleX, bigTitleY, bigTitleW, nameSize.height)];
        bigTitle = [[UILabel alloc] init];
         bigTitle.font = [UIFont fontWithName:kFont size:16];
         bigTitle.textColor = [UIColor blackColor];
         bigTitle.numberOfLines = 3;
//         bigTitle.text = _titleStr;
         [backView addSubview:bigTitle];
     
//         CGFloat rightMarkY = CGRectGetMaxY(bigTitle.frame);
//         CGFloat rightMarkX = CGRectGetMaxX(titleLab.frame) - 15;
//         UIImageView *rightMark = [[UIImageView alloc] initWithFrame:CGRectMake(rightMarkX, rightMarkY, 11, 15)];
        rightMark = [[UIImageView alloc] init];
         rightMark.image = [UIImage imageNamed:@"rightMark.png"];
         [backView addSubview:rightMark];
         
        
        
        
    }
    return self;
}

- (void)setAbsDatasource:(AbsDatasource *)absDatasource
{
    _absDatasource = absDatasource;
    [self putContent];
}

- (void)putContent
{
    CGFloat bigTitleY = leftMarkY + 12.5 + 10;
    CGFloat bigTitleX = titleLabX + 8;
    CGFloat bigTitleW = screenW - 1.8 * bigTitleX;
    
//    CGSize nameSize = [AutoLabelSize autoLabSizeWithStr:_absDatasource.absStr Fontsize:16 SizeW:bigTitleW SizeH:0];
    bigTitle.frame = CGRectMake(bigTitleX, bigTitleY, bigTitleW, 48);
    bigTitle.text = _absDatasource.absStr;
    
    CGFloat rightMarkY = CGRectGetMaxY(bigTitle.frame) + 10;
//    CGFloat rightMarkX = CGRectGetMaxX(titleLab.frame) - 15;
    CGFloat rightMarkX = screenW - 0.9 * bigTitleX;
//    UIImageView *rightMark = [[UIImageView alloc] initWithFrame:CGRectMake(rightMarkX, rightMarkY, 11, 15)];
    rightMark.frame = CGRectMake(rightMarkX, rightMarkY, 11, 15);
    
    _cellH = CGRectGetMaxY(rightMark.frame) + 25;

}

@end
