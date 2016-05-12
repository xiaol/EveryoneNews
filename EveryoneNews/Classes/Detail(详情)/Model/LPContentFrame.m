//
//  LPContentFrame.m
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPContentFrame.h"
#import "LPContent.h"
#import "LPComment.h"
#import "LPConcern.h"
#import "UIImageView+WebCache.h"

@implementation LPContentFrame

- (void)setContent:(LPContent *)content {
    CGFloat bodyPadding = 13;
    if (iPhone6Plus) {
        bodyPadding = 15;
    } else if (iPhone5) {
        bodyPadding = 10;
    }
    _content = content;
    if (!_content.isPhoto) { // 普通类型(非图)g
        CGFloat bodyX = bodyPadding;
        CGFloat bodyY = 0;
        CGFloat bodyW = ScreenWidth - 2 * bodyPadding;
        CGFloat bodyH = [_content.bodyHtmlString textViewHeightWithConstraintWidth:bodyW];
        _bodyLabelF = CGRectMake(bodyX, bodyY, bodyW, bodyH);
        _cellHeight = CGRectGetMaxY(_bodyLabelF) + 3.5f;
    }
    else { // 图像类型
        [self setupPhotoFAndCellHWithImage:_content.image];
    }
}

- (void)downloadImageWithCompletionBlock:(imageDownLoadCompletionBlock)imageDownLoadCompletionBlock  {
    if (!self.content.isPhoto) {
        //imageDownLoadCompletionBlock();
        return;
    }
    // 图片下载完成后获取图片大小
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.content.photo] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            self.content.image = image;
            [self setupPhotoFAndCellHWithImage:image];
            imageDownLoadCompletionBlock();
        }];    
}

- (void)setupPhotoFAndCellHWithImage:(UIImage *)image {
    CGFloat bodyPadding = 13;
    if (iPhone6Plus) {
        bodyPadding = 19;
    } else if (iPhone5) {
        bodyPadding = 15;
    }
    CGFloat photoX = bodyPadding;
    CGFloat photoY = 0;
    CGFloat photoW = ScreenWidth - 2 * bodyPadding;
    CGFloat photoH =  photoW * (image.size.height / image.size.width);
    _photoViewF = CGRectMake(photoX, photoY, photoW, photoH);
    _cellHeight = CGRectGetMaxY(_photoViewF) + 3.5f;

}

- (void)setContentWhenFontSizeChanged:(LPContentFrame *)contentFrame {
    self.content = contentFrame.content;
}

@end
