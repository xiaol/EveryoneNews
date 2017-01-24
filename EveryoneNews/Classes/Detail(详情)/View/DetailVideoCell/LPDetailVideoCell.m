//
//  LPDetailVideoCell.m
//  EveryoneNews
//
//  Created by dongdan on 2017/1/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LPDetailVideoCell.h"
#import "LPDetailVideoFrame.h"
#import "UIImageView+WebCache.h"
#import "LPFontSizeManager.h"
#import "LPUITextView.h"
#import "LPVideoModel.h"

@interface LPDetailVideoCell()

@property (nonatomic, strong) LPUITextView *titleLabel;
@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) LPVideoModel *videoModel;

@end

@implementation LPDetailVideoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID= @"detailVideoCell";
    LPDetailVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LPDetailVideoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        titelLabel.textColor = [UIColor colorFromHexString:LPColor1];
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
        UIImageView *thumbnailImageView = [[UIImageView alloc] init];
        thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
        thumbnailImageView.clipsToBounds = YES;
        [self.contentView addSubview:thumbnailImageView];
        self.thumbnailImageView = thumbnailImageView;
        
        // 分割线
        UIView *seperatorView = [[UIView alloc] init];
        seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
        [self.contentView addSubview:seperatorView];
        self.seperatorView = seperatorView;
        
        UIImageView *playImageView = [[UIImageView alloc] init];
        playImageView.image = [UIImage imageNamed:@"video_play2"];
        [thumbnailImageView addSubview:playImageView];
        self.playImageView = playImageView ;
        
        UILabel *durationLabel = [[UILabel alloc] init];
        durationLabel.font = [UIFont systemFontOfSize:10];
        durationLabel.textColor = [UIColor whiteColor];
        [thumbnailImageView addSubview:durationLabel];
        self.durationLabel = durationLabel;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellView)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)setDetailVideoFrame:(LPDetailVideoFrame *)detailVideoFrame {
    _detailVideoFrame = detailVideoFrame;
    
    LPVideoModel *videoModel = detailVideoFrame.videoModel;
    self.videoModel = videoModel;
    
    self.titleLabel.frame = detailVideoFrame.titleF;
    self.titleLabel.attributedText = videoModel.titleHtmlString;
    
    self.sourceLabel.frame = detailVideoFrame.sourceSiteF;
    self.sourceLabel.text = videoModel.sourceName;
    
    self.playImageView.frame = detailVideoFrame.playImageViewF;

    self.durationLabel.frame = detailVideoFrame.durationF;
    
    NSInteger totalSeconds =  videoModel.duration;
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60);
 

    self.durationLabel.text =  [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    self.durationLabel.textColor = [UIColor whiteColor];
    
    self.thumbnailImageView.frame = detailVideoFrame.thumbnailImageViewF;
    
    UIImage *coverPlaceHolder = [UIImage sharePlaceholderImage:[UIColor colorFromHexString:@"#000000" alpha:0.2f] sizes:CGSizeMake(100, 100)];
    [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.thumbnail] placeholderImage:coverPlaceHolder];
    
    self.seperatorView.frame = detailVideoFrame.seperatorViewF;
    self.durationLabel.centerY = self.playImageView.centerY;
}

- (void)tapCellView{
    if ([self.delegate respondsToSelector:@selector(videoCell:didClickCellWithVideoModel:)]) {
        [self.delegate videoCell:self didClickCellWithVideoModel:self.videoModel];
    }
}

@end
