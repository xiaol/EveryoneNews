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
    
    UIImageView *sourceIcon_1;
    UIImageView *sourceIcon_2;
    UIImageView *sourceIcon_3;
    
    UIImageView *shotView;
    
    GRKBlurView *blurView;

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
        
       
        shotView = [[UIImageView alloc] init];
        shotView.contentMode = UIViewContentModeScaleAspectFill;
        shotView.clipsToBounds = YES;
        [backgroupView addSubview:shotView];
        
        blurView = [[GRKBlurView alloc] init];
        [backgroupView addSubview:blurView];
        
        
        titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont fontWithName:kFont size:20];
        titleLab.textColor = [UIColor colorFromHexString:@"#ffffff"];
        titleLab.numberOfLines = 2;
        //字体加阴影
        titleLab.layer.shadowColor = [UIColor blackColor].CGColor;
        titleLab.layer.shadowOpacity = 0.6;
        titleLab.layer.shadowRadius = 1.0;
        //阴影方向
        titleLab.layer.shadowOffset = CGSizeMake(2, 2);
        
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
    
    [self settingSubviewFrame];
    [self settingData];
    
    
}

- (void)settingData
{
    titleLab.text = _headViewFrm.headViewDatasource.titleStr;
    
    if ([self isBlankString:_headViewFrm.headViewDatasource.imgStr]) {
        imgView.image = [UIImage imageNamed:@"demo_1.jpg"];
    } else {
        NSURL *url = [NSURL URLWithString:_headViewFrm.headViewDatasource.imgStr];
        
        [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"demo_1.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    imgView.image = [ScaleImage scaleImage:imgView.image size:_headViewFrm.imgFrm.size];
            
            [self screenShotWithRect:shotView.bounds];
        }];
    }
    
    [self screenShotWithRect:shotView.bounds];
    
    NSArray *subArr = _headViewFrm.headViewDatasource.subArr;
    
    if (subArr != nil && ![subArr isKindOfClass:[NSNull class]] && subArr.count != 0) {
        NSMutableArray *sourceTitle = [[NSMutableArray alloc] init];
        NSMutableArray *sourceName = [[NSMutableArray alloc] init];
        NSMutableArray *sourceUrl = [[NSMutableArray alloc] init];
        
        NSMutableArray *sourceSiteNames = [[NSMutableArray alloc] init];
        for (NSDictionary * dic in subArr) {
            [sourceTitle addObject:dic[@"title"]];
            if (![self isBlankString:dic[@"user"]]) {
                [sourceName addObject:dic[@"user"]];
            } else if (![self isBlankString:dic[@"sourceSitename"]]){
                [sourceName addObject:dic[@"sourceSitename"]];
            } else {
                [sourceName addObject:@"木有数据"];
            }
            
            [sourceSiteNames addObject:dic[@"sourceSitename"]];
            [sourceUrl addObject:dic[@"url"]];
        }
        
        sourceTitle_1.text = sourceTitle[0];
        sourceName_1.text = [NSString stringWithFormat:@"%@:", sourceName[0]];
        NSLog(@"title:%@", sourceTitle_1.text);
        [self setSourceIcon:sourceIcon_1 SourceSiteName:sourceSiteNames[0]];
        [self setRelateNewsWithSourceTitle:sourceTitle_1 SourceName:sourceName_1];
        
        if (sourceTitle.count >= 2) {
            sourceTitle_2.text = sourceTitle[1];
            sourceName_2.text = [NSString stringWithFormat:@"%@:", sourceName[1]];
            NSLog(@"title:%@", sourceTitle_2.text);
            [self setSourceIcon:sourceIcon_2 SourceSiteName:sourceSiteNames[1]];
            [self setRelateNewsWithSourceTitle:sourceTitle_2 SourceName:sourceName_2];
        }
        
        if (sourceTitle.count >= 3) {
            sourceTitle_3.text = sourceTitle[2];
            sourceName_3.text = [NSString stringWithFormat:@"%@:", sourceName[2]];
            NSLog(@"title:%@", sourceTitle_3.text);
            [self setSourceIcon:sourceIcon_3 SourceSiteName:sourceSiteNames[2]];
            [self setRelateNewsWithSourceTitle:sourceTitle_3 SourceName:sourceName_3];
        }
        
        
    } else {
        
        sourceTitle_1.text = @"木有数据啊";
        sourceTitle_2.text = @"木有数据啊";
        sourceTitle_3.text = @"";
        
        sourceName_1.text = @"哮天犬";
        sourceName_2.text = @"哮天犬";
        sourceName_3.text = @"";
    }
    
    
  
    aspect.text = _headViewFrm.headViewDatasource.aspectStr;
}

- (void)settingSubviewFrame
{
    backgroupView.frame = _headViewFrm.backgroundViewFrm;
    imgView.frame = _headViewFrm.imgFrm;
    titleLab.frame = _headViewFrm.titleLabFrm;
    shotView.frame = titleLab.frame;
    
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
        
        aspectView.frame = _headViewFrm.aspectFrm;
        aspect.frame = _headViewFrm.aspectFrm;
    }
    
    cutBlock.frame = _headViewFrm.cutBlockFrm;
    showBtn.frame = imgView.frame;
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

#pragma mark screenShot
-(void)screenShotWithRect:(CGRect)rect {
    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 960), YES, 0);
    UIGraphicsBeginImageContextWithOptions(self.contentView.frame.size, YES, 1);
    [[imgView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
//    CGRect rect =CGRectMake(100,  100, 320, 400);//这里可以设置想要截图的区域
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    shotView.image = sendImage;
    
    CGImageRelease(imageRefRect);
    
    [self setBlurView];
    
}

#pragma mark 设置毛玻璃效果
- (void)setBlurView
{
    blurView.frame = shotView.frame;
    blurView.targetImage = shotView.image;
    blurView.blurRadius = 22;

    //设置右下圆角
    UIBezierPath *maskPath_Shadow = [UIBezierPath bezierPathWithRoundedRect:blurView.bounds byRoundingCorners:UIRectCornerBottomRight  cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer_Shadow = [[CAShapeLayer alloc] init];
    maskLayer_Shadow.frame = blurView.bounds;
    maskLayer_Shadow.path = maskPath_Shadow.CGPath;
    blurView.layer.mask = maskLayer_Shadow;
}

#pragma mark 设置相关新闻UI
- (void)setRelateNewsWithSourceTitle:(UILabel *)sourceTitle SourceName:(UILabel *)sourceName
{
    CGSize size = [AutoLabelSize autoLabSizeWithStr:sourceName.text Fontsize:16 SizeW:0 SizeH:16];
    CGRect rect = sourceName.frame;
    rect.size.width = size.width;
    sourceName.frame = rect;
    
    CGFloat titleX = CGRectGetMaxX(rect);
    CGFloat titleW = [UIScreen mainScreen].bounds.size.width - titleX - 16;
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
    
    sourceTitle.font = [UIFont fontWithName:kFont size:18];
    sourceTitle.textColor = [UIColor blackColor];
    sourceTitle.backgroundColor = [UIColor clearColor];
    [sourceView addSubview:sourceTitle];
    
    sourceName.font = [UIFont fontWithName:kFont size:16];
    sourceName.textColor = [UIColor colorFromHexString:@"#666666"];
    sourceName.backgroundColor = [UIColor clearColor];
    [sourceView addSubview:sourceName];
    
}

- (void)setSourceIcon:(UIImageView *)sourceIcon SourceSiteName:(NSString *)sourceSiteName
{
    NSLog(@"sourceSiteName:  %@", sourceSiteName);
    if ([self isBlankString:sourceSiteName]) {
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
@end
