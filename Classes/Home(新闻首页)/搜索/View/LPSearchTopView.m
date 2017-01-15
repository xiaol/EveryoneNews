//
//  LPSearchTopView.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSearchTopView.h"

@interface LPSearchTopView() <UISearchBarDelegate>

@end

@implementation LPSearchTopView

- (instancetype)initWithFrame:(CGRect)frame {
    // 分享，评论，添加按钮边距设置
    double topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    double padding = 15;
    
    double returnButtonWidth = 13;
    double returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
        padding = 18;
    }
    
    if (iPhone6) {
        topViewHeight = 72;
    }
    double returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // 定义顶部视图
        self.frame = CGRectMake(0 , 0, ScreenWidth, topViewHeight);
        self.backgroundColor = [UIColor colorFromHexString:LPColor29];
        
        // 返回button
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(padding, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
        [backBtn setBackgroundImage:[UIImage oddityImage:@"video_back"] forState:UIControlStateNormal];
        backBtn.enlargedEdge = 15;
        [backBtn addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        
        // 搜索框
        CGFloat searchViewH = 30;
        CGFloat searchViewX = CGRectGetMaxX(backBtn.frame) + 8;
        CGFloat searchViewW = ScreenWidth - searchViewX - padding;
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(searchViewX, 0, searchViewW, searchViewH)];
        searchBar.delegate = self;
        searchBar.showsCancelButton = NO;
        searchBar.placeholder = @"请输入关键词";
        searchBar.tintColor = [UIColor  colorFromHexString:@"#b3b3b3"];
        searchBar.backgroundImage = [[UIImage alloc] init];
        searchBar.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
        searchBar.centerY = backBtn.centerY;
  
        [self addSubview:searchBar];
        self.searchBar = searchBar;
        
        UITextField *searchField = [searchBar valueForKey:@"_searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor colorFromHexString:@"#ffffff"]];
            searchField.layer.cornerRadius = 14.0f;
            searchField.layer.borderColor = [UIColor colorFromHexString:LPColor5].CGColor;
            searchField.layer.borderWidth = 0.5;
            searchField.font = [UIFont systemFontOfSize:LPFont4];
            searchField.layer.masksToBounds = YES;
        }
        [searchBar becomeFirstResponder];
    }
    return self;
}

#pragma mark - delegate
- (void)topViewBackBtnClick {
    if([self.delegate respondsToSelector:@selector(backButtonDidClick:)]){
        [self.delegate backButtonDidClick:self];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([self.delegate respondsToSelector:@selector(topView:searchBarSearchButtonClicked:)]) {
        [self.delegate topView:self searchBarSearchButtonClicked:searchBar];
    }
}

@end
