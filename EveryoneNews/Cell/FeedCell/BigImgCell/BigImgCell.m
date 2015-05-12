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
#import "UIColor+HexToRGB.h"

@implementation BigImgCell
{
    UIView *backView;
    UIImageView *imgView;
    UILabel *titleLab;
    UILabel *categoryLab;
    UIButton *showBtn;
    UIImageView *toumuImg;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        imgView = [[UIImageView alloc] init];
        [backView addSubview:imgView];
        
        toumuImg = [[UIImageView alloc] init];
        toumuImg.image = [UIImage imageNamed:@"toum.png"];
        toumuImg.alpha = 0.7;
        [backView addSubview:toumuImg];
        
        titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont fontWithName:kFont size:20];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.numberOfLines = 0;
        [backView addSubview:titleLab];
        
        categoryLab = [[UILabel alloc] init];
        categoryLab.font = [UIFont fontWithName:kFont size:15];
        categoryLab.textAlignment = NSTextAlignmentCenter;
        categoryLab.numberOfLines = 2;
        categoryLab.textColor = [UIColor whiteColor];
        [imgView addSubview:categoryLab];
        
        showBtn = [[UIButton alloc] init];
        showBtn.backgroundColor = [UIColor clearColor];
        [showBtn addTarget:self action:@selector(showBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:showBtn];
        
        _cutlineView = [[UIView alloc] init];
        _cutlineView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_cutlineView];
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
    toumuImg.frame = _bigImgFrm.toumuFrm;
    titleLab.frame = _bigImgFrm.titleFrm;
    categoryLab.frame = _bigImgFrm.categoryFrm;
    showBtn.frame = imgView.frame;
    _cutlineView.frame = _bigImgFrm.cutlineFrm;
}

- (void)settingData
{
    titleLab.text = _bigImgFrm.bigImgDatasource.titleStr;
    NSURL *url = [NSURL URLWithString:_bigImgFrm.bigImgDatasource.imgStr];
    [imgView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        imgView.image = [ScaleImage scaleImage:imgView.image size:_bigImgFrm.imgFrm.size];
        
    }];
    NSString *categoryStr = _bigImgFrm.bigImgDatasource.categoryStr;
    if ([self isBlankString:categoryStr]) {
        categoryLab.hidden = YES;
    } else {
        if ([categoryStr isEqualToString:@"焦点"]) {
            categoryLab.backgroundColor = [UIColor colorFromHexString:@"#FF4341"];
        }
        else if ([categoryStr isEqualToString:@"国际"]) {
            categoryLab.backgroundColor = [UIColor colorFromHexString:@"#007fff"];
        }
        else if ([categoryStr isEqualToString:@"港台"]) {
            categoryLab.backgroundColor = [UIColor colorFromHexString:@"#726bf8"];
        }
        else if ([categoryStr isEqualToString:@"内地"]) {
            categoryLab.backgroundColor = [UIColor colorFromHexString:@"#18a68b"];
        }
        else if ([categoryStr isEqualToString:@"财经"]) {
            categoryLab.backgroundColor = [UIColor colorFromHexString:@"#32bfcd"];
        }
        else if ([categoryStr isEqualToString:@"娱乐"]) {
            categoryLab.backgroundColor = [UIColor colorFromHexString:@"#ff7272"];
        }
        else if ([categoryStr isEqualToString:@"科技"]) {
            categoryLab.backgroundColor = [UIColor colorFromHexString:@"#007FFF"];
        }
        else if ([categoryStr isEqualToString:@"体育"]) {
            categoryLab.backgroundColor = [UIColor colorFromHexString:@"#df8145"];
        }
        else if ([categoryStr isEqualToString:@"社会"]) {
            categoryLab.backgroundColor = [UIColor colorFromHexString:@"#00b285"];
        }
        else if ([categoryStr isEqualToString:@"国内"]) {
            categoryLab.backgroundColor = [UIColor colorFromHexString:@"#726bf8"];
        }
    }
    categoryLab.text = categoryStr;
//    categoryLab.text = _bigImgFrm.bigImgDatasource.categoryStr;
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
    
#pragma mark 判断字符串是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
