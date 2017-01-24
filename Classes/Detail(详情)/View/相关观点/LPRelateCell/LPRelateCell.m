//
//  LPRelateCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/3/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPRelateCell.h"
#import "LPRelateFrame.h"
#import "LPRelatePoint.h"
#import "UIImageView+WebCache.h"
#import "LPFontSizeManager.h"
#import "LPUITextView.h"

@interface LPRelateCell ()


@property (nonatomic, strong) UIImageView *pointImageView;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) LPUITextView *titleLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) NSString *relatePointURL;

@end

@implementation LPRelateCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"relatePointID";
    LPRelateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LPRelateCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorFromHexString:LPColor9];
        
        // 标题
        LPUITextView *titelLabel = [[LPUITextView alloc] init];
        titelLabel.textColor = [UIColor colorFromHexString:LPColor3];
        [self.contentView addSubview:titelLabel];
        self.titleLabel = titelLabel;
        
        // 来源
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.numberOfLines = 0;
        sourceLabel.font = [UIFont systemFontOfSize:LPFont7];
        sourceLabel.textColor = [UIColor colorFromHexString:LPColor4];
        [self.contentView addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        // 图片
        UIImageView *pointImageView = [[UIImageView alloc] init];
        pointImageView.contentMode = UIViewContentModeScaleAspectFill;
        pointImageView.clipsToBounds = YES;
        [self.contentView addSubview:pointImageView];
        self.pointImageView = pointImageView;
        
        // 分割线
        UIView *seperatorView = [[UIView alloc] init];
        seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
        [self.contentView addSubview:seperatorView];
        self.seperatorView = seperatorView;
       
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellView)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)setRelateFrame:(LPRelateFrame *)relateFrame {
    _relateFrame = relateFrame;

    LPRelatePoint *point = _relateFrame.relatePoint;
    self.relatePointURL = point.url;
    
    self.titleLabel.frame = _relateFrame.titleF;
    self.titleLabel.attributedText = _relateFrame.titleHtmlString;
    
    self.sourceLabel.frame = _relateFrame.sourceSiteF;
    self.sourceLabel.text = point.pname;
    
    self.seperatorView.frame = _relateFrame.seperatorViewF;
 
   if (point.img.length > 0 && [point.img rangeOfString:@","].location == NSNotFound) {
       
        [self.pointImageView sd_setImageWithURL:[NSURL URLWithString:point.img] placeholderImage:[UIImage sharePlaceholderImage:[UIColor colorFromHexString:@"#000000" alpha:0.2f] sizes:CGSizeMake(100, 100)]];
        self.pointImageView.hidden = NO;
        self.pointImageView.frame = _relateFrame.imageViewF;
   } else {
        self.pointImageView.hidden = YES;
   }
}

- (void)tapCellView{
    if ([self.delegate respondsToSelector:@selector(relateCell:didClickURL:)]) {
        [self.delegate relateCell:self didClickURL:self.relatePointURL];
    }
}

@end
