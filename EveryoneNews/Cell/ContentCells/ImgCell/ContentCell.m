//
//  ContentCell.m
//  upNews
//
//  Created by 于咏畅 on 15/1/21.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "ContentCell.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

@implementation ContentCell
{
    UIView *imgView;
//    UIImageView *img;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgView = [[UIView alloc] init];
        [self.contentView addSubview:imgView];
    }
    return self;
}

- (void)setContentCellFrm:(ContentCellFrame *)contentCellFrm
{
    _contentCellFrm = contentCellFrm;
    
    [self settingData];
    [self settingSubviewFrame];
    
}

- (void)settingData
{
    _img = [[UIImageView alloc] init];
    
    NSURL *url = [NSURL URLWithString:_contentCellFrm.contentDatasource.imgUrl];

    [_img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultImg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
//        _img.image = [self scaleImage:_img.image size:_contentCellFrm.imgFrm.size];
        
        [SVProgressHUD dismiss];
    }];
    
    [imgView addSubview:_img];
}

- (void)settingSubviewFrame
{
    imgView.frame = _contentCellFrm.imgViewFrm;
    _img.frame = _contentCellFrm.imgFrm;
}


@end
