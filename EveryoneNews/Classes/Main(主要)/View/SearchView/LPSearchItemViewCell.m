//
//  LPSearchItemViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/1/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSearchItemViewCell.h"
#import "LPSearchItemFrame.h"
#import "LPSearchItem.h"

@interface LPSearchItemViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *seperatorLineLabel;

@end

@implementation LPSearchItemViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat titleFontSize = 16;
        CGFloat sourceFontSize = 10;
        if (iPhone6Plus) {
            titleFontSize = 18;
            sourceFontSize = 12;
        }
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor colorFromHexString:@"#2b2b2b"];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont fontWithName:OpinionFontName size:titleFontSize];
        titleLabel.numberOfLines = 0;
        titleLabel.clipsToBounds = YES;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.textColor = [UIColor colorFromHexString:@"#747474"];
        sourceLabel.font = [UIFont fontWithName:OpinionFontName size:sourceFontSize];
        [self.contentView addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        UILabel *seperatorLineLabel = [[UILabel alloc] init];
        seperatorLineLabel.backgroundColor = [UIColor colorFromHexString:@"dadada"];
        [self.contentView addSubview:seperatorLineLabel];
        self.seperatorLineLabel = seperatorLineLabel;
    }
    return  self;
}

- (void)setSearchItemFrame:(LPSearchItemFrame *)searchItemFrame {
    _searchItemFrame = searchItemFrame;
    LPSearchItem *searchItem = _searchItemFrame.searchItem;

    NSString *sourceSiteName = [searchItem.sourceSiteName  isEqualToString: @""] ? @"未知来源": searchItem.sourceSiteName;
    NSString *source = [NSString stringWithFormat:@"%@    %@",sourceSiteName,searchItem.updateTime];
    self.titleLabel.frame = self.searchItemFrame.titleFrame;
    self.sourceLabel.frame = self.searchItemFrame.sourceFrame;
    self.seperatorLineLabel.frame = self.searchItemFrame.seperatorLineFrame;
    self.titleLabel.text = searchItem.title;
    self.sourceLabel.text = source;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}
@end
