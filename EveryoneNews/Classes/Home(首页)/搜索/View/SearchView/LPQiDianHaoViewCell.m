//
//  LPQiDianHaoViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPQiDianHaoViewCell.h"

@implementation LPQiDianHaoViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSInteger tag = 12345;
        NSArray *array = @[@"1", @"2", @"3", @"4"];
        // 添加奇点号
        UIView *qiDianView = [self qiDianViewWithArray:array tag:tag];
        [self.contentView addSubview:qiDianView];
    }
    return self;
}

#pragma mark - 奇点号
- (UIView *)qiDianViewWithArray:(NSArray *)array tag:(NSInteger)tag {
    
    UIView *qiDianView = [[UIView alloc] init];
    qiDianView.tag = tag;
    qiDianView.backgroundColor = [UIColor colorFromHexString:LPColor5];
    
    UIView *childView = [[UIView alloc] init];
    childView.backgroundColor = [UIColor whiteColor];
    
    CGFloat childViewY = 11;
    CGFloat childViewH = 0;
    CGFloat chileViewW = ScreenWidth;
    
    NSString *qiDianStr = @"奇点号";
    CGFloat qiDianLabelY = 18;
    CGFloat qiDianLabelX = 12;
    CGFloat qiDianLabelW = [qiDianStr sizeWithFont:[UIFont systemFontOfSize:LPFont2] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat qiDianLabelH = [qiDianStr sizeWithFont:[UIFont systemFontOfSize:LPFont2] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    
    // 奇点号
    UILabel *qiDianLabel = [[UILabel alloc] initWithFrame:CGRectMake(qiDianLabelX, qiDianLabelY, qiDianLabelW, qiDianLabelH)];
    qiDianLabel.text = qiDianStr;
    qiDianLabel.textColor = [UIColor colorWithHexString:LPColor3];
    qiDianLabel.font = [UIFont systemFontOfSize:LPFont2];
    [childView addSubview:qiDianLabel];
    
    CGFloat imageViewW = 59;
    CGFloat imageViewH = 59;
    CGFloat imageViewY = CGRectGetMaxY(qiDianLabel.frame) + 17;
    CGFloat imageViewX = 18;
    
    NSString *title = @"历史";
    CGFloat titleLabelH = [title sizeWithFont:[UIFont systemFontOfSize:LPFont5] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    NSInteger count = array.count;
    CGFloat gap = (ScreenWidth - 4 * imageViewW - imageViewX * 2) / 3;
    for (int i = 0 ; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageViewX = ((ScreenWidth - count * imageViewW - (count - 1) * gap) / 2) + (imageViewW + gap) * i;
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        
        if (i == 3) {
            imageView.image = [UIImage imageNamed:@"奇点号更多"];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapQiDianHaoMore:)];
            [imageView addGestureRecognizer:tapGesture];
            
        } else {
            imageView.image = [UIImage imageNamed:@"奇点号占位图1"];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapQiDianHao)];
            [imageView addGestureRecognizer:tapGesture];
        }
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(imageViewX, CGRectGetMaxY(imageView.frame) + 7, imageViewW, titleLabelH);
        titleLabel.textColor = [UIColor colorWithHexString:LPColor3];
        titleLabel.font = [UIFont systemFontOfSize:LPFont5];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        
        [childView addSubview:imageView];
        [childView addSubview:titleLabel];
        childViewH = CGRectGetMaxY(titleLabel.frame) + 18;
    }
    childView.frame = CGRectMake(0, childViewY, chileViewW, childViewH);
    
    [qiDianView addSubview:childView];
 
    qiDianView.frame = CGRectMake(0, 0, ScreenWidth, [self heightWithQiDianView]);
    
    return qiDianView;
}


- (CGFloat)heightWithQiDianView {
    NSString *qiDianStr = @"奇点号";
    CGFloat qiDianLabelH = [qiDianStr sizeWithFont:[UIFont systemFontOfSize:LPFont2] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    NSString *title = @"历史";
    CGFloat titleLabelH = [title sizeWithFont:[UIFont systemFontOfSize:LPFont5] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat padding = 11 * 2 + 18 * 2 + 17 + 7 + 59;
    return qiDianLabelH + titleLabelH + padding;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

#pragma mark - 奇点号更多
- (void)tapQiDianHaoMore:(UIImageView *)imageView {
    if ([self.delegate respondsToSelector:@selector(cell:didTapWithQiDianMoreImageView:)]) {
        [self.delegate cell:self didTapWithQiDianMoreImageView:imageView];
    }
    
//    if ([self.delegate respondsToSelector:@selector(didTapQiDianHaoMoreWithCell:)]) {
//        NSLog(@"ss");
////        [self.delegate didTapQiDianHaoMoreWithCell:self];
//    }
}

- (void)tapQiDianHao {
     NSLog(@"奇点号");
}
@end
