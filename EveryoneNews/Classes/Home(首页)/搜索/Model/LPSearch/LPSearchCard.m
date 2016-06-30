//
//  LPSearchCard.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSearchCard.h"

@implementation LPSearchCard

- (NSMutableAttributedString *)titleHtmlString {
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithData:[self.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                                     documentAttributes:nil error:nil];
    return mutableAttributeString;
}

- (NSString *)title {
    CGFloat titleFontSize = 16;
    if (iPhone6Plus) {
        titleFontSize = 18;
    }
    return [NSString stringWithFormat:@"<style> body{  font-weight:100; line-height:1.49;font-size:%fpx; text-align:left;  }</style> %@ ",
            [UIFont systemFontOfSize:titleFontSize].pointSize, [[_title stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>" withString:@""]];
}

@end
