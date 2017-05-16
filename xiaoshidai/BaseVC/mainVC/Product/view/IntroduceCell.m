//
//  IntroduceCell.m
//  xiaoshidai
//
//  Created by XSD on 2017/2/9.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "IntroduceCell.h"

@implementation IntroduceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.bounds = [UIScreen mainScreen].bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
