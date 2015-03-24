//
//  FTCoreTextCell.m
//  upNews
//
//  Created by 于咏畅 on 15/3/6.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "FTCoreTextCell.h"
#import "FTCoreTextView.h"

#define kParagraphInsetH 15

@implementation FTCoreTextCell
{
    FTCoreTextView *coreTextView;
    UIView *bgView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if  (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        coreTextView = [[FTCoreTextView alloc] init];
        
//        coreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        // set styles
        [coreTextView addStyles:[self coreTextStyle]];
        //set delegate
//        [coreTextView setDelegate:self];
        
        bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor clearColor];
//        bgView.backgroundColor = [UIColor greenColor];
//        bgView.alpha = 0.4;
//        [self.contentView addSubview:bgView];
        
        [self.contentView addSubview:coreTextView];
    }
    return self;
}

- (void)setTxtDatasource:(TxtDatasource *)txtDatasource
{
    _txtDatasource = txtDatasource;
    // set text
    NSString *str = [NSString stringWithFormat:@"<myDefault>%@</myDefault>", txtDatasource.txtStr];
    [coreTextView setText:str];
    coreTextView.frame = [self setTextViewFrm];
    [coreTextView fitToSuggestedHeight];
    
    bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, coreTextView.frame.size.height + kParagraphInsetH);
    
    //返回Cell高度
    _cellH = bgView.frame.size.height;
}

- (NSArray *)coreTextStyle
{
    NSMutableArray *result = [NSMutableArray array];
    
    FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
//    defaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
    defaultStyle.name = @"myDefault";
//    defaultStyle.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:16.f];
    defaultStyle.font = [UIFont systemFontOfSize:16];
    defaultStyle.textAlignment = FTCoreTextAlignementJustified;
    defaultStyle.paragraphInset = UIEdgeInsetsMake(12, 0, 0, 0);
//    defaultStyle.maxLineHeight = 100;
    defaultStyle.minLineHeight = 22;
    [result addObject:defaultStyle];
    
    return  result;
}
- (CGRect)setTextViewFrm
{
    CGFloat txtX = 15;
    CGFloat txtY = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * txtX;
    CGRect frm = CGRectMake(txtX, txtY, width, 0);
    return frm;
}
@end
