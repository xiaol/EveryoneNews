//
//  HeadViewCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "HeadViewCell.h"
#import "UIColor+HexToRGB.h"
#import "DRNRealTimeBlurView.h"

@implementation HeadViewCell
{
    UIView *backgroupView;
    UIImageView *imgView;
    UILabel *titleLab;
    UILabel *sourceTitle_1;
    UILabel *sourceTitle_2;
    UILabel *sourceTitle_3;
    UILabel *aspect;
    UIView *cutBlock;
    UIButton *showBtn;

    DRNRealTimeBlurView *blurView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        backgroupView = [[UIView alloc] init];
        backgroupView.backgroundColor = [UIColor colorFromHexString:@"#ecf2fe"];
        [self.contentView addSubview:backgroupView];
        
        imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [backgroupView addSubview:imgView];
        
        blurView = [[DRNRealTimeBlurView alloc] init];
//        blurView.alpha = 0.9;
        [backgroupView addSubview:blurView];
        
        
        titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont fontWithName:kFont size:20];
        titleLab.textColor = [UIColor colorFromHexString:@"#ffffff"];
        titleLab.numberOfLines = 2;
        [backgroupView addSubview:titleLab];
        
        sourceTitle_1 = [[UILabel alloc] init];
        sourceTitle_1.font = [UIFont fontWithName:kFont size:20];
        sourceTitle_1.textColor = [UIColor yellowColor];
//        sourceTitle_1.numberOfLines = 2;
        [backgroupView addSubview:sourceTitle_1];
        
        sourceTitle_2 = [[UILabel alloc] init];
        sourceTitle_2.font = [UIFont fontWithName:kFont size:20];
        sourceTitle_2.textColor = [UIColor yellowColor];
        [backgroupView addSubview:sourceTitle_2];
        
        sourceTitle_3 = [[UILabel alloc] init];
        sourceTitle_3.font = [UIFont fontWithName:kFont size:20];
        sourceTitle_3.textColor = [UIColor yellowColor];
        [backgroupView addSubview:sourceTitle_3];
        
        aspect = [[UILabel alloc] init];
        aspect.font = [UIFont fontWithName:kFont size:20];
        aspect.textColor = [UIColor greenColor];
        aspect.textAlignment = NSTextAlignmentRight;
        [backgroupView addSubview:aspect];
        
        cutBlock = [[UIView alloc] init];
        cutBlock.backgroundColor = [UIColor whiteColor];
        [backgroupView addSubview:cutBlock];
        
        showBtn = [[UIButton alloc] init];
        showBtn.backgroundColor = [UIColor clearColor];
        [showBtn addTarget:self action:@selector(showBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [backgroupView addSubview:showBtn];
    }
    
    return self;
}

- (void)setHeadViewFrm:(HeadViewFrame *)headViewFrm
{
    _headViewFrm = headViewFrm;
    [self settingData];
    [self settingSubviewFrame];
}

- (void)settingData
{
    titleLab.text = _headViewFrm.headViewDatasource.titleStr;
    imgView.image = [UIImage imageNamed:@"demo_1.jpg"];
    
    sourceTitle_1.text = _headViewFrm.headViewDatasource.sourceTitle;
    sourceTitle_2.text = _headViewFrm.headViewDatasource.sourceTitle;
    sourceTitle_3.text = _headViewFrm.headViewDatasource.sourceTitle;
    
    aspect.text = _headViewFrm.headViewDatasource.aspectStr;
}

- (void)settingSubviewFrame
{
    backgroupView.frame = _headViewFrm.backgroundViewFrm;
    imgView.frame = _headViewFrm.imgFrm;
    titleLab.frame = _headViewFrm.titleLabFrm;
    blurView.frame = titleLab.frame;
//    blurImg.frame = titleLab.frame;
    
    sourceTitle_1.frame = _headViewFrm.titleFrm_1;
    sourceTitle_2.frame = _headViewFrm.titleFrm_2;
    sourceTitle_3.frame = _headViewFrm.titleFrm_3;
    
    aspect.frame = _headViewFrm.aspectFrm;
    cutBlock.frame = _headViewFrm.cutBlockFrm;
    showBtn.frame = imgView.frame;
}

- (void)showBtnClick
{
    if ([self.delegate respondsToSelector:@selector(getTextContent:imgUrl:SourceSite:Update:Title:sourceUrl:hasImg:favorNum:)]) {
        [self.delegate getTextContent:@"4d4716525b6d76e79a657116f318ba2be5ba7068"
                               imgUrl:@"http://img31.mtime.cn/mg/2015/03/24/163919.94945336.jpg"
                           SourceSite:@"影像日报"
                               Update:@"2015-03-24 18:08:45"
                                Title:@"《速度与激情7》特辑 怀念保罗·沃克"
                            sourceUrl:@"http://moviesoon.com/news/2015/03/%e3%80%8a%e9%80%9f%e5%ba%a6%e4%b8%8e%e6%bf%80%e6%83%857%e3%80%8b%e7%89%b9%e8%be%91-%e6%80%80%e5%bf%b5%e4%bf%9d%e7%bd%97%c2%b7%e6%b2%83%e5%85%8b/"
                               hasImg:YES
                             favorNum:0];
    }
}

@end
