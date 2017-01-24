//
//  LPContentCell.m
//  EveryoneNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPContentCell.h"
#import "LPContentFrame.h"
#import "LPContent.h"
#import "UIImageView+WebCache.h"
#import <DTCoreText/DTCoreText.h>
#import <DTRichTextEditor/DTRichTextEditorView.h>
#import <DTRichTextEditor/DTTextRange.h>

@interface LPContentCell()<UIWebViewDelegate>

@property (nonatomic, strong) DTRichTextEditorView *bodyTextView;



@property (nonatomic, strong) UILabel *photoLabel;

@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, strong) UIImageView *videoImageView;
// 视频播放
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, assign) BOOL videoIsFinishLoaded;

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
        DTRichTextEditorView *bodyTextView = [[DTRichTextEditorView alloc] init];

        bodyTextView.showsVerticalScrollIndicator = NO;
        bodyTextView.showsHorizontalScrollIndicator = NO;
        bodyTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        bodyTextView.scrollEnabled = NO;
        bodyTextView.bounces = NO;
        bodyTextView.editable = NO;
        
    
        bodyTextView.userInteractionEnabled = YES;
        bodyTextView.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
        bodyTextView.textDelegate = self;
        bodyTextView.editorViewDelegate = self;

        [self.contentView addSubview:bodyTextView];
        self.bodyTextView = bodyTextView;
        // 图片
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        [self.contentView addSubview:photoView];
        self.photoView = photoView;
        
        UIWebView *webView = [[UIWebView alloc] init];
        webView.delegate = self;
        webView.scrollView.scrollEnabled = NO;
        [self.contentView  addSubview:webView];
        self.webView = webView;
        
        // 视频
        UIImageView *videoImageView = [[UIImageView alloc] init];
        videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        videoImageView.clipsToBounds = YES;
        [self.contentView  addSubview:videoImageView];
        self.videoImageView = videoImageView;
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
        activity.color = [UIColor grayColor];
        [videoImageView addSubview:activity];
        self.activity = activity;
        
        
        
    }
    return self;
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
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:content.photo] placeholderImage:[UIImage oddityImage:@"单图大图占位图"]];
        
        // 文字
    } else if(content.contentType == 2) {
        self.bodyTextView.hidden = NO;
        self.photoView.hidden = YES;
        self.webView.hidden = YES;
        self.videoImageView.hidden = YES;
        self.bodyTextView.frame = self.contentFrame.bodyLabelF;
        [self.bodyTextView setAttributedString:self.contentFrame.bodyHtmlString];
        
       // self.bodyTextView.attributedText = self.contentFrame.bodyHtmlString;
     
    } else if (content.contentType == 3) {
        self.bodyTextView.hidden = YES;
        self.photoView.hidden = YES;
        self.webView.hidden = NO;
        self.videoImageView.hidden = self.videoIsFinishLoaded;
        self.videoImageView.image = [UIImage oddityImage:@"单图大图占位图"];
        self.webView.frame = self.contentFrame.webViewF;
        self.videoImageView.frame = self.contentFrame.videoImageViewF;

        // 处理视频宽高
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:content.video];
        NSString *videoURLScheme = [urlComponents scheme];
        NSString *videoURLHost = [urlComponents host];
        NSString *videoURLPath = [urlComponents path];
        NSString *videoURLQuery = [urlComponents query];
        
        NSString *mutableString = @"";
        NSString *urlStr = @"";
        if ([content.video containsString:@"?"]) {
            mutableString = [NSString stringWithFormat:@"%@://%@%@?",videoURLScheme, videoURLHost, videoURLPath];
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
                mutableString = [NSString stringWithFormat:@"%@%@=%@&",mutableString, key, value];
            }
            if([[mutableString substringFromIndex:(mutableString.length - 1)] isEqualToString:@"&"]) {
                urlStr = [mutableString substringToIndex:(mutableString.length - 1)];
            } else {
                urlStr = mutableString;
            }
        } else {
            // mp4格式 (秒拍)
             mutableString = [NSMutableString stringWithFormat:@"%@://%@%@",videoURLScheme, videoURLHost, videoURLPath];
             urlStr = mutableString;
        }
        if (!self.videoIsFinishLoaded) {
            NSString *urlEncode = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *url =[NSURL URLWithString:urlEncode];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
            self.activity.frame = CGRectMake(0, 0, 30, 30);
            self.activity.center = self.videoImageView.center;
            [self.activity startAnimating];
        }
 
     }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activity stopAnimating];
    self.videoImageView.hidden = YES;
    self.videoIsFinishLoaded = YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
        [self.activity stopAnimating];
        self.videoImageView.hidden = YES;
        self.videoIsFinishLoaded = YES;
}



@end
