//
//  DoubanCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "DoubanCell.h"
#import "UIColor+HexToRGB.h"

@implementation DoubanCell
{
    UIView *baseView;
    UIView *backView;
    UIImageView *doubanIcon;
    CGFloat doubanLeftX;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        baseView = [[UIView alloc] init];
        baseView.backgroundColor = [UIColor colorFromHexString:kGreen];
        [self.contentView addSubview:baseView];
        
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:backView];
        
        doubanIcon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 32, 28)];
        doubanIcon.image = [UIImage imageNamed:@"douban.png"];
        [backView addSubview:doubanIcon];
        
        doubanLeftX = CGRectGetMaxX(doubanIcon.frame) + 14;
    }
    return self;
}

- (void)setDoubanDatasource:(DoubanDatasource *)doubanDatasource
{
    _doubanDatasource = doubanDatasource;
    [self setTags];
}

- (void)setTags
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat tagH = 17;
    CGFloat tagX = doubanLeftX;
    CGFloat tagY = 10;
    
    NSString *tagStr;
    
    NSInteger tag = 1;
   
    
    
    for (NSArray *arr in _doubanDatasource.tagArr) {
        tagStr = arr[0];
        UILabel *tagLab = [[UILabel alloc] init];
        NSDictionary * attribute = @{NSFontAttributeName: [UIFont fontWithName:kFont size:12.5]};
        CGSize nameSize = [tagStr boundingRectWithSize:CGSizeMake(0, tagH) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        if (tagX + nameSize.width + 6<= screenW - 14) {
            tagLab.frame = CGRectMake(tagX, tagY, nameSize.width + 6, tagH);
        } else {
            tagX = doubanLeftX;
            tagY += tagH + 10;
            tagLab.frame = CGRectMake(tagX, tagY, nameSize.width + 6, tagH);
        }
        tagX = tagX + nameSize.width + 14;
        
        UIView *tagView = [[UIView alloc] initWithFrame:tagLab.frame];
        tagView.backgroundColor = [UIColor clearColor];
        tagView.layer.borderWidth = 1;
        tagView.layer.borderColor = [UIColor colorFromHexString:@"#4db3ea"].CGColor;
        tagView.layer.cornerRadius = 2;
        [backView addSubview:tagView];

        
        tagLab.font = [UIFont fontWithName:kFont size:12.5];
        tagLab.text = tagStr;
        tagLab.textColor = [UIColor colorFromHexString:@"#4db3ea"];
        tagLab.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:tagLab];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:tagLab.frame];
        [btn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
//        btn.tag = tag * 1000;
        [btn setTag:tag * 1000];
        tag++;
        [backView addSubview:btn];
    }
    
    CGFloat backViewH;
    if (tagY == 10) {
        backViewH = CGRectGetMaxY(doubanIcon.frame) + 10;
    } else {
        backViewH = tagY + tagH + 10;
    }
    backView.frame = CGRectMake(0, 14, screenW, backViewH);
    
    baseView.frame = CGRectMake(0, 0, screenW, backViewH + 14 * 2);
    _cellH = CGRectGetMaxY(baseView.frame);
}

- (void)btnPress:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    tag = tag / 1000 - 1;
    
    NSString *url = _doubanDatasource.tagArr[tag][1];
    [self showWebViewWithUrl:url];
}

@end
