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
        menuButton.alpha = 0.8f;
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
    [super setSelected:selected];
    if(selected) {
        self.menuButton.alpha = 1.0f;
        self.menuButton.textColor = LPSelectedColor;
        [UIView animateWithDuration:0.2f animations:^{
            self.menuButton.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        }];
    } else {
        
        self.menuButton.alpha = 0.8f;
        self.menuButton.textColor = LPNormalColor;
        self.menuButton.transform = CGAffineTransformIdentity;
    }
}




@end
