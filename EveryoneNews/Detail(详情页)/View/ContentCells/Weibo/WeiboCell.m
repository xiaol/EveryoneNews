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
#import "DMPagingScrollView.h"
#import "NSString+YU.h"

@implementation WeiboCell
{
    DMPagingScrollView *scrollView;
    NSMutableArray *urlArr;
    NSInteger tagCount;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        
        urlArr = [[NSMutableArray alloc] init];
        tagCount = 1;
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 150 + 14)];
        baseView.backgroundColor = [UIColor colorFromHexString:kGreen];
        [self.contentView addSubview:baseView];
        
        scrollView = [[DMPagingScrollView alloc] initWithFrame:CGRectMake(0, 0, screenW, 160)];
        scrollView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:scrollView];
        _cellH = CGRectGetMaxY(baseView.frame);
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
    CGFloat bolder = 14.0;
    CGFloat weiboW = 195;
    CGFloat weiboH = 137;
    CGFloat weiboX = bolder;
    
    for (int i = 0; i < _weiboDatasource.weiboArr.count; i++) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(weiboX, weiboY, weiboW, weiboH)];
//        backView.backgroundColor = [UIColor yellowColor];
        NSDictionary *dic = _weiboDatasource.weiboArr[i];
        [urlArr addObject:dic[@"url"]];
//        [self setDetailsInView:backView UserName:dic[@"user"] userTitle:dic[@"title"]];
        [self noProfileImageUI:backView UserName:dic[@"user"] userTitle:dic[@"title"]];
        [scrollView addSubview:backView];
        
        weiboX += ( weiboW + bolder);
    }
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pageWidth = weiboW + bolder;
    
    CGFloat contentW = weiboX;
    scrollView.contentSize = CGSizeMake(contentW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
}


- (void)noProfileImageUI:(UIView *)backView UserName:(NSString *)userName userTitle:(NSString *)userTitle
{
    CGFloat weiboX = 7;
    UIImageView *weiboLogo = [[UIImageView alloc] initWithFrame:CGRectMake(weiboX, 7, 24.8, 21.6)];
    weiboLogo.image = [UIImage imageNamed:@"weibo.png"];
    [backView addSubview:weiboLogo];
    
    CGFloat userNameX = CGRectGetMaxX(weiboLogo.frame) + 5;
    CGFloat userNameW = 136;
    CGFloat userNameH = 14;
//    CGFloat userNameY = CGRectGetMaxY(weiboLogo.frame) - userNameH;
    UILabel *userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(userNameX, 11, userNameW, userNameH)];
    userNameLab.text = userName;
    userNameLab.font = [UIFont fontWithName:kFont size:userNameH];
    userNameLab.textColor = [UIColor blackColor];
    userNameLab.textAlignment = NSTextAlignmentLeft;
    
//    userNameLab.backgroundColor = [UIColor blueColor];
    
    [backView addSubview:userNameLab];
    
    CGFloat userTitleY = CGRectGetMaxY(weiboLogo.frame);
    CGFloat userTitleH = backView.frame.size.height - userTitleY - 8;
    CGFloat userTitleW = (backView.frame.size.width - weiboX * 2);
    UILabel *userTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(weiboX, userTitleY, userTitleW, userTitleH)];
    userTitleLab.text = userTitle;
    userTitleLab.font = [UIFont fontWithName:kFont size:13];
    userTitleLab.textColor = [UIColor colorFromHexString:@"#7f7f7f"];
    userTitleLab.numberOfLines = 0;
    userTitleLab.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:userTitleLab];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:backView.bounds];
    [btn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTag:tagCount * 2000];
    tagCount++;
    [backView addSubview:btn];

}

- (void)btnPress:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    tag = tag / 2000 - 1;
    NSString *url = urlArr[tag];
    if (![NSString isBlankString:url]) {
        [self showWebViewWithUrl:url];
    }
}
@end
