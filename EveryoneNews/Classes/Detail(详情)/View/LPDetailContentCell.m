//
//  LPDetailContentCell.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPDetailContentCell.h"
#import "LPDetailContentFrame.h"
#import "LPDetailContent.h"
#import "UIImageView+WebCache.h"

@interface LPDetailContentCell ()

@property (nonatomic, strong) UILabel *bodyLabel;
// 图片类型
@property (nonatomic, strong) UIImageView *photoView;

@end

@implementation LPDetailContentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"content";
    LPDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LPDetailContentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        UILabel *bodyLabel = [[UILabel alloc] init];
        bodyLabel.userInteractionEnabled = YES;
        bodyLabel.lineBreakMode = NSLineBreakByCharWrapping;
        bodyLabel.numberOfLines = 0;
        [self.contentView addSubview:bodyLabel];
        self.bodyLabel = bodyLabel;
        
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        [self.contentView addSubview:photoView];
        self.photoView = photoView;
    }
    return self;
}

- (void)setContentFrame:(LPDetailContentFrame *)contentFrame
{
    _contentFrame = contentFrame;
    LPDetailContent *content = contentFrame.content;
    self.bodyLabel.frame = self.contentFrame.bodyLabelF;
    self.bodyLabel.attributedText = content.bodyString;
    
   [self.photoView sd_setImageWithURL:[NSURL URLWithString:content.img] placeholderImage:[UIImage imageNamed:@"详情占位图"]];
    self.photoView.frame = self.contentFrame.photoViewF;
    
}
@end
