//
//  CardImage+Create.m
//  EveryoneNews
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CardImage+Create.h"
#import "Card.h"

@implementation CardImage (Create)

+ (NSOrderedSet *)createCardImagesWithURLArray:(NSArray *)urls
                                     card:(Card *)card
                   inManagedObjectContext:(NSManagedObjectContext *)context {
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
    for (NSString *url in urls) {
        CardImage *image = [self createCardImageWithURL:url card:card inManagedObjectContext:context];
        [set addObject:image];
    }
    return set;
}

+ (CardImage *)createCardImageWithURL:(NSString *)url
                                    card:(Card *)card
                  inManagedObjectContext:(NSManagedObjectContext *)context {
    CardImage *image = nil;
    image = [NSEntityDescription insertNewObjectForEntityForName:@"CardImage" inManagedObjectContext:context];
    [context obtainPermanentIDsForObjects:@[image] error:nil];
    image.imgUrl = url;
    image.card = card;
    return image;
}

@end
