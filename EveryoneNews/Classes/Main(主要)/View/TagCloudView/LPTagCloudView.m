//
//  LPTagCloudView.m
//  EveryoneNews
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPTagCloudView.h"
#import "POP.h"

@interface LPTagCloudView ()
@property (nonatomic, strong) UILabel *hobbyLabel;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UIView *cloudView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSMutableArray *pagingTags;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableArray *tagLabels;
@property (nonatomic, strong) UIButton *startBtn;
@end

static CGFloat padding = 10;

@implementation LPTagCloudView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        UILabel *hobbyLabel = [[UILabel alloc] init];
        hobbyLabel.textAlignment = NSTextAlignmentLeft;
        hobbyLabel.textColor = [UIColor whiteColor];
        hobbyLabel.text = @"我的兴趣爱好";
        hobbyLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:hobbyLabel];
        self.hobbyLabel = hobbyLabel;
        
        UIButton *changeBtn = [[UIButton alloc] init];
        [changeBtn setBackgroundImage:[UIImage resizableImage:@"换一批"] forState:UIControlStateNormal];
        changeBtn.backgroundColor = [UIColor clearColor];
        [changeBtn setTitle:@"换一批" forState:UIControlStateNormal];
        changeBtn.titleLabel.textColor = [UIColor whiteColor];
        changeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        changeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [changeBtn addTarget:self action:@selector(changeTags) forControlEvents:UIControlEventTouchUpInside];
        [changeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        changeBtn.enlargedEdge = 8;
        [self addSubview:changeBtn];
        self.changeBtn = changeBtn;
        
        UIView *cloudView = [[UIView alloc] init];
        [self addSubview:cloudView];
        self.cloudView = cloudView;
        
        UIButton *startBtn = [[UIButton alloc] init];
        [startBtn setEnlargedEdgeWithTop:15 left:10 bottom:15 right:10];
        [startBtn setBackgroundImage:[UIImage resizableImage:@"立即体验"] forState:UIControlStateNormal];
        startBtn.backgroundColor = [UIColor clearColor];
        [startBtn setTitle:@"立即体验" forState:UIControlStateNormal];
        startBtn.titleLabel.textColor = [UIColor whiteColor];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        startBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [startBtn addTarget:self action:@selector(startClicked) forControlEvents:UIControlEventTouchUpInside];
        [startBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self addSubview:startBtn];
        self.startBtn = startBtn;
    }
    return self;
}

- (NSArray *)colorArray {
    if (_colorArray == nil) {
        _colorArray = @[@"#ff9691", @"#de92b6", @"#fdcd5a", @"#4ecb93", @"#c9ba91", @"#8ab6e9", @"#80c3fd", @"#82cbc3"];
    }
    return _colorArray;
}

- (NSMutableArray *)tagLabels {
    if (_tagLabels == nil) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (NSMutableArray *)pagingTags {
    if (_pagingTags == nil) {
        _pagingTags = [NSMutableArray array];
    }
    return _pagingTags;
}

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    
    // 计算页数
    self.pageCount = tags.count / self.pageCapacity + (tags.count % self.pageCapacity != 0);
    
    // 计算分页后的标签数组
    NSMutableArray *tempArray = nil;
    if (self.pageCount == 1) {
        [self.pagingTags addObject:tags];
    } else {
        for (int i = 0; i < self.pageCount; i++) {
            if (i == self.pageCount - 1) {
                NSInteger loc = i * self.pageCapacity;
                NSInteger len = tags.count - loc;
                tempArray = [NSMutableArray arrayWithArray:[tags subarrayWithRange:NSMakeRange(loc, len)]];
                [self.pagingTags addObject:tempArray];
            } else {
                tempArray = [NSMutableArray arrayWithArray:[tags subarrayWithRange:NSMakeRange(i * self.pageCapacity, self.pageCapacity)]];
                [self.pagingTags addObject:tempArray];
            }
        }
    }
    
    self.startBtn.width = 190;
    self.startBtn.height = 44;
    self.startBtn.center = CGPointMake(self.width / 2, self.height * 0.75);
    
    self.hobbyLabel.x = padding;
    self.hobbyLabel.y = padding + 20;
    self.hobbyLabel.width = self.width - self.hobbyLabel.x;
    self.hobbyLabel.height = 30;
    
    self.changeBtn.height = 24;
    self.changeBtn.width = 80;
    self.changeBtn.y = CGRectGetMinY(self.startBtn.frame) - self.changeBtn.height - 60;
    self.changeBtn.x = self.width - padding - self.changeBtn.width;

    self.cloudView.x = 10;
    self.cloudView.width = self.width - 20;
    if (iPhone6Plus) {
        self.cloudView.x = 20;
        self.cloudView.width = self.width - 40;
    }
    self.cloudView.y = CGRectGetMaxY(self.hobbyLabel.frame) + 50;
    self.cloudView.height = CGRectGetMinY(self.changeBtn.frame) - self.cloudView.y - 60;
//    self.cloudView.height = self.cloudView.width - padding;
    
    [self changeTags];
}

- (void)changeTags {
    // 清空之前的标签控件
    [self.cloudView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    // 设置按钮状态
    self.changeBtn.userInteractionEnabled = (self.pageNo + 1 < self.pageCount);
    self.changeBtn.hidden = (self.pageNo + 1 == self.pageCount);
    
    // 获取当前页标签
    NSArray *currentPageTags = self.pagingTags[self.pageNo];
    // 创建相应的标签控件
    NSMutableArray *colorStrs = [self rearrangeColorArray];
    for (int i = 0; i < currentPageTags.count; i++) {
        NSString *tagName = currentPageTags[i];
        UILabel *tagLabel = [self tagLabelWithTitle:tagName];
        tagLabel.textColor = [UIColor colorFromHexString:colorStrs[i]];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.numberOfLines = 1;
        [self.cloudView addSubview:tagLabel];
        [self.tagLabels addObject:tagLabel];
    }
    // 计算当前页面标签的frames
    NSArray *tagFrames = [self driftedTagFramesWithTagLabels:self.tagLabels];
    for (int j = 0; j < self.tagLabels.count; j++) {
        UILabel *tagLabel = self.tagLabels[j];
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        positionAnimation.fromValue = [NSValue valueWithCGRect:tagLabel.frame];
        positionAnimation.toValue = [NSValue valueWithCGRect:[tagFrames[j] CGRectValue]];
        positionAnimation.springBounciness = 11.0f;
        if (iPhone6Plus) {
            positionAnimation.springBounciness = 15.0f;
        }
        positionAnimation.springSpeed = 4.0f;
        [tagLabel pop_addAnimation:positionAnimation forKey:@"frameAnimation"];
    }
    self.pageNo ++;
}

- (UILabel *)tagLabelWithTitle:(NSString *)title {
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.font = [UIFont systemFontOfSize:15];
    if (iPhone6Plus) {
        tagLabel.font = [UIFont systemFontOfSize:16];
    }
    tagLabel.text = [NSString stringWithFormat:@"#%@#", title];
    CGSize size = [tagLabel.text sizeWithFont:tagLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    tagLabel.width = size.width + 6;
    tagLabel.height = size.height + 4;
    tagLabel.center = CGPointMake(self.cloudView.width / 2, self.cloudView.height / 2);
    return tagLabel;
}

- (NSMutableArray *)rearrangeColorArray {
    NSMutableArray *colors = [NSMutableArray arrayWithArray:self.colorArray];
    NSInteger count = colors.count;
    for (NSInteger i = 0; i < count; i++) {
        NSInteger randIndex = arc4random() % (count - i) + i;
        [colors exchangeObjectAtIndex:i withObjectAtIndex:randIndex];
    }
    return colors;
}

- (NSArray *)driftedTagFramesWithTagLabels:(NSArray *)labels {
    NSMutableArray *frames = [NSMutableArray array];
    NSInteger totalNum = labels.count;
    if (totalNum > 3) {
        // 每行个数布局数组
        NSArray *numInRows = [self numInRowsWithTotalCount:totalNum];
        NSInteger rowHeight = self.cloudView.height / numInRows.count;
        NSInteger labelIndex = 0;
        for (int i = 0; i < numInRows.count; i++) { // 每行中的布局
            NSMutableArray *widthArrayInRow = [NSMutableArray array];
            NSMutableArray *xArrayInRow = [NSMutableArray array];
            NSInteger minY = i * rowHeight;
            NSInteger numInRow = [numInRows[i] integerValue];
            CGFloat totalTagWidthInRow = 0.0;
            for (int j = 0; j < numInRow; j++) {
                UILabel *tagLabel = self.tagLabels[labelIndex];
                totalTagWidthInRow += tagLabel.width;
                [widthArrayInRow addObject:@(tagLabel.width)];
                labelIndex ++;
            }
            labelIndex -= numInRow;
            NSInteger residualWidthInRow = self.cloudView.width - totalTagWidthInRow;
            for (int k = 0; k < numInRow; k++) {
                UILabel *tagLabel = self.tagLabels[labelIndex];
                NSInteger paddingX = (CGFloat)random() / (CGFloat)RAND_MAX * residualWidthInRow / (numInRow - k);
                residualWidthInRow -= paddingX;
                if (k == 0) {
                    NSInteger x = paddingX;
                    [xArrayInRow addObject:@(x)];
                    NSInteger y = minY + 10 + arc4random() % (int)(rowHeight - tagLabel.height - 10);
                    CGRect rect = CGRectMake(x, y, tagLabel.width, tagLabel.height);
                    [frames addObject:[NSValue valueWithCGRect:rect]];
                } else {
                    NSInteger lastX = [xArrayInRow[k - 1] integerValue];
                    CGFloat lastW = [widthArrayInRow[k - 1] floatValue];
                    NSInteger x = lastX + lastW + paddingX;
                    [xArrayInRow addObject:@(x)];
                    NSInteger y = minY + 10 + arc4random() % (int)(rowHeight - tagLabel.height - 10);
                    CGRect rect = CGRectMake(x, y, tagLabel.width, tagLabel.height);
                    [frames addObject:[NSValue valueWithCGRect:rect]];
                }
                labelIndex ++;
            }
        }
    } else if (totalNum == 3) {
        NSArray *labels = self.tagLabels;
        UILabel *firstLabel = labels[0];
        NSInteger firstY = self.cloudView.height / 2 - firstLabel.height - (arc4random() % 30 + 1);
        NSInteger firstX = arc4random() % (int)(self.cloudView.width - firstLabel.width - 60) + 30;
        [frames addObject:[NSValue valueWithCGRect:CGRectMake(firstX, firstY, firstLabel.width, firstLabel.height)]];
        
        UILabel *secLabel = labels[1];
        UILabel *thrLabel = labels[2];
        NSInteger residualW = self.cloudView.width - secLabel.width - thrLabel.width;
        NSInteger secPadding = arc4random() % (residualW / 2 - 10) + 1 + 10;
        NSInteger secY = self.cloudView.height / 2 + arc4random() % 30 + 1;
        CGRect secRect = CGRectMake(secPadding, secY, secLabel.width, secLabel.height);
        [frames addObject:[NSValue valueWithCGRect:secRect]];
        
        residualW -= secPadding;
        NSInteger thrY = self.cloudView.height / 2 + arc4random() % 30 + 1;
        NSInteger thrPadding = arc4random() % (residualW - 10) + 1 + 10;
        NSInteger thrX = secPadding + secLabel.width + thrPadding;
        CGRect thrRect = CGRectMake(thrX, thrY, thrLabel.width, thrLabel.height);
        [frames addObject:[NSValue valueWithCGRect:thrRect]];
    } else if (totalNum == 2) {
        NSArray *labels = self.tagLabels;
        UILabel *firLabel = labels[0];
        UILabel *secLabel = labels[1];
        NSInteger minY = self.cloudView.height / 2 - 40;
        NSInteger firY = minY + arc4random() % 60 + 1;
        NSInteger secY = minY + arc4random() % 60 + 1;
        NSInteger residualW = self.cloudView.width - secLabel.width - firLabel.width;
        NSInteger firX = arc4random() % (residualW / 2 - 20) + 1 + 20;
        residualW -= firX;
        NSInteger secPadding = arc4random() % (residualW - 20) + 1 + 20;
        NSInteger secX = firX + firLabel.width + secPadding;
        [frames addObject:[NSValue valueWithCGRect:CGRectMake(firX, firY, firLabel.width, firLabel.height)]];
        [frames addObject:[NSValue valueWithCGRect:CGRectMake(secX, secY, secLabel.width, secLabel.height)]];
    } else {
        UILabel *tagLabel = [self.tagLabels firstObject];
        CGRect rect = CGRectMake(tagLabel.x, tagLabel.y - 25, tagLabel.width, tagLabel.height);
        [frames addObject:[NSValue valueWithCGRect:rect]];
    }
    return frames;
}

- (NSArray *)numInRowsWithTotalCount:(NSInteger)total {
    NSMutableArray *rowNumArray = [NSMutableArray array];
    //    NSInteger maxNumOfRow = MAX(minNumOfRow, total / 2);
    //    NSInteger rowCount = minNumOfRow + arc4random() % (maxNumOfRow - minNumOfRow + 1);
    NSInteger rowCount = 3;
    for (int i = 0; i < rowCount; i++) {
        if (i == rowCount - 1) {
            [rowNumArray addObject:@(total)];
        } else {
            //            NSInteger minNumInRow = MAX(1, (total - 1) / rowCount);
            //            NSInteger maxNumInRow = total / 3 + 1;
            //            NSInteger minNumInRow = maxNumInRow - 1;
            NSInteger maxNumInRow = total / (rowCount - i) + (total % (rowCount - i) != 0);
            NSInteger minNumInRow = total / (rowCount - i);
            NSInteger numInRow = minNumInRow + arc4random() % (maxNumInRow - minNumInRow + 1);
            [rowNumArray addObject:@(numInRow)];
            total -= numInRow;
        }
    }
    return rowNumArray;
}

- (void)startClicked {
    if ([self.delegate respondsToSelector:@selector(tagCloudViewDidClickStartButton:)]) {
        [self.delegate tagCloudViewDidClickStartButton:self];
    }
}

@end
