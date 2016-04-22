//
//  LPContent.m
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPContent.h"
#import "SDWebImageManager.h"
#import "LPFontSizeManager.h"

@implementation LPContent

- (LPComment *)displayingComment
{
    return [self.comments objectAtIndex:0];
}

- (NSMutableAttributedString *)bodyString
{
    CGFloat fontSize = [LPFontSizeManager sharedManager].currentDetailContentFontSize ;
    return [self.body attributedStringWithFont:[UIFont systemFontOfSize:fontSize] color:[UIColor colorFromHexString:@"#060606"] lineSpacing:BodyLineSpacing];
}

- (NSMutableAttributedString *)bodyHtmlString {
     NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithData:[self.body dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                         documentAttributes:nil error:nil];
    return mutableAttributeString;
}

- (NSString *)body {
    CGFloat fontSize = [LPFontSizeManager sharedManager].currentDetailContentFontSize ;
    return [NSString stringWithFormat:@"<style> body{  font-weight:100; line-height:1.49;text-indent:2em;font-size:%fpx; text-align:justify;}</style> %@ ",[UIFont systemFontOfSize:fontSize].pointSize, _body];
}

- (NSMutableAttributedString *)photoDescString {
    return [self.photoDesc attributedStringWithFont:[UIFont systemFontOfSize:BodyFontSize] color:[UIColor blackColor] lineSpacing:BodyLineSpacing];
}

- (NSMutableAttributedString *)opinionString {
    if (_opinion) {
        return [_opinion attributedStringWithFont:[UIFont systemFontOfSize:12] color:[UIColor colorFromHexString:@"#b8b8b8"] lineSpacing:3];
    }
    return nil;
}

- (void)dealloc {
    if (self != nil) {
        if (self.isPhoto && !self.isAbstract) {
            [[SDWebImageManager sharedManager].imageCache removeImageForKey:self.photo fromDisk:NO];
        }
    }
}
@end
