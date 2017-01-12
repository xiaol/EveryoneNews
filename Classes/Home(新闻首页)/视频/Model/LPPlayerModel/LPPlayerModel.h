//
//  LPPlayerModel.h
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/7.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPPlayerModel : NSObject

// 标题
@property (nonatomic, copy) NSString *title;
// 视频URL
@property (nonatomic, strong) NSURL *videoURL;
// 视频封面本地图片
@property (nonatomic, strong) UIImage *placeholderImage;
// 视频封面网络图片url 如果和本地图片同时设置，则忽略本地图片，显示网络图片
@property (nonatomic, copy) NSString *placeHolderImageURLString;
// 视频起始位置
@property (nonatomic, assign) NSInteger seekTime;
// cell 播放视频
@property (nonatomic, strong) UITableView *tableView;
// cell 所在indexPath
@property (nonatomic, strong) NSIndexPath *indexPath;
// 父视图
@property (nonatomic, weak) UIView *parentView;

@end
