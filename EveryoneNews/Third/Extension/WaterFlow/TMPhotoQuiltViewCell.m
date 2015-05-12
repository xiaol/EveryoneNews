//
//  TMQuiltView
//
//  Created by Bruno Virlet on 7/20/12.
//
//  Copyright (c) 2012 1000memories

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//


#import "TMPhotoQuiltViewCell.h"

const CGFloat kTMPhotoQuiltViewMargin = 5;

@implementation TMPhotoQuiltViewCell

@synthesize photoView = _photoView;
@synthesize titleLabel = _titleLabel;
@synthesize backView = _backView;

- (void)dealloc {
    [_photoView release], _photoView = nil;
    [_titleLabel release], _titleLabel = nil;
    [_backView release], _backView = nil;
    
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor blackColor];
//        self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.backView.layer.shadowOffset = CGSizeMake(1, 1);
        _backView.alpha = 0.25;
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 1;
        [self addSubview:_backView];
        [self sendSubviewToBack:_backView];
    }
    return _backView;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
//        _photoView.contentMode = UIViewContentModeScaleAspectFit;
        _photoView.clipsToBounds = YES;
        [self addSubview:_photoView];
//        [_backView addSubview:_photoView];
    }
    return _photoView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont fontWithName:kFont size:12.5];
        [self addSubview:_titleLabel];
//        [_backView addSubview:_titleLabel];
    }
    return _titleLabel;
}
    
- (void)layoutSubviews {
    
    self.backView.frame = CGRectInset(self.bounds, 2, 2);
    self.backView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    
//    self.photoView.frame = CGRectInset(self.bounds, kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
    
    self.photoView.frame = CGRectMake(1, 1, self.bounds.size.width - 2, self.bounds.size.height - 40 - 1);
    
//    self.titleLabel.frame = CGRectMake(kTMPhotoQuiltViewMargin, self.bounds.size.height - 20 - kTMPhotoQuiltViewMargin,
//                                       self.bounds.size.width - 2 * kTMPhotoQuiltViewMargin, 20);
    self.titleLabel.frame = CGRectMake(1, self.bounds.size.height - 40 - 1, self.bounds.size.width - 2, 40);
    
//    self.titleLabel.frame = CGRectMake(0, 100, 100, 100);
}

@end
