//
//  PayListModel.h
//  xiaoshidai
//
//  Created by XSD on 2017/1/5.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PayData ;

@interface PayListModel : NSObject
@property (nonatomic , copy) NSString * msg;

@property (nonatomic , strong) NSArray<PayData *> * data;

@property (nonatomic , copy) NSString * code;
@end

@interface PayData :NSObject
/**
 支付类目
 */
@property (nonatomic , copy) NSString * item_type;
/**
 收取人姓名，已完成才有，其余为空
 */
@property (nonatomic , copy) NSString * operator_name_pay;
/**
 渠道名称
 */
@property (nonatomic , copy) NSString * channel_name;

/**
 待收款项自增ID
 */
@property (nonatomic , copy) NSString * receipt_id;
/**
 支付状态文本值
 */
@property (nonatomic , copy) NSString * pay_status_txt;

/**
 支付状态1待支付 2待审核 3已驳回 4支付失败 5已完成
 */
@property (nonatomic , copy) NSString * pay_status;
/**
 支付类目文本值
 */
@property (nonatomic , copy) NSString * item_type_txt;
/**
 客户姓名
 */
@property (nonatomic , copy) NSString * realname_client;
/**
 支付金额，元
 */
@property (nonatomic , copy) NSString * money;

@end
