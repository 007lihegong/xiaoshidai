//
//  LeftView.m
//  xiaoshidai
//
//  Created by XSD on 16/10/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "LeftView.h"

@implementation LeftView
-(instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    self.leftline = [UIView new];
    self.leftline.backgroundColor = UIColorFromRGB(0xff7f1a);
    [self addSubview:self.leftline];
    [self.leftline mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(8);
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(3, 15));
    }];
    self.title = [UILabel new];
    self.title.font = [UIFont systemFontOfSize:14];
    [self addSubview: self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(8);
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.leftline.mas_right).with.offset(15);
    }];
    return self;
}
@end
