//
//  LJKDatePicker.m
//  网众
//
//  Created by ljk on 15/7/6.
//  Copyright (c) 2015年 ZM. All rights reserved.
//

@implementation LJKDatePicker
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"YYYYMMdd"];

        NSString *  locationString=[dateformatter stringFromDate:senddate];

        NSString   *year=[locationString substringWithRange:NSMakeRange(0, 4)];
        _year=year;

        NSString   *month=[locationString  substringWithRange:NSMakeRange(4, 2)];
        _month=month;

        NSString   *day=[locationString  substringWithRange:NSMakeRange(6, 2)];
        _day=day;
    
        
    
        self.backgroundColor = RGBColor(237, 237, 237);
        [self  showInterface];
    }
    return self;
}
-(void)showInterface{
    UILabel  *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width-70, 40)];
    label.text=LocalizationNotNeeded(@"     请选择");
    label.textColor=[UIColor blackColor];
    [self  addSubview:label];
    
    _lconfirm=[UIButton  buttonWithType:UIButtonTypeCustom];
    [_lconfirm  setFrame:CGRectMake(kScreen_Width-70, 0, 70, 40)];
    [_lconfirm    setTitle:LocalizationNotNeeded(@"确定") forState:UIControlStateNormal];
    [_lconfirm   setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_lconfirm    addTarget:self action:@selector(btnCilik:) forControlEvents:UIControlEventTouchUpInside];
    [self  addSubview:_lconfirm];
    
    _dater=[[UUDatePicker alloc]initWithframe:CGRectMake(0, 40, kScreen_Width, 160) Delegate:self PickerStyle:UUDateStyle_YearMonthDay];
    _dater.delegate=self;
   // _dater.minLimitDate = [NSDate date];
    _dater.maxLimitDate = [NSDate date];

    [self  addSubview:_dater];
    
}

-(void)btnCilik:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ljkBtnClick:)]) {
        [self.delegate ljkBtnClick:sender];
    }
}
-(void)uuDatePicker:(UUDatePicker *)datePicker year:(NSString *)year month:(NSString *)month day:(NSString *)day hour:(NSString *)hour minute:(NSString *)minute weekDay:(NSString *)weekDay{
    self.year=year;
    self.month=month;
    self.day=day;
}
@end
