//
//  NSString+LP.h
//  EveryoneNews
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LP)


- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGFloat)heightForLineWithFont:(UIFont *)font;

- (NSMutableAttributedString *)attributedString;

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font;

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing;

- (NSMutableAttributedString *)truncatingTailAttributedStringWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing characterSpacing:(CGFloat)spacing firstLineSpacing:(CGFloat)firstSpacing;

- (BOOL)isMoreThanOneLineConstraintToWidth:(CGFloat)width withFont:(UIFont *)font;

// 判断是否为空
- (BOOL)isBlank;

+ (instancetype)stringFromIntValue:(int)intValue;
+ (instancetype)stringFromIntegerValue:(NSInteger)integerValue;
+ (instancetype)stringFromUIntegerValue:(NSUInteger)uIntValue;
+ (instancetype)stringFromBOOLValue:(BOOL)boolValue;
+ (instancetype)stringFromNowDate;
+ (instancetype)absoluteStringFromNowDate;

- (instancetype)stringByTrimmingWhitespaceAndNewline;
- (instancetype)stringByTrimmingNewline;
- (instancetype)stringByTrimmingString:(NSString *)string;
// 去除中横线
- (instancetype)stringByTrimmingHyphen;
- (instancetype)absoluteDateString;

- (instancetype)stringByBase64Encoding;
- (instancetype)stringByBase64Decoding;



// 获取时间戳
- (double)timestampWithDateFormat:(NSString *)dateFormat;
- (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;

- (NSString *)stringToMD5:(NSString *)str;
@end
