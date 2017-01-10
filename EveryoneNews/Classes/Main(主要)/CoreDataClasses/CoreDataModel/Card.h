//
//  Card.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CardImage, CardRelate, Comment, CardConcern;

NS_ASSUME_NONNULL_BEGIN

@interface Card : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Card+CoreDataProperties.h"
