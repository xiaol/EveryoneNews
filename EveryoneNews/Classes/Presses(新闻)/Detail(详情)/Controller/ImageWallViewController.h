//
//  ImageWallViewController.h
//  EveryoneNews
//
//  Created by Feng on 15/7/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageWallViewController : UIViewController
//图片显示
@property (nonatomic,strong) UIScrollView *imageWallScrollView;
//图片描述
@property (nonatomic,strong) UITextView *descTextView;
//图片索引进度
@property (nonatomic,strong) UILabel *progressLabel;
//图片数据集合
@property (nonatomic,strong) NSArray *images;
//当前显示图片位置
@property (nonatomic,assign) NSInteger currentIndex;
//关闭按钮
@property (nonatomic,strong) UIButton *closeBtn;
//新闻标题
@property (nonatomic,copy) NSString *newsTitle;
//新闻标题label
@property (nonatomic,strong) UILabel *newsTitleLabel;

@end
