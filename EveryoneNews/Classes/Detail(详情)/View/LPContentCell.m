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
#import "UIImageView+WebCache.h"

@interface LPContentCell()
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) LPCommentView *commentView;
// 图片类型
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *photoLabel;
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
        
        UILabel *bodyLabel = [[UILabel alloc] init];
        bodyLabel.lineBreakMode = NSLineBreakByCharWrapping;
        bodyLabel.numberOfLines = 0;
        [self.contentView addSubview:bodyLabel];
        self.bodyLabel = bodyLabel;
        
        LPCommentView *commentView = [[LPCommentView alloc] init];
        [self.contentView addSubview:commentView];
        self.commentView = commentView;
        [commentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapComment)]];
        
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        [self.contentView addSubview:photoView];
        self.photoView = photoView;
        
        UILabel *photoLabel = [[UILabel alloc] init];
        photoLabel.numberOfLines = 0;
        photoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:photoLabel];
        self.photoLabel = photoLabel;
    }
    return self;
}

- (void)setContentFrame:(LPContentFrame *)contentFrame
{
    _contentFrame = contentFrame;
    LPContent *content = contentFrame.content;
    
    if (!content.isPhoto) {
        self.bodyLabel.hidden = NO;
        self.photoView.hidden = YES;
        self.photoLabel.hidden = YES;
        self.commentView.hidden = NO;
        
        self.bodyLabel.frame = self.contentFrame.bodyLabelF;
        self.bodyLabel.attributedText = content.bodyString;
    } else {
        self.bodyLabel.hidden = YES;
        self.photoView.hidden = NO;
        self.photoView.frame = self.contentFrame.photoViewF;
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:content.photo] placeholderImage:[UIImage imageNamed:@"详情占位图"]];
        if (!content.photoDesc || content.photoDesc.length == 0) {
            self.commentView.hidden = YES;
            self.photoLabel.hidden = YES;
        } else {
            self.commentView.hidden = NO;
            self.photoLabel.hidden = NO;
            self.photoLabel.frame = self.contentFrame.photoDescViewF;
            self.photoLabel.attributedText = content.photoDescString;
        }
    }
    if (!content.isAbstract || (content.isPhoto && content.photoDesc.length)) {
        self.commentView.hidden = NO;
        self.commentView.frame = self.contentFrame.commentViewF;
        self.commentView.contentFrame = self.contentFrame;
    } else {
        self.commentView.hidden = YES;
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = DetailCellBilateralBorder;
    frame.size.height -= DetailCellHeightBorder;
    frame.size.width -= 2 * DetailCellBilateralBorder;
    [super setFrame:frame];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)tapComment
{
    if (self.contentFrame.content.hasComment) {
        if ([self.delegate respondsToSelector:@selector(contentCellDidClickCommentView:)]) {
            [self.delegate contentCellDidClickCommentView:self];
        }
    }
}
@end
