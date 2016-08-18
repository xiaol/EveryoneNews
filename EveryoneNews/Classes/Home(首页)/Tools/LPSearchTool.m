//
//  LPSearchTool.m
//  EveryoneNews
//
//  Created by dongdan on 16/8/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSearchTool.h"

@implementation LPSearchTool

/**
 *  拆分汉字
 *
 *  @param word 初始汉字
 *
 *  @return 拆分后数组
 */
+ (NSArray *)stringTokenizerWithWord:(NSString *)word {
    NSMutableArray *keyWords =[NSMutableArray new];
    CFStringTokenizerRef ref = CFStringTokenizerCreate(NULL,  (__bridge CFStringRef)word, CFRangeMake(0, word.length),kCFStringTokenizerUnitWord,NULL);
    CFRange range;
    CFStringTokenizerAdvanceToNextToken(ref);
    range = CFStringTokenizerGetCurrentTokenRange(ref);
    NSString *keyWord;
    while (range.length > 0)
    {
        keyWord = [word substringWithRange:NSMakeRange(range.location, range.length)];
        [keyWords addObject:keyWord];
        CFStringTokenizerAdvanceToNextToken(ref);
        range = CFStringTokenizerGetCurrentTokenRange(ref);
    }
    CFRelease(ref);
    return keyWords;
}

/**
 *  给关键字设置颜色
 *
 *  @param content  原文
 *  @param keyWords 关键字数组
 *  @param color    颜色
 *
 *  @return 属性字符串
 */
+ (NSAttributedString *)attributeStringWithContent:(NSString *)content keyWords:(NSArray *)keyWords color:(UIColor *)color fontSize:(CGFloat)fontSize {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:content];
    if (keyWords) {
        [keyWords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableString *tempString = [NSMutableString stringWithString:content];
            NSRange range = [content rangeOfString:obj];
            NSInteger location = 0;
            while (range.length > 0) {
                [attrString addAttribute:(NSString*)NSForegroundColorAttributeName value:color range:NSMakeRange(location + range.location, range.length)];
                [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(location + range.location, range.length)];
                location += (range.location + range.length);
                NSString *temp = [tempString substringWithRange:NSMakeRange(range.location + range.length, content.length - location)];
                tempString = [NSMutableString stringWithString:temp];
                range = [temp rangeOfString:obj];
            }
        }];
    }
    return attrString;
}

/**
 *  过滤html标签
 *
 *  @param html html字符串
 *
 *  @return 过滤后字符串
 */
+ (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd] == NO) {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

/**
 *  字符串转换为数组
 *
 *  @param word 字符串
 *
 *  @return 数组
 */
+ (NSArray *)stringWithWord:(NSString *)word {
    NSMutableArray *letterArray = [NSMutableArray array];
    [word enumerateSubstringsInRange:NSMakeRange(0, [word length])
                             options:(NSStringEnumerationByComposedCharacterSequences)
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              [letterArray addObject:substring];
                          }];
    return letterArray;
}

@end
