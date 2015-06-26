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

@interface LPContentCell()
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) LPCommentView *commentView;
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
        UILabel *bodyLabel = [[UILabel alloc] init];
        bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        bodyLabel.numberOfLines = 0;
        [self.contentView addSubview:bodyLabel];
        self.bodyLabel = bodyLabel;
        
        LPCommentView *commentView = [[LPCommentView alloc] init];
//        commentView.backgroundColor = [UIColor colorFromHexString:@"FDFEFE"];
        [self.contentView addSubview:commentView];
        self.commentView = commentView;
        [commentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapComment)]];
    }
    return self;
}

- (void)setContentFrame:(LPContentFrame *)contentFrame
{
    _contentFrame = contentFrame;
    LPContent *content = contentFrame.content;
    if ([content.category isEqualToString:@"财经"]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        self.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:250/255.0 alpha:0.9];
    }
    
    self.bodyLabel.frame = self.contentFrame.bodyLabelF;
    self.bodyLabel.attributedText = content.bodyString;
    
    if (content.hasComment) {
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
    if ([self.delegate respondsToSelector:@selector(contentCellDidClickCommentView:)]) {
        [self.delegate contentCellDidClickCommentView:self];
    }
}
@end
