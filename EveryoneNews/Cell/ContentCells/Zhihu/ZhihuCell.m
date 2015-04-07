//
//  ZhihuCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "ZhihuCell.h"
#import "UIColor+HexToRGB.h"

@implementation ZhihuCell
{
    UIView *baseView;
    UIView *backView;
    CGFloat zhihuTitleX;
    
    CGFloat screenW;
    
    UILabel *zhihuTitle;
    UIButton *btn;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        screenW = [UIScreen mainScreen].bounds.size.width;
        
        baseView = [[UIView alloc] init];
        baseView.backgroundColor = [UIColor colorFromHexString:kGreen];
        [self.contentView addSubview:baseView];
        
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:backView];
        
        UIImageView *zhihuIcon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 32, 28)];
        zhihuIcon.image = [UIImage imageNamed:@"zhihu.png"];
        [backView addSubview:zhihuIcon];
        
        zhihuTitleX = CGRectGetMaxX(zhihuIcon.frame) + 14;
        
    }
    return self;
}

- (void)setZhihuDatasource:(ZhihuDatasource *)zhihuDatasource
{
    _zhihuDatasource = zhihuDatasource;
    [self drawDetails];
}

- (void)drawDetails
{
    
    CGFloat zhihuTitleY = 10;
    NSInteger i = 1;
    
    for (NSDictionary *dict in _zhihuDatasource.zhihuArr) {
        CGFloat zhihuTitleW = screenW - 14 - zhihuTitleX;
        CGFloat zhihuTitleH = 34;
        
        if (i != 1) {
            UIView *cutline = [[UIView alloc] init];
            CGFloat cutlineW = screenW - zhihuTitleX;
            cutline.frame = CGRectMake(zhihuTitleX, zhihuTitleY - 3, cutlineW, 1);
            cutline.backgroundColor = [UIColor colorFromHexString:@"#D6D6D6"];
            [backView addSubview:cutline];
        }
        
        zhihuTitle = [[UILabel alloc] initWithFrame:CGRectMake(zhihuTitleX, zhihuTitleY, zhihuTitleW, zhihuTitleH)];
        zhihuTitle.font = [UIFont fontWithName:kFont size:16];
        zhihuTitle.textColor = [UIColor blackColor];
//        zhihuTitle.numberOfLines = 2;
        zhihuTitle.textAlignment = NSTextAlignmentJustified;
        zhihuTitle.text = dict[@"title"];
        [backView addSubview:zhihuTitle];
        
        btn = [[UIButton alloc] initWithFrame:zhihuTitle.frame];
        [btn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i * 3000];
        [backView addSubview:btn];
        
        i++;
        
        zhihuTitleY += 10 + zhihuTitleH;
    }
    
    
    CGFloat backViewH = CGRectGetMaxY(zhihuTitle.frame) + 10;
    backView.frame = CGRectMake(0, 14, screenW, backViewH);
    
    CGFloat baseViewH = CGRectGetMaxY(backView.frame) + 14;
    baseView.frame = CGRectMake(0, 0, screenW, baseViewH);
    
    
    
    _cellH = baseViewH;
    
}

- (void)btnPress:(UIButton *)sender
{
    NSInteger tag = sender.tag / 3000 - 1;
    NSDictionary *dic = _zhihuDatasource.zhihuArr[tag];
    [self showWebViewWithUrl:dic[@"url"]];
}

@end
