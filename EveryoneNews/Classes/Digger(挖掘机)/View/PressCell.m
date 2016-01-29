//
//  PressCell.m
//  EveryoneNews
//
//  Created by apple on 15/10/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PressCell.h"
#import "Press.h"
#import "PressPhoto.h"
#import "Press+HTTPStatus.h"
#import "Press+HTTP.h"

static const CGFloat paddingVer = 12.0f;
static const CGFloat paddingHor = 8.0f;
const CGFloat pressThumbnailW = 66.0f;
const CGFloat pressThumbnailH = 54.0f;
const CGFloat pressCellH = paddingVer + pressThumbnailH;
static NSString * const freshAnimationKey = @"freshRotation";

@interface PressCell () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *freshView;
@property (nonatomic, strong) CABasicAnimation *anim;
@end

@implementation PressCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"digPressCell";
    PressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PressCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = NO;

        
        UIImageView *thumbnailView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"占位图"]];
        thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
        thumbnailView.clipsToBounds = YES;
        [self.contentView addSubview:thumbnailView];
        self.thumbnailView = thumbnailView;
        thumbnailView.layer.cornerRadius = 3.0;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        titleLabel.numberOfLines = 0;
        
        UIImageView *freshView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"digshuaxin"]];
        freshView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:freshView];
        self.freshView = freshView;
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        anim.repeatCount = FLT_MAX;
        anim.duration = 0.6;
        anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(- M_PI, 0, 0, 1)];
        self.anim = anim;
        
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFresh:)];
        [self addGestureRecognizer:gr];
        gr.delegate = self;
    }
    return self;
}

- (void)setPress:(Press *)press {
    _press = press;
    NSLog(@"%@", press.http);
    if (press.thumbnail) {
        self.thumbnailView.image = [UIImage imageWithData:press.thumbnail];
    } else {
        self.thumbnailView.image = [UIImage imageNamed:@"dig占位图"];
    }
    
    self.thumbnailView.x = paddingHor;
    self.thumbnailView.y = paddingVer;
    self.thumbnailView.width = pressThumbnailW;
    self.thumbnailView.height = pressThumbnailH;
    
    self.freshView.width = 18;
    self.freshView.height = 18;
    self.freshView.y = paddingVer + (pressThumbnailH - self.freshView.height) / 2;
    self.freshView.x = ScreenWidth - paddingHor - self.freshView.width;
    
    if (press.isDownload.boolValue) {
        [self.freshView setImage:[UIImage imageNamed:@"dig完成"]];
//        self.freshView.hidden = YES;
        self.userInteractionEnabled = YES;
    } else {
        self.freshView.hidden = NO;
        if (press.isDownloading.boolValue) {
            self.userInteractionEnabled = NO;
            [self.freshView.layer addAnimation:self.anim forKey:freshAnimationKey];
        } else {
             self.userInteractionEnabled = YES;
            [self.freshView.layer removeAnimationForKey:freshAnimationKey];

//            if (press.httpStatus && [press.httpStatus isEqualToString:@"99"]) {
//                self.userInteractionEnabled = NO;
//                [self.freshView setImage:[UIImage imageNamed:@"dig未完成"]];
//            } else {
//                self.userInteractionEnabled = YES;
//            }
      
        }
    }
    
    self.titleLabel.text = press.title;
    CGFloat titleW = CGRectGetMinX(self.freshView.frame) - CGRectGetMaxX(self.thumbnailView.frame) - paddingHor * 2;
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.thumbnailView.frame) + paddingHor, paddingVer, titleW, pressThumbnailH);
    
//    因为frc会根据模型变动刷新cell 故无需使用KVO监听属性变化
//    [self.press addObserver:self forKeyPath:@"isDownloading" options:0 context:nil];
//    [self.press addObserver:self forKeyPath:@"photo.data" options:0 context:nil];
//    [self.press addObserver:self forKeyPath:@"isDownload" options:0 context:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    // 1. 下载完成与否
//    self.freshView.hidden = self.press.isDownload;
//    
//    // 2. 正在下载则添加动画
//    if (self.press.isDownloading) {
//        [self.freshView.layer addAnimation:self.anim forKey:freshAnimationKey];
//    } else {
//        [self.freshView.layer removeAnimationForKey:freshAnimationKey];
//    }
//    
//    // 3. 处理缩略图
//    
//}
//
//- (void)dealloc {
//    [self.press removeObserver:self forKeyPath:@"isDownloading"];
//    [self.press removeObserver:self forKeyPath:@"photo.data"];
//    [self.press removeObserver:self forKeyPath:@"isDownload"];
//}

- (void)tapFresh:(UITapGestureRecognizer *)gr {
    if ([self.delegate respondsToSelector:@selector(pressCell:didRefreshPress:)]) {
        [self.delegate pressCell:self didRefreshPress:self.press];
    }
//    [self.freshView.layer addAnimation:self.anim forKey:freshAnimationKey];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint loc = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(CGRectMake(ScreenWidth - 34, paddingVer, 34, pressThumbnailH), loc) && ![self.freshView.layer animationForKey:freshAnimationKey]) { // 在相应区域内 且 无动画时 才能点击
        return YES;
    }
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}
@end
