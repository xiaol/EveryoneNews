//
//  LPPagingViewConcernPage.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPPagingViewConcernPage.h"
#import "LPConcernViewCell.h"
#import "LPCardConcernFrame.h"
#import "LPDetailViewController.h"


@interface LPPagingViewConcernPage() <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *noDataConcernView;

@end

@implementation LPPagingViewConcernPage

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIView *noDataConcernView = [[UIView alloc] initWithFrame:CGRectMake(0, 142, ScreenWidth, 200)];
        CGFloat noDataImageViewW = 67;
        CGFloat noDataImageViewH = 71;
        CGFloat noDataImageViewX = (ScreenWidth - noDataImageViewW) / 2;
        UIImageView *noDataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(noDataImageViewX, 0, noDataImageViewW, noDataImageViewH)];
        noDataImageView.image = [UIImage imageNamed:@"关注占位图"];
        [noDataConcernView addSubview:noDataImageView];
        
        NSString *noDataStr = @"快去关注吧";
        CGFloat noDataLabelX = 0;
        CGFloat noDataLabelY = CGRectGetMaxY(noDataImageView.frame) + 9;
        CGFloat noDataLabelW = ScreenWidth;
        CGFloat noDataLabelH = [noDataStr heightForLineWithFont:[UIFont systemFontOfSize:LPFont2]];
        
        UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(noDataLabelX, noDataLabelY, noDataLabelW, noDataLabelH)];
        noDataLabel.font = [UIFont systemFontOfSize:LPFont2];
        noDataLabel.textColor = [UIColor colorFromHexString:LPColor1];
        noDataLabel.text = noDataStr;
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        [noDataConcernView addSubview:noDataLabel];
        [self addSubview:noDataConcernView];
         self.noDataConcernView = noDataConcernView;
        
        // 搜索
        CGFloat searchViewHeight = 35;
        CGFloat cornerRadius = 10;
        CGFloat paddingTop = 5;
        CGFloat searchImageH = 12;
        CGFloat searchImageW = 12;
        CGFloat searchLabelFontSize = 12;
        CGFloat searchViewPadding = 10;
        
        if (iPhone6Plus) {
            searchViewHeight = 42;
            cornerRadius = 15;
            searchImageH = 15;
            searchImageW = 15;
            searchLabelFontSize = 16;
            paddingTop = 6;
            searchViewPadding = 13;
        } else if (iPhone5) {
            searchViewHeight = 35;
            paddingTop = 5;
            cornerRadius = 12;
            searchViewPadding = 10;
            searchLabelFontSize = 12;
        } else if (iPhone6) {
            searchViewHeight = 47;
            paddingTop = 9;
            searchViewPadding = 10;
            searchLabelFontSize = LPFont4;
            cornerRadius = 14;
            searchImageH = 15;
            searchImageW = 15;
        }
        
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, searchViewHeight)];
        searchView.backgroundColor = [UIColor colorFromHexString:@"#f0f0f0"];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(searchViewPadding, paddingTop, ScreenWidth - searchViewPadding * 2, searchViewHeight - paddingTop * 2);
        layer.backgroundColor =[UIColor whiteColor].CGColor;
        layer.cornerRadius = cornerRadius;
        layer.borderColor = [UIColor colorFromHexString:@"e4e4e4"].CGColor;
        layer.borderWidth = 0.5;
        [searchView.layer addSublayer:layer];
        
        UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(26, 0, searchImageW, searchImageH)];
        searchImageView.image = [UIImage imageNamed:@"首页搜索"];
        searchImageView.centerY = searchViewHeight / 2;
        [searchView addSubview:searchImageView];
        
        UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame) + 6, 0, 40, 29)];
        searchLabel.text = @"搜索";
        searchLabel.textAlignment = NSTextAlignmentLeft;
        searchLabel.textColor = [UIColor colorFromHexString:@"#cacaca"];
        searchLabel.font = [UIFont systemFontOfSize:searchLabelFontSize];
        searchLabel.centerY = searchViewHeight / 2;
        [searchView addSubview:searchLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)];
        tapGesture.delegate = self;
        [searchView addGestureRecognizer:tapGesture];
        self.searchView = searchView;
        
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, searchViewHeight - 0.5, ScreenWidth, 0.5)];
        seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
        [searchView addSubview:seperatorView];
        [self addSubview:searchView];
        
        
        UITableView *tableView = [[UITableView alloc] init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor =  [UIColor colorFromHexString:LPColor9];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.scrollsToTop = NO;
        [self addSubview:tableView];
        self.tableView = tableView;
    }
    return self;
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    self.tableView.tableHeaderView = self.searchView;
}

- (void)setCardFrames:(NSMutableArray *)cardFrames {
    
    _cardFrames = cardFrames;
    [self.tableView reloadData];
    
    if (cardFrames.count > 0) {
        self.noDataConcernView.hidden = YES;
    } else {
        self.noDataConcernView.hidden = NO;
    }
}

#pragma mark - tableView  datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = self.cellIdentifier;
    LPConcernViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LPConcernViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.cardFrame = self.cardFrames[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPCardConcernFrame *cardFrame = self.cardFrames[indexPath.row];
    return cardFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LPCardConcernFrame *cardFrame = self.cardFrames[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(concernPage:didSelectCellWithCardID:)]) {
        [self.delegate concernPage:self didSelectCellWithCardID:cardFrame.card.objectID];
    }
}


- (void)tapImageView {
    NSLog(@"search");
}



@end
