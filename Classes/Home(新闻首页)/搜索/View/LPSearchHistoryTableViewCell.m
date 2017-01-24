//
//  LPSearchHistoryTableViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSearchHistoryTableViewCell.h"
#import "LPSearchHistoryFrame.h"
#import "LPSearchHistoryItem.h"

@interface LPSearchHistoryTableViewCell ()

@property (nonatomic, strong) UILabel *historyLabel;
@property (nonatomic, strong) UILabel *seperatorLabel;

@end

@implementation LPSearchHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorFromHexString:LPColor9];
        
        UILabel *historyLabel = [[UILabel alloc] init];
        [self.contentView addSubview:historyLabel];
        self.historyLabel = historyLabel;
        
        UILabel *seperatorLabel = [[UILabel alloc] init];
        seperatorLabel.backgroundColor = [UIColor colorFromHexString:LPColor5];
        [self.contentView addSubview:seperatorLabel];
        self.seperatorLabel = seperatorLabel;
        
    }
    return self;
}


- (void)setSearchHistoryFrame:(LPSearchHistoryFrame *)searchHistoryFrame {
    _searchHistoryFrame = searchHistoryFrame;
    LPSearchHistoryItem *item = searchHistoryFrame.searchHistoryItem;
    
    self.historyLabel.text = item.historyString;
    self.historyLabel.frame = searchHistoryFrame.historyLabelF;
    self.seperatorLabel.frame = searchHistoryFrame.seperatorLabelF;
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}
@end
