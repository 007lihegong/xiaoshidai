//
//  OrderDetailModel.h
//  xiaoshidai
//
//  Created by XSD on 16/10/16.
//  Copyright © 2016年 lihegong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderData,User_Assets_Info,User_Base_Info,Other_Pic_Show,User_Credit_Info,Order_Info,Reply_Info;
@interface OrderDetailModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) OrderData *data;

@property (nonatomic, copy) NSString *code;

@end
@interface OrderData : NSObject

@property (nonatomic, strong) NSArray *channel_info;

@property (nonatomic, strong) User_Assets_Info *user_assets_info;

@property (nonatomic, strong) User_Base_Info *user_base_info;

@property (nonatomic, strong) Order_Info *order_info;

@property (nonatomic, strong) NSArray<Reply_Info *> *reply_info;

@property (nonatomic, strong) User_Credit_Info *user_credit_info;

@end

@interface User_Assets_Info : NSObject

@property (nonatomic, copy) NSString *car_buyonce;

@property (nonatomic, copy) NSString *house_paperwork;

@property (nonatomic, copy) NSString *house_kind;

@property (nonatomic, copy) NSString *house_togather;

@property (nonatomic, copy) NSString *has_car;

@property (nonatomic, copy) NSString *car_buytime;

@property (nonatomic, copy) NSString *car_brand;

@property (nonatomic, copy) NSString *house_mortgage;

@property (nonatomic, copy) NSString *car_nudeprice;

@property (nonatomic, copy) NSString *house_price;

@property (nonatomic, copy) NSString *house_buytime;

@property (nonatomic, copy) NSString *has_house;

@property (nonatomic, copy) NSString *house_style;

@property (nonatomic, copy) NSString *house_district;

@end

@interface User_Base_Info : NSObject

@property (nonatomic, copy) NSString *residence_city_name;

@property (nonatomic, copy) NSString *other_pic;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *residence_province;

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, copy) NSString *is_local;

@property (nonatomic, copy) NSString *loan_type;

@property (nonatomic, copy) NSString *apply_rate;

@property (nonatomic, copy) NSString *residence_province_name;

@property (nonatomic, copy) NSString *department_name_to;

@property (nonatomic, copy) NSString *apply_amount;

@property (nonatomic, strong) NSArray<Other_Pic_Show *> *other_pic_show;

@property (nonatomic, copy) NSString *notes;

@property (nonatomic, copy) NSString *marriage;

@property (nonatomic, copy) NSString *client_source;

@property (nonatomic, copy) NSString *id_number;

@property (nonatomic, copy) NSString *department_id_to;

@property (nonatomic, copy) NSString *residence_city;

@end

@interface Other_Pic_Show : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *path;

@end

@interface User_Credit_Info : NSObject

@property (nonatomic, copy) NSString *debt_money;

@property (nonatomic, copy) NSString *has_guarantee_slip;

@property (nonatomic, copy) NSString *has_social_security;

@property (nonatomic, copy) NSString *house_fund_money;

@property (nonatomic, copy) NSString *debt_type;

@property (nonatomic, copy) NSString *salary_type;

@property (nonatomic, copy) NSString *agency_type;

@property (nonatomic, copy) NSString *social_security_contribute;

@property (nonatomic, copy) NSString *guarantee_company;

@property (nonatomic, copy) NSString *has_debt;

@property (nonatomic, copy) NSString *industry;

@property (nonatomic, copy) NSString *salary_money;

@property (nonatomic, copy) NSString *job_type;

@property (nonatomic, copy) NSString *guarantee_buytime;

@property (nonatomic, copy) NSString *guarantee_money;

@property (nonatomic, copy) NSString *has_house_fund;

@property (nonatomic, copy) NSString *agency_querytimes;

@property (nonatomic, copy) NSString *guarantee_years;

@property (nonatomic, copy) NSString *month_money;

@property (nonatomic, copy) NSString *company_type;

@property (nonatomic, copy) NSString *social_security_money;

@end

@interface Order_Info : NSObject

@property (nonatomic, copy) NSString *operator_id_author_txt;

@property (nonatomic, copy) NSString *operator_id_author;

@property (nonatomic, copy) NSString *order_status;

@property (nonatomic, copy) NSString *order_nid;

@property (nonatomic, copy) NSString *order_status_txt;

@end

@interface Reply_Info : NSObject

@property (nonatomic, copy) NSString *reply_type_small;

@property (nonatomic, copy) NSString *reply_time;

@property (nonatomic, copy) NSString *operator_id_reply;

@property (nonatomic, copy) NSString *reply_text;

@property (nonatomic, copy) NSString *reply_department;

@property (nonatomic, copy) NSString *reply_person;

@end

