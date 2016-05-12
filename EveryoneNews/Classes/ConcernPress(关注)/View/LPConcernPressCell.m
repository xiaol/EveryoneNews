//
//  LPConcernPressCell.m
//  EveryoneNews
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPConcernPressCell.h"
#import "LPConcernPressFrame.h"
#import "LPConcernPress.h"
#import "UIImageView+WebCache.h"

@interface LPConcernPressCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIImageView *iconView;
@end

@implementation LPConcernPressCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"concernPress";
    LPConcernPressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LPConcernPressCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.layer.cornerRadius = 2.0;
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.clipsToBounds = YES;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:ConcernPressTitleFontSize];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.numberOfLines = 0;
        tagLabel.font = [UIFont systemFontOfSize:ConcernPressTagFontSize];
        tagLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:tagLabel];
        self.tagLabel = tagLabel;
    }
    return self;
}

- (void)setConcernPressFrame:(LPConcernPressFrame *)concernPressFrame {
    _concernPressFrame = concernPressFrame;
    LPConcernPress *concernPress = self.concernPressFrame.concernPress;
    
    self.iconView.frame = self.concernPressFrame.imageViewF;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:concernPress.imgUrl] placeholderImage:[UIImage imageNamed:@"占位图"]];
    
    self.titleLabel.frame = self.concernPressFrame.titleLabelF;
    self.titleLabel.text = concernPress.title;
    
    if (concernPress.tags.length) {
        self.tagLabel.hidden = NO;
        self.tagLabel.frame = self.concernPressFrame.tagLabelF;
        self.tagLabel.text = concernPress.tags;
    } else {
        self.tagLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}
@end
