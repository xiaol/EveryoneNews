//
//  LPSpecialTopicHomeViewController.m
//  EveryoneNews
//
//  Created by dongdan on 16/10/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSpecialTopicHomeViewController.h"
#import "LPHttpTool.h"
#import "UIImageView+WebCache.h"
#import "LPSpecialTopicViewCell.h"
#import "LPSpecialTopicCard.h"
#import "LPSpecailTopicCardFrame.h"
#import "LPDetailViewController.h"
#import "LPLoadingView.h"

@interface LPSpecialTopicHomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cardFrames;
@property (nonatomic, strong) NSMutableArray *headerTitleArray;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) LPLoadingView *loadingView;

@end

@implementation LPSpecialTopicHomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed = true;
    }
    return self;
}


#pragma mark - 懒加载
- (NSMutableArray *)cardFrames {
    if (_cardFrames == nil) {
        _cardFrames = [NSMutableArray array];
    }
    return _cardFrames;
}

- (NSMutableArray *)headerTitleArray {
    if (_headerTitleArray == nil) {
        _headerTitleArray = [NSMutableArray array];
    }
    return _headerTitleArray;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
    [self setupData];
    
}

#pragma mark - setup subviews
- (void)setupSubView {
    self.view.backgroundColor = [UIColor colorFromHexString:LPColor29];
    // 导航栏
    double topViewHeight = TabBarHeight + StatusBarHeight;
    double padding = 15;
    
    double returnButtonWidth = 13;
    double returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
    }
    if (iPhone6) {
        topViewHeight = 72;
    }
    double returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topViewHeight)];
    topView.backgroundColor = [UIColor colorFromHexString:@"#ffffff" alpha:0.0f];
    [self.view addSubview:topView];
 
    CGFloat shareButtonW = 25;
    CGFloat shareButtonH = 5;
    CGFloat shareButtonX = ScreenWidth - padding - shareButtonW;
    
    CGFloat shareButtonY =  (topViewHeight - shareButtonH + StatusBarHeight) / 2.0f;
    
    // 返回button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
    [backButton setBackgroundImage:[UIImage oddityImage:@"video_back"] forState:UIControlStateNormal];
    backButton.enlargedEdge = 15;
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth , 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor10];
    [self.view addSubview:seperatorView];
    // UITableView
    CGFloat tableViewX = 0;
    CGFloat tableViewY = CGRectGetMaxY(seperatorView.frame);
    CGFloat tableViewW = ScreenWidth;
    CGFloat tableViewH = ScreenHeight - tableViewY;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    // 正在加载提示信息
    [self setupLoadingView];
}

#pragma mark - shareButtonClick 
- (void)shareButtonClick {
    NSLog(@"分享");
}

#pragma mark - Loading View
- (void)setupLoadingView {
    LPLoadingView *loadingView = [[LPLoadingView alloc] initWithFrame:CGRectMake(0, StatusBarHeight + TabBarHeight, ScreenWidth, (ScreenHeight - StatusBarHeight - TabBarHeight) / 2.0f)];
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
    [loadingView startAnimating];

}

#pragma mark - UITableView HeaderView
- (void)setupHeaderView:(NSString *)coverImageURL desc:(NSString *)desc {
    
    CGFloat headerViewH = 0.f;
    CGFloat headerViewY = 0.f;
    CGFloat headerViewW = ScreenWidth;
    CGFloat headerViewX = 0.0f;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorFromHexString:LPColor9];
    
    if (coverImageURL.length > 0) {
        CGFloat coverH = 76.0f;
        UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, coverH)];
        [coverImageView sd_setImageWithURL:[NSURL URLWithString:coverImageURL] placeholderImage:[UIImage oddityImage:@"单图小图占位图"]];
        [headerView addSubview:coverImageView];
        headerViewH += coverH;
    }
    
    if (desc.length > 0) {
     
        NSString *abstract = [NSString stringWithFormat:@"一一%@", desc];
        
        CGFloat labelMarginTop = 16.0f;
        CGFloat labelY = headerViewH + labelMarginTop;
        CGFloat labelX = 15;
        CGFloat labelW = ScreenWidth - labelX * 2;
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        
        UILabel *abstractLabel = [[UILabel alloc] init];
        abstractLabel.textAlignment = NSTextAlignmentCenter;
        abstractLabel.layer.borderColor = [UIColor colorFromHexString:@"#e94220"].CGColor;
        abstractLabel.layer.borderWidth = 0.5f;
        abstractLabel.layer.cornerRadius = 2.0f;
        abstractLabel.font = [UIFont systemFontOfSize:11];
        abstractLabel.text = @"摘要";
        abstractLabel.textColor = [UIColor colorFromHexString:@"#e94220"];
        abstractLabel.layer.masksToBounds = YES;
 
        NSMutableAttributedString *abstractFontStr =  [@"摘要" attributedStringWithFont:[UIFont systemFontOfSize:LPFont10] lineSpacing:2];
        
        NSMutableAttributedString *abstractFont11Str =  [@"摘要" attributedStringWithFont:[UIFont systemFontOfSize:11] lineSpacing:2];
        

        CGRect abstractFontRect = [abstractFontStr boundingRectWithSize:CGSizeMake(labelW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        
       CGRect abstractFont11Rect = [abstractFont11Str boundingRectWithSize:CGSizeMake(labelW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
       
        NSMutableAttributedString *attrStr =  [abstract attributedStringWithFont:[UIFont systemFontOfSize:LPFont10] lineSpacing:2];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,2)];
        
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(labelW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat labelH = ceilf(rect.size.height);

        label.attributedText = attrStr;

        CGFloat gap = (abstractFontRect.size.height - abstractFont11Rect.size.height) / 2.0f;
        CGFloat abstractStrX = labelX;
        CGFloat abstractStrY = labelY + gap;
        CGFloat abstractStrH = abstractFontRect.size.height - gap * 2;
        CGFloat abstractStrW = abstractFontRect.size.width;
        
        abstractLabel.frame = CGRectMake(abstractStrX, abstractStrY, abstractStrW, abstractStrH);
 
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        [headerView addSubview:label];
        [headerView addSubview:abstractLabel];
        
        headerViewH += (labelH + labelMarginTop * 2);
        
        CALayer *seperatorLayer = [CALayer layer];
        seperatorLayer.backgroundColor =  [UIColor colorFromHexString:@"e4e4e4"].CGColor;
        seperatorLayer.frame = CGRectMake(0, headerViewH - 0.5, ScreenWidth, 0.5);
        [headerView.layer addSublayer:seperatorLayer];
    }
    headerView.frame = CGRectMake(headerViewX, headerViewY, headerViewW, headerViewH);
   
    if (headerViewH > 0) {
        self.tableView.tableHeaderView = headerView;
    }
}





#pragma mark - tableView  datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.cardFrames[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"identifier";
    LPSpecialTopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LPSpecialTopicViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.cardFrame = self.cardFrames[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LPSpecailTopicCardFrame *cardFrame = self.cardFrames[indexPath.section][indexPath.row];
    LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
    detailVc.specialTopicCardFrame = cardFrame;
    detailVc.sourceViewController = specialTopicSource;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 47)];
    headerView.backgroundColor = [UIColor colorFromHexString:LPColor11];
    
    CALayer *seperatorHeaderLayer = [CALayer layer];
    seperatorHeaderLayer.backgroundColor =  [UIColor colorFromHexString:@"e4e4e4"].CGColor;
    seperatorHeaderLayer.frame = CGRectMake(0, 7.5f, ScreenWidth, 0.5f);
    [headerView.layer addSublayer:seperatorHeaderLayer];
    
    CGFloat subviewY = 8;
    CGFloat subViewH = 39;
    UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0, subviewY, ScreenWidth, subViewH)];
    subview.backgroundColor = [UIColor colorFromHexString:LPColor9];
    
    NSString *title = self.headerTitleArray[section];
    CGFloat titleH = [title sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat titleW = [title sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    
    CGFloat layerX = 0;
    CGFloat layerY = (subViewH - titleH) / 2;
    CGFloat layerW = 4;
    CGFloat layerH = titleH;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(layerX, layerY, layerW, layerH);
    layer.backgroundColor = [UIColor colorFromHexString:LPColorDetail].CGColor;
    [subview.layer addSublayer:layer];
    
    CGFloat labelX = CGRectGetMaxX(layer.frame) + 8;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, layerY, titleW, titleH)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    CALayer *seperatorLayer = [CALayer layer];
    seperatorLayer.backgroundColor =  [UIColor colorFromHexString:@"e4e4e4"].CGColor;
    seperatorLayer.frame = CGRectMake(0, subViewH - 0.5, ScreenWidth, 0.5);
    [subview.layer addSublayer:seperatorLayer];

    [subview addSubview:titleLabel];
    [headerView addSubview:subview];
    return headerView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPSpecailTopicCardFrame *cardFrame = self.cardFrames[indexPath.section][indexPath.row];
    CGFloat cellHeight = cardFrame.cellHeight;
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5f;
}

#pragma mark - backButtonDidClick
- (void)backButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - setupData
- (void)setupData {
    NSString *specialTopicURL = [NSString stringWithFormat:@"%@/v2/ns/tdq", ServerUrlVersion2];
    NSMutableDictionary *specialTopicParams = [NSMutableDictionary dictionary];
    specialTopicParams[@"tid"] = self.tid;
    [LPHttpTool getWithURL:specialTopicURL params:specialTopicParams success:^(id json) {
    
        if ([json[@"code"] integerValue] == 2000) {
            // 字典
            NSDictionary *dict = json[@"data"];
            
            // 摘要
            NSDictionary *topicBaseInfoDict = dict[@"topicBaseInfo"];
            NSString *coverImageURL = topicBaseInfoDict[@"cover"];
            NSString *desc = topicBaseInfoDict[@"description"];
//            desc = @"奇点资讯摘要测试测试测试";
            [self setupHeaderView:coverImageURL desc:desc];
            NSArray *topicCLassArray = dict[@"topicClass"];
            NSMutableArray *newsFeedMutableArray = [NSMutableArray array];
            for (NSDictionary *topClassDict in topicCLassArray) {
                NSString *title = topClassDict[@"topicClassBaseInfo"][@"name"];
                [self.headerTitleArray addObject:title];
                
                NSArray *newsFeedArray = topClassDict[@"newsFeed"];
                NSMutableArray *newsFeedCardFrameArray = [NSMutableArray array];
                
                for (NSDictionary *dictNewsFeed in newsFeedArray) {
                    LPSpecialTopicCard *card = [[LPSpecialTopicCard alloc] init];
                    card.nid = dictNewsFeed[@"nid"];
                    card.title = dictNewsFeed[@"title"];
                    card.sourceSiteName = dictNewsFeed[@"pname"];
                    card.sourceSiteURL = dictNewsFeed[@"purl"];
                    card.updateTime = [NSString stringWithFormat:@"%lld", (long long)([dictNewsFeed[@"ptime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
                    card.channelId = dict[@"channel"];
                    card.docId = dictNewsFeed[@"docid"];
                    card.commentsCount = dictNewsFeed[@"comment"];
                    card.cardImages = dictNewsFeed[@"imgs"];
                    
                    LPSpecailTopicCardFrame *cardFrame = [[LPSpecailTopicCardFrame alloc] init];
                    cardFrame.card = card;
                    [newsFeedCardFrameArray addObject:cardFrame];
                }
                [newsFeedMutableArray addObject:newsFeedCardFrameArray];
            }
            self.cardFrames = newsFeedMutableArray;
            
            if (self.cardFrames.count > 0) {
                [self.tableView reloadData];
                [self.loadingView stopAnimating];
          
            }
        }
    } failure:^(NSError *error) {
        [self.loadingView stopAnimating];
    }];
}



@end
