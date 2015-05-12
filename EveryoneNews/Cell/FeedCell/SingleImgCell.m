//
//  SingleImgCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/5/6.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "SingleImgCell.h"
#import "UIColor+HexToRGB.h"
#import "UIImageView+WebCache.h"
#import "ScaleImage.h"
#import "AutoLabelSize.h"

#define kBlue @"#4FB5EA"

@implementation SingleImgCell
{
    UIView *baseView;
    UIView *backgroundView;
    UIImageView *imgView;
    UILabel *titleLab;
    UILabel *categoryLab;
    UILabel *aspectLab;
    UIImageView *aspectImg;
    UIView *pointView_1;
    UIView *pointView_2;
    UIView *pointView_3;
    UIView *cutlineView;
    UIButton *showBtn;
    
    
    UIView *circleView_1;
    UIView *circleView_2;
    UIView *circleView_3;
    UIView *topBar_1;
    UIView *topBar_2;
    UIView *topBar_3;
    UIView *bottonBar_1;
    UIView *bottonBar_2;
    UIView *bottonBar_3;
    UILabel *sourceLab_1;
    UILabel *sourceLab_2;
    UILabel *sourceLab_3;
    UILabel *sourceTitleLab_1;
    UILabel *sourceTitleLab_2;
    UILabel *sourceTitleLab_3;
    UILabel *indexLab_1;
    UILabel *indexLab_2;
    UILabel *indexLab_3;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        baseView = [[UIView alloc] init];
        baseView.backgroundColor = [UIColor colorFromHexString:@"#ebeded"];
        [self.contentView addSubview:baseView];
        
        backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:backgroundView];
        
        imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [backgroundView addSubview:imgView];
        
        titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont fontWithName:kFont size:16];
        titleLab.textColor = [UIColor colorFromHexString:@"#7d7d7d"];
        titleLab.numberOfLines = 0;
        [backgroundView addSubview:titleLab];
        
        categoryLab = [[UILabel alloc] init];
        categoryLab.font = [UIFont fontWithName:kFont size:15];
        categoryLab.textAlignment = NSTextAlignmentCenter;
        [backgroundView addSubview:categoryLab];
        
        aspectLab = [[UILabel alloc] init];
        aspectLab.font = [UIFont fontWithName:kFont size:15];
        aspectLab.backgroundColor = [UIColor colorFromHexString:@"#ff7f00"];
        aspectLab.textAlignment = NSTextAlignmentLeft;
        aspectLab.textColor = [UIColor whiteColor];
        aspectLab.layer.masksToBounds = YES;
        aspectLab.layer.cornerRadius = 2;
        [backgroundView addSubview:aspectLab];
        aspectImg = [[UIImageView alloc] init];
        
        pointView_1 = [[UIView alloc] init];
        pointView_2 = [[UIView alloc] init];
        pointView_3 = [[UIView alloc] init];
        pointView_1.hidden = YES;
        pointView_2.hidden = YES;
        pointView_3.hidden = YES;
        [backgroundView addSubview:pointView_1];
        [backgroundView addSubview:pointView_2];
        [backgroundView addSubview:pointView_3];

        circleView_1 = [[UIView alloc] init];
        topBar_1 = [[UIView alloc] init];
        bottonBar_1 = [[UIView alloc] init];
        sourceLab_1 = [[UILabel alloc] init];
        sourceTitleLab_1 = [[UILabel alloc] init];
        indexLab_1 = [[UILabel alloc] init];
        
        circleView_2 = [[UIView alloc] init];
        topBar_2 = [[UIView alloc] init];
        bottonBar_2 = [[UIView alloc] init];
        sourceLab_2 = [[UILabel alloc] init];
        sourceTitleLab_2 = [[UILabel alloc] init];
        indexLab_2 = [[UILabel alloc] init];
        
        circleView_3 = [[UIView alloc] init];
        topBar_3 = [[UIView alloc] init];
        bottonBar_3 = [[UIView alloc] init];
        sourceLab_3 = [[UILabel alloc] init];
        sourceTitleLab_3 = [[UILabel alloc] init];
        indexLab_3 = [[UILabel alloc] init];
    
        showBtn = [[UIButton alloc] init];
        showBtn.backgroundColor = [UIColor clearColor];
        [showBtn addTarget:self action:@selector(showBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:showBtn];

        cutlineView = [[UIView alloc] init];
        cutlineView.backgroundColor = [UIColor colorFromHexString:@"#ebeded"];
        [baseView addSubview:cutlineView];
    }
    return self;
}

- (void)setSingleImgFrm:(SingleImgFrm *)singleImgFrm
{
    _singleImgFrm = singleImgFrm;
    [self settingSubviewFrame];
    [self settingData];
}

- (void)settingSubviewFrame
{
    baseView.frame = _singleImgFrm.baseFrm;
    backgroundView.frame = _singleImgFrm.backgroundFrm;
    imgView.frame = _singleImgFrm.imgFrm;
    titleLab.frame = _singleImgFrm.titleFrm;
    categoryLab.frame = _singleImgFrm.categoryFrm;
    aspectLab.frame = _singleImgFrm.aspectFrm;
    pointView_1.frame = _singleImgFrm.pointFrm_1;
    pointView_2.frame = _singleImgFrm.pointFrm_2;
    pointView_3.frame = _singleImgFrm.pointFrm_3;
    cutlineView.frame = _singleImgFrm.cutlineFrm;
    showBtn.frame = _singleImgFrm.backgroundFrm;
}

- (void)settingData
{
    NSURL *url = [NSURL URLWithString:_singleImgFrm.headViewDatasource.imgStr];
    
    [imgView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        imgView.image = [ScaleImage scaleImage:imgView.image size:_singleImgFrm.imgFrm.size];
    }];
    
    titleLab.text = _singleImgFrm.headViewDatasource.titleStr;
    aspectLab.text = _singleImgFrm.headViewDatasource.aspectStr;
    aspectLab.text = [NSString stringWithFormat:@"  %@", aspectLab.text];
    CGSize size = [AutoLabelSize autoLabSizeWithStr:aspectLab.text Fontsize:15 SizeW:0 SizeH:15];
    CGRect rect = aspectLab.frame;
    rect.size.width = size.width + 15;
    aspectLab.frame = rect;
    
    CGFloat aspectImgX = CGRectGetMaxX(rect) - 12;
    aspectImg.frame = CGRectMake(aspectImgX, rect.origin.y, 6, 11);
    aspectImg.center = CGPointMake(aspectImg.center.x, aspectLab.center.y);
    aspectImg.image = [UIImage imageNamed:@"arrow_right_white.png"];
    [backgroundView addSubview:aspectImg];
    
    if ([aspectLab.text isEqualToString:@"  0家观点"]) {
        aspectLab.hidden = YES;
        aspectImg.hidden = YES;
    } else {
        aspectLab.hidden = NO;
        aspectImg.hidden = NO;
    }

    //分类
    NSString *categoryStr = _singleImgFrm.headViewDatasource.categoryStr;
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
        categoryLab.text = categoryStr;
        categoryLab.textColor = [UIColor whiteColor];
        CGFloat cornerRad = categoryLab.frame.size.height / 2;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:categoryLab.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(cornerRad, cornerRad)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = categoryLab.bounds;
        maskLayer.path = maskPath.CGPath;
        categoryLab.layer.mask = maskLayer;
    }
    
    NSArray *subArr = _singleImgFrm.headViewDatasource.subArr;
    if (subArr.count == 1) {
        [self setPointDetail:pointView_1 WithDict:subArr[0] WithType:@"only" WithIndex:1 Circle:circleView_1 Topbar:topBar_1 Bottonbar:bottonBar_1 source:sourceLab_1 sourceTitleLab:sourceTitleLab_1 Index:indexLab_1];
        pointView_2.hidden = YES;
        pointView_3.hidden = YES;
    } else {
        [self setPointDetail:pointView_1 WithDict:subArr[0] WithType:@"top" WithIndex:1 Circle:circleView_1 Topbar:topBar_1 Bottonbar:bottonBar_1 source:sourceLab_1 sourceTitleLab:sourceTitleLab_1 Index:indexLab_1];
    }
    
    if (subArr.count == 2) {
        [self setPointDetail:pointView_2 WithDict:subArr[1] WithType:@"botton" WithIndex:2 Circle:circleView_2 Topbar:topBar_2 Bottonbar:bottonBar_2 source:sourceLab_2 sourceTitleLab:sourceTitleLab_2 Index:indexLab_2];
        pointView_3.hidden = YES;
    } else if (subArr.count >= 3) {
        [self setPointDetail:pointView_2 WithDict:subArr[1] WithType:@"nil" WithIndex:2 Circle:circleView_2 Topbar:topBar_2 Bottonbar:bottonBar_2 source:sourceLab_2 sourceTitleLab:sourceTitleLab_2 Index:indexLab_2];
        [self setPointDetail:pointView_3 WithDict:subArr[2] WithType:@"botton" WithIndex:3 Circle:circleView_3 Topbar:topBar_3 Bottonbar:bottonBar_3 source:sourceLab_3 sourceTitleLab:sourceTitleLab_3 Index:indexLab_3];
    }
}

- (void)setPointDetail:(UIView *)view WithDict:(NSDictionary *)dict WithType:(NSString *)type WithIndex:(int)index Circle:(UIView *)circle Topbar:(UIView *)topbar Bottonbar:(UIView *)bottonbar source:(UILabel *)sourceLab sourceTitleLab:(UILabel *)sourceTitleLab Index:(UILabel *)indexLab

{
    view.hidden = NO;
    
//    circle = [[UIView alloc] init];
    circle.backgroundColor = [UIColor colorFromHexString:kBlue];
    circle.frame = _singleImgFrm.circleFrm;
    circle.layer.masksToBounds = YES;
    circle.layer.cornerRadius = circle.frame.size.width / 2;
    
    [view addSubview:circle];
    
//    topbar = [[UIView alloc] init];
    topbar.backgroundColor = [UIColor colorFromHexString:kBlue];
    topbar.frame = _singleImgFrm.topBlueBarFrm;
    topbar.hidden = NO;
    [view addSubview:topbar];
    
//    bottonbar = [[UIView alloc] init];
    bottonbar.backgroundColor = [UIColor colorFromHexString:kBlue];
    bottonbar.frame = _singleImgFrm.bottonBlueBarFrm;
    bottonbar.hidden = NO;
    [view addSubview:bottonbar];
    NSString *sourceStr;
    if (![self isBlankString:dict[@"user"]]) {
        sourceStr = dict[@"user"];
    } else if (![self isBlankString:dict[@"sourceSitename"]]) {
        sourceStr = dict[@"sourceSitename"];
    } else {
        sourceStr = @"null";
    }
    sourceStr = [NSString stringWithFormat:@"%@:", sourceStr];
    
    CGSize sourceSize = [AutoLabelSize autoLabSizeWithStr:sourceStr Fontsize:12 SizeW:0 SizeH:57];
    
    CGRect sourceRect = _singleImgFrm.sourceFrm;
    sourceRect.size = sourceSize;
    
//    sourceLab = [[UILabel alloc] initWithFrame:sourceRect];
    sourceLab.frame = sourceRect;
    sourceLab.text = sourceStr;
    sourceLab.font = [UIFont fontWithName:kFont size:12];
    sourceLab.textAlignment = NSTextAlignmentNatural;
    sourceLab.textColor = [UIColor colorFromHexString:@"#8c8c8c"];
    [view addSubview:sourceLab];
    
    CGRect rect = _singleImgFrm.sourceTitleFrm;
    rect.origin.x = CGRectGetMaxX(sourceLab.frame);
    rect.size.width = [UIScreen mainScreen].bounds.size.width - rect.origin.x - 10;
//    sourceTitleLab = [[UILabel alloc] initWithFrame:rect];
    sourceTitleLab.frame = rect;
    sourceTitleLab.text = dict[@"title"];
    sourceTitleLab.font = [UIFont fontWithName:kFont size:13];
    sourceTitleLab.textAlignment = NSTextAlignmentJustified;
    [view addSubview:sourceTitleLab];
    
    
    circle.center = CGPointMake(circle.center.x, sourceLab.center.y);
    topbar.center = CGPointMake(circle.center.x, topbar.center.y);
    bottonbar.center = CGPointMake(circle.center.x, bottonbar.center.y);
    
//    indexLab = [[UILabel alloc] init];
    indexLab.bounds = CGRectMake(0, 0, 10, 10);
    indexLab.text = [NSString stringWithFormat:@"%d", index];
    indexLab.textColor = [UIColor whiteColor];
    indexLab.center = circle.center;
    indexLab.font = [UIFont fontWithName:kFont size:10];
    indexLab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:indexLab];
    
    
    if ([type isEqualToString:@"top"]) {
        topbar.hidden = YES;
    } else if ([type isEqualToString:@"botton"]) {
        bottonbar.hidden = YES;
    } else if ([type isEqualToString:@"only"]) {
        topbar.hidden = YES;
        bottonbar.hidden = YES;
    }
    
}

- (void)pointViewInit:(UIView *)circle Topbar:(UIView *)topbar Bottonbar:(UIView *)bottonbar source:(UILabel *)sourceLab sourceTitleLab:(UILabel *)sourceTitleLab Index:(UILabel *)indexLab
{
    circle = [[UIView alloc] init];
    topbar = [[UIView alloc] init];
    bottonbar = [[UIView alloc] init];
    sourceLab = [[UILabel alloc] init];
    sourceTitleLab = [[UILabel alloc] init];
    indexLab = [[UILabel alloc] init];
}

- (void)showBtnClick
{
    
    if ([self.delegate respondsToSelector:@selector(getTextContent:imgUrl:SourceSite:Update:Title:ResponseUrls: RootClass: hasImg:)]) {
        [self.delegate getTextContent:_singleImgFrm.headViewDatasource.sourceUrl
                               imgUrl:_singleImgFrm.headViewDatasource.imgStr
                           SourceSite:_singleImgFrm.headViewDatasource.sourceSiteName
                               Update:_singleImgFrm.headViewDatasource.updateTime
                                Title:_singleImgFrm.headViewDatasource.titleStr
                         ResponseUrls:_singleImgFrm.headViewDatasource.responseUrls
                            RootClass:_singleImgFrm.headViewDatasource.rootClass
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
