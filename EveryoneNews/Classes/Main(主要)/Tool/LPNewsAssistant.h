//
//  QDNewsAssistant.h
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPNewsAssistant : NSObject

+ (UIImage *)imageWithContentsOfFileForTabBar:(NSString *) name;

+ (UIImage *)imageWithContentsOfFile:(NSString *) name;

+ (UIImage *)imageWithContentsOfJPGFile:(NSString *) name;

+ (BOOL)validateMobileNum:(NSString *)candidate;

+ (BOOL)validateEmail:(NSString *)candidate;

+ (BOOL)isPureInt:(NSString*)string;

+ (BOOL)isChineseCharacterAndLettersAndNumbersAndUnderScore:(NSString *)string;

+ (NSString *)wipeOffBlankCharacter:(NSString *)string;

+ (BOOL)stringContainsEmoji:(NSString *)string;

#pragma mark- ServerUrl

#pragma mark- ServerNeedData



#pragma mark- Utility

+ (BOOL)isMultiTaskingSupported;

+ (NSString *)convertSecondsToTimeFormat:(NSNumber *)audioLength;

+ (NSString *)stringForAllFileSize:(UInt64)fileSize;

+ (NSDictionary *)getJSONKeyPathsByPropertyKey:(Class)aClass;

#pragma mark-  ArrayInvokeProtect
+ (id)objectAtIndexSafe:(NSArray *)array index:(NSUInteger)index;

#pragma mark- FileManage

//获取程序的Home目录路径
+ (NSString *)getHomeDirectoryPath;
//获取document目录路径
+ (NSString *)getDocumentPath;
//获取Cache目录路径
+ (NSString *)getCachePath;
//获取Library目录路径
+ (NSString *)getLibraryPath;
//获取Tmp目录路径
+ (NSString *)getTmpPath;

+ (NSString *)getDirectoryForDocuments:(NSString *)dir;

+ (NSString *)getPathForDocuments:(NSString *)filename;

+ (NSString *)getDirectoryForCaches:(NSString *)dir;

+ (NSString *)getPathForDocuments:(NSString *)filename inDir:(NSString *)dir;

+ (BOOL)isExistFile:(NSString *)fileName;

+ (long long)getFileSize:(NSString *)filePath;


@end

