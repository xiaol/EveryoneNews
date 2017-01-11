//
//  CoreDataHelper.m
//  EveryoneNews
//
//  Created by apple on 15/10/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CoreDataHelper.h"
#import "Album+Create.h"
#import "Faulter.h"


@implementation CoreDataHelper

#define debug 0

#pragma mark - FILES
NSString *storeFileName = @"EveryoneNews.sqlite";

#pragma mark - PATHS
- (NSString *)applicationDocumentsDirectory {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class,NSStringFromSelector(_cmd));
    }
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
}
- (NSURL *)applicationStoresDirectory {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSURL *storesDirectory =
    [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]]
     URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&error]) {
            if (debug==1) {
                NSLog(@"Successfully created Stores directory");}
        }
        else {NSLog(@"FAILED to create Stores directory: %@", error);}
    }
    return storesDirectory;
}
- (NSURL *)storeURL {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        NSLog(@"path is: %@", [self applicationStoresDirectory].absoluteString);
    }
    return [[self applicationStoresDirectory]
            URLByAppendingPathComponent:storeFileName];
}

+(CoreDataHelper *)shareCoreDataHelper{

    static CoreDataHelper* _coreDataHelper;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _coreDataHelper = [[CoreDataHelper alloc] init];
    });
    [_coreDataHelper setupCoreData];
    
    return _coreDataHelper;
}

#pragma mark - SETUP
- (id)init {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    self = [super init];
    if (!self) {return nil;}
    
    
    NSBundle *oddityBundle =  [NSBundle bundleForClass:[self class]];
    NSURL *url = [oddityBundle URLForResource:@"OdditBundle" withExtension:@"bundle"];
    if(url){
        NSBundle *shareBundle = [NSBundle bundleWithURL:url];
        _model = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:shareBundle]];
    }
    
    _coordinator = [[NSPersistentStoreCoordinator alloc]
                    initWithManagedObjectModel:_model];
    
    _parentContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_parentContext performBlockAndWait:^{
        _parentContext.persistentStoreCoordinator = _coordinator;
        _parentContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        _parentContext.undoManager = nil;
    }];
    
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _context.parentContext = _parentContext;
    _context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    _context.undoManager = nil;
    
    _importContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_importContext performBlockAndWait:^{
        _importContext.parentContext = _context;
        _importContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        _importContext.undoManager = nil;
    }];
    
    return self;
}

/// 创建子上下文
-(void)initImportContext:(NSManagedObjectContext*)_importContext{
    
    NSBundle *oddityBundle =  [NSBundle bundleForClass:[self class]];
    
    NSURL *url = [oddityBundle URLForResource:@"OdditBundle" withExtension:@"bundle"];
    
    if(url){
        NSBundle *shareBundle = [NSBundle bundleWithURL:url];
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:shareBundle]];
        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *sqlitePath = [doc stringByAppendingPathComponent:@"EveryoneNews.sqlite"];
        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];
        
        _coordinator = store;
    }
}


- (void)loadStore {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (_store) {return;} // 确保存储区只加载一次
    NSError *error = nil;
    NSDictionary *options =
    @{
      NSMigratePersistentStoresAutomaticallyOption:@YES
      ,NSInferMappingModelAutomaticallyOption:@YES
      ,NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}
      };

    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:[self storeURL]
                                              options:options error:&error];
    if (!_store) {NSLog(@"Failed to add store. Error: %@", error);abort();}
    else         {if (debug==1) {NSLog(@"Successfully added store: %@", _store);}}
}

- (void)setupCoreData {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self loadStore];
}

#pragma mark - SAVING
- (void)saveContext {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (_context.hasChanges) {
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"_context saved changes to parent context");
        } else {
            NSLog(@"Failed to save _context: %@", error);
            [self showValidationError:error];
        }
    } else {
//        NSLog(@"SKIPPED _context save, there are no changes!");
    }
}

- (void)saveContextAndParentContext {
    [self saveContext];
    // 2.把父上下文保存到持久化存储区(在专用队列上异步执行)
    [_parentContext performBlock:^{
        if (_parentContext.hasChanges) {
            NSError *error = nil;
            if ([_parentContext save:&error]) {
                NSLog(@"_parentContext saved changes to persistent store");
            } else {
                NSLog(@"_parentContext Failed to save _context: %@", error);
                [self showValidationError:error];
            }
        } else {
            //            NSLog(@"SKIPPED _parentContext save, there are no changes!");
        }
    }];
}

- (void)saveImportContext {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [_importContext performBlock:^{
        if (_importContext.hasChanges) {
            NSError *error = nil;
            if ([_importContext save:&error]) {
                NSLog(@"_importContext saved changes to parent context");
            } else {
                NSLog(@"Failed to save _importContext: %@", error);
                [self showValidationError:error];
            }
        } else {
            //        NSLog(@"SKIPPED _context save, there are no changes!");
        }
    }];

}

- (void)Ï {
    
    [_importContext performBlock:^{
        
        if (_importContext.hasChanges) {
            
            NSError *error = nil;
            if ([_importContext save:&error]) {
                
                NSLog(@"_importContext saved changes to parent context");
                
                if (_context.hasChanges) {
                    
                    NSError *error = nil;
                    
                    if ([_context save:&error]) {
                        
                        NSLog(@"_context saved changes to parent context");
                        
                        [_parentContext performBlock:^{
                            
                            if (_parentContext.hasChanges) {
                                
                                NSError *error = nil;
                                if ([_parentContext save:&error]) {
                                    
                                    NSLog(@"_parentContext saved changes to persistent store");
                                    
                                } else {
                                    
                                    NSLog(@"_parentContext Failed to save _context: %@", error);
                                    
                                    [self showValidationError:error];
                                    
                                }
                            } else {
                                NSLog(@"SKIPPED _parentContext save, there are no changes!");
                            }
                        }];
                        
                        
                    } else {
                        
                        NSLog(@"Failed to save _context: %@", error);
                        
                        [self showValidationError:error];
                    }
                }
            } else {
                NSLog(@"Failed to save _importContext: %@", error);
                [self showValidationError:error];
            }
        } else {
          
        }
    }];
    
}




#pragma mark - VALIDATION ERROR HANDLING
- (void)showValidationError:(NSError *)anError {
    if (anError && [anError.domain isEqualToString:@"NSCocoaErrorDomain"]) {
        NSArray *errors = nil;  // holds all errors
        NSString *txt = @""; // the error message text of the alert
        
        // Populate array with error(s)
        if (anError.code == NSValidationMultipleErrorsError) {
            errors = [anError.userInfo objectForKey:NSDetailedErrorsKey];
        } else {
            errors = [NSArray arrayWithObject:anError];
        }
        // Display the error(s)
        if (errors && errors.count > 0) {
            // Build error message text based on errors
            for (NSError * error in errors) {
                NSString *entity =
                [[[error.userInfo objectForKey:@"NSValidationErrorObject"] entity] name];
                
                NSString *property =
                [error.userInfo objectForKey:@"NSValidationErrorKey"];
                
                switch (error.code) {
                    case NSValidationRelationshipDeniedDeleteError:
                        txt = [txt stringByAppendingFormat:
                               @"%@ delete was denied because there are associated %@\n(Error Code %li)\n\n", entity, property, (long)error.code];
                        break;
                    case NSValidationRelationshipLacksMinimumCountError:
                        txt = [txt stringByAppendingFormat:
                               @"the '%@' relationship count is too small (Code %li).", property, (long)error.code];
                        break;
                    case NSValidationRelationshipExceedsMaximumCountError:
                        txt = [txt stringByAppendingFormat:
                               @"the '%@' relationship count is too large (Code %li).", property, (long)error.code];
                        break;
                    case NSValidationMissingMandatoryPropertyError:
                        txt = [txt stringByAppendingFormat:
                               @"the '%@' property is missing (Code %li).", property, (long)error.code];
                        break;
                    case NSValidationNumberTooSmallError:
                        txt = [txt stringByAppendingFormat:
                               @"the '%@' number is too small (Code %li).", property, (long)error.code];
                        break;
                    case NSValidationNumberTooLargeError:
                        txt = [txt stringByAppendingFormat:
                               @"the '%@' number is too large (Code %li).", property, (long)error.code];
                        break;
                    case NSValidationDateTooSoonError:
                        txt = [txt stringByAppendingFormat:
                               @"the '%@' date is too soon (Code %li).", property, (long)error.code];
                        break;
                    case NSValidationDateTooLateError:
                        txt = [txt stringByAppendingFormat:
                               @"the '%@' date is too late (Code %li).", property, (long)error.code];
                        break;
                    case NSValidationInvalidDateError:
                        txt = [txt stringByAppendingFormat:
                               @"the '%@' date is invalid (Code %li).", property, (long)error.code];
                        break;
                    case NSValidationStringTooLongError:
                        txt = [txt stringByAppendingFormat:
                               @"the '%@' text is too long (Code %li).", property, (long)error.code];
                        break;
                    case NSValidationStringTooShortError:
                        txt = [txt stringByAppendingFormat:
                               @"the '%@' text is too short (Code %li).", property, (long)error.code];
                        break;
                    case NSValidationStringPatternMatchingError:
                        txt = [txt stringByAppendingFormat:
                               @"the '%@' text doesn't match the specified pattern (Code %li).", property, (long)error.code];
                        break;
                    case NSManagedObjectValidationError:
                        txt = [txt stringByAppendingFormat:
                               @"generated validation error (Code %li)", (long)error.code];
                        break;
                        
                    default:
                        txt = [txt stringByAppendingFormat:
                               @"Unhandled error code %li in showValidationError method", (long)error.code];
                        break;
                }
            }
            // display error message txt message
            UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:@"数据库验证错误"
                                       message:[NSString stringWithFormat:@"%@Please double-tap the home button and close this application by swiping the application screenshot upwards",txt]
                                      delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)saveBackgroundContext {
    
    [_importContext performBlock:^{
        
        if (_importContext.hasChanges) {
            
            NSError *error = nil;
            if ([_importContext save:&error]) {
                
                NSLog(@"_importContext saved changes to parent context");
                
                if (_context.hasChanges) {
                    
                    NSError *error = nil;
                    
                    if ([_context save:&error]) {
                        
                        NSLog(@"_context saved changes to parent context");
                        
                        [_parentContext performBlock:^{
                            
                            if (_parentContext.hasChanges) {
                                
                                NSError *error = nil;
                                if ([_parentContext save:&error]) {
                                    
                                    NSLog(@"_parentContext saved changes to persistent store");
                                    
                                } else {
                                    
                                    NSLog(@"_parentContext Failed to save _context: %@", error);
                                    
                                    [self showValidationError:error];
                                    
                                }
                            } else {
                                NSLog(@"SKIPPED _parentContext save, there are no changes!");
                            }
                        }];
                        
                        
                    } else {
                        
                        NSLog(@"Failed to save _context: %@", error);
                        
                        [self showValidationError:error];
                    }
                }
            } else {
                NSLog(@"Failed to save _importContext: %@", error);
                [self showValidationError:error];
            }
        } else {
            
        }
    }];
    
}



- (void)deleteCoreData {
    // Card
    NSFetchRequest *cardRequest = [[NSFetchRequest alloc] init];
    [cardRequest setEntity:[NSEntityDescription entityForName:@"Card" inManagedObjectContext:_importContext]];
    [cardRequest setIncludesPropertyValues:NO]; // only fetch the managedObjectID
    NSError *cardError = nil;
    NSArray *cards = [_importContext executeFetchRequest:cardRequest error:&cardError];
    //error handling goes here
    for (NSManagedObject *card in cards) {
        [_importContext deleteObject:card];
    }
    
    [_importContext performBlock:^{
        [self saveBackgroundContext];
    }];
  
}

- (void)deleteCoreDataFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self applicationStoresDirectory].path]) {
        [fileManager removeItemAtPath:[self applicationStoresDirectory].path error:nil];
    }
}

@end
