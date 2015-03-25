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
    
    UIView *sourceView_1;
    UIView *sourceView_2;
    UIView *sourceView_3;
    
    UILabel *sourceName_1;
    UILabel *sourceName_2;
    UILabel *sourceName_3;
    
    UILabel *aspect;
    UIView *aspectView;
    UIView *bottonView;
    UIView *cutBlock;
    UIButton *showBtn;

    DRNRealTimeBlurView *blurView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        backgroupView = [[UIView alloc] init];
        backgroupView.backgroundColor = [UIColor colorFromHexString:@"#EBEDED"];
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
        
        sourceView_1 = [[UIView alloc] init];
        sourceView_1.backgroundColor = [UIColor whiteColor];
        [backgroupView addSubview:sourceView_1];
        
        sourceView_2 = [[UIView alloc] init];
        sourceView_2.backgroundColor = [UIColor whiteColor];
        [backgroupView addSubview:sourceView_2];
        
        sourceView_3 = [[UIView alloc] init];
        sourceView_3.backgroundColor = [UIColor whiteColor];
        [backgroupView addSubview:sourceView_3];
        
        ////////////////////////////////////////////////////////////
        
        sourceTitle_1 = [[UILabel alloc] init];
        sourceTitle_1.font = [UIFont fontWithName:kFont size:18];
        sourceTitle_1.textColor = [UIColor blackColor];
        sourceTitle_1.backgroundColor = [UIColor clearColor];
        [sourceView_1 addSubview:sourceTitle_1];
        
        sourceTitle_2 = [[UILabel alloc] init];
        sourceTitle_2.font = [UIFont fontWithName:kFont size:18];
        sourceTitle_2.textColor = [UIColor blackColor];
        sourceTitle_2.backgroundColor = [UIColor clearColor];
        [sourceView_2 addSubview:sourceTitle_2];
        
        sourceTitle_3 = [[UILabel alloc] init];
        sourceTitle_3.font = [UIFont fontWithName:kFont size:18];
        sourceTitle_3.textColor = [UIColor blackColor];
        sourceTitle_3.backgroundColor = [UIColor clearColor];
        [sourceView_3 addSubview:sourceTitle_3];
        
        sourceName_1 = [[UILabel alloc] init];
        sourceName_1.font = [UIFont fontWithName:kFont size:16];
        sourceName_1.textColor = [UIColor colorFromHexString:@"#666666"];
        sourceName_1.backgroundColor = [UIColor clearColor];
        [sourceView_1 addSubview:sourceName_1];
        
        sourceName_2 = [[UILabel alloc] init];
        sourceName_2.font = [UIFont fontWithName:kFont size:16];
        sourceName_2.textColor = [UIColor colorFromHexString:@"#666666"];
        sourceName_2.backgroundColor = [UIColor clearColor];
        [sourceView_2 addSubview:sourceName_2];
        
        sourceName_3 = [[UILabel alloc] init];
        sourceName_3.font = [UIFont fontWithName:kFont size:16];
        sourceName_3.textColor = [UIColor colorFromHexString:@"#666666"];
        sourceName_3.backgroundColor = [UIColor clearColor];
        [sourceView_3 addSubview:sourceName_3];
        
        bottonView = [[UIView alloc] init];
        bottonView.backgroundColor = [UIColor whiteColor];
        [backgroupView addSubview:bottonView];
        
        aspectView = [[UIView alloc] init];
        aspectView.backgroundColor = [UIColor clearColor];
        aspectView.layer.borderWidth = 1;
        aspectView.layer.borderColor = [UIColor colorFromHexString:@"#EBEDED"].CGColor;
        aspectView.layer.cornerRadius = 3;
        [backgroupView addSubview:aspectView];
        
        aspect = [[UILabel alloc] init];
        aspect.font = [UIFont fontWithName:kFont size:20];
        aspect.textColor = [UIColor colorFromHexString:@"#4eb4ea"];
        aspect.backgroundColor = [UIColor clearColor];
        aspect.textAlignment = NSTextAlignmentRight;
        [backgroupView addSubview:aspect];
        
        
        
        cutBlock = [[UIView alloc] init];
        cutBlock.backgroundColor = [UIColor clearColor];
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
    
    sourceName_1.text = _headViewFrm.headViewDatasource.sourceName;
    sourceName_2.text = _headViewFrm.headViewDatasource.sourceName;
    sourceName_3.text = _headViewFrm.headViewDatasource.sourceName;
    
    aspect.text = _headViewFrm.headViewDatasource.aspectStr;
}

- (void)settingSubviewFrame
{
    backgroupView.frame = _headViewFrm.backgroundViewFrm;
    imgView.frame = _headViewFrm.imgFrm;
    titleLab.frame = _headViewFrm.titleLabFrm;
    blurView.frame = titleLab.frame;
//    blurImg.frame = titleLab.frame;
    
    sourceView_1.frame = _headViewFrm.sourceView_1;
    sourceView_2.frame = _headViewFrm.sourceView_2;
    sourceView_3.frame = _headViewFrm.sourceView_3;
    
    sourceTitle_1.frame = _headViewFrm.sourceTitle;
    sourceTitle_2.frame = _headViewFrm.sourceTitle;
    sourceTitle_3.frame = _headViewFrm.sourceTitle;
    
    sourceName_1.frame = _headViewFrm.sourceName;
    sourceName_2.frame = _headViewFrm.sourceName;
    sourceName_3.frame = _headViewFrm.sourceName;
    
    bottonView.frame = _headViewFrm.bottonView;
    aspectView.frame = _headViewFrm.aspectFrm;
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
