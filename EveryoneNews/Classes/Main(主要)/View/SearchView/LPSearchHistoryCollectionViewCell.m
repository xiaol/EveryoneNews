//
//  LPSearchHistoryCollectionViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/1/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSearchHistoryCollectionViewCell.h"

@implementation LPSearchHistoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGFloat titleFontSize = 16;
        if (iPhone6Plus) {
            titleFontSize = 18;
        }
        UILabel *searchHistoryLabel = [[UILabel alloc] init];
        searchHistoryLabel.font = [UIFont systemFontOfSize:titleFontSize];
        searchHistoryLabel.textColor = [UIColor colorFromHexString:@"#545454"];
        searchHistoryLabel.textAlignment = NSTextAlignmentCenter;
        searchHistoryLabel.layer.borderColor = [UIColor colorFromHexString:@"#d2d2d2"].CGColor;
        searchHistoryLabel.layer.cornerRadius = 5.0f;
        searchHistoryLabel.layer.borderWidth = 0.5f;;
        searchHistoryLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:searchHistoryLabel];
        self.searchHistoryLabel = searchHistoryLabel;
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label sizeToFit];
    CGFloat enlargeWidth = 8;
    if (iPhone6Plus) {
        enlargeWidth = 12;
    }
    CGFloat width = label.frame.size.width + enlargeWidth;
    CGFloat height = label.frame.size.height + enlargeWidth;
    self.searchHistoryLabel.frame = CGRectMake(0, 0, width, height);
    self.searchHistoryLabel.text = title;
}


@end
