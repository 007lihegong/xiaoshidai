//
//  ItemCell.m
//  xiaoshidai
//
//  Created by XSD on 2017/2/9.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.bounds = [UIScreen mainScreen].bounds;
    [self setView:self.view1 Corner:2.5 backroundColor:UIColorFromRGB(0x41abf5)];
    [self setView:self.view2 Corner:2.5 backroundColor:UIColorFromRGB(0x41abf5)];
    [self setView:self.view3 Corner:2.5 backroundColor:UIColorFromRGB(0x41abf5)];
    
    [self.rangeLabel.layer setCornerRadius:10];
    [self.rangeLabel.titleLabel setTextColor:UIColorFromRGB(0x41abf5)];
    [self.rangeLabel.layer setBorderColor:UIColorFromRGB(0x41abf5).CGColor];
    [self.rangeLabel.layer setBorderWidth:1.0];
    self.rangeLabel.userInteractionEnabled = NO;
}
- (void)setView:(UIView *)view Corner:(CGFloat)r backroundColor:(UIColor *)color{
    [view.layer setCornerRadius:r];
    [view.layer setBackgroundColor:color.CGColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)setModel:(NSArray *)model{
    if ([model count] == 1) {
        self.contentLabel.text = model[0];
        //self.height.constant = 0;
        self.contentLabel2.text = nil;
        self.contentLabel3.text = nil;
        self.height.constant = 0;
        self.height0.constant = 0;
    }else{
        self.contentLabel.text = model[0];
        self.contentLabel2.text = model[1];
        self.contentLabel3.text = model[2];
       // self.height.constant = 42;
    }
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    [self setView:self.view1 Corner:2.5 backroundColor:UIColorFromRGB(0x41abf5)];
    [self setView:self.view2 Corner:2.5 backroundColor:UIColorFromRGB(0x41abf5)];
    [self setView:self.view3 Corner:2.5 backroundColor:UIColorFromRGB(0x41abf5)];
}
@end
