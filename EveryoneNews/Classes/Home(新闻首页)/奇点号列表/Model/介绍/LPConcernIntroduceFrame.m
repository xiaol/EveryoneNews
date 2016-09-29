//
//  LPConcernIntroduceFrame.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPConcernIntroduceFrame.h"
#import "LPConcernIntroduce.h"
#import "Card+Create.h"
#import "TTTAttributedLabel.h"

const static CGFloat paddingLeft = 17;
const static CGFloat paddingTop = 15;
@implementation LPConcernIntroduceFrame

- (void)setConcernIntroduce:(LPConcernIntroduce *)concernIntroduce {
    _concernIntroduce = concernIntroduce;
    
    NSMutableAttributedString *htmlTitle = [Card titleHtmlString:concernIntroduce.introduce];
    // 标题
    CGFloat titleX = paddingLeft;
    CGFloat titleY = paddingTop;
    CGFloat titleW = ScreenWidth - titleX * 2;
    CGFloat titleH = [htmlTitle tttAttributeLabel:titleW];
    _introduceLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
    
    // 分割线
    CGFloat introduceSeperatorLineFrameY = CGRectGetMaxY(_introduceLabelFrame) + paddingTop;
    _introduceSeperatorLineFrame = CGRectMake( paddingLeft , introduceSeperatorLineFrameY, ScreenWidth - paddingLeft * 2, 0.5);
    _cellHeight = CGRectGetMaxY(_introduceSeperatorLineFrame);
    
}

@end
