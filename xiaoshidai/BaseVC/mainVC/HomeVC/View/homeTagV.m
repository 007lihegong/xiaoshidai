//
//  homeTagV.m
//  xiaoshidai
//
//  Created by 名侯 on 16/10/17.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "homeTagV.h"
#import "Defines.h"
#import "BaseVC.h"

@implementation homeTagV
{
    UILabel *tagLB;
    BaseVC *base;
    UILabel *titleLB;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp {
    
    base = [[BaseVC alloc] init];
    
    tagLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    tagLB.textAlignment = NSTextAlignmentCenter;
    tagLB.font = [UIFont systemFontOfSize:10];
    [self addSubview:tagLB];
    
    titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 12)];
    titleLB.textColor = colorValue(0x333333, 1);
    titleLB.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLB];
}

- (void)setType:(NSInteger)type {
    _type = type;
    if (self.type==1) {
        tagLB.text = @"金";
        tagLB.textColor = colorValue(0xfcbb4d, 1);
        [base setBorder:tagLB size:1 withColor:colorValue(0xfcbb4d, 1)];
        [base setYuan:tagLB size:3];
    }else if (self.type==2) {
        tagLB.text = @"房";
        tagLB.textColor = colorValue(0x41abf5, 1);
        [base setBorder:tagLB size:1 withColor:colorValue(0x41abf5, 1)];
        [base setYuan:tagLB size:3];
    }else if (self.type==3) {
        tagLB.text = @"保";
        tagLB.textColor = colorValue(0x4dd097, 1);
        [base setBorder:tagLB size:1 withColor:colorValue(0x4dd097, 1)];
        [base setYuan:tagLB size:3];
    }else if (self.type==4) {
        tagLB.text = @"逾";
        tagLB.textColor = colorValue(0xff7d5f, 1);
        [base setBorder:tagLB size:1 withColor:colorValue(0xff7d5f, 1)];
        [base setYuan:tagLB size:3];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    titleLB.text = title;
    CGFloat w = [XYString WidthForString:title withSizeOfFont:12];
    titleLB.width = w;
    self.width = 15+w;
}
@end
