//
//  QDNewsAssistant.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsAssistant.h"
#import <objc/runtime.h>
#import <Reachability.h>
@implementation LPNewsAssistant

+ (UIImage *)imageWithContentsOfFileForTabBar:(NSString *) name
{
    UIImage *image = [LPNewsAssistant imageWithContentsOfFile:name];
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

+ (UIImage *)imageWithContentsOfFile:(NSString *) name
{
    static NSBundle *GYbundle = nil;
    static UIScreen *GYScreen = nil;
    if (GYbundle == nil) {
        GYbundle = [NSBundle mainBundle];
    }
    if (GYScreen == nil) {
        GYScreen = [UIScreen mainScreen];
    }
    NSString *path = nil;
    if (GYScreen.scale == 1.0) {
        path = [GYbundle pathForResource:name ofType:@"png"];
    }else{
        NSString *scaleStr = [NSString stringWithFormat:@"%@x",@((NSInteger)GYScreen.scale)];
        if (!Screeen_3_5_INCH) {
            path = [GYbundle pathForResource:[[NSString alloc] initWithFormat:@"%@@%@",name,scaleStr] ofType:@"png"];
            if (!path || path.length == 0) {
                path = [GYbundle pathForResource:[[NSString alloc] initWithFormat:@"%@@2x",name] ofType:@"png"];
            }
            
        }else{
            path = [GYbundle pathForResource:[[NSString alloc] initWithFormat:@"%@@%@",name,scaleStr] ofType:@"png"];
        }
    }
    return  [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)imageWithContentsOfJPGFile:(NSString *) name;
{
    static NSBundle *GYbundle = nil;
    static UIScreen *GYScreen = nil;
    if (GYbundle == nil) {
        GYbundle = [NSBundle mainBundle];
    }
    if (GYScreen == nil) {
        GYScreen = [UIScreen mainScreen];
    }
    NSString *path = nil;
    if (GYScreen.scale == 1.0) {
        path = [GYbundle pathForResource:name ofType:@"jpg"];
    }else{
        NSString *scaleStr = [NSString stringWithFormat:@"%@x",@((NSInteger)GYScreen.scale)];
        if (!Screeen_3_5_INCH) {
            path = [GYbundle pathForResource:[[NSString alloc] initWithFormat:@"%@@%@",name,scaleStr] ofType:@"jpg"];
            if (!path || path.length == 0) {
                path = [GYbundle pathForResource:[[NSString alloc] initWithFormat:@"%@@2x",name] ofType:@"jpg"];
            }
        }else{
            path = [GYbundle pathForResource:[[NSString alloc] initWithFormat:@"%@@%@",name,scaleStr] ofType:@"jpg"];
        }
        
    }
    return  [UIImage imageWithContentsOfFile:path];
}

+ (BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL isCorrect = [regExPredicate evaluateWithObject:[candidate lowercaseString]];
    return isCorrect;
}

+ (BOOL)validateMobileNum:(NSString *)candidate
{
    NSString *emailRegEx = @"(1[0-9]{10})";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL isCorrect = [regExPredicate evaluateWithObject:[candidate lowercaseString]];
    return isCorrect;
}

+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isChineseCharacterAndLettersAndNumbersAndUnderScore:(NSString *)string
{
    NSInteger len=string.length;
    for(NSUInteger i = 0; i < len; i++){
        unichar a=[string characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='_'))
             ||((a >= 0x4e00 && a <= 0x9fa6))
             ))
            return NO;
    }
    
    return YES;
}//判断用户名可包含汉字,字母,数字,下划线这些以外的字符

+ (NSString *)wipeOffBlankCharacter:(NSString *)string{//去掉字符串中的空格和换行
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n\r "];
    string = [[string componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    return string;
}


+ (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}


+ (NSString*)get_imei{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

+ (NSString*)get_ua{
    NSString* us = [NSString stringWithFormat:@"%@-%@%@",
                    [UIDevice currentDevice].model,
                    [UIDevice currentDevice].systemName,
                    [UIDevice currentDevice].systemVersion];
    return us;
}


#pragma mark- JailBreak
//读取环境变量
//这个DYLD_INSERT_LIBRARIES环境变量，
//攻击者可能会给MobileSubstrate改名，但是原理都是通过DYLD_INSERT_LIBRARIES注入动态库。
char* printEnv(void){
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if (env){
        NSLog(@"%s", env);
    }
    return env;
}

#if TARGET_OS_IPHONE
+ (BOOL)isMultiTaskingSupported
{
    BOOL multiTaskingSupported = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        multiTaskingSupported = [(id)[UIDevice currentDevice] isMultitaskingSupported];
    }
    return multiTaskingSupported;
}
#endif

+ (BOOL)isJailBreak
{
    if (printEnv()) {
        NSLog(@"The device is jail broken!");
        return YES;
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}




#pragma mark- Utility
+ (NSString *)convertSecondsToTimeFormat:(NSNumber *)audioLength{
    if (audioLength && [audioLength longValue] > 0) {
        long audioTime = [audioLength longValue];
        long hour = audioTime / (60 *60);
        long minute;
        long seconds;
        if (hour > 0) {
            minute = (audioTime % (60 *60)) / 60;
            seconds =  (audioTime % (60 *60)) % 60;
            return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,seconds];
        }else{
            minute = (audioTime % (60 *60)) / 60;
            seconds =  (audioTime % (60 *60)) % 60;
            return [NSString stringWithFormat:@"%02ld:%02ld",minute,seconds];
        }
    }
    return @"";
    
}



+ (NSDictionary *)getJSONKeyPathsByPropertyKey:(Class)aClass{
    u_int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    NSMutableDictionary *propertiesDict = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (NSInteger i = 0; i<count; i++){
        const char* propertyName =property_getName(properties[i]);
        NSString *key = [NSString stringWithUTF8String: propertyName];
        
        if ([key hasPrefix:@"joy"]){
            NSString *value = [key substringFromIndex:3];
            [propertiesDict setObject:value forKey:key];
        }
    }
    
    free(properties);
    
    return propertiesDict;
}


/******************************************************************************
 函数名称 : + (NSString *)stringForAllFileSize:(UInt64)fileSize
 函数描述 : 格式化返回文件大小
 输入参数 : (UInt64)fileSize
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
#define Localizable_LF_Size_Bytes                                   @"%lldBytes"
#define Localizable_LF_Size_K                                       @"%lldK"
#define Localizable_LF_Size_M                                       @"%lld.%lldM"
#define Localizable_LF_Size_G                                       @"%lld.%d G"
#define Localizable_LF_All_Size_M                                   @"%lld.%lldM"
#define Localizable_LF_All_Size_G                                   @"%lld.%lldG"

+ (NSString *)stringForAllFileSize:(UInt64)fileSize
{
    if (fileSize<1024) {//Bytes/Byte
        if (fileSize>1) {
            return [NSString stringWithFormat:Localizable_LF_Size_Bytes,
                    fileSize];
        }else {//==1 Byte
            return [NSString stringWithFormat:Localizable_LF_Size_Bytes,
                    fileSize];
        }
    }
    if ((1024*1024)>(fileSize)&&(fileSize)>1024) {//K
        return [NSString stringWithFormat:Localizable_LF_Size_K,
                fileSize/1024];
    }
    
    if ((1024*1024*1024)>fileSize&&fileSize>(1024*1024)) {//M
        return [NSString stringWithFormat:Localizable_LF_All_Size_M,
                fileSize/(1024*1024),
                fileSize%(1024*1024)/(1024*102)];
    }
    if (fileSize>(1024*1024*1024)) {//G
        return [NSString stringWithFormat:Localizable_LF_All_Size_G,
                fileSize/(1024*1024*1024),
                fileSize%(1024*1024*1024)/(1024*1024*102)];
    }
    return nil;
}


#pragma mark-  ArrayInvokeProtect
+ (id)objectAtIndexSafe:(NSArray *)array index:(NSUInteger)index{
    if(array && index < array.count){
        return [array objectAtIndex:index];
    }else{
        return nil;
    }
}


#pragma mark-  FileBackup

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                  forKey:@"NSURLIsExcludedFromBackupKey" error: &error];
    if(!success){
        // NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}



#pragma mark- FileManage

/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取程序的Home目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+ (NSString *)getHomeDirectoryPath
{
    return NSHomeDirectory();
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取document目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+ (NSString *)getDocumentPath
{
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
#else
    NSString* homePath = [[NSBundle mainBundle] resourcePath];
    return homePath;
#endif
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取Cache目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+ (NSString *)getCachePath
{
    NSArray *Paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取Library目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+ (NSString *)getLibraryPath
{
    NSArray *Paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [Paths objectAtIndex:0];
    return path;
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取Tmp目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+ (NSString *)getTmpPath
{
    return NSTemporaryDirectory();
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊返回Documents下的指定文件路径(加创建)
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+ (NSString *)getDirectoryForDocuments:(NSString *)dir
{
    NSString* dirPath = [[self getDocumentPath] stringByAppendingPathComponent:dir];
    BOOL isDir = NO;
    BOOL isCreated = [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir];
    if ( isCreated == NO || isDir == NO ) {
        NSError* error = nil;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if(success == NO)
            NSLog(@"create dir error: %@",error.debugDescription);
    }
    return dirPath;
}

+ (NSString *)getPathForDocuments:(NSString *)filename{
    return [[self getDocumentPath] stringByAppendingPathComponent:filename];
}

+(NSString *)getPathForDocuments:(NSString *)filename inDir:(NSString *)dir{
    if (!filename) {
        filename = @"";
    }
    if (!dir) {
        dir = @"";
    }
    return [[self getDirectoryForDocuments:dir] stringByAppendingPathComponent:filename];
}

/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊返回Caches下的指定文件路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+ (NSString *)getDirectoryForCaches:(NSString *)dir
{
    NSError* error;
    NSString* path = [[self getCachePath] stringByAppendingPathComponent:dir];
    if (path) {
        [LPNewsAssistant addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
    }
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]){
        NSLog(@"create dir error: %@",error.debugDescription);
    }
    return path;
}

+ (BOOL)isExistFile:(NSString *)fileName
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

+ (long long)getFileSize:(NSString *)filePath{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([LPNewsAssistant isExistFile:filePath]) {
        NSError *error;
        return [[fileManager attributesOfItemAtPath:filePath error:&error] fileSize];
    }
    return 0;
}



@end
