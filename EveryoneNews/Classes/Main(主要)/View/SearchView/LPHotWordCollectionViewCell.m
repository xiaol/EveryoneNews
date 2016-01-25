//
//  LPHotWordCollectionViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/1/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPHotWordCollectionViewCell.h"

@interface LPHotWordCollectionViewCell ()



@end
@implementation LPHotWordCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *hotWordLabel = [[UILabel alloc] init];
        hotWordLabel.font = [UIFont systemFontOfSize:16];
        hotWordLabel.textColor = [UIColor colorFromHexString:@"#545454"];
        hotWordLabel.textAlignment = NSTextAlignmentCenter;
        hotWordLabel.layer.borderColor = [UIColor colorFromHexString:@"#d2d2d2"].CGColor;
        hotWordLabel.layer.cornerRadius = 5.0f;
        hotWordLabel.layer.borderWidth = 0.5f;;
        hotWordLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:hotWordLabel];
        self.hotWordLabel = hotWordLabel;
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label sizeToFit];
    CGFloat width = label.frame.size.width + 8;
    CGFloat height = label.frame.size.height + 8;
    self.hotWordLabel.frame = CGRectMake(0, 0, width, height);
    self.hotWordLabel.text = title;
}


@end
