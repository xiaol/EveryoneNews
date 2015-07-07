//
//  LPUpView.m
//  EveryoneNews
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPUpView.h"
#import "LPParaCommentFrame.h"
#import "LPComment.h"

@interface LPUpView ()
@property (nonatomic, strong) UIImageView *upImageView;
@property (nonatomic, strong) UILabel *upCountLabel;
@end

@implementation LPUpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *upImageView = [[UIImageView alloc] init];
        upImageView.userInteractionEnabled = YES;
        [self addSubview:upImageView];
        self.upImageView = upImageView;
        
        UILabel *upCountLabel = [[UILabel alloc] init];
        upCountLabel.textColor = [UIColor redColor];
        upCountLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:upCountLabel];
        self.upCountLabel = upCountLabel;
    }
    return self;
}

- (void)setCommentFrame:(LPParaCommentFrame *)commentFrame
{
    _commentFrame = commentFrame;
    LPComment *comment = commentFrame.comment;
    
    self.upImageView.frame = self.commentFrame.upImageViewF;
    if (comment.isPraiseFlag.intValue) {
        self.upImageView.image = [UIImage imageNamed:@"点赞心1"];
    } else {
        self.upImageView.image = [UIImage imageNamed:@"点赞心0"];
    }
    
    self.upCountLabel.frame = self.commentFrame.upCountsLabelF;
    self.upCountLabel.text = comment.up;
}


@end
