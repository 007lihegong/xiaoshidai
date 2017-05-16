//
//  PNChartLabel.m
//  PNChart
//
//  Created by 2014-763 on 15/3/12.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "SCChartLabel.h"
#import "SCColor.h"

@implementation SCChartLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setLineBreakMode:NSLineBreakByWordWrapping];
        [self setMinimumScaleFactor:5.0f];
        [self setNumberOfLines:1];
        if (iPhone6) {
            [self setFont:[UIFont boldSystemFontOfSize:8.0f]];
        }else if (iPhone5s ||iPhone4s){
            [self setFont:[UIFont boldSystemFontOfSize:6.0f]];
        }else{
            [self setFont:[UIFont boldSystemFontOfSize:10.0f]];
        }
        [self setTextColor: SCDeepGrey];
        self.backgroundColor = [UIColor clearColor];
        [self setTextAlignment:NSTextAlignmentCenter];
        //[self setTransform:CGAffineTransformMakeRotation(M_PI/9)];
        self.userInteractionEnabled = YES;
    }
    return self;
}


@end
