//
//  LPDetailContentFrame.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPDetailContentFrame.h"
#import "LPDetailContent.h"
@implementation LPDetailContentFrame

- (void)setContent:(LPDetailContent *)content {
    CGFloat photoX = 0;
    CGFloat photoY = 0;
    CGFloat photoW = DetailCellWidth;
    CGFloat photoH = photoW * 9 / 11;
    _photoViewF = CGRectMake(photoX, photoY, photoW, photoH);
    
    _content = content;
    CGFloat bodyX = BodyPadding;
    CGFloat bodyY = BodyPadding + CGRectGetMaxY(_photoViewF);
    CGFloat bodyW = DetailCellWidth;
    CGFloat bodyH = [self.content.bodyString heightWithConstraintWidth:bodyW];
    _bodyLabelF = CGRectMake(bodyX, bodyY, bodyW, bodyH);
    
    _cellHeight = CGRectGetMaxY(_bodyLabelF);
}
@end
