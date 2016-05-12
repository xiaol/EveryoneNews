//
//  LPContent.h
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPComment.h"

@class LPConcern;

typedef void(^imageDownLoadCompletionBlock)();
//@protocol LPContentDelegate <NSObject>
//
//@optional
//- (void)LPContent:(LPContent *)content contentWithDictionary
//
//@end

@interface LPContent : NSObject
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, assign) BOOL hasComment;
@property (nonatomic, assign) BOOL isAbstract;
@property (nonatomic, assign) int paragraphIndex;
@property (nonatomic, strong) LPConcern *concern;
// 针对图像cell
@property (nonatomic, assign) BOOL isPhoto;
@property (nonatomic, copy) NSString *photoDesc;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, strong) UIImage *image;


@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) UIColor *color;

// 针对观点cell
@property (nonatomic, assign) BOOL isOpinion;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *opinion;

- (NSMutableAttributedString *)opinionString;
- (LPComment *)displayingComment;
- (NSMutableAttributedString *)bodyString;
- (NSMutableAttributedString *)bodyHtmlString;
- (NSMutableAttributedString *)photoDescString;

@end
