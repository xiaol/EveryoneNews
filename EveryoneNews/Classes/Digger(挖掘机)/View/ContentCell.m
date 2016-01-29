//
//  ContentCell.m
//  EveryoneNews
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ContentCell.h"
#import "ContentPhoto.h"
#import "Content.h"
#import "Thumbnailer.h"
#import "UIImageView+WebCache.h"
#import "ContentFrame.h"
#import "Content+AttributedText.h"

@interface ContentCell ()
@property (nonatomic, strong) UILabel *textView;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) NSURL *imageURL;
@end

@implementation ContentCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"digContentCell";
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

//+ (instancetype)cellWithTableView:(UITableView *)tableView photoCompleted:(PhotoCompletedHandler)handler {
//    static NSString *ID = @"digContentCell";
//    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
//    cell.photoHandler = handler;
//    return cell;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        UILabel *textView = [[UILabel alloc] init];
        textView.numberOfLines = 0;
        [self.contentView addSubview:textView];
        self.textView = textView;
        
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.clipsToBounds = YES;
        photoView.layer.cornerRadius = 4.0;
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        
        // 必须设置
        photoView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturePressed:)];
        [photoView addGestureRecognizer:tapGesture];
        
        [self.contentView addSubview:photoView];
        self.photoView = photoView;
    }
    return self;
}

- (void)tapGesturePressed:(UITapGestureRecognizer *)recognizer {
    if([self.delegate respondsToSelector:@selector(contentCell:didSavePhotoWithImageURL:)]) {
        [self.delegate contentCell:self didSavePhotoWithImageURL:self.imageURL];
    }
}



- (void)setContentFrame:(ContentFrame *)contentFrame {
    _contentFrame = contentFrame;
    
    Content *content = contentFrame.content;
    
    if (content.isPhotoType.boolValue) {
        self.photoView.hidden = NO;
        self.textView.hidden = YES;
        self.imageURL = [NSURL URLWithString:content.photoURL];
        self.photoView.frame = contentFrame.photoF;
        [self.photoView sd_setImageWithURL:self.imageURL placeholderImage:[UIImage imageNamed:@"dig详情页占位大图"]];
//        [self.photoView sd_setImageWithURL:self.imageURL placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            _contentFrame.cellHeight = image.size.height;
//            if([self.delegate respondsToSelector:@selector(contentCell:didDownloadPhoto:)])
//            {
//                [self.delegate contentCell:self didDownloadPhoto:image];
//            }
//           
//        }];

    } else {
        self.photoView.hidden = YES;
        self.textView.hidden = NO;

        self.textView.frame = contentFrame.textF;
        self.textView.attributedText = [content attributedBodyText];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}
@end
