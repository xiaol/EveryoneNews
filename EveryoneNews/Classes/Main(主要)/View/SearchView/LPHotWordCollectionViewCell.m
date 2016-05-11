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
        CGFloat titleFontSize = 16;
        if (iPhone6Plus) {
            titleFontSize = 18;
        }
        UILabel *hotWordLabel = [[UILabel alloc] init];
        
        hotWordLabel.font = [UIFont systemFontOfSize:titleFontSize];
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
    CGFloat enlargeWidth = 8;
    if (iPhone6Plus) {
        enlargeWidth = 12;
    }
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label sizeToFit];
    CGFloat width = label.frame.size.width + enlargeWidth;
    CGFloat height = label.frame.size.height + enlargeWidth;
    self.hotWordLabel.frame = CGRectMake(0, 0, width, height);
    self.hotWordLabel.text = title;
}


@end
