//
//  LPDetailTipView.m
//  EveryoneNews
//
//  Created by dongdan on 16/5/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPDetailTipView.h"

@implementation LPDetailTipView

- (instancetype)initWithCondition:(NSInteger)condtionNum {
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        CGFloat width = 0;
        CGFloat height = 50;
        CGFloat fontSize = 14;
        
        CGFloat imageW = 16;
        CGFloat imageH = 16;
        CGFloat imageX = 15;
        CGFloat imageY = (height - imageH) / 2;
        
        UIImage *image = [UIImage imageNamed:@"详情页完成图标"];
        UIImageView *tipImageView = [[UIImageView  alloc] initWithImage:image];
        tipImageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [self addSubview:tipImageView];
        
        NSString *tipStr;
        switch (condtionNum) {
            case 1:
                tipStr = @"收藏成功";
                break;
            case 2:
                tipStr = @"收藏已取消";
                break;
            case 3:
                
                image = [UIImage imageNamed:@"详情页关心本文"];
                tipImageView.image = image;
                tipImageView.frame = CGRectMake(imageX, imageY, 21, 18);
                tipStr = @"将推荐更多此类文章";
                break;
                
            case 4:
                tipStr = @"发表成功";
                break;
            case 5:
                tipStr = @"发表失败";
                break;
            case 6:
                tipStr = @"点赞失败";
                break;
            case 7:
                tipStr = @"不能给自己点赞";
                break;
            case 8:
                tipStr = @"您已赞过";
                break;
            default:
                break;
        }
        
        CGSize size = [tipStr sizeWithFont:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        
        CGFloat labelW = size.width;
        CGFloat labelH = size.height;
        CGFloat labelY = (height - labelH) / 2;
        CGFloat labelPaddingLeft = 5;
        
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = [UIFont systemFontOfSize:fontSize];
        tipLabel.frame = CGRectMake(CGRectGetMaxX(tipImageView.frame) + labelPaddingLeft, labelY, labelW, labelH);
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.text = tipStr;
        [self addSubview:tipLabel];
        
        width = size.width + imageW + imageX * 2 + labelPaddingLeft;
        
        self.frame = CGRectMake((ScreenWidth - width) / 2, (ScreenHeight - height) / 2, width, height);
        self.layer.cornerRadius = 5;
        
    }
    return self;
}

@end
