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
#import "Content+PhotoDownloadCompletion.h"

static const CGFloat paddingY = 18.0f;
static const CGFloat paddingX = 13.0f;

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
//        photoView.layer.cornerRadius = 4.0;
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        
        // 必须设置
//        photoView.userInteractionEnabled = YES;
//        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturePressed:)];
//        [photoView addGestureRecognizer:tapGesture];
        
        [self.contentView addSubview:photoView];
        self.photoView = photoView;
    }
    return self;
}

//- (void)tapGesturePressed:(UITapGestureRecognizer *)recognizer {
//    if([self.delegate respondsToSelector:@selector(contentCell:didSavePhotoWithImageURL:)]) {
//        [self.delegate contentCell:self didSavePhotoWithImageURL:self.imageURL];
//    }
//}


- (void)setContent:(Content *)content {
    _content = content;
    if (content.isPhotoType.boolValue) {
        self.photoView.hidden = NO;
        self.textView.hidden = YES;
        
        CGFloat photoX = paddingX;
        CGFloat photoY = paddingY;
        CGFloat photoW = ScreenWidth - paddingX * 2;
        CGFloat photoH = photoW * (_content.image.size.height / _content.image.size.width);
        self.photoView.frame = CGRectMake(photoX, photoY, photoW, photoH);
        
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:content.photoURL] placeholderImage:[UIImage imageNamed:@"dig详情页占位大图"]];

    } else {
        self.photoView.hidden = YES;
        self.textView.hidden = NO;
        
        CGFloat textW = ScreenWidth - paddingX * 2;
        CGFloat textH = [[content attributedBodyText] heightWithConstraintWidth:textW] + 2.0;
        CGFloat textX = paddingX;
        CGFloat textY = paddingY;
        self.textView.frame = CGRectMake(textX, textY, textW, textH);
        
        self.textView.attributedText = [content attributedBodyText];
    }
}

//- (void)setContentFrame:(ContentFrame *)contentFrame {
//    _contentFrame = contentFrame;
//    
//    Content *content = contentFrame.content;
//    
//    if (content.isPhotoType.boolValue) {
//        self.photoView.hidden = NO;
//        self.textView.hidden = YES;
//        
//        self.photoView.frame = contentFrame.photoF;
//        [self.photoView sd_setImageWithURL:[NSURL URLWithString:content.photoURL] placeholderImage:[UIImage imageNamed:@"dig详情页占位大图"]];
//        
////        __weak typeof(self) wself = self;
////        
////        [self.photoView sd_setImageWithURL:[NSURL URLWithString:content.photoURL]
////                          placeholderImage:[UIImage imageNamed:@"dig详情页占位大图"]
////                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////            if (!_contentFrame.isUpdated && image && imageURL) {
////                // 图片实际高度和宽度比例
////                CGFloat scaleRate = image.size.height /  image.size.width ;
////                CGFloat photoH = _contentFrame.photoF.size.width * scaleRate;
////                CGRect rect = CGRectMake(_contentFrame.photoF.origin.x, _contentFrame.photoF.origin.y, _contentFrame.photoF.size.width, photoH);
////                _contentFrame.photoF = rect;
////                wself.photoView.frame = rect;
////                _contentFrame.cellHeight  = photoH + 18.0;
////                _contentFrame.updated = YES;
////                
////                if([wself.delegate respondsToSelector:@selector(contentCell:didDownloadPhoto:)])
////                {
////                    [wself.delegate contentCell:wself didDownloadPhoto:image];
////                    
////            
////                }
////            }
////        }];
//
//    } else {
//        self.photoView.hidden = YES;
//        self.textView.hidden = NO;
//
//        self.textView.frame = contentFrame.textF;
//        self.textView.attributedText = [content attributedBodyText];
//    }
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}
@end
