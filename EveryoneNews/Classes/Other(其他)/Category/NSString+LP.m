//
//  NSString+LP.m
//  EveryoneNews
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSString+LP.h"

@implementation NSString (LP)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGFloat)heightForLineWithFont:(UIFont *)font
{
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.height;
}

- (NSMutableAttributedString *)attributedString
{
    return [[NSMutableAttributedString alloc] initWithString:self];
}

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font
{
    NSDictionary *attrs = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    return [[NSMutableAttributedString alloc] initWithString:self attributes:attrs];
}

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = NSMakeRange(0, self.length);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 0.001f;
    
    style.lineSpacing = lineSpacing;
    [string addAttribute:NSFontAttributeName value:font range:range];
    [string addAttribute:NSForegroundColorAttributeName value:color range:range];
    [string addAttribute:NSParagraphStyleAttributeName value:style range:range];
    return string;
}

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing characterSpacing:(CGFloat)spacing firstLineSpacing:(CGFloat)firstSpacing {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = NSMakeRange(0, self.length);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = firstSpacing;
    style.alignment = NSTextAlignmentJustified;
    style.lineSpacing = lineSpacing;
    [string addAttribute:NSFontAttributeName value:font range:range];
    [string addAttribute:NSForegroundColorAttributeName value:color range:range];
    [string addAttribute:NSParagraphStyleAttributeName value:style range:range];
    [string addAttribute:NSKernAttributeName value:@(spacing) range:range];
    return string;
}

- (BOOL)isBlank
{
    if (self == nil || self == NULL || [self isKindOfClass:[NSNull class]] || [self stringByTrimmingWhitespaceAndNewline].length == 0) {
        return YES;
    }
    return NO;
}

- (instancetype)stringByTrimmingWhitespaceAndNewline {
    return [[[self stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (instancetype)stringByTrimmingNewline {
    return [[self stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
}

- (instancetype)stringByTrimmingString:(NSString *)string {
    return [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (instancetype)absoluteDateString {
    return [[[self stringByTrimmingString:@"-"] stringByTrimmingString:@":"] stringByTrimmingString:@" "];
}

- (BOOL)isOnlyWhitespace
{
    return ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0);
}

+ (instancetype)stringFromIntValue:(int)intValue
{
    return [NSString stringWithFormat:@"%d", intValue];
}

+ (instancetype)stringFromIntegerValue:(NSInteger)integerValue
{
    return [NSString stringWithFormat:@"%ld", integerValue];
}

+ (instancetype)stringFromUIntegerValue:(NSUInteger)uIntValue
{
    return [NSString stringWithFormat:@"%lu", uIntValue];
}

+ (instancetype)stringFromBOOLValue:(BOOL)boolValue
{
    return boolValue ? @"YES" : @"NO";
}

+ (instancetype)stringFromNowDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [fmt stringFromDate:date];
}

+ (instancetype)absoluteStringFromNowDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMddHHmmss";
    return [fmt stringFromDate:date];
}

- (BOOL)isMoreThanOneLineConstraintToWidth:(CGFloat)width withFont:(UIFont *)font
{
    return [self sizeWithFont:font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width > width;
}

@end
