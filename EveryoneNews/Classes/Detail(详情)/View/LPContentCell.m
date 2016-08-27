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

@property (nonatomic, strong) LPUITextView *bodyTextView;

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
        bodyTextView.userInteractionEnabled = YES;
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
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:content.video];
        NSString *videoURLScheme = [urlComponents scheme];
        NSString *videoURLHost = [urlComponents host];
        NSString *videoURLPath = [urlComponents path];
        NSString *videoURLQuery = [urlComponents query];
        
        NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@://%@%@?",videoURLScheme, videoURLHost, videoURLPath];
        NSArray *parametersArray = [videoURLQuery componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in parametersArray) {
            
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
            NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
            
            if ([key isEqualToString:@"width"]) {
                value = [NSString stringWithFormat:@"%.1f",self.contentFrame.webViewF.size.width];
            } else if ([key isEqualToString:@"height"]) {
                value = [NSString stringWithFormat:@"%.1f",self.contentFrame.webViewF.size.height];
            }
            
            [mutableString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
        }
        NSString *urlStr = @"";
        if([[mutableString substringFromIndex:(mutableString.length - 1)] isEqualToString:@"&"]) {
            urlStr = [mutableString substringToIndex:(mutableString.length - 1)];
        } else {
            urlStr = mutableString;
        }
        
        NSURL *url =[NSURL URLWithString:urlStr];
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

- (BOOL)canBecomeFirstResponder {
    return NO;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    UITextRange *selectedRange = [textView selectedTextRange];
    NSString *selectedText = [textView textInRange:selectedRange];
    if (selectedText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(contentCell:selectedText:)]) {
            [self.delegate contentCell:self selectedText:selectedText];
        }
    }
    
}

@end
