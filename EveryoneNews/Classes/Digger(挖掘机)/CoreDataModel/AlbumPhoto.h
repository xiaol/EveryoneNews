//
//  AlbumPhoto.h
//  EveryoneNews
//
//  Created by apple on 15/11/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Photo.h"

@class Album;

@interface AlbumPhoto : Photo

@property (nonatomic, retain) Album *album;

@end
