//
//  WeiboCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HexToRGB.h"

@implementation WeiboCell
{
    UIScrollView *scrollView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenW, 125)];
        scrollView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:scrollView];
        _cellH = 125;
    }
    return self;
}

- (void)setWeiboDatasource:(WeiboDatasource *)weiboDatasource
{
    _weiboDatasource = weiboDatasource;
    [self setScrollViewContent];
}

- (void)setScrollViewContent
{
    CGFloat weiboY = 10;
    
    UIImageView *weiboLogo = [[UIImageView alloc] initWithFrame:CGRectMake(14, weiboY, 32, 28)];
    weiboLogo.image = [UIImage imageNamed:@"weibo.png"];
    [scrollView addSubview:weiboLogo];
    
    CGFloat bolder = 14.0;
    CGFloat weiboW = 195;
    CGFloat weiboH = 102;
    CGFloat weiboX = CGRectGetMaxX(weiboLogo.frame) + bolder;
    
    for (int i = 0; i < _weiboDatasource.weiboArr.count; i++) {
        weiboX += ( weiboW + bolder) * i;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(weiboX, weiboY, weiboW, weiboH)];
        NSDictionary *dic = _weiboDatasource.weiboArr[i];
        [self setDetailsInView:backView UserName:dic[@"user"] userTitle:dic[@"title"]];
        [scrollView addSubview:backView];
    }
}

- (void)setDetailsInView:(UIView *)backView UserName:(NSString *)userName userTitle:(NSString *)userTitle
{
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 36, 36)];
    NSURL *URL = [NSURL URLWithString:@"http://tp2.sinaimg.cn/3189729061/180/5671804570/1"];
    [iconImg sd_setImageWithURL:URL];
    [backView addSubview:iconImg];
    
    CGFloat userNameX = CGRectGetMaxX(iconImg.frame) + 9;
    CGFloat userNameW = 136;
    CGFloat userNameH = 12;
    UILabel *userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(userNameX, 7, userNameW, userNameH)];
    userNameLab.text = userName;
    userNameLab.font = [UIFont fontWithName:kFont size:12];
    userNameLab.textColor = [UIColor blackColor];
    userNameLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:userNameLab];
    
    CGFloat userTitleY = CGRectGetMaxY(userNameLab.frame) + 8;
    UILabel *userTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(userNameX, userTitleY, userNameW, 24)];
    userTitleLab.text = userTitle;
    userTitleLab.font = [UIFont fontWithName:kFont size:11];
    userTitleLab.textColor = [UIColor colorFromHexString:@"#7f7f7f"];
    userTitleLab.numberOfLines = 2;
    [backView addSubview:userTitleLab];
    
}

@end
