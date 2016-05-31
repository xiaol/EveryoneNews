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

@interface LPContentCell()<UITextViewDelegate>
//@property (nonatomic, strong) UILabel *bodyLabel;

@property (nonatomic, strong) UITextView *bodyTextView;

@property (nonatomic, strong) LPCommentView *commentView;

@property (nonatomic, strong) UILabel *photoLabel;

@property (nonatomic, strong) LPSupplementView *supplementView;

@property (nonatomic, strong) UIView *abstractSeperatorView;

@property (nonatomic, strong) NSTextContainer *textContainer;

@property (nonatomic, strong) NSLayoutManager *layoutManager;

@property (nonatomic, strong) UIWebView *webView;

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
//        self.layer.shouldRasterize = YES;
//        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
//        UILabel *bodyLabel = [[UILabel alloc] init];
//        bodyLabel.userInteractionEnabled = YES;
//        bodyLabel.numberOfLines = 0;
//        [self.contentView addSubview:bodyLabel];
//        self.bodyLabel = bodyLabel;
//
        
        LPUITextView *bodyTextView = [[LPUITextView alloc] init];
        bodyTextView.delegate = self;

        [self.contentView addSubview:bodyTextView];
        self.bodyTextView = bodyTextView;
        
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        
        [self.contentView addSubview:photoView];
        self.photoView = photoView;
        
        UIWebView *webView = [[UIWebView alloc] init];
        webView.scrollView.scrollEnabled = NO;
        webView.scrollView.bounces = NO;
        [self addSubview:webView];
        self.webView = webView;
                
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
//    if (!content.isPhoto) { // 非图
//        self.bodyTextView.hidden = NO;
//        self.photoView.hidden = YES;
//        
//        self.bodyTextView.frame = self.contentFrame.bodyLabelF;
//        self.bodyTextView.attributedText = content.bodyHtmlString;
//
//    } else {
//
//        self.bodyTextView.hidden = YES;
//        self.photoView.hidden = NO;
//        self.photoView.frame = self.contentFrame.photoViewF;
//        self.photoView.image = content.image;
//    }
    
    
    if (content.contentType == 1) { // 图像
        self.bodyTextView.hidden = YES;
        self.photoView.hidden = NO;
        self.webView.hidden = YES;
        
        self.photoView.frame = self.contentFrame.photoViewF;
        self.photoView.image = content.image;
        
     
        // 文字
    } else if(content.contentType == 2) {
        self.bodyTextView.hidden = NO;
        self.photoView.hidden = YES;
        self.webView.hidden = YES;
        
        self.bodyTextView.frame = self.contentFrame.bodyLabelF;
        self.bodyTextView.attributedText = content.bodyHtmlString;
     
    } else if (content.contentType == 3) {
        self.bodyTextView.hidden = YES;
        self.photoView.hidden = YES;
        self.webView.hidden = NO;
        
        self.webView.frame = self.contentFrame.webViewF;
        [self.webView loadHTMLString:content.video baseURL:nil];
  
    }
    
}

//- (void)setContent:(LP *)content {
//    _content = content;
//    if (!content.isPhoto) { // 非图
//        self.bodyLabel.hidden = NO;
//        self.photoView.hidden = YES;
//        self.bodyLabel.frame = self.contentFrame.bodyLabelF;
//        self.bodyLabel.attributedText = _content.bodyHtmlString;
//    
//    } else {
//        self.bodyLabel.hidden = YES;
//        self.photoView.hidden = NO;
//
//        CGFloat photoX = 0;
//        CGFloat photoY = BodyPadding * 2;
//        CGFloat photoW = ScreenWidth - 2 * BodyPadding;
//        CGFloat photoH =  photoW * (_content.image.size.height / _content.image.size.width);
//        self.photoView.frame = CGRectMake(photoX, photoY, photoW, photoH);
//        
//        [self.photoView sd_setImageWithURL:[NSURL URLWithString:content.photo] placeholderImage:[UIImage imageNamed:@"单图大图占位图"]];
//    }
//}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}
@end
