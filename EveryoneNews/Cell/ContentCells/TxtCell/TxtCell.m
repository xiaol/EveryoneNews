//
//  TxtCell.m
//  upNews
//
//  Created by 于咏畅 on 15/1/21.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "TxtCell.h"
#import "UIColor+HexToRGB.h"

@implementation TxtCell
{
    UILabel *txtLab;
    UIView *backgrounpView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        backgrounpView = [[UIView alloc] init];
        backgrounpView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:backgrounpView];
        
        txtLab = [[UILabel alloc] init];
//        txtLab.font = [UIFont systemFontOfSize:14];
        txtLab.font = [UIFont fontWithName:kFont size:16];
        txtLab.numberOfLines = 0;
        txtLab.textAlignment = NSTextAlignmentJustified;
        txtLab.textColor = [UIColor colorFromHexString:@"#000000"];
        [backgrounpView addSubview:txtLab];
    }
    return self;
}

- (void)setTxtFrm:(TxtFrm *)txtFrm
{
    _txtFrm = txtFrm;
    [self settingData];
    [self settingSubviewFrame];
}

- (void)settingData
{
    txtLab.text = _txtFrm.txtDatasource.txtStr;
    _cellH = _txtFrm.cellHeight;
}

- (void)settingSubviewFrame
{
    txtLab.frame = _txtFrm.txtFrm;
    backgrounpView.frame = _txtFrm.backgroundViewFrm;
}

@end
