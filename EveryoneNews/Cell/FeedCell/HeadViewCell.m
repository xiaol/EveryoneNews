//
//  HeadViewCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "HeadViewCell.h"
#import "UIColor+HexToRGB.h"
#import "UIImageView+WebCache.h"
#import "ScaleImage.h"
#import "GRKBlurView.h"
#import "AutoLabelSize.h"
#import "NSString+YU.h"

#define kSiteNameFont 13
#define kTitleFont 14

@implementation HeadViewCell
{
    UIView *backgroupView;
    UIImageView *imgView;
    UIImageView *imgView_2;
    UIImageView *imgView_3;
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
    
    UIImageView *sourceIcon_1;
    UIImageView *sourceIcon_2;
    UIImageView *sourceIcon_3;
    
    UIImageView *shotView;
    
    UILabel *categoryLab;
    
    GRKBlurView *blurView;
    UIView *grayView;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        backgroupView = [[UIView alloc] init];
        backgroupView.backgroundColor = [UIColor colorFromHexString:@"#EBEDED"];
        backgroupView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:backgroupView];
        
        imgView = [[UIImageView alloc] init];
        imgView_2 = [[UIImageView alloc] init];
        imgView_3 = [[UIImageView alloc] init];
        [self setImg:imgView];
        [self setImg:imgView_2];
        [self setImg:imgView_3];
        
        categoryLab = [[UILabel alloc] init];
        categoryLab.font = [UIFont fontWithName:kFont size:15];
        categoryLab.textAlignment = NSTextAlignmentCenter;
        
        [backgroupView addSubview:categoryLab];
       
        shotView = [[UIImageView alloc] init];
        shotView.clipsToBounds = YES;
//        [backgroupView addSubview:shotView];
        
        blurView = [[GRKBlurView alloc] init];
        [backgroupView addSubview:blurView];
        
        //加灰色透明层
        grayView = [[UIView alloc] init];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.7;
        grayView.layer.masksToBounds = YES;
        grayView.layer.cornerRadius = 2;
//        [backgroupView addSubview:grayView];
        
        
        titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont fontWithName:kFont size:20];
//        titleLab.textColor = [UIColor colorFromHexString:@"#ffffff"];
        titleLab.textColor = [UIColor blackColor];
        titleLab.numberOfLines = 2;
        titleLab.lineBreakMode = NSLineBreakByWordWrapping;
//        //字体加阴影
//        titleLab.layer.shadowColor = [UIColor blackColor].CGColor;
//        titleLab.layer.shadowOpacity = 0.6;
//        titleLab.layer.shadowRadius = 1.0;
//        //阴影方向
//        titleLab.layer.shadowOffset = CGSizeMake(2, 2);
        
        [backgroupView addSubview:titleLab];
        
        sourceView_1 = [[UIView alloc] init];
        sourceView_2 = [[UIView alloc] init];
        sourceView_3 = [[UIView alloc] init];
        
        sourceIcon_1 = [[UIImageView alloc] init];
        sourceIcon_2 = [[UIImageView alloc] init];
        sourceIcon_3 = [[UIImageView alloc] init];
       
        sourceTitle_1 = [[UILabel alloc] init];
        sourceTitle_2 = [[UILabel alloc] init];
        sourceTitle_3 = [[UILabel alloc] init];
        
        sourceName_1 = [[UILabel alloc] init];
        sourceName_2 = [[UILabel alloc] init];
        sourceName_3 = [[UILabel alloc] init];

        [self setSourceTitle:sourceTitle_1 SourceName:sourceName_1 SourceIcon:sourceIcon_1 inSourceView:sourceView_1];
        [self setSourceTitle:sourceTitle_2 SourceName:sourceName_2 SourceIcon:sourceIcon_2 inSourceView:sourceView_2];
        [self setSourceTitle:sourceTitle_3 SourceName:sourceName_3 SourceIcon:sourceIcon_3 inSourceView:sourceView_3];
        
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
        cutBlock.backgroundColor = [UIColor colorFromHexString:@"#EBEDED"];
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
    
    [self settingSubviewFrame];
    [self settingData];
}


- (void)settingData
{
    titleLab.text = _headViewFrm.headViewDatasource.titleStr;

    
    if ([NSString isBlankString:_headViewFrm.headViewDatasource.imgStr]) {

    } else {
        [self loadImgView:imgView WithUrl:_headViewFrm.headViewDatasource.imgStr WithSize:_headViewFrm.imgFrm.size];
    }
    
    if (_headViewFrm.headViewDatasource.imgArr.count == 2) {
        [self loadImgView:imgView_2 WithUrl:_headViewFrm.headViewDatasource.imgArr[1] WithSize:_headViewFrm.imgFrm_2.size];
    }
    
    if (_headViewFrm.headViewDatasource.imgArr.count >= 3) {

        [self loadImgView:imgView_2 WithUrl:_headViewFrm.headViewDatasource.imgArr[1] WithSize:_headViewFrm.imgFrm_2.size];

        [self loadImgView:imgView_3 WithUrl:_headViewFrm.headViewDatasource.imgArr[2] WithSize:_headViewFrm.imgFrm_3.size];
    }
    
    //分类
    NSString *categoryStr = _headViewFrm.headViewDatasource.categoryStr;
    if ([NSString isBlankString:categoryStr]) {
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
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:categoryLab.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = categoryLab.bounds;
        maskLayer.path = maskPath.CGPath;
        categoryLab.layer.mask = maskLayer;
    }
    
    NSArray *subArr = _headViewFrm.headViewDatasource.subArr;
    
    if (subArr != nil && ![subArr isKindOfClass:[NSNull class]] && subArr.count != 0) {
        NSMutableArray *sourceTitle = [[NSMutableArray alloc] init];
        NSMutableArray *sourceName = [[NSMutableArray alloc] init];
        NSMutableArray *sourceUrl = [[NSMutableArray alloc] init];
        
        NSMutableArray *sourceSiteNames = [[NSMutableArray alloc] init];
        for (NSDictionary * dic in subArr) {
            [sourceTitle addObject:dic[@"title"]];
            if (![NSString isBlankString:dic[@"user"]]) {
                [sourceName addObject:dic[@"user"]];
            } else if (![NSString isBlankString:dic[@"sourceSitename"]]){
                [sourceName addObject:dic[@"sourceSitename"]];
            } else {
                [sourceName addObject:@"木有数据"];
            }
            
            [sourceSiteNames addObject:dic[@"sourceSitename"]];
            [sourceUrl addObject:dic[@"url"]];
        }
        
        sourceTitle_1.text = sourceTitle[0];
        sourceName_1.text = [NSString stringWithFormat:@"%@:", sourceName[0]];
        [self setSourceIcon:sourceIcon_1 SourceSiteName:sourceSiteNames[0]];
        [self setRelateNewsWithSourceTitle:sourceTitle_1 SourceName:sourceName_1];
        
        sourceView_2.hidden = YES;
        sourceView_3.hidden = YES;
        
        if (sourceTitle.count == 2) {
            sourceView_2.hidden = NO;
            sourceTitle_2.text = sourceTitle[1];
            sourceName_2.text = [NSString stringWithFormat:@"%@:", sourceName[1]];
            [self setSourceIcon:sourceIcon_2 SourceSiteName:sourceSiteNames[1]];
            [self setRelateNewsWithSourceTitle:sourceTitle_2 SourceName:sourceName_2];
        }
        
        if (sourceTitle.count >= 3) {
            
            sourceView_2.hidden = NO;
            sourceTitle_2.text = sourceTitle[1];
            sourceName_2.text = [NSString stringWithFormat:@"%@:", sourceName[1]];
            [self setSourceIcon:sourceIcon_2 SourceSiteName:sourceSiteNames[1]];
            [self setRelateNewsWithSourceTitle:sourceTitle_2 SourceName:sourceName_2];
            
            sourceView_3.hidden = NO;
            sourceTitle_3.text = sourceTitle[2];
            sourceName_3.text = [NSString stringWithFormat:@"%@:", sourceName[2]];
            [self setSourceIcon:sourceIcon_3 SourceSiteName:sourceSiteNames[2]];
            [self setRelateNewsWithSourceTitle:sourceTitle_3 SourceName:sourceName_3];
        }
    }
    aspect.text = _headViewFrm.headViewDatasource.aspectStr;
}

- (void)settingSubviewFrame
{
    backgroupView.frame = _headViewFrm.backgroundViewFrm;
    imgView.frame = _headViewFrm.imgFrm;
    imgView_2.frame = _headViewFrm.imgFrm_2;
    imgView_3.frame = _headViewFrm.imgFrm_3;
    categoryLab.frame = _headViewFrm.categoryFrm;

    grayView.frame = _headViewFrm.titleLabFrm;
    titleLab.frame = _headViewFrm.titleLabFrm;
    
    CGRect rect = titleLab.frame;
    rect.origin.x = rect.origin.x - 12;
    rect.origin.y = rect.origin.y + 2;
    rect.size.width = rect.size.width + 12 * 2;
    
    shotView.frame = rect;
    
    sourceView_1.frame = _headViewFrm.sourceView_1;
    sourceView_2.frame = _headViewFrm.sourceView_2;
    sourceView_3.frame = _headViewFrm.sourceView_3;
    
    sourceIcon_1.frame = _headViewFrm.sourceIcon;
    sourceIcon_2.frame = _headViewFrm.sourceIcon;
    sourceIcon_3.frame = _headViewFrm.sourceIcon;
    
    sourceTitle_1.frame = _headViewFrm.sourceTitle;
    sourceTitle_2.frame = _headViewFrm.sourceTitle;
    sourceTitle_3.frame = _headViewFrm.sourceTitle;
    
    sourceName_1.frame = _headViewFrm.sourceName;
    sourceName_2.frame = _headViewFrm.sourceName;
    sourceName_3.frame = _headViewFrm.sourceName;
    
    bottonView.frame = _headViewFrm.bottonView;
    if (![_headViewFrm.headViewDatasource.aspectStr isEqualToString:@"0家观点"]) {
    
//        bottonView = [[UIView alloc] init];
//        bottonView.backgroundColor = [UIColor whiteColor];
//        [backgroupView addSubview:bottonView];
//        
//        aspectView = [[UIView alloc] init];
//        aspectView.backgroundColor = [UIColor clearColor];
//        aspectView.layer.borderWidth = 1;
//        aspectView.layer.borderColor = [UIColor colorFromHexString:@"#EBEDED"].CGColor;
//        aspectView.layer.cornerRadius = 3;
//        [backgroupView addSubview:aspectView];
//        
//        aspect = [[UILabel alloc] init];
//        aspect.font = [UIFont fontWithName:kFont size:20];
//        aspect.textColor = [UIColor colorFromHexString:@"#4eb4ea"];
//        aspect.backgroundColor = [UIColor clearColor];
//        aspect.textAlignment = NSTextAlignmentRight;
//        [backgroupView addSubview:aspect];
    
        CGSize aspectSize = [AutoLabelSize autoLabSizeWithStr:_headViewFrm.headViewDatasource.aspectStr Fontsize:20 SizeW:0 SizeH:21];
        CGRect rect = _headViewFrm.aspectFrm;
        CGFloat aspectX = [UIScreen mainScreen].bounds.size.width - aspectSize.width - 16;
        rect.origin.x = aspectX;
        rect.size.width = aspectSize.width;
        
        aspectView.frame = rect;
        aspect.frame = rect;
        
        aspectView.hidden = NO;
        aspect.hidden = NO;
    } else {
        aspect.hidden = YES;
        aspectView.hidden = YES;
        aspect.frame = CGRectMake(0, 0, 0, 0);
        aspectView.frame = CGRectMake(0, 0, 0, 0);
    }

    cutBlock.frame = _headViewFrm.cutBlockFrm;
    showBtn.frame = _headViewFrm.backgroundViewFrm;
}

- (void)showBtnClick
{

    if ([self.delegate respondsToSelector:@selector(getTextContent:imgUrl:SourceSite:Update:Title:ResponseUrls: RootClass: hasImg:)]) {
        [self.delegate getTextContent:_headViewFrm.headViewDatasource.sourceUrl
                               imgUrl:_headViewFrm.headViewDatasource.imgStr
                           SourceSite:_headViewFrm.headViewDatasource.sourceSiteName
                               Update:_headViewFrm.headViewDatasource.updateTime
                                Title:_headViewFrm.headViewDatasource.titleStr
                         ResponseUrls:_headViewFrm.headViewDatasource.responseUrls
                            RootClass:_headViewFrm.headViewDatasource.rootClass
                               hasImg:NO];
    }
}

//#pragma mark screenShot
//-(void)screenShotWithRect:(CGRect)rect {
//    
//    rect.origin.x = 0;
//    if ([UIScreen mainScreen].bounds.size.width > 320) {
//        rect.origin.y = rect.origin.y - 8;
//    }
//    
//    
////    UIGraphicsBeginImageContextWithOptions(imgView.frame.size, YES, 1);
//    UIGraphicsBeginImageContextWithOptions(self.contentView.frame.size, YES, 1);
//    [[imgView layer] renderInContext:UIGraphicsGetCurrentContext()];
////    [[self.contentView layer] renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    CGImageRef imageRef = viewImage.CGImage;
////    CGRect rect =CGRectMake(100,  100, 320, 400);//这里可以设置想要截图的区域
//    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
//    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
//    
//    shotView.image = sendImage;
//    
//    CGImageRelease(imageRefRect);
//    
//    //设置右下圆角
//    UIBezierPath *maskPath_Shadow = [UIBezierPath bezierPathWithRoundedRect:shotView.bounds byRoundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight  cornerRadii:CGSizeMake(5, 5)];
//    CAShapeLayer *maskLayer_Shadow = [[CAShapeLayer alloc] init];
//    maskLayer_Shadow.frame = shotView.bounds;
//    maskLayer_Shadow.path = maskPath_Shadow.CGPath;
//    shotView.layer.mask = maskLayer_Shadow;
//    
////    [self setBlurView];
//    
//}

//#pragma mark 设置毛玻璃效果
//- (void)setBlurView
//{
//    CGRect rect = shotView.frame;
//    blurView.frame = rect;
//    blurView.targetImage = shotView.image;
//
////    blurView.blurRadius = 15.56;
//    blurView.blurRadius = 0;
//    blurView.alpha = 0.7;
//
//    //设置右下圆角
//    UIBezierPath *maskPath_Shadow = [UIBezierPath bezierPathWithRoundedRect:blurView.bounds byRoundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight  cornerRadii:CGSizeMake(5, 5)];
//    CAShapeLayer *maskLayer_Shadow = [[CAShapeLayer alloc] init];
//    maskLayer_Shadow.frame = blurView.bounds;
//    maskLayer_Shadow.path = maskPath_Shadow.CGPath;
//    blurView.layer.mask = maskLayer_Shadow;
//}

#pragma mark 设置相关新闻UI
- (void)setRelateNewsWithSourceTitle:(UILabel *)sourceTitle SourceName:(UILabel *)sourceName
{
    CGSize size = [AutoLabelSize autoLabSizeWithStr:sourceName.text Fontsize:kSiteNameFont SizeW:0 SizeH:kSiteNameFont + 2];
    CGRect rect = sourceName.frame;
    rect.size.width = size.width;
    sourceName.frame = rect;
    
    CGFloat titleX = CGRectGetMaxX(rect);
    CGFloat titleW = [UIScreen mainScreen].bounds.size.width - titleX - 16 * 2;
    rect = sourceTitle.frame;
    rect.size.width = titleW;
    rect.origin.x = titleX;
    sourceTitle.frame = rect;
}


- (void)setSourceTitle:(UILabel *)sourceTitle SourceName:(UILabel *)sourceName SourceIcon:(UIImageView *)sourceIcon inSourceView:(UIView *)sourceView
{
    sourceView.backgroundColor = [UIColor whiteColor];
    [backgroupView addSubview:sourceView];
    
    [sourceView addSubview:sourceIcon];
    
    sourceTitle.font = [UIFont fontWithName:kFont size:kTitleFont];
    sourceTitle.textColor = [UIColor colorFromHexString:@"#787878"];
    sourceTitle.backgroundColor = [UIColor clearColor];
    sourceTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [sourceView addSubview:sourceTitle];
    
    sourceName.font = [UIFont fontWithName:kFont size:kSiteNameFont];
    sourceName.textColor = [UIColor colorFromHexString:@"#666666"];
    sourceName.backgroundColor = [UIColor clearColor];
    [sourceView addSubview:sourceName];
    
}

- (void)setImg:(UIImageView *)img
{
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    img.backgroundColor = [UIColor grayColor];
    [backgroupView addSubview:img];
}

- (void)loadImgView:(UIImageView *)img WithUrl:(NSString *)urlStr WithSize:(CGSize)size
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [img sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        img.image = [ScaleImage scaleImage:img.image size:size];
    }];
}

- (void)setSourceIcon:(UIImageView *)sourceIcon SourceSiteName:(NSString *)sourceSiteName
{
//    NSLog(@"sourceSiteName:  %@", sourceSiteName);
    if ([NSString isBlankString:sourceSiteName]) {
        sourceIcon.image = [UIImage imageNamed:@"other.png"];
    }
    else {
        if ([sourceSiteName isEqualToString:@"凤凰网"]) {
            sourceIcon.image = [UIImage imageNamed:@"fenghuangwang.png"];
        }
        else if ([sourceSiteName isEqualToString:@"网易"]){
            sourceIcon.image = [UIImage imageNamed:@"yi.png"];
        }
        else if ([sourceSiteName isEqualToString:@"zhihu"]){
            sourceIcon.image = [UIImage imageNamed:@"zhihu.png"];
        }
        else if ([sourceSiteName isEqualToString:@"weibo"]){
            sourceIcon.image = [UIImage imageNamed:@"weibo.png"];
        }
        else if ([sourceSiteName isEqualToString:@"国际在线"]){
            sourceIcon.image = [UIImage imageNamed:@"guojizaixian.png"];
        }
        else if ([sourceSiteName isEqualToString:@"新浪网"]){
            sourceIcon.image = [UIImage imageNamed:@"xinlang.png"];
        }
        else if ([sourceSiteName isEqualToString:@"搜狐"]){
            sourceIcon.image = [UIImage imageNamed:@"souhu.png"];
        }
        else if ([sourceSiteName isEqualToString:@"腾讯"]){
            sourceIcon.image = [UIImage imageNamed:@"tengxun.png"];
        }
        else if ([sourceSiteName isEqualToString:@"中国经济报"]){
            sourceIcon.image = [UIImage imageNamed:@"zhongguojingjibao.png"];
        }
        else if ([sourceSiteName isEqualToString:@"中国经济网"]){
            sourceIcon.image = [UIImage imageNamed:@"zhongguojingjiwang.png"];
        }
        else if ([sourceSiteName isEqualToString:@"人民网"]){
            sourceIcon.image = [UIImage imageNamed:@"renminwang.png"];
        }
        else if ([sourceSiteName isEqualToString:@"经济参考报"]){
            sourceIcon.image = [UIImage imageNamed:@"jingjicankaobao.png"];
        }
        else if ([sourceSiteName isEqualToString:@"南方网"]){
            sourceIcon.image = [UIImage imageNamed:@"nanfang.png"];
        }
        else if ([sourceSiteName isEqualToString:@"中工网"]){
            sourceIcon.image = [UIImage imageNamed:@"zhonggongwang.png"];
        }
        else if ([sourceSiteName isEqualToString:@"央视网"]){
            sourceIcon.image = [UIImage imageNamed:@"yangshiwang.png"];
        }
        else if ([sourceSiteName isEqualToString:@"金融街"]){
            sourceIcon.image = [UIImage imageNamed:@"jinrongjie.png"];
        }
        else if ([sourceSiteName isEqualToString:@"南海网"]){
            sourceIcon.image = [UIImage imageNamed:@"nanhaiwang.png"];
        }
        else if ([sourceSiteName isEqualToString:@"36氪"]){
            sourceIcon.image = [UIImage imageNamed:@"thirty_six_ke.png"];
        }
        else if ([sourceSiteName isEqualToString:@"环球网"]){
            sourceIcon.image = [UIImage imageNamed:@"huanqiuwang.png"];
        }
        else if ([sourceSiteName isEqualToString:@"解放牛网"]){
            sourceIcon.image = [UIImage imageNamed:@"iefangniuwang.png"];
        }
        else if ([sourceSiteName isEqualToString:@"21CN"]){
            sourceIcon.image = [UIImage imageNamed:@"twenty_one_cn.png"];
        }
        else if ([sourceSiteName isEqualToString:@"中金在线"]){
            sourceIcon.image = [UIImage imageNamed:@"zhongjinzaixian.png"];
        }
        else if ([sourceSiteName isEqualToString:@"证券之星"]){
            sourceIcon.image = [UIImage imageNamed:@"zhengquanzhixing.png"];
        }
        else if ([sourceSiteName isEqualToString:@"太平洋电脑网"]){
            sourceIcon.image = [UIImage imageNamed:@"taipingyangdiannaowang.png"];
        }
        else if ([sourceSiteName isEqualToString:@"中关村在线"]){
            sourceIcon.image = [UIImage imageNamed:@"zhongguancunzaixian.png"];
        }
        else if ([sourceSiteName isEqualToString:@"红网"]){
            sourceIcon.image = [UIImage imageNamed:@"hongwang.png"];
        }
        else if ([sourceSiteName isEqualToString:@"北青网"]){
            sourceIcon.image = [UIImage imageNamed:@"beiqingwang.png"];
        }
        else if ([sourceSiteName isEqualToString:@"sports.cn"]){
            sourceIcon.image = [UIImage imageNamed:@"sportscn.png"];
        }
        else if ([sourceSiteName isEqualToString:@"新民网"]){
            sourceIcon.image = [UIImage imageNamed:@"xinmin.png"];
        }
        else if ([sourceSiteName isEqualToString:@"中国山东网"]){
            sourceIcon.image = [UIImage imageNamed:@"zhongguoshandongwang.png"];
        }
        else {
            sourceIcon.image = [UIImage imageNamed:@"other.png"];
        }
    }
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    if (!firstLoad) {
//        [UIView animateWithDuration:1 animations:^{
//            self.contentView.alpha = 1;
//        }];
//        firstLoad = YES;
//    }
//    
//}
@end
