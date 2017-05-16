//
//  ordDetailModel.h
//  xiaoshidai
//
//  Created by 名侯 on 16/9/26.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ordDetailModel : NSObject
//渠道信息
@property (nonatomic, strong) NSString *channel_id;//渠道id
@property (nonatomic, strong) NSString *channel_status;//渠道状态
@property (nonatomic, strong) NSString *channel_status_txt;//状态文本值
@property (nonatomic, strong) NSString *loan_amount;//放款金额
@property (nonatomic, strong) NSString *loan_rate;//放款利率
@property (nonatomic, strong) NSString *service_fee;//服务费用
@property (nonatomic, strong) NSString *return_fee;//渠道返点费
@property (nonatomic, strong) NSString *pack_fee;//包装费
/**
 服务费用是否支付，0未生成待收数据 1生成待收数据待支付 2支付成功
 */
@property (nonatomic, strong) NSString *is_pay_service;
/**
 渠道返点费是否支付，0未生成待收数据 1生成待收数据待支付 2支付成功
 */
@property (nonatomic, strong) NSString *is_pay_return;
/**
 包装费是否支付，0未生成待收数据 1生成待收数据待支付 2支付成功
 */
@property (nonatomic, strong) NSString *is_pay_pack;
//用户基本信息
@property (nonatomic, strong) NSString *realname;//真实姓名
@property (nonatomic, strong) NSString *id_number;//身份证号
@property (nonatomic, strong) NSString *phone;//手机号
@property (nonatomic, strong) NSString *is_local;//是否本地户口
@property (nonatomic, strong) NSString *marriage;//婚姻状况 1.已婚 2.未婚 3.离异 4.丧偶
@property (nonatomic, strong) NSString *apply_amount;//资金需求
@property (nonatomic, strong) NSString *apply_rate;//利率要求
@property (nonatomic, strong) NSArray  *other_pic_show;//利率要求
@property (nonatomic, strong) NSString *path;//图片链接
@property (nonatomic, strong) NSString *notes;//备注
@property (nonatomic, strong) NSString *loan_type;//建议类型
@property (nonatomic, strong) NSString *department_id_to;//接受部门id
@property (nonatomic, strong) NSString *department_name_to;//接收部门
@property (nonatomic, strong) NSString *client_source;//客户来源
//用户资产信息
@property (nonatomic, strong) NSString *has_car;//是否有车
@property (nonatomic, strong) NSString *car_brand;//车辆型号
@property (nonatomic, strong) NSString *car_nudeprice;//裸车价格
@property (nonatomic, strong) NSString *car_buyonce;//是否全款购买
@property (nonatomic, strong) NSString *car_buytime;//车辆购买时间
@property (nonatomic, strong) NSString *has_house;//是否有房
@property (nonatomic, strong) NSString *house_togather;//房产是否共有
@property (nonatomic, strong) NSString *house_paperwork;//房产证件
@property (nonatomic, strong) NSString *house_kind;//房产性质
@property (nonatomic, strong) NSString *house_style;//房屋类型
@property (nonatomic, strong) NSString *house_mortgage;//是否有房贷
@property (nonatomic, strong) NSString *house_price;//房产购买价格
@property (nonatomic, strong) NSString *house_buytime;//房屋购买时间
@property (nonatomic, strong) NSString *house_district;//房产位置
//用户征信资料
@property (nonatomic, strong) NSString *agency_type;//征信情况
@property (nonatomic, strong) NSString *agency_querytimes;//查询次数
@property (nonatomic, strong) NSString *job_type;//职业身份
@property (nonatomic, strong) NSString *company_type;//工作单位
@property (nonatomic, strong) NSString *salary_type;//工资形式
@property (nonatomic, strong) NSString *salary_money;//工资发放金额
@property (nonatomic, strong) NSString *has_social_security;//是否有社保
@property (nonatomic, strong) NSString *social_security_contribute;//社保缴纳形式
@property (nonatomic, strong) NSString *social_security_money;//社保金额
@property (nonatomic, strong) NSString *has_house_fund;//是否有公积金
@property (nonatomic, strong) NSString *house_fund_money;//公积金金额
@property (nonatomic, strong) NSString *has_guarantee_slip;//是否有保单
@property (nonatomic, strong) NSString *guarantee_company;//投保公司名称
@property (nonatomic, strong) NSString *guarantee_buytime;//保险购买时间
@property (nonatomic, strong) NSString *guarantee_years;//保险年限
@property (nonatomic, strong) NSString *guarantee_money;//年缴纳金额
@property (nonatomic, strong) NSString *industry;//从事行业
@property (nonatomic, strong) NSString *month_money;//生意月流水
@property (nonatomic, strong) NSString *has_debt;//是否有负债
@property (nonatomic, strong) NSString *debt_type;//负债类型
@property (nonatomic, strong) NSString *debt_money;//负债金额
//订单信息
@property (nonatomic, strong) NSString *order_nid;//订单号
@property (nonatomic, strong) NSString *order_status;//订单状态
@property (nonatomic, strong) NSString *order_status_txt;//订单状态文本值
@property (nonatomic, strong) NSString *operator_id_author;//订单来源
@property (nonatomic, strong) NSString *operator_id_author_txt;//订单来源文本值
@property (nonatomic, strong) NSString *operator_id_solution;//接单人
@property (nonatomic, strong) NSString *operator_id_solution_txt;//接单人文本值
@property (nonatomic, strong) NSString *is_intime;//是否准时
@property (nonatomic, strong) NSString *is_change_rate;//利率是否变更
//订单进度信息
@property (nonatomic, strong) NSString *reply_type_small;//回复类型
@property (nonatomic, strong) NSString *reply_time;//回复时间
@property (nonatomic, strong) NSString *reply_person;//回复人
@property (nonatomic, strong) NSString *reply_department;//回复部门
@property (nonatomic, strong) NSString *reply_text;//回复内容
@property (nonatomic, strong) NSString *channel_name;//渠道名称
@property (nonatomic, strong) NSString *loan_prerate;//预期利率
@property (nonatomic, strong) NSString *loan_pretime;//预计放款时间
@property (nonatomic, strong) NSString *solution_detail;//方案内容

@property (nonatomic, strong) NSArray *reply_solution;//方案内容
@property (nonatomic, strong) NSDictionary *channel_extinfo;//已放款


@end
