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
        self.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        UILabel *bodyLabel = [[UILabel alloc] init];
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

- (void)setContent:(LPContent *)content {
    _content = content;
    if (!content.isPhoto) { // 非图
        self.bodyLabel.hidden = NO;
        self.photoView.hidden = YES;
        CGFloat bodyX = 0;
        CGFloat bodyY = BodyPadding * 2;
        CGFloat bodyW = ScreenWidth - 2 * BodyPadding;
//        CGFloat bodyH = [_content.bodyHtmlString heightWithConstraintWidth:bodyW];
        CGFloat bodyH = self.cellHeight;
        self.bodyLabel.frame = CGRectMake(bodyX, bodyY, bodyW, bodyH);
        self.bodyLabel.attributedText = _content.bodyHtmlString;
    
    } else {
        self.bodyLabel.hidden = YES;
        self.photoView.hidden = NO;

        CGFloat photoX = 0;
        CGFloat photoY = BodyPadding * 2;
        CGFloat photoW = ScreenWidth - 2 * BodyPadding;
        CGFloat photoH =  photoW * (_content.image.size.height / _content.image.size.width);
        self.photoView.frame = CGRectMake(photoX, photoY, photoW, photoH);
        
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:content.photo] placeholderImage:[UIImage imageNamed:@"单图大图占位图"]];
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}
@end
