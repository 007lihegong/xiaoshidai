//
//  UUBar.m
//  UUChartDemo
//
//  Created by 2014-763 on 15/3/12.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "SCBar.h"
#import "SCColor.h"
#import "ServiceFeeController.h"
@interface SCBar (){
    UILabel * label;
}
@end
@implementation SCBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        label  = [UILabel new];
        label.hidden = YES;
		_chartLine = [CAShapeLayer layer];
		_chartLine.lineCap = kCALineCapSquare;
		_chartLine.fillColor   = [[UIColor whiteColor] CGColor];
		_chartLine.lineWidth   = self.frame.size.width;
		_chartLine.strokeEnd   = 0.0;
		self.clipsToBounds = YES;
		[self.layer addSublayer:_chartLine];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
//		self.layer.cornerRadius = 2.0; // 直接设置layer会造成卡顿
    }
    return self;
}

-(void)setGrade:(float)grade
{
    if (grade==0)
    return;
    
	_grade = grade;
	UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height+30)];
	[progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - grade) * self.frame.size.height+15)];
	
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
	_chartLine.path = progressline.CGPath;

	if (_barColor) {
		_chartLine.strokeColor = [_barColor CGColor];
	}else{
		_chartLine.strokeColor = [SCGreen CGColor];
	}
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 2.0;
}

- (void)drawRect:(CGRect)rect
{
	//Draw BG
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextFillRect(context, rect);
    
}

-(void)tap:(UIGestureRecognizer *)tap{
    //SCBar *bar = (SCBar *)tap.view;
   // NSLog(@"%@",bar.valueStr);
    UIEvent *event = [[UIEvent alloc] init];
    NSSet *touches =  [event allTouches];
    [self touchesBegan:touches withEvent:event];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchPoint:touches withEvent:event];
    //[self touchKeyPoint:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self touchPoint:touches withEvent:event];
   // [self touchKeyPoint:touches withEvent:event];
}

- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event {
    // Get the point user touched
   // UITouch *touch = [touches anyObject];
   // CGPoint touchPoint = [touch locationInView:self];
    [self addSubview:label];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:11];
    label.text = self.valueStr;
    label.textAlignment = NSTextAlignmentCenter;
    label.hidden = !label.hidden;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.width.mas_equalTo(self.width);
    }];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:11];
    
}

- (void)touchKeyPoint:(NSSet *)touches withEvent:(UIEvent *)event {
    // Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];

    [self addSubview:label];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:11];
    label.text = self.valueStr;
    label.hidden = !label.hidden;

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(touchPoint.y);
        make.width.mas_equalTo(self.width);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:11];
}


@end
