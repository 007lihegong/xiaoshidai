//
//  HZTextField.m
//  猴子微博
//
//  Created by 名侯 on 15/10/17.
//  Copyright (c) 2015年 名侯. All rights reserved.
//

#import "HZTextField.h"
#import "UIView+XBExtension.h"

@implementation HZTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:13];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seach_2"]];
        self.leftView = image;
        //默认不显示，设置总是显示
        self.leftViewMode = UITextFieldViewModeAlways;
        //调整位置
        self.leftView.width +=16;
        image.contentMode = UIViewContentModeCenter;

    }
    return self;
}

@end
