//
//  LPSubscriberCell.m
//  Test
//
//  Created by dongdan on 16/9/1.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "LPSubscriberCell.h"
#import "LPSubscriberFrame.h"
#import "LPSubscriber.h"

@interface LPSubscriberCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *subscriberImageView;
@property (nonatomic, strong) UIButton *subcriberButton;

@end


@implementation LPSubscriberCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = [UIColor redColor];
//        
        UIImageView *subscriberImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:subscriberImageView];
        self.subscriberImageView = subscriberImageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:LPFont6];
        
        if (iPhone6Plus) {
            titleLabel.font = [UIFont systemFontOfSize:LPFont11];
        }
        
        
        
        titleLabel.textColor = [UIColor colorFromHexString:LPColor1];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIButton *subcriberButton = [[UIButton alloc] init];
        subcriberButton.enlargedEdge = 5;
        [subcriberButton setBackgroundImage:[UIImage imageNamed:@"订阅号加号"] forState:UIControlStateNormal];
        [self.contentView addSubview:subcriberButton];
        self.subcriberButton = subcriberButton;
        [subcriberButton addTarget:self action:@selector(subcriberButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setSubscriberFrame:(LPSubscriberFrame *)subscriberFrame {
    _subscriberFrame = subscriberFrame;
    LPSubscriber *subscriber = subscriberFrame.subscriber;
    
    self.subscriberImageView.frame = subscriberFrame.imageFrame;
    self.subscriberImageView.image = [UIImage imageNamed:subscriber.imageURL];
    
    self.titleLabel.frame = subscriberFrame.titleFrame;
    self.titleLabel.text = subscriber.title;
    [self.titleLabel sizeToFit];
    
    self.subcriberButton.frame = subscriberFrame.subscriberButtonFrame;
    
    // 居中显示
    self.subscriberImageView.centerX = self.contentView.centerX;
    self.titleLabel.centerX = self.contentView.centerX;
    self.subcriberButton.centerX = self.contentView.centerX;
}

- (void)subcriberButtonDidClick {
    self.buttonSelected = !self.buttonSelected;
    if (self.buttonSelected) {
        [self.subcriberButton setBackgroundImage:[UIImage imageNamed:@"订阅号对勾"] forState:UIControlStateNormal];
    } else {
        [self.subcriberButton setBackgroundImage:[UIImage imageNamed:@"订阅号加号"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(cell:title:buttonSelected:)]) {
        [self.delegate cell:self title:self.titleLabel.text buttonSelected:self.buttonSelected];
    }
    
}


@end
