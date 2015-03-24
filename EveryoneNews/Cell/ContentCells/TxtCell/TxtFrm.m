//
//  TxtFrm.m
//  upNews
//
//  Created by 于咏畅 on 15/1/21.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "TxtFrm.h"

@implementation TxtFrm
{
    NSDictionary *_attribute;
}

- (void)setTxtDatasource:(TxtDatasource *)txtDatasource
{
    _txtDatasource = txtDatasource;
    CGFloat txtX = 15;
    CGFloat txtY = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * txtX;
    //_attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    _attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize txtSize = [_txtDatasource.txtStr boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:_attribute context:nil].size;
    
    _txtFrm = CGRectMake(0, txtY + 5, width, txtSize.height);
    _backgroundViewFrm = CGRectMake(txtX, txtY, width, txtSize.height + 5);
    _cellHeight = CGRectGetMaxY(_backgroundViewFrm);
}
@end
