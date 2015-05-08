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
    UIView *pointView_1;
    UIView *pointView_2;
    UIView *pointView_3;
    UIView *cutlineView;
    UIButton *showBtn;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        baseView = [[UIView alloc] init];
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
        [backgroundView addSubview:aspectLab];
        
        pointView_1 = [[UIView alloc] init];
        pointView_2 = [[UIView alloc] init];
        pointView_3 = [[UIView alloc] init];
        [backgroundView addSubview:pointView_1];
        [backgroundView addSubview:pointView_2];
        [backgroundView addSubview:pointView_3];
        
        showBtn = [[UIButton alloc] init];
        showBtn.backgroundColor = [UIColor clearColor];
        [showBtn addTarget:self action:@selector(showBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:showBtn];
        
        
        cutlineView = [[UIView alloc] init];
        cutlineView.backgroundColor = [UIColor grayColor];      //暂定
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
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:categoryLab.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(2, 2)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = categoryLab.bounds;
        maskLayer.path = maskPath.CGPath;
        categoryLab.layer.mask = maskLayer;
    }
    
    NSArray *subArr = _singleImgFrm.headViewDatasource.subArr;
    [self setPointDetail:pointView_1 WithDict:subArr[0]];
    if (subArr.count == 2) {
        [self setPointDetail:pointView_2 WithDict:subArr[1]];
    } else if (subArr.count >= 3) {
        [self setPointDetail:pointView_2 WithDict:subArr[1]];
        [self setPointDetail:pointView_3 WithDict:subArr[2]];
    }
    

}

- (void)setPointDetail:(UIView *)view WithDict:(NSDictionary *)dict
{
    UIView *circleView = [[UIView alloc] init];
    circleView.backgroundColor = [UIColor colorFromHexString:kBlue];
    circleView.frame = _singleImgFrm.circleFrm;
    circleView.layer.masksToBounds = YES;
    circleView.layer.cornerRadius = circleView.frame.size.width / 2;
    circleView.center = CGPointMake(circleView.center.x, view.frame.size.height / 2);
    [view addSubview:circleView];
    
    UIView *topBar = [[UIView alloc] init];
    topBar.backgroundColor = [UIColor colorFromHexString:kBlue];
//    topBar.backgroundColor = [UIColor yellowColor];
    topBar.frame = _singleImgFrm.topBlueBarFrm;
    topBar.center = CGPointMake(circleView.center.x, topBar.center.y);
    [view addSubview:topBar];
    
    UIView *bottonBar = [[UIView alloc] init];
    bottonBar.backgroundColor = [UIColor colorFromHexString:kBlue];
//    bottonBar.backgroundColor = [UIColor greenColor];
    bottonBar.frame = _singleImgFrm.bottonBlueBarFrm;
    bottonBar.center = CGPointMake(circleView.center.x, bottonBar.center.y);
    [view addSubview:bottonBar];
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
    
    UILabel *sourceLab = [[UILabel alloc] initWithFrame:sourceRect];
    sourceLab.text = sourceStr;
    sourceLab.font = [UIFont fontWithName:kFont size:12];
    sourceLab.textAlignment = NSTextAlignmentNatural;
    [view addSubview:sourceLab];
    
    CGRect rect = _singleImgFrm.sourceTitleFrm;
    rect.origin.x = CGRectGetMaxX(sourceLab.frame);
    rect.size.width = [UIScreen mainScreen].bounds.size.width - rect.origin.x - 10;
    UILabel *sourceTitleLab = [[UILabel alloc] initWithFrame:rect];
    sourceTitleLab.text = dict[@"title"];
    sourceTitleLab.font = [UIFont fontWithName:kFont size:13];
    [view addSubview:sourceTitleLab];
    
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
