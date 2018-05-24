//
//  GuideCollectionViewCell.m
//  PadProject
//
//  Created by SansiMac on 2018/5/16.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import "GuideCollectionViewCell.h"

@implementation GuideCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _describeLab = [[UILabel alloc] init];
        _describeLab.backgroundColor = kRandomColor;
        _describeLab.numberOfLines = 0;
        [_describeLab sizeToFit];
        [self.contentView addSubview:_describeLab];
    }
    return self;
}

- (void)layoutSubviews{
    [_describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

@end
