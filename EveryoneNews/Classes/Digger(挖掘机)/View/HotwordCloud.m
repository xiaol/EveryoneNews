//
//  HotwordCloud.m
//  EveryoneNews
//
//  Created by apple on 15/9/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "HotwordCloud.h"
#import "POP.h"

static const CGFloat padding = 10;
//const CGFloat [self labelHeight] = 22;
//const CGFloat wordCloudH = [self labelHeight] * 5 + padding * 4;
//const CGFloat hotwordCloudHeight = wordCloudH + 25 + 44;

@interface HotwordCloud () <POPAnimationDelegate>
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, strong) UIView *cloudView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSMutableArray *pagingWords;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableArray *wordLabels;
@end


@implementation HotwordCloud

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *cloudView = [[UIView alloc] init];
        [self addSubview:cloudView];
        self.cloudView = cloudView;
        
        UIButton *preBtn = [[UIButton alloc] init];
        preBtn.tag = 100;
        [preBtn setBackgroundImage:[UIImage imageNamed:@"dig换一批"] forState:UIControlStateNormal];
        preBtn.backgroundColor = [UIColor clearColor];
        [preBtn setTitle:@"上一批" forState:UIControlStateNormal];
        [preBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        preBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        preBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [preBtn addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
        [preBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        preBtn.enlargedEdge = 5;
        [self addSubview:preBtn];
        self.preBtn = preBtn;
        
        UIButton *nextBtn = [[UIButton alloc] init];
        nextBtn.tag = 200;
        [nextBtn setBackgroundImage:[UIImage imageNamed:@"dig换一批"] forState:UIControlStateNormal];
        nextBtn.backgroundColor = [UIColor clearColor];
        [nextBtn setTitle:@"下一批" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [nextBtn addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
        [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        nextBtn.enlargedEdge = 5;
        [self addSubview:nextBtn];
        self.nextBtn = nextBtn;
    }
    return self;
}

# pragma mark - lazy initial
- (NSMutableArray *)pagingWords {
    if (_pagingWords == nil) {
        _pagingWords = [NSMutableArray array];
    }
    return _pagingWords;
}

- (NSMutableArray *)wordLabels {
    if (_wordLabels == nil) {
        _wordLabels = [NSMutableArray array];
    }
    return _wordLabels;
}

- (NSArray *)colorArray {
    if (_colorArray == nil) {
        _colorArray = @[@"#ff9691", @"#de92b6", @"#fdcd5a", @"#4ecb93", @"#c9ba91", @"#8ab6e9", @"#80c3fd", @"#82cbc3"];
    }
    return _colorArray;
}

# pragma mark - setter
- (void)setHotwords:(NSArray *)hotwords {
    _hotwords = hotwords;
    // 1. 总页数
    _pageCount = (NSInteger)ceil(hotwords.count / (double)HotwordPageCapacity);
    // 2. 分页数组
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.pageCount; i++) {
        if (i == self.pageCount - 1) {
            // 若是最后一组, 则将余下全部作为数组, 保存为pagingWords里最后一个元素
            NSInteger loc = i * HotwordPageCapacity;
            NSInteger len = hotwords.count - loc;
            tmpArray = [NSMutableArray arrayWithArray:[hotwords subarrayWithRange:NSMakeRange(loc, len)]];
            [self.pagingWords addObject:tmpArray];
        } else {
            tmpArray = [NSMutableArray arrayWithArray:[hotwords subarrayWithRange:NSMakeRange(i * HotwordPageCapacity, HotwordPageCapacity)]];
            [self.pagingWords addObject:tmpArray];
        }
    }
    // 3. 设置按钮与标签云的frame
    self.preBtn.width = 55;
    self.preBtn.height = 25;
    self.preBtn.x = padding;
    self.preBtn.y = (int)self.height - 25;
    
    self.nextBtn.width = 55;
    self.nextBtn.height = 25;
    self.nextBtn.x = self.width - padding - 55;
    self.nextBtn.y = (int)self.height - 25;
    
    self.cloudView.y = 0;
    self.cloudView.x = 0;
    self.cloudView.width = self.width;
    self.cloudView.height = [self cloudHeight];
    
    // 初始化, 展示第一页
    [self changePage:self.nextBtn];
}

#pragma mark - 换一批
- (void)changePage:(UIButton *)sender {
    if (self.wordLabels.count) {
        // 计算当前页(前提:非初始化)
        sender.tag == 100 ? self.pageNo-- : self.pageNo++;
        // 清空之前的标签控件
        [self.cloudView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.wordLabels removeAllObjects];
        [self initializeWordLabels];
        // 计算当前页面标签最终的frame, 并做动画
        NSArray *wordFrms = [self driftedFramesWithWordLabels:self.wordLabels];
        for (NSInteger j = 0; j < self.wordLabels.count; j++) {
            UILabel *wordLabel = self.wordLabels[j];
            wordLabel.userInteractionEnabled = YES;
            POPSpringAnimation *positionAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            positionAnim.delegate = nil;
            positionAnim.delegate = self;
            positionAnim.fromValue = [NSValue valueWithCGRect:wordLabel.frame];
            positionAnim.toValue = [NSValue valueWithCGRect:[wordFrms[j] CGRectValue]];
            positionAnim.springBounciness = 7.0f;
            positionAnim.springSpeed = 3.0f;
            [wordLabel pop_addAnimation:positionAnim forKey:@"frameAnimation"];
        }
    } else {
        [self initializeWordLabels];
        // 计算当前页面标签最终的frame, 并做动画
        NSArray *wordFrms = [self driftedFramesWithWordLabels:self.wordLabels];
        for (NSInteger j = 0; j < self.wordLabels.count; j++) {
            UILabel *wordLabel = self.wordLabels[j];
            wordLabel.userInteractionEnabled = YES;
            wordLabel.frame = [wordFrms[j] CGRectValue];
        }
    }
}

- (void)initializeWordLabels {
    // 设置按钮隐藏状态
    self.preBtn.hidden = (self.pageNo == 0);
    self.nextBtn.hidden = (self.pageNo == self.pageCount - 1);
    
    // 获取当前的热词组
    NSArray *currentPageWords = self.pagingWords[self.pageNo];
    // 创建热词控件并初始化frame
    NSMutableArray *colorStrs = [self rearrangeColorArray];
    for (NSInteger i = 0; i < currentPageWords.count; i++) {
        NSString *wordName = currentPageWords[i];
        UILabel *wordLabel = [self wordLabelWithTitle:wordName];
        wordLabel.backgroundColor = [UIColor colorFromHexString:colorStrs[i]];
        [self.cloudView addSubview:wordLabel];
        [self.wordLabels addObject:wordLabel];
    }
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

- (UILabel *)wordLabelWithTitle:(NSString *)title {
    UILabel *wordLabel = [[UILabel alloc] init];
    NSString *btnTitle = [NSString stringWithFormat:@"%@", title];
    wordLabel.text = btnTitle;
    wordLabel.font = [self wordFont];

    CGSize size = [btnTitle sizeWithFont:wordLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    wordLabel.center = CGPointMake(self.width / 2 - 20, [[self class] totalHeight] / 2);
    wordLabel.height = (int)[self labelHeight];
    wordLabel.width = (int)(size.width + wordLabel.height);
    wordLabel.textColor = [UIColor whiteColor];
    wordLabel.textAlignment = NSTextAlignmentCenter;
    wordLabel.numberOfLines = 0;
//    wordLabel.layer.cornerRadius = wordLabel.height / 2;
//    wordLabel.layer.masksToBounds = YES;
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = [UIBezierPath bezierPathWithRoundedRect:wordLabel.bounds cornerRadius:wordLabel.height / 2].CGPath;
    wordLabel.layer.mask = layer;
    [wordLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWordLabel:)]];
    return wordLabel;
}

- (UIFont *)wordFont {
    UIFont *font = nil;
    if (iPhone6Plus) {
        font = [UIFont boldSystemFontOfSize:15];
    } else {
        font = [UIFont boldSystemFontOfSize:14];
    }
    return font;
}

- (CGFloat)labelHeight {
    return [@"哈哈" sizeWithFont:[self wordFont] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height + 8;
}

- (void)tapWordLabel:(UITapGestureRecognizer *)sender {
    UILabel *wordLabel = (UILabel *)sender.view;
    if ([self.delegate respondsToSelector:@selector(hotwordCloud:didClickTitle:)]) {
        [self.delegate hotwordCloud:self didClickTitle:wordLabel.text];
    }
    NSLog(@"%@", wordLabel.text);
}

- (NSArray *)driftedFramesWithWordLabels:(NSArray *)labels {
    NSMutableArray *frames = [NSMutableArray array];
    UILabel *firstLabel = labels[0];
    CGRect firstRect = CGRectMake((self.width - firstLabel.width) / 2 , 0, firstLabel.width, [self labelHeight]);
    [frames addObject:[NSValue valueWithCGRect:firstRect]];
    NSInteger colCount = 2;
    CGFloat gap = 8;
    for (NSInteger i = 0; i < 6; i++) {
        UILabel *wordLabel = labels[i+1];
        NSInteger row = i / colCount;
        NSInteger col = i % colCount;
        CGFloat y = (row + 1) * ([self labelHeight] + padding);
        CGFloat x = self.width / 2 + (col ? gap : - (gap + wordLabel.width));
        CGRect rect = CGRectMake(x, y, wordLabel.width, [self labelHeight]);
        [frames addObject:[NSValue valueWithCGRect:rect]];
    }
    if (labels.count == HotwordPageCapacity) {
        UILabel *lastLabel = [labels lastObject];
        CGRect preRect = [[frames lastObject] CGRectValue];
        CGFloat preY = CGRectGetMaxY(preRect);
        CGFloat y = preY + padding;
        CGFloat x = (self.width - lastLabel.width) / 2;
        CGRect lastRect = CGRectMake(x, y, lastLabel.width, [self labelHeight]);
        [frames addObject:[NSValue valueWithCGRect:lastRect]];
    }
    return frames;
}

- (CGFloat)cloudHeight {
    return (int)[self labelHeight] * 5 + padding * 4;
}

+ (CGFloat)totalHeight {
    return [[self new] cloudHeight] + 25 + 44;
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished { // 只有点击preBtn或nextBtn时才有可能调用
    if (finished) {
        if ([self.delegate respondsToSelector:@selector(hotwordCloudDidChangeWords:)]) {
            [self.delegate hotwordCloudDidChangeWords:self];
        }
        [self stopAnimation];
    }
}

- (void)stopAnimation {
    [self.cloudView.subviews makeObjectsPerformSelector:@selector(pop_removeAllAnimations)];
}

@end
