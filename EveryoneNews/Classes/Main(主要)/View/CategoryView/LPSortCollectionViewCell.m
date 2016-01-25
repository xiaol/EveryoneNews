//
//  LPSortCollectionViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPSortCollectionViewCell.h"
#import "LPChannelItem.h"

@interface LPSortCollectionViewCell () <UIGestureRecognizerDelegate>

@end
@implementation LPSortCollectionViewCell

- (LPChannelItem *)channelItem {
    if(_channelItem == nil) {
        _channelItem = [[LPChannelItem alloc] init];
    }
    return _channelItem;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGFloat fontSize = 15;
    if (iPhone6Plus) {
        fontSize = 18;
    }
    if(self = [super initWithFrame:frame]) {
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.center = self.contentView.center;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.font = [UIFont systemFontOfSize:fontSize];
        self.contentLabel.numberOfLines = 1;
        self.contentLabel.adjustsFontSizeToFitWidth = YES;
        self.contentLabel.minimumScaleFactor = 0.1f;
        [self.contentView addSubview:self.contentLabel];
        
        UIImageView *deleteButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分类删除"]];
        
        [self.contentView addSubview:deleteButton];
        self.deleteButton = deleteButton;
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setCellWithArray:(NSMutableArray *)dataMutableArray indexPath:(NSIndexPath*)indexPath selectedTitle:(NSString *)selectedTitle{
    CGFloat deleteButtonWidth = 13;
    CGFloat deleteButtonHeight = 13;
    if (iPhone6Plus) {
        deleteButtonWidth = 18;
        deleteButtonHeight = 18;
    }
    CGFloat labelX = 8 + deleteButtonWidth / 2;
    CGFloat labelY = deleteButtonHeight / 2;
    CGFloat labelW = self.bounds.size.width - labelX;
    CGFloat labelH = self.bounds.size.height - labelY;
    
    self.contentLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    self.deleteButton.frame = CGRectMake(8, 0 , deleteButtonWidth, deleteButtonHeight);
    self.indexPath = indexPath;
    self.contentLabel.hidden = NO;
    self.channelItem = dataMutableArray[indexPath.row];
    self.contentLabel.text = self.channelItem.channelName;
    if([self.contentLabel.text isEqualToString:selectedTitle]) {
        self.contentLabel.textColor = [UIColor colorFromHexString:@"#0086d1"];
    } else {
        self.contentLabel.textColor = [UIColor colorFromHexString:@"#737376"];
    }
    if(indexPath.section == 0 && indexPath.row == 0) {
        self.contentLabel.layer.borderColor = [UIColor clearColor].CGColor;
        self.contentLabel.layer.borderWidth = 0.0f;
        self.contentLabel.layer.masksToBounds = YES;
        
    } else {
        self.contentLabel.layer.borderColor = [UIColor grayColor].CGColor;
        self.contentLabel.layer.borderWidth = 0.45f;
        self.contentLabel.layer.cornerRadius = 5.0f;
        self.contentLabel.layer.masksToBounds = YES;
    }
}

@end
