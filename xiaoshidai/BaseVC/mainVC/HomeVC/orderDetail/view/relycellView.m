//
//  relycellView.m
//  xiaoshidai
//
//  Created by 名侯 on 16/9/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "relycellView.h"
#import "Defines.h"
#import "BaseVC.h"
#import "UIView+SDAutoLayout.h"

@implementation relycellView
{
    UILabel *_company;
    UILabel *_loan;
    UILabel *_interest;
    UILabel *_time;
    UILabel *_comment;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
#pragma mark -- 布局
- (void)setUp {
    
    _company = [UILabel new];
    _company.textColor = colorValue(0x333333, 1);
    _company.font = [UIFont systemFontOfSize:12];
    [self addSubview:_company];
    
    _loan = [UILabel new];
    _loan.textAlignment = NSTextAlignmentRight;
    _loan.textColor = colorValue(0x333333, 1);
    _loan.font = [UIFont systemFontOfSize:12];
    [self addSubview:_loan];
    
    _interest = [UILabel new];
    _interest.textColor = colorValue(0x111111, 1);
    _interest.font = [UIFont systemFontOfSize:12];
    [self addSubview:_interest];
    
    _time = [UILabel new];
    _time.textAlignment = NSTextAlignmentRight;
    _time.textColor = colorValue(0x111111, 1);
    _time.font = [UIFont systemFontOfSize:12];
    [self addSubview:_time];
    
    _comment = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth-60, 15)];
    _comment.textColor = colorValue(0x666666, 1);
    _comment.font = [UIFont systemFontOfSize:11];
    _comment.numberOfLines=0;
    [self addSubview:_comment];
    
    CGFloat W = (ScreenWidth-60)/2;
    
    UILabel *interestLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, W, 15)];
    interestLB.text = LocalizationNotNeeded(@"预计贷款利率");
    interestLB.textColor = colorValue(0x666666, 1);
    interestLB.font = [UIFont systemFontOfSize:11];
    [self addSubview:interestLB];
    
    UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(W, 30, W, 15)];
    timeLB.text = LocalizationNotNeeded(@"预计放款时间");
    timeLB.textAlignment = NSTextAlignmentRight;
    timeLB.textColor = colorValue(0x666666, 1);
    timeLB.font = [UIFont systemFontOfSize:10];
    [self addSubview:timeLB];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat W = (ScreenWidth-60)/2;
    _company.frame = CGRectMake(0, 5, W, 15);
    _loan.frame = CGRectMake(W, 5, W, 15);
    _interest.frame = CGRectMake(0, 55, W, 15);
    _time.frame = CGRectMake(W, 55, W, 15);
}
- (void)setModel:(ordDetailModel *)model {
    
    _model = model;
   
    _company.text = model.channel_name;
    _loan.text = model.loan_type;
    _interest.text = model.loan_prerate;
    _time.text = model.loan_pretime;
    
    NSString *moneyStr = [NSString stringWithFormat:@"方案内容：%@",[XYString changeFloatWithString:model.solution_detail]];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:avoidNullStr(moneyStr)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:colorValue(0x111111, 1) range:NSMakeRange(0, 5)];
    _comment.attributedText = attributedString;
    [_comment sizeToFit];
    
}

- (CGFloat)setHeaght {
    return CGRectGetMaxY(_comment.frame)+10;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
