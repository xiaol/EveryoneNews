//
//  LPPressCell.m
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPPressCell.h"
#import "LPPressFrame.h"
#import "LPSingleGraphTopView.h"
#import "LPMultiGraphTopView.h"
#import "LPSingleGraphOpinionsView.h"
#import "LPMultiGraphOpinionsView.h"
#import "LPPhotoView.h"
#import "LPPress.h"
#import "LPSingleGraphMidSeperaterView.h"


@interface LPPressCell ()
//// 大图
@property (nonatomic, strong) LPPhotoView *photoView;
// 单图、多图
@property (nonatomic, strong) LPSingleGraphTopView *singleGraphTopView;
@property (nonatomic, strong) LPSingleGraphMidSeperaterView  *singleGraphSeparaterView;
@property (nonatomic, strong) LPSingleGraphOpinionsView *singleGraphOpinionsView;

//@property (nonatomic, strong) LPMultiGraphTopView *multiGraphTopView;
//@property (nonatomic, strong) LPMultiGraphOpinionsView *multiGraphOpinionsView;
@end

@implementation LPPressCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        LPPhotoView *photoView = [[LPPhotoView alloc] init];
        [self.contentView addSubview:photoView];
        self.photoView = photoView;
        
        LPSingleGraphTopView *topView = [[LPSingleGraphTopView alloc] init];
        [self.contentView addSubview:topView];
        self.singleGraphTopView = topView;
        LPSingleGraphMidSeperaterView *seperaterView = [[LPSingleGraphMidSeperaterView alloc] init];
        [self.contentView addSubview:seperaterView];
        self.singleGraphSeparaterView = seperaterView;
        LPSingleGraphOpinionsView *opinionsView = [[LPSingleGraphOpinionsView alloc] init];
        [self.contentView addSubview:opinionsView];
        self.singleGraphOpinionsView = opinionsView;
    }
    return self;
}


//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//
//            LPPhotoView *photoView = [[LPPhotoView alloc] init];
//            [self.contentView addSubview:photoView];
//            self.photoView = photoView;
//
//            LPSingleGraphTopView *topView = [[LPSingleGraphTopView alloc] init];
//            [self.contentView addSubview:topView];
//            self.singleGraphTopView = topView;
//            LPSingleGraphMidSeperaterView *seperaterView = [[LPSingleGraphMidSeperaterView alloc] init];
//            [self.contentView addSubview:seperaterView];
//            self.singleGraphSeparaterView = seperaterView;
//            LPSingleGraphOpinionsView *opinionsView = [[LPSingleGraphOpinionsView alloc] init];
//            [self.contentView addSubview:opinionsView];
//            self.singleGraphOpinionsView = opinionsView;
//
////            LPMultiGraphTopView *topView = [[LPMultiGraphTopView alloc] init];
////            [self.contentView addSubview:topView];
////            self.multiGraphTopView = topView;
////            
////            LPMultiGraphOpinionsView *opinionsView = [[LPMultiGraphOpinionsView alloc] init];
////            [self.contentView addSubview:opinionsView];
////            self.multiGraphOpinionsView = opinionsView;
//
//    }
//    return self;
//}
//
//+ (instancetype)cellWithTableView:(UITableView *)tableView
//{
//    static NSString *ID = @"press";
//    LPPressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[LPPressCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
//    return cell;
//}

- (void)setPressFrame:(LPPressFrame *)pressFrame
{
    _pressFrame = pressFrame;
    LPPress *press = pressFrame.press;
    int mode = press.special.intValue;
    if (mode == 1) {
        self.photoView.hidden = NO;
        self.singleGraphTopView.hidden = YES;
        self.singleGraphSeparaterView.hidden = YES;
        self.singleGraphOpinionsView.hidden = YES;
        
        self.photoView.frame = self.pressFrame.photoViewF;
        self.photoView.pressFrame = self.pressFrame;
    } else if (mode == 400) {
        self.photoView.hidden = YES;
        
        self.singleGraphTopView.hidden = NO;
        self.singleGraphTopView.frame = self.pressFrame.singleGraphTopViewF;
        self.singleGraphTopView.pressFrame = self.pressFrame;
        if (pressFrame.press.sublist.count) {
            self.singleGraphSeparaterView.hidden = NO;
            self.singleGraphOpinionsView.hidden = NO;
            self.singleGraphSeparaterView.frame = self.pressFrame.singleGraphMidSeparaterF;
            self.singleGraphSeparaterView.category = press.category;
            self.singleGraphOpinionsView.frame = self.pressFrame.singleGraphOpinionsViewF;
            self.singleGraphOpinionsView.press = press;
        } else {
            self.singleGraphSeparaterView.hidden = YES;
            self.singleGraphOpinionsView.hidden = YES;
        }
    } else if (mode == 9) {
        
    }
}

//- (void)setFrame:(CGRect)frame
//{
//    frame.size.height -= CellHeightBorder;
//    [super setFrame:frame];
//}
//
//-(void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    
//}
//
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    
//}
@end
