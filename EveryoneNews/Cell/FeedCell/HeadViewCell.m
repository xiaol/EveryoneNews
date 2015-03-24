//
//  HeadViewCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "HeadViewCell.h"

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
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        backgroupView = [[UIView alloc] init];
        backgroupView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:backgroupView];
        
        imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [backgroupView addSubview:imgView];
        
        titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont systemFontOfSize:20.0];
        titleLab.textColor = [UIColor purpleColor];
        titleLab.numberOfLines = 2;
        [backgroupView addSubview:titleLab];
        
        sourceTitle_1 = [[UILabel alloc] init];
        sourceTitle_1.font = [UIFont systemFontOfSize:20.0];
        sourceTitle_1.textColor = [UIColor yellowColor];
//        sourceTitle_1.numberOfLines = 2;
        [backgroupView addSubview:sourceTitle_1];
        
        sourceTitle_2 = [[UILabel alloc] init];
        sourceTitle_2.font = [UIFont systemFontOfSize:20.0];
        sourceTitle_2.textColor = [UIColor yellowColor];
        [backgroupView addSubview:sourceTitle_2];
        
        sourceTitle_3 = [[UILabel alloc] init];
        sourceTitle_3.font = [UIFont systemFontOfSize:20.0];
        sourceTitle_3.textColor = [UIColor yellowColor];
        [backgroupView addSubview:sourceTitle_3];
        
        aspect = [[UILabel alloc] init];
        aspect.font = [UIFont systemFontOfSize:16.0];
        aspect.textColor = [UIColor greenColor];
        aspect.textAlignment = NSTextAlignmentRight;
        [backgroupView addSubview:aspect];
        
        cutBlock = [[UIView alloc] init];
        cutBlock.backgroundColor = [UIColor whiteColor];
        [backgroupView addSubview:cutBlock];
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
    
    sourceTitle_1.frame = _headViewFrm.titleFrm_1;
    sourceTitle_2.frame = _headViewFrm.titleFrm_2;
    sourceTitle_3.frame = _headViewFrm.titleFrm_3;
    
    aspect.frame = _headViewFrm.aspectFrm;
    cutBlock.frame = _headViewFrm.cutBlockFrm;
}

@end
