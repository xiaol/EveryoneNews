//
//  LPChannelItemCollectionViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPChannelItemCollectionViewCell.h"
#import "LPChannelItem.h"

@implementation LPChannelItemCollectionViewCell

- (LPChannelItem *)channelItem {
    if(_channelItem == nil) {
        _channelItem = [[LPChannelItem alloc] init];
    }
    return _channelItem;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGFloat fontSize = LPFont4;
        CGFloat paddingLeft = 12;
        CGFloat cellPadding = 18;
        
        CGFloat imageViewW = 18;
        CGFloat imageViewH = 18;
        
        CGFloat channelItemLabelX = 0;
        CGFloat channelItemLabelY = imageViewH / 2;
        CGFloat channelItemLabelW = (ScreenWidth - 2 * paddingLeft - 2 * cellPadding) / 3;
        CGFloat channelItemLabelH = 35;

        UILabel *channelItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(channelItemLabelX, channelItemLabelY, channelItemLabelW, channelItemLabelH)];
        channelItemLabel.textColor = [UIColor colorFromHexString:LPColor3];
        channelItemLabel.font = [UIFont systemFontOfSize:fontSize];
        channelItemLabel.layer.cornerRadius = 7;
        channelItemLabel.layer.borderColor = [UIColor colorFromHexString:@"#e5e5e5"].CGColor;
        channelItemLabel.layer.borderWidth = 0.5f;
        channelItemLabel.textAlignment = NSTextAlignmentCenter;
        channelItemLabel.backgroundColor = [UIColor whiteColor];
        channelItemLabel.clipsToBounds = YES;
        [self.contentView addSubview:channelItemLabel];
        self.channelItemLabel = channelItemLabel;
        
        
        CGFloat imageViewX = channelItemLabelW - imageViewW;
        CGFloat imageViewY = 0;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
    }
    return  self;
}

- (void)setCellWithArray:(NSMutableArray *)dataMutableArray indexPath:(NSIndexPath*)indexPath selectedTitle:(NSString *)selectedTitle{
    self.indexPath = indexPath;
    self.channelItem = dataMutableArray[indexPath.row];
    self.channelItemLabel.text = self.channelItem.channelName;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.userInteractionEnabled = NO;
            self.imageView.hidden = YES;
            self.channelItemLabel.textColor = [UIColor colorFromHexString:LPColor4];
            self.channelItemLabel.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
        } else {
            self.imageView.image = [UIImage imageNamed:@"频道减少"];
            self.imageView.hidden = NO;
            self.channelItemLabel.textColor = [UIColor colorFromHexString:LPColor3];
            self.channelItemLabel.backgroundColor = [UIColor whiteColor];
            self.userInteractionEnabled = YES;
        }
        
    } else if(indexPath.section == 1){
        self.imageView.image = [UIImage imageNamed:@"频道增加"];
        self.imageView.hidden = NO;
        self.channelItemLabel.textColor = [UIColor colorFromHexString:LPColor3];
        self.channelItemLabel.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
    
 
    // 判断用户第一次安装是否订阅“关注”频道，没有订阅过就隐藏关注频道
//    if ([self.channelItem.channelName isEqualToString:LPConcernChannelItemName] && ![userDefaults objectForKey:LPConcernChannelItemShowOrHide]) {
//        self.contentView.hidden = YES;
//    } else {
//        self.contentView.hidden = NO;
//    }
}

@end
