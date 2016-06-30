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
#import "LPPressTool.h"
#import "LPUITextView.h"
#import <WebKit/WebKit.h>

@interface LPContentCell()<UITextViewDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UITextView *bodyTextView;

@property (nonatomic, strong) LPCommentView *commentView;

@property (nonatomic, strong) UILabel *photoLabel;

@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, strong) UIImageView *videoImageView;
// 视频播放
@property (nonatomic, strong) WKWebView *webView;

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
        
        // 文字
        LPUITextView *bodyTextView = [[LPUITextView alloc] init];
        bodyTextView.delegate = self;
        [self.contentView addSubview:bodyTextView];
        self.bodyTextView = bodyTextView;
        
        // 图片
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        [self.contentView addSubview:photoView];
        self.photoView = photoView;
        
        WKWebView *webView = [[WKWebView alloc] init];
        webView.navigationDelegate = self;
        webView.scrollView.scrollEnabled = NO;
        [self.contentView  addSubview:webView];
        self.webView = webView;
        
        // 视频
        UIImageView *videoImageView = [[UIImageView alloc] init];
        videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        videoImageView.clipsToBounds = YES;
        [self.contentView  addSubview:videoImageView];
        self.videoImageView = videoImageView;
//
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVideoImageView)];
//        [videoImageView addGestureRecognizer:tapGesture];
//        
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([self.delegate respondsToSelector:@selector(contentCell:didOpenURL:)]) {
        [self.delegate contentCell:self didOpenURL:[URL absoluteString]];
    }
    return NO;
}

- (void)setContentFrame:(LPContentFrame *)contentFrame
{
    _contentFrame = contentFrame;
    LPContent *content = contentFrame.content;
    
    if (content.contentType == 1) { // 图像
        self.bodyTextView.hidden = YES;
        self.photoView.hidden = NO;
        self.webView.hidden = YES;
        self.photoView.frame = self.contentFrame.photoViewF;
        self.videoImageView.hidden = YES;
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:content.photo] placeholderImage:[UIImage imageNamed:@"单图大图占位图"]];
        
        // 文字
    } else if(content.contentType == 2) {
        self.bodyTextView.hidden = NO;
        self.photoView.hidden = YES;
        self.webView.hidden = YES;
        self.videoImageView.hidden = YES;
        self.bodyTextView.frame = self.contentFrame.bodyLabelF;
        self.bodyTextView.attributedText = content.bodyHtmlString;
     
    } else if (content.contentType == 3) {
        self.bodyTextView.hidden = YES;
        self.photoView.hidden = YES;
        self.webView.hidden = NO;
        self.videoImageView.hidden = NO;
        self.videoImageView.image = [UIImage imageNamed:@"详情页视频占位图"];
        self.webView.frame = self.contentFrame.webViewF;
        self.videoImageView.frame = self.contentFrame.videoImageViewF;
        
        // 处理视频宽高
        NSArray *array = [content.video componentsSeparatedByString:@";"];
        NSMutableString *mutableString = [[NSMutableString alloc] init];
        for (NSString *str in array) {
            NSString *tempStr = [str copy];
            if ([tempStr containsString:@"width"]) {
                tempStr = [NSString stringWithFormat:@"width=%f&amp", self.contentFrame.webViewF.size.width];
            } else if ([tempStr containsString:@"height"]) {
                tempStr = [NSString stringWithFormat:@"height=%f&amp", self.contentFrame.webViewF.size.height];
            }
            if (tempStr.length > 0) {
                [mutableString appendString:[NSString stringWithFormat:@"%@;",tempStr]];
            }
        }
        
        NSURL *url =[NSURL URLWithString:mutableString];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
     }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.videoImageView.hidden = YES;
}



//#pragma mark - 点击videoImageView
//- (void)tapVideoImageView {
//    if ([self.delegate respondsToSelector:@selector(contentCell:videoImageViewDidTapped:webView:webViewF:)]) {
//        [self.videoImageView removeFromSuperview];
//        [self.delegate contentCell:self videoImageViewDidTapped:self.videoURL webView:self.webView webViewF:self.webView.frame];
//    }
//}
@end
