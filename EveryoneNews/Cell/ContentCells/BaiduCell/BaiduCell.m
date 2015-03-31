//
//  BaiduCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "BaiduCell.h"
#import "UIColor+HexToRGB.h"

@implementation BaiduCell
{
    UIView *baseView;
    UIView *backView;
    UILabel *titleLab;
    UILabel *abstractLab;
    UIImageView *baiduIcon;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        baseView = [[UIView alloc] init];
        baseView.backgroundColor = [UIColor colorFromHexString:@"#7f7f7f"];
        [self.contentView addSubview:baseView];
        
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:backView];
        
        titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont fontWithName:kFont size:16];
        titleLab.textColor = [UIColor colorFromHexString:@"#000000"];
        [backView addSubview:titleLab];
        
        abstractLab = [[UILabel alloc] init];
        abstractLab.font = [UIFont fontWithName:kFont size:12];
        abstractLab.textColor = [UIColor blackColor];
        abstractLab.numberOfLines = 0;
        [backView addSubview:abstractLab];
        
        baiduIcon = [[UIImageView alloc] init];
        baiduIcon.image = [UIImage imageNamed:@"baiduLogo.png"];
        [backView addSubview:baiduIcon];
    }
    return self;
}

- (void)setBaiduFrm:(BaiduFrame *)baiduFrm
{
    _baiduFrm = baiduFrm;
    [self settingData];
    [self settingSubviewFrame];
    
}

//- (void)setBaiduFrm:(BaiduFrame *)baiduFrm
//{
//    NSLog(@"--------222----------");
//}

- (void)settingSubviewFrame
{
    baseView.frame = _baiduFrm.baseViewFrm;
    backView.frame = _baiduFrm.backViewFrm;
    titleLab.frame = _baiduFrm.titleFrm;
    abstractLab.frame = _baiduFrm.abstractFrm;
    baiduIcon.frame = _baiduFrm.baiduIconFrm;
}

- (void)settingData
{
    titleLab.text = _baiduFrm.baiduDatasource.title;
    abstractLab.text = _baiduFrm.baiduDatasource.abstract;
}

@end
