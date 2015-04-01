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
    UILabel *zhihuTitle;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        
        UIView *baseView = [[UIView alloc] init];
        baseView.backgroundColor = [UIColor colorFromHexString:kGreen];
        [self.contentView addSubview:baseView];
        
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:backView];
        
        UIImageView *zhihuIcon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 32, 28)];
        zhihuIcon.image = [UIImage imageNamed:@"zhihu.png"];
        [backView addSubview:zhihuIcon];
        
        CGFloat zhihuTitleX = CGRectGetMaxX(zhihuIcon.frame) + 14;
        CGFloat zhihuTitleW = screenW - 14 - zhihuTitleX;
        CGFloat zhihuTitleH = 34;
        zhihuTitle = [[UILabel alloc] initWithFrame:CGRectMake(zhihuTitleX, 10, zhihuTitleW, zhihuTitleH)];
        zhihuTitle.font = [UIFont fontWithName:kFont size:16];
        zhihuTitle.textColor = [UIColor blackColor];
        zhihuTitle.numberOfLines = 2;
        [backView addSubview:zhihuTitle];
        
        CGFloat backViewH = CGRectGetMaxY(zhihuTitle.frame) + 10;
        backView.frame = CGRectMake(0, 14, screenW, backViewH);
        
        CGFloat baseViewH = CGRectGetMaxY(backView.frame) + 14;
        baseView.frame = CGRectMake(0, 0, screenW, baseViewH);
        
        _cellH = baseViewH;
        
        
    }
    return self;
}

- (void)setZhihuDatasource:(ZhihuDatasource *)zhihuDatasource
{
    _zhihuDatasource = zhihuDatasource;
    zhihuTitle.text = _zhihuDatasource.title;
//    self.URL = _zhihuDatasource.url;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    [self showWebViewWithUrl:_zhihuDatasource.url];
//}

@end
