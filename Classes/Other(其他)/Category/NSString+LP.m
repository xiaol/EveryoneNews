//
//  NSString+LP.m
//  EveryoneNews
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSString+LP.h"
#import <CommonCrypto/CommonCrypto.h>


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

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = NSMakeRange(0, self.length);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 0.001f;
    style.lineSpacing = lineSpacing;
    [string addAttribute:NSFontAttributeName value:font range:range];
    [string addAttribute:NSParagraphStyleAttributeName value:style range:range];
    return string;
}

- (NSMutableAttributedString *)adsAttributedStringWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = NSMakeRange(0, self.length);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 0.001f;
    style.lineSpacing = lineSpacing;
    [string addAttribute:NSFontAttributeName value:font range:range];
    [string addAttribute:NSParagraphStyleAttributeName value:style range:range];
    [string addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorFromHexString:LPColor17]
                          range:NSMakeRange(0, 2)];
    
    return string;
}

- (NSMutableAttributedString *)truncatingTailAttributedStringWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = NSMakeRange(0, self.length);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentJustified;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.firstLineHeadIndent = 0.001f;
    style.lineSpacing = lineSpacing;
    [string addAttribute:NSFontAttributeName value:font range:range];
    [string addAttribute:NSParagraphStyleAttributeName value:style range:range];
    return string;
}

- (NSMutableAttributedString *)truncatingTailAttributedStringWithFont:(CGFloat)fontSize lineSpacing:(CGFloat)lineSpacing rtype:(BOOL)rtype {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = NSMakeRange(0, self.length);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentJustified;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.firstLineHeadIndent = 0.001f;
    style.lineSpacing = lineSpacing;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    [string addAttribute:NSFontAttributeName value:font range:range];
    if (rtype) {
        style.firstLineHeadIndent = 5.0f;
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0,2)];
    }
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
    return [self stringByReplacingOccurrencesOfString:string withString:@""];
}

- (instancetype)stringByTrimmingHyphen{
    return [self stringByTrimmingString:@"-"];
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

- (BOOL)isMoreThanOneLineConstraintToWidth:(CGFloat)width withFont:(UIFont *)font {
    return [self sizeWithFont:font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width > width;
}

- (instancetype)stringByBase64Encoding {
    NSData *encodeData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [encodeData base64EncodedStringWithOptions:0];
}

- (instancetype)stringByBase64Decoding {
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
}

- (double)timestampWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:dateFormat];
    NSDate *date = [fmt dateFromString:self];
    return [date timeIntervalSince1970];
}

- (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

- (NSString *)stringToMD5:(NSString *)str
{
    
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}

@end
