//
//  LPSubscribeView.m
//  Test
//
//  Created by dongdan on 16/9/1.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "LPSubscribeView.h"
#import "LPSubscriberCell.h"

static NSString *cellIdentifier = @"cellIdentifier";
const static CGFloat padding = 20;

@interface LPSubscribeView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LPSubscriberCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *sourceNameArray;
@property (nonatomic, strong) UIButton *confirmButton;

@end


@implementation LPSubscribeView

- (NSMutableArray *)sourceNameArray {
    if (_sourceNameArray == nil) {
        _sourceNameArray = [NSMutableArray array];
    }
    return _sourceNameArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorFromHexString:LPColor9];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 30)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:LPFont3];
        titleLabel.textColor = [UIColor colorFromHexString:LPColor1];
        titleLabel.text = @"根据你的爱好为你推荐";
        [self addSubview:titleLabel];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat collectionViewY = CGRectGetMaxY(titleLabel.frame) + 20;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(padding, collectionViewY, ScreenWidth - 2 * padding, ScreenHeight - collectionViewY - 50) collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.scrollEnabled = NO;
        collectionView.backgroundColor = [UIColor colorFromHexString:LPColor9];
        [collectionView registerClass:[LPSubscriberCell class] forCellWithReuseIdentifier:cellIdentifier];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        
        CGFloat confirmButtonH = 50;
        UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight - confirmButtonH, ScreenWidth, confirmButtonH)];
        confirmButton.backgroundColor = [UIColor colorFromHexString:@"#bdc3c7"];
        [confirmButton setTitle:@"开始体验" forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        confirmButton.titleLabel.textColor = [UIColor whiteColor];
        [confirmButton addTarget:self action:@selector(confirmButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmButton];
        self.confirmButton = confirmButton;
        
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.subscriberFrames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPSubscriberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.subscriberFrame = self.subscriberFrames[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (ScreenWidth - 2 * padding - 1) / 3.0f;
    CGFloat height = (ScreenHeight - 160) / 3.0f;
    return  CGSizeMake(width, height);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001f;
}

#pragma mark - LPSubscriberCellDelegate
- (void)cell:(LPSubscriberCell *)cell title:(NSString *)title buttonSelected:(BOOL)buttonSelected {
    if (buttonSelected) {
        [self.sourceNameArray addObject:title];
    } else {
       [self.sourceNameArray removeObject:title];
    }
    
    if (self.sourceNameArray.count > 0) {
        self.confirmButton.backgroundColor = [UIColor colorFromHexString:@"#0091fa"];
        
    } else {
        self.confirmButton.backgroundColor = [UIColor colorFromHexString:@"#bdc3c7"];
    }
}


#pragma mark - 点击开始体验按钮
- (void)confirmButtonDidClick {
    if (self.sourceNameArray.count > 0) {
       
    }
    [self removeFromSuperview];
}





 



@end
