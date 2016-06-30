//
//  LPChannelItemCollectionReusableView.m
//  EveryoneNews
//
//  Created by dongdan on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPChannelItemCollectionReusableView.h"

@implementation LPChannelItemCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
        CGFloat fontSize = LPFont4;
        CGFloat height = 38;
        
        CGFloat colorLabelW = 4;
        CGFloat colorLabelH = 15;
        CGFloat colorLabelX = 0;
        CGFloat colorLabelY = (height - colorLabelH) / 2;
        
        UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(colorLabelX, colorLabelY, colorLabelW, colorLabelH)];
        colorLabel.backgroundColor = [UIColor colorFromHexString:@"#0091fa"];
        [self addSubview:colorLabel];
        
        CGFloat paddingColorLabel = 8;
        NSString *title = @"我的频道 (拖动调整顺序)";
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        
        CGFloat titleLabelX = colorLabelW + paddingColorLabel;
        CGFloat titleLabelW = size.width;
        CGFloat titleLabelH = size.height;
        CGFloat titleLabelY = (height - titleLabelH) / 2;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
        titleLabel.font = [UIFont systemFontOfSize:LPFont4];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        // 分割线
        UILabel *firstSeperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 0.5, ScreenWidth, 0.5)];
        firstSeperatorLabel.backgroundColor = [UIColor colorFromHexString:LPColor5];
        [self addSubview:firstSeperatorLabel];
        
 
    }
    return self;
}

@end
