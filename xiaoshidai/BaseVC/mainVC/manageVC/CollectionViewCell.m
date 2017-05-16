//
//  CollectionViewCell.m
//  网众
//
//  Created by WZ on 16/5/19.
//  Copyright © 2016年 lihegong. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = MyBlueColor;
        [self initView];
        
    }
    return self;
}
- (void)initView{
//    self.imageView = [UIImageView new];
//    [self addSubview:self.imageView];
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self);
//        make.size.mas_equalTo(self);
//    }];
//    self.backView = [UIView new];
//    self.backView.backgroundColor = [UIColor blackColor];
////    self.backView.alpha = 0.2;
//    [self addSubview:self.backView];
//    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_imageView);
//        make.bottom.mas_equalTo(_imageView.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(_imageView.width, _imageView.height/3));
//    }];
    self.name = [self label:self font:12];
    _name.textAlignment = NSTextAlignmentCenter;
    _name.numberOfLines = 0;
   // self.type = [self label:self font:6];
    //self.date = [self label:self font:6];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(self);
    }];
}
- (void)setModel:(NSObject *)model{
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (UILabel *)label:(UIView *)subView font:(CGFloat)font{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:font];
    [subView addSubview:label];
    return label;
}
@end
