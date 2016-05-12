//
//  QDNewsBaseTableViewCell.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsBaseTableViewCell.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface LPNewsBaseTableViewCellContentView : UIView{
    LPNewsBaseTableViewCell *cell_;
}

- (instancetype)init:(LPNewsBaseTableViewCell *)cell;

@end

@implementation LPNewsBaseTableViewCellContentView

- (instancetype)init:(LPNewsBaseTableViewCell *)cell{
    self = [super init];
    if (self) {
        cell_ = cell;
    }
    return self;
}
@end

@implementation LPNewsBaseTableViewCell

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath{
    
}




@end






