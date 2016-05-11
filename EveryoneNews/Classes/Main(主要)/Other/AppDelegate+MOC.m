//
//  AppDelegate+MOC.m
//  EveryoneNews
//
//  Created by apple on 15/9/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AppDelegate+MOC.h"
#import <CoreData/CoreData.h>

@implementation AppDelegate (MOC)

//- (NSURL *)documentURL {
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    NSURL *appDocumentDirectory = [[fileMgr URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
//    NSString * docName = @"MyDocument";
//    NSURL *url = [appDocumentDirectory URLByAppendingPathComponent:docName];
//    return url;
//}
//
//- (UIManagedDocument *)createManagedDocument {
//    // 1. create a UIMangagedDocument
//    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:[self documentURL]];
//    return document;
//}
//
//- (NSManagedObjectContext *)createManagedObjectContextWithDocument:(UIManagedDocument *)document {
//    __block NSManagedObjectContext *ctx = nil;
//    NSURL *url = [self documentURL];
//    // 2. open from disk (if not exist, create it)
//    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
//        [document openWithCompletionHandler:^(BOOL success) {
//            if (success) {
//                ctx = [self managedObjectContextWithDocument:document];
//                NSLog(@"open document success!");
//            } else {
//                NSLog(@"could not open document!");
//            }
//        }];
//    } else {
//        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
//            if (success) {
//                ctx = [self managedObjectContextWithDocument:document];
//                NSLog(@"create document success!");
//            } else {
//                NSLog(@"could not create document!");
//            }
//        }];
//    }
//    return ctx;
//}
//
//- (NSManagedObjectContext *)managedObjectContextWithDocument:(UIManagedDocument *)document {
//    if (document.documentState == UIDocumentStateNormal) {
//        return document.managedObjectContext;
//    } else {
//        return nil;
//    }
//}

@end
