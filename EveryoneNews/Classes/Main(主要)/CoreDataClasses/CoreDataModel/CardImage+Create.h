//
//  CardImage+Create.h
//  EveryoneNews
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CardImage.h"
@class Card;

@interface CardImage (Create)

+ (NSSet *)createCardImagesWithURLArray:(NSArray *)urls
                                   card:(Card *)card
                 inManagedObjectContext:(NSManagedObjectContext *)context;
+ (CardImage *)createCardImageWithURL:(NSString *)url
                                 card:(Card *)card
               inManagedObjectContext:(NSManagedObjectContext *)context;

@end
