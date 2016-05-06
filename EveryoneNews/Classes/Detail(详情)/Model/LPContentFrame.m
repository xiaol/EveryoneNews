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
    
    _content = content;
    
    if (!_content.isPhoto) { // 普通类型(非图)g
        CGFloat bodyX = 0;
        CGFloat bodyY = 5;
        CGFloat bodyW = ScreenWidth - 2 * BodyPadding;
        CGFloat bodyH = [_content.bodyHtmlString textViewHeightWithConstraintWidth:bodyW];
        _bodyLabelF = CGRectMake(bodyX, bodyY, bodyW, bodyH);
        _cellHeight = CGRectGetMaxY(_bodyLabelF) + 5;
        
    }
    
    else { // 图像类型
        [self setupPhotoFAndCellHWithImage:_content.image];
        
    }
}

- (void)downloadImageWithCompletionBlock:(imageDownLoadCompletionBlock)imageDownLoadCompletionBlock  {
    if (!self.content.isPhoto) {
        imageDownLoadCompletionBlock();
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
    CGFloat photoX = 0;
    CGFloat photoY = 5;
    CGFloat photoW = ScreenWidth - 2 * BodyPadding;
    CGFloat photoH =  photoW * (image.size.height / image.size.width);
    
    //        CGFloat photoH = photoW * 9 / 11;
    _photoViewF = CGRectMake(photoX, photoY, photoW, photoH);
    _cellHeight = CGRectGetMaxY(_photoViewF) + 5;

}

- (void)setContentWhenFontSizeChanged:(LPContentFrame *)contentFrame {
    self.content = contentFrame.content;
}

@end
