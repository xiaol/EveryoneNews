//
//  LPMenuCollectionViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPMenuCollectionViewCell.h"
#import "LPChannelItem.h"
#import "LPMenuButton.h"

@interface LPMenuCollectionViewCell ()

@end

@implementation LPMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        LPMenuButton *menuButton = [[LPMenuButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
        [self.contentView addSubview:menuButton];
        self.menuButton = menuButton;
    }
    return self;
}

- (void)setChannelItem:(LPChannelItem *)channelItem {
    _channelItem = channelItem;
    self.menuButton.text = channelItem.channelName;
}

- (void)setSelected:(BOOL)selected {
    if(selected) {
        self.menuButton.textColor = LPSelectedColor;
        [UIView animateWithDuration:0.4 animations:^{
            self.menuButton.transform = CGAffineTransformMakeScale(1.15, 1.15);
        }];
        
    } else {
        self.menuButton.textColor = LPNormalColor;
        [UIView animateWithDuration:0.4 animations:^{
            self.menuButton.transform = CGAffineTransformIdentity;
            
        }];
    }
}

@end
