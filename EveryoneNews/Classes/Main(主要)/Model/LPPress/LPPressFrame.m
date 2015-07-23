//
//  LPPressFrame.m
//  EveryoneNews
//
//  Created by apple on 15/scr5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPPressFrame.h"
#import "LPPress.h"
#import "LPSingleGraphOpinionsView.h"

#define TitleFont [UIFont fontWithName:FontName size:16]


@implementation LPPressFrame

- (void)setPress:(LPPress *)press
{
    _press = press;
    int mode = self.press.special.intValue;
    if (mode == 1) {
        // 大图模式
        
        // 大图frame
        CGFloat photoViewX = 0;
        CGFloat photoViewY = 0;
        CGFloat photoViewW = CellWidth;
        CGFloat photoViewH = CellWidth * 2 / 3;
        _photoViewF = CGRectMake(photoViewX, photoViewY, photoViewW, photoViewH);
        
        _bgImageViewF = _photoViewF;
        
        // 标题背景图片frame
        CGFloat titleBgViewX = 0;
        CGFloat titleBgViewY = CGRectGetMaxY(_photoViewF) - TitleBgViewHeight;
        CGFloat titleBgViewW = CellWidth;
        CGFloat titleBgViewH = TitleBgViewHeight;
        _titleBgViewF = CGRectMake(titleBgViewX, titleBgViewY, titleBgViewW, titleBgViewH);
        
        CGFloat titleX = PhotoTitlePadding;
        CGFloat titleY = titleBgViewY;
        CGFloat titleW = ScreenWidth - 2 * PhotoTitlePadding;
        CGFloat titleH = TitleBgViewHeight;
        _titleLabelF = CGRectMake(titleX, titleY, titleW, titleH);

        // 分类F
        CGFloat categoryX = ScreenWidth - PhotoTitlePadding;
        CGFloat categoryY = 45;
        CGFloat categoryW = 18;
        CGFloat categoryH = 36;
        _categoryLabelF = CGRectMake(categoryX, categoryY, categoryW, categoryH);
        
        _cellHeight = CGRectGetHeight(_photoViewF) + CellHeightBorder;
    } else if (mode == 400) {
        // 单图frame
        CGFloat thumbnailX = 8;
        CGFloat thumbnailY = 27;
        CGFloat thumbnailW = 110;
        CGFloat thumbnailH = thumbnailW - 20;
        _thumbnailViewF = CGRectMake(thumbnailX, thumbnailY, thumbnailW, thumbnailH);
    
        // 分类frame
        CGFloat categoryW = 32;
        CGFloat categoryH = 17;
        CGFloat categoryX = CellWidth - categoryW;
        CGFloat categoryY = CGRectGetMinY(_thumbnailViewF) + 5;
        _categoryLabelF = CGRectMake(categoryX, categoryY, categoryW, categoryH);
        // 标题frame
        CGFloat titleLabelX = CGRectGetMaxX(_thumbnailViewF) + 8;
        CGFloat titleLabelY = CGRectGetMinY(_thumbnailViewF) + 5;
        CGFloat titleLabelW = CellWidth - titleLabelX - categoryW - 18;
        CGFloat titleLabelH = [press.titleString heightWithConstraintWidth:titleLabelW];
        _titleLabelF = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
        // 小图标frame (封装)
        CGFloat smallIconsX = CGRectGetMaxX(_thumbnailViewF) + 8;
        CGFloat smallIconsW = IconW * Icons.count + IconBorder * (Icons.count - 1) + 2;
        CGFloat smallIconsH = 24;
        CGFloat smallIconsY = MAX(CGRectGetMaxY(_thumbnailViewF) - IconW - 3, CGRectGetMaxY(_titleLabelF) + 10) ;
        _smallIconsViewF = CGRectMake(smallIconsX, smallIconsY, smallIconsW, smallIconsH);
//        // 多家观点数目frame
//        CGFloat pointsH = 22;
//        CGFloat pointsW = 46;
//        CGFloat pointsX = CellWidth - pointsW - 10;
//        CGFloat pointsY = CGRectGetMaxY(_thumbnailViewF) - 1 - pointsH;
//        _pointsLabelF = CGRectMake(pointsX, pointsY, pointsW, pointsH);
        // 上半部分frame
        CGFloat topViewX = 0;
        CGFloat topViewY = 0;
        CGFloat topViewW = CellWidth;
        CGFloat topViewH = MAX(CGRectGetMaxY(_thumbnailViewF) + 17, CGRectGetMaxY(_smallIconsViewF) + 5);
        _singleGraphTopViewF = CGRectMake(topViewX, topViewY, topViewW, topViewH);
        
        _cellHeight = CGRectGetMaxY(_singleGraphTopViewF) + CellHeightBorder;
        if (press.sublist.count > 0) {
            // 中间部分
            CGFloat separaterX = 0;
            CGFloat separaterY = CGRectGetMaxY(_singleGraphTopViewF);
            CGFloat separaterW = CellWidth;
            CGFloat separaterH = 24;
            _singleGraphMidSeparaterF = CGRectMake(separaterX, separaterY, separaterW, separaterH);
            
            // 下半部分观点的frame
            _singleGraphOpinionsViewF = CGRectMake(0, CGRectGetMaxY(_singleGraphMidSeparaterF), CellWidth,[LPSingleGraphOpinionsView opinionsViewHeightWithOpinions: press.sublist]);
            
            // cell高度
            
            _cellHeight = CGRectGetMaxY(_singleGraphOpinionsViewF) + CellHeightBorder;
        }
    } else if (mode == 9) {
        
    }
}

//+ (instancetype)pressFrameWithTimeCell
//{

//}

@end
