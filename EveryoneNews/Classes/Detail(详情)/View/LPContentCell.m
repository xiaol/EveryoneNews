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
#import "LPUITextView.h"
#import <WebKit/WebKit.h>
#import <DTCoreText/DTCoreText.h>
#import <DTRichTextEditor/DTRichTextEditorView.h>
#import <DTRichTextEditor/DTTextRange.h>

@interface LPContentCell()<DTAttributedTextContentViewDelegate, WKNavigationDelegate, DTRichTextEditorViewDelegate>

@property (nonatomic, strong) DTRichTextEditorView *bodyTextView;



@property (nonatomic, strong) UILabel *photoLabel;

@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, strong) UIImageView *videoImageView;
// 视频播放
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, assign) BOOL videoIsFinishLoaded;

@end

@implementation LPContentCell

@synthesize menuItems = _menuItems;

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
        bodyTextView.backgroundColor = [UIColor redColor];
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
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
        activity.color = [UIColor grayColor];
        [videoImageView addSubview:activity];
        self.activity = activity;
        
        
        
    }
    return self;
}


- (NSArray *)menuItems {
    if (_menuItems == nil) {
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyItem)];
        UIMenuItem *searchItem = [[UIMenuItem alloc] initWithTitle:@"搜索" action:@selector(searchItem)];
        _menuItems = @[copyItem, searchItem];
    }
    return _menuItems;
}

- (BOOL)editorView:(DTRichTextEditorView *)editorView canPerformAction:(SEL)action withSender:(id)sender {
    DTTextRange *selectedTextRange = (DTTextRange *)editorView.selectedTextRange;
    NSString *selectedText = [self.bodyTextView textInRange:selectedTextRange];
    if (selectedText.length > 0) {
        if (action == @selector(copyItem) || action == @selector(searchItem)) {
            return YES;
        }
    }
    return NO;

}


#pragma mark - DTAttributedTextContentViewDelegate

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView
                          viewForLink:(NSURL *)url
                           identifier:(NSString *)identifier
                                frame:(CGRect)frame
{
    DTLinkButton *linkButton = [[DTLinkButton alloc] initWithFrame:frame];
    linkButton.URL = url;
    [linkButton addTarget:self
                   action:@selector(linkButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    
    return linkButton;
}

- (void)copyItem {
        UITextRange *selectedRange = [self.bodyTextView selectedTextRange];
        NSString *selectedText = [self.bodyTextView textInRange:selectedRange];
        if (selectedText.length > 0) {
            if ([self.delegate respondsToSelector:@selector(contentCell:copyText:)]) {
                [self.delegate contentCell:self copyText:selectedText];
            }
        }
}

- (void)searchItem {
    UITextRange *selectedRange = [self.bodyTextView selectedTextRange];
    NSString *selectedText = [self.bodyTextView textInRange:selectedRange];
    if (selectedText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(contentCell:searchText:)]) {
            [self.delegate contentCell:self searchText:selectedText];
        }
    }
}

#pragma mark - Events

- (IBAction)linkButtonClicked:(DTLinkButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(contentCell:didOpenURL:)]) {
        [self.delegate contentCell:self didOpenURL:[sender.URL absoluteString]];
    }
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
        [self.bodyTextView setAttributedString:self.contentFrame.bodyHtmlString];
        
       // self.bodyTextView.attributedText = self.contentFrame.bodyHtmlString;
     
    } else if (content.contentType == 3) {
        self.bodyTextView.hidden = YES;
        self.photoView.hidden = YES;
        self.webView.hidden = NO;
        self.videoImageView.hidden = self.videoIsFinishLoaded;
        self.videoImageView.image = [UIImage imageNamed:@"单图大图占位图"];
        self.webView.frame = self.contentFrame.webViewF;
        self.videoImageView.frame = self.contentFrame.videoImageViewF;
     
        
        
        
        // 处理视频宽高
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:content.video];
        NSString *videoURLScheme = [urlComponents scheme];
        NSString *videoURLHost = [urlComponents host];
        NSString *videoURLPath = [urlComponents path];
        NSString *videoURLQuery = [urlComponents query];
        
        NSMutableString *mutableString = [NSMutableString string];
        NSString *urlStr = @"";
        if ([content.video containsString:@"?"]) {
            mutableString = [NSMutableString stringWithFormat:@"%@://%@%@?",videoURLScheme, videoURLHost, videoURLPath];
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

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self.activity stopAnimating];
    self.videoImageView.hidden = YES;
    self.videoIsFinishLoaded = YES;
}

// mp4加载时调用，原因待查找
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self.activity stopAnimating];
    self.videoImageView.hidden = YES;
    self.videoIsFinishLoaded = YES;
    
}

- (BOOL)editorViewShouldBeginEditing:(DTRichTextEditorView *)editorView {
    UITextRange *selectedRange = [editorView selectedTextRange];
    NSString *selectedText = [editorView textInRange:selectedRange];
    if(selectedText.length > 0) {
        return YES;
    }
    return NO;
}


//- (BOOL)canBecomeFirstResponder {
//    return NO;
//}

//- (void)editorViewDidChangeSelection:(DTRichTextEditorView *)editorView {
//        UITextRange *selectedRange = [editorView selectedTextRange];
//        NSString *selectedText = [editorView textInRange:selectedRange];
//    NSLog(@"---%@", selectedText);
//}




//- (void)textViewDidChangeSelection:(UITextView *)textView {
//    UITextRange *selectedRange = [textView selectedTextRange];
//    NSString *selectedText = [textView textInRange:selectedRange];
//    if (selectedText.length > 0) {
//        if ([self.delegate respondsToSelector:@selector(contentCell:selectedText:)]) {
//            [self.delegate contentCell:self selectedText:selectedText];
//        }
//    }
//    
//}

@end
