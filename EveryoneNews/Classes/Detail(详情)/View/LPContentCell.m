//
//  LPContentCell.m
//  EveryoneNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPContentCell.h"
#import "LPCommentView.h"
#import "LPContentFrame.h"
#import "LPContent.h"
#import "LPSupplementView.h"
#import "UIImageView+WebCache.h"

@interface LPContentCell()
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) LPCommentView *commentView;
// 图片类型
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *photoLabel;

@property (nonatomic, strong) LPSupplementView *supplementView;

@property (nonatomic, strong) UIView *abstractSeperatorView;

@end

@implementation LPContentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"content";
    LPContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LPContentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];        
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
        
//        UIView *abstractSeperatorView = [[UIView alloc] init];
//        abstractSeperatorView.backgroundColor = [UIColor colorFromHexString:@"#edefef"];
//        [self.contentView addSubview:abstractSeperatorView];
//        self.abstractSeperatorView = abstractSeperatorView;
        
    }
    return self;
}

- (void)setContentFrame:(LPContentFrame *)contentFrame
{
    _contentFrame = contentFrame;
    LPContent *content = contentFrame.content;
    if (!content.isPhoto) { // 非图
        self.bodyLabel.hidden = NO;
        self.photoView.hidden = YES;
        
        self.bodyLabel.frame = self.contentFrame.bodyLabelF;
        self.bodyLabel.attributedText = content.bodyString;
        
    } else {
        self.bodyLabel.hidden = YES;
        self.photoView.hidden = NO;
        
        self.photoView.frame = self.contentFrame.photoViewF;
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:content.photo] placeholderImage:[UIImage imageNamed:@"单图大图占位图"]];
        
//        [self.photoView sd_setImageWithURL:[NSURL URLWithString:content.photo] placeholderImage:[UIImage imageNamed:@"单图大图占位图"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (!_contentFrame.isUpdated) {
//                // 图片实际高度和宽度比例
//                CGFloat scaleRate = image.size.height /  image.size.width ;
//                CGFloat photoH = contentFrame.photoViewF.size.width * scaleRate;
//                CGRect rect = CGRectMake(contentFrame.photoViewF.origin.x, contentFrame.photoViewF.origin.y, contentFrame.photoViewF.size.width, photoH);
//                self.photoView.frame = rect;
//                
//                _contentFrame.cellHeight  = CGRectGetMaxY(rect);
//                _contentFrame.updated = YES;
//                if ([self.delegate respondsToSelector:@selector(tableViewDidReload:)]) {
//                    [self.delegate tableViewDidReload:self];
//                }
//            }
//        }];
    }
}

//- (void)setFrame:(CGRect)frame
//{
//    frame.origin.x = DetailCellBilateralBorder;
//    frame.size.width -= 2 * DetailCellBilateralBorder;
//    [super setFrame:frame];
//}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}
@end
