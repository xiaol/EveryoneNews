//
//  LPItemView.m
//  EveryoneNews
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPItemView.h"
#import "LPCommentView.h"
#import "LPContentFrame.h"
#import "LPContent.h"
#import "LPSupplementView.h"
#import "UIImageView+WebCache.h"

@interface LPItemView()
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) LPCommentView *commentView;
@property (nonatomic, strong) LPSupplementView *supplementView;
@end

@implementation LPItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *bodyLabel = [[UILabel alloc] init];
        bodyLabel.userInteractionEnabled = YES;
        bodyLabel.lineBreakMode = NSLineBreakByCharWrapping;
        bodyLabel.numberOfLines = 0;
        [self addSubview:bodyLabel];
        self.bodyLabel = bodyLabel;
        
        LPCommentView *commentView = [[LPCommentView alloc] init];
        [self addSubview:commentView];
        self.commentView = commentView;
//        [commentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapComment)]];
        
        LPSupplementView *supplementView = [[LPSupplementView alloc] init];
        [self addSubview:supplementView];
        self.supplementView = supplementView;
    }
    return self;
}

- (void)setContentFrame:(LPContentFrame *)contentFrame
{
    _contentFrame = contentFrame;
    LPContent *content = contentFrame.content;
    
    self.commentView.hidden = content.isOpinion || content.isAbstract;
    self.supplementView.hidden = !content.isOpinion;
        
    self.bodyLabel.frame = self.contentFrame.bodyLabelF;
  //  self.bodyLabel.attributedText = content.bodyString;
    
    if (!self.commentView.hidden) {
        [self setupCommentView];
    }
    if (!self.supplementView.hidden) {
        self.supplementView.frame = self.contentFrame.supplementViewF;
        self.supplementView.contentFrame = self.contentFrame;
    }
}

- (void)setupCommentView {
    self.commentView.frame = self.contentFrame.commentViewF;
    self.commentView.contentFrame = self.contentFrame;
}



@end
