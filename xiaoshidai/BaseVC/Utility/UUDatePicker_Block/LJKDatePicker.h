//
//  LJKDatePicker.h
//  网众
//
//  Created by ljk on 15/7/6.
//  Copyright (c) 2015年 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUDatePicker.h"
@protocol LJKDatePickerDelegate <NSObject>
- (void)ljkBtnClick:(UIButton *)button ;
@optional

@end
@interface LJKDatePicker : UIView<UUDatePickerDelegate>
@property(nonatomic,strong)UIButton   *lconfirm;
@property(nonatomic,strong)UIButton   *lcancel;

@property(nonatomic,strong)UUDatePicker   *dater;
@property(nonatomic,strong)NSString   *year;
@property(nonatomic,strong)NSString   *month;
@property(nonatomic,strong)NSString   *day;
@property (nonatomic, assign) id <LJKDatePickerDelegate> delegate;


@end
