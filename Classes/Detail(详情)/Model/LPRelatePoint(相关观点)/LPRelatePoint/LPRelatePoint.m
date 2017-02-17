//
//  LPRelatePoint.m
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPRelatePoint.h"
#import "LPFontSizeManager.h"
#import "LPFontSize.h"
@implementation LPRelatePoint

- (NSMutableAttributedString *)titleString {
    return [_title attributedStringWithFont:[UIFont systemFontOfSize:[[LPFontSizeManager sharedManager].lpFontSize currentDetailRelatePointFontSize]] color:[UIColor colorFromHexString:LPColor3] lineSpacing:0];
}

- (NSMutableAttributedString *)sourceString {
   return [_pname attributedStringWithFont:[UIFont systemFontOfSize:LPFont7] color:[UIColor colorFromHexString:LPColor4] lineSpacing:0];
}

- (NSMutableAttributedString *)titleHtmlString {
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithData:[self.title  dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                                     documentAttributes:nil error:nil];
    return mutableAttributeString;
}

- (NSString *)title {
    
   _title =  [_title stringByReplacingOccurrencesOfString:@"#0091fa" withString:LPColor3];
    CGFloat fontSize = [LPFontSizeManager sharedManager].lpFontSize.currentDetailRelatePointFontSize ;
    return [NSString stringWithFormat:@"<style> body{ font-size:%fpx; text-align:justify;  }</style> %@ ",
            [UIFont systemFontOfSize:fontSize].pointSize, _title];
}

- (NSMutableAttributedString *)singleHtmlString {
    CGFloat fontSize = [LPFontSizeManager sharedManager].lpFontSize.currentDetailRelatePointFontSize ;
    
    NSString *str = @"单行";
    NSString *singlestr = [NSString stringWithFormat:@"<style> body{ font-size:%fpx; text-align:justify;  }</style> %@ ",
                           [UIFont systemFontOfSize:fontSize].pointSize, str];
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithData:[singlestr  dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                                     documentAttributes:nil error:nil];
    return mutableAttributeString;
    
    
}
@end
