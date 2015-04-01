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
        
        UIImageView *doubanIcon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 32, 28)];
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
   
    
    
    for (NSArray *arr in _doubanDatasource.tagArr) {
        tagStr = arr[0];
        UILabel *tagLab = [[UILabel alloc] init];
        NSDictionary * attribute = @{NSFontAttributeName: [UIFont fontWithName:kFont size:12.5]};
        CGSize nameSize = [tagStr boundingRectWithSize:CGSizeMake(0, tagH) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        if (tagX + nameSize.width <= screenW - 14) {
            tagLab.frame = CGRectMake(tagX, tagY, nameSize.width, tagH);
        } else {
            tagX = doubanLeftX;
            tagY += tagH;
            tagLab.frame = CGRectMake(tagX, tagY, nameSize.width, tagH);
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
        [backView addSubview:tagLab];
    }
    
    CGFloat backViewH = tagY + tagH + 10;
    backView.frame = CGRectMake(0, 14, screenW, backViewH);
    
    baseView.frame = CGRectMake(0, 0, screenW, backViewH + 14 * 2);
    _cellH = CGRectGetMaxY(baseView.frame);
}

@end
