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
//        self.menuButton.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
//        [tapGestureRecognizer addTarget:self action:@selector(clickMenuButton)];
        [self.menuButton addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)setChannelItem:(LPChannelItem *)channelItem {
    _channelItem = channelItem;
    self.menuButton.text = channelItem.channelName;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
       self.menuButton.textColor = LPSelectedColor;
        
    } else {
        self.menuButton.textColor = LPNormalColor;
    }
}

- (void)clickMenuButton {
    if ([self.delegate respondsToSelector:@selector(didClickMenuCollectionViewCell:)]) {
        [self.delegate didClickMenuCollectionViewCell:self];
    }
}

@end
