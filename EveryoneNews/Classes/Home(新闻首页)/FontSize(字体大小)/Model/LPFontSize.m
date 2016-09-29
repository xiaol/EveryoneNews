//
//  LPFontSize.m
//  EveryoneNews
//
//  Created by dongdan on 16/9/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPFontSize.h"

@implementation LPFontSize

- (instancetype)initWithFontSizeType:(NSString *)fontSizeType {
    if (self = [super init]) {
        if (iPhone6) {
            if ([fontSizeType isEqualToString:@"standard"]) {
                _currentHomeViewFontSize = iPhone6HomeTitleSizeStandard;
                _currentDetailContentFontSize = iPhone6DetailContentSizeStandard;
                _currentDetaiTitleFontSize  = iPhone6DetailTitleSizeStandard;
                _currentDetailCommentFontSize = iPhone6DetailCommentSizeStandard;
                _currentDetailRelatePointFontSize = iPhone6DetailRelateSizeStandard;
                _currentDetailSourceFontSize = iPhone6DetailSourceSizeStandard;
                
            } else if ([fontSizeType isEqualToString:@"larger"]) {
                _currentHomeViewFontSize = iPhone6HomeTitleSizeLarger;
                _currentDetailContentFontSize = iPhone6DetailContentSizeLarger;
                _currentDetaiTitleFontSize  = iPhone6DetailTitleSizeLarger;
                _currentDetailCommentFontSize = iPhone6DetailCommentSizeLarger;
                _currentDetailRelatePointFontSize = iPhone6DetailRelateSizeLarger;
                _currentDetailSourceFontSize = iPhone6DetailSourceSizeLarger;
                
            } else if ([fontSizeType isEqualToString:@"superlarger"])  {
                _currentHomeViewFontSize = iPhone6HomeTitleSizeSuperLarger;
                _currentDetailContentFontSize = iPhone6DetailContentSizeSuperLarger;
                _currentDetaiTitleFontSize  = iPhone6DetailTitleSizeSuperLarger;
                _currentDetailCommentFontSize = iPhone6DetailCommentSizeSuperLarger;
                _currentDetailRelatePointFontSize = iPhone6DetailRelateSizeSuperLarger;
                _currentDetailSourceFontSize = iPhone6DetailSourceSizeSuperLarger;
            }
        } else if (iPhone6Plus) {
            if ([fontSizeType isEqualToString:@"standard"]) {
                _currentHomeViewFontSize = iPhone6PlusHomeTitleSizeStandard;
                _currentDetailContentFontSize = iPhone6PlusDetailContentSizeStandard;
                _currentDetaiTitleFontSize  = iPhone6PlusDetailTitleSizeStandard;
                _currentDetailCommentFontSize = iPhone6PlusDetailCommentSizeStandard;
                _currentDetailRelatePointFontSize = iPhone6PlusDetailRelateSizeStandard;
                _currentDetailSourceFontSize = iPhone6PlusDetailSourceSizeStandard;
                
            } else if ([fontSizeType isEqualToString:@"larger"]) {
                _currentHomeViewFontSize = iPhone6PlusHomeTitleSizeLarger;
                _currentDetailContentFontSize = iPhone6PlusDetailContentSizeLarger;
                _currentDetaiTitleFontSize  = iPhone6PlusDetailTitleSizeLarger;
                _currentDetailCommentFontSize = iPhone6PlusDetailCommentSizeLarger;
                _currentDetailRelatePointFontSize = iPhone6PlusDetailRelateSizeLarger;
                _currentDetailSourceFontSize = iPhone6PlusDetailSourceSizeLarger;
                
            } else if ([fontSizeType isEqualToString:@"superlarger"])  {
                _currentHomeViewFontSize = iPhone6PlusHomeTitleSizeSuperLarger;
                _currentDetailContentFontSize = iPhone6PlusDetailContentSizeSuperLarger;
                _currentDetaiTitleFontSize  = iPhone6PlusDetailTitleSizeSuperLarger;
                _currentDetailCommentFontSize = iPhone6PlusDetailCommentSizeSuperLarger;
                _currentDetailRelatePointFontSize = iPhone6PlusDetailRelateSizeSuperLarger;
                _currentDetailSourceFontSize = iPhone6PlusDetailSourceSizeSuperLarger;
            }
            
        } else {
            if ([fontSizeType isEqualToString:@"standard"]) {
                _currentHomeViewFontSize = iPhone5HomeTitleSizeStandard;
                _currentDetailContentFontSize = iPhone5DetailContentSizeStandard;
                _currentDetaiTitleFontSize  = iPhone5DetailTitleSizeStandard;
                _currentDetailCommentFontSize = iPhone5DetailCommentSizeStandard;
                _currentDetailRelatePointFontSize = iPhone5DetailRelateSizeStandard;
                _currentDetailSourceFontSize = iPhone5DetailSourceSizeStandard;
                
            } else if ([fontSizeType isEqualToString:@"larger"]) {
                _currentHomeViewFontSize = iPhone5HomeTitleSizeLarger;
                _currentDetailContentFontSize = iPhone5DetailContentSizeLarger;
                _currentDetaiTitleFontSize  = iPhone5DetailTitleSizeLarger;
                _currentDetailCommentFontSize = iPhone5DetailCommentSizeLarger;
                _currentDetailRelatePointFontSize = iPhone5DetailRelateSizeLarger;
                _currentDetailSourceFontSize = iPhone5DetailSourceSizeLarger;
                
            } else if ([fontSizeType isEqualToString:@"superlarger"])  {
                _currentHomeViewFontSize = iPhone5HomeTitleSizeSuperLarger;
                _currentDetailContentFontSize = iPhone5DetailContentSizeSuperLarger;
                _currentDetaiTitleFontSize  = iPhone5DetailTitleSizeSuperLarger;
                _currentDetailCommentFontSize = iPhone5DetailCommentSizeSuperLarger;
                _currentDetailRelatePointFontSize = iPhone5DetailRelateSizeSuperLarger;
                _currentDetailSourceFontSize = iPhone5DetailSourceSizeSuperLarger;
            }
        }
        _fontSizeType = fontSizeType;
    }
    return self;
}


 

@end
