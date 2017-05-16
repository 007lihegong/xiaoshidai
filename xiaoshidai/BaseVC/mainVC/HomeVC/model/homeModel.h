//
//  homeModel.h
//  xiaoshidai
//
//  Created by 名侯 on 16/9/23.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeModel : NSObject 

@property (nonatomic, strong) NSString *order_nid;
@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, strong) NSString *agency_type;//征信状态：1～4
@property (nonatomic, strong) NSString *apply_amount;//资金需求
@property (nonatomic, strong) NSString *has_car;//是否有车 1.是 2.否（下同）
@property (nonatomic, strong) NSString *has_guarantee_slip;//是否有保单
@property (nonatomic, strong) NSString *has_house;//是否有房
@property (nonatomic, strong) NSString *has_house_fund;//是否有公积金
@property (nonatomic, strong) NSString *has_social_security;//是否有社保
@property (nonatomic, strong) NSString *realname;//
@property (nonatomic, strong) NSString *department_name_author;//店名
@property (nonatomic, strong) NSString *is_read;//
@property (nonatomic, strong) NSString *loan_type;//贷款类型 month_income
@property (nonatomic, strong) NSString *month_income;//个人工资
@property (nonatomic, strong) NSString *order_status_txt;
@property (nonatomic, strong) NSString *job_type;//职业身份
@property (nonatomic, strong) NSString *month_income_type;//工资形势
@end
