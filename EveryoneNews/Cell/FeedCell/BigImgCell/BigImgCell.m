//
//  BigImgCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/21.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "BigImgCell.h"
#import "UIImageView+WebCache.h"
#import "ScaleImage.h"

@implementation BigImgCell
{
    UIView *backView;
    UIImageView *imgView;
    UILabel *titleLab;
    UILabel *categoryLab;
    UIButton *showBtn;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:imgView];
        
        titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont fontWithName:kFont size:20];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.numberOfLines = 0;
        [imgView addSubview:titleLab];
        
        categoryLab = [[UILabel alloc] init];
        categoryLab.font = [UIFont fontWithName:kFont size:15];
        categoryLab.textAlignment = NSTextAlignmentCenter;
        [imgView addSubview:categoryLab];
        
        showBtn = [[UIButton alloc] init];
        showBtn.backgroundColor = [UIColor clearColor];
        [showBtn addTarget:self action:@selector(showBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:showBtn];
        
    }
    return self;
}

- (void)setBigImgFrm:(BigImgFrm *)bigImgFrm
{
    _bigImgFrm = bigImgFrm;
    
    [self settingSubviewFrame];
    [self settingData];
}

- (void)settingSubviewFrame
{
    backView.frame = _bigImgFrm.backFrm;
    imgView.frame = _bigImgFrm.imgFrm;
    titleLab.frame = _bigImgFrm.titleFrm;
    categoryLab.frame = _bigImgFrm.categoryFrm;
    showBtn.frame = imgView.frame;
}

- (void)settingData
{
    titleLab.text = _bigImgFrm.bigImgDatasource.titleStr;
    
    NSURL *url = [NSURL URLWithString:_bigImgFrm.bigImgDatasource.imgStr];
    
    [imgView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        imgView.image = [ScaleImage scaleImage:imgView.image size:_bigImgFrm.imgFrm.size];
        
    }];
    
    categoryLab.text = _bigImgFrm.bigImgDatasource.categoryStr;
}

- (void)showBtnClick
{
    
    if ([self.delegate respondsToSelector:@selector(getTextContent:imgUrl:SourceSite:Update:Title:ResponseUrls: RootClass: hasImg:)]) {
        [self.delegate getTextContent:_bigImgFrm.bigImgDatasource.sourceUrl
                               imgUrl:_bigImgFrm.bigImgDatasource.imgStr
                           SourceSite:_bigImgFrm.bigImgDatasource.sourceSiteName
                               Update:_bigImgFrm.bigImgDatasource.updateTime
                                Title:_bigImgFrm.bigImgDatasource.titleStr
                         ResponseUrls:_bigImgFrm.bigImgDatasource.responseUrls
                            RootClass:_bigImgFrm.bigImgDatasource.rootClass
                               hasImg:NO];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
