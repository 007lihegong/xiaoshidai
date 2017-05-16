//
//  LianPayModel.h
//  xiaoshidai
//
//  Created by XSD on 2017/1/12.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLOrder.h"
#import "LLPaySdk.h"
@class LianPaData;
@interface LianPayModel : NSObject
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) LianPaData             * data;
@property (nonatomic , copy) NSString              * code;
@end

@interface LianPaData :NSObject

-(LLOrder *)getLLOrderFrom:(LianPaData *)data;
/**
 签名
 */
@property (nonatomic , copy) NSString              * sign;
/**
 订单描述
 */
@property (nonatomic , copy) NSString              * info_order;
/**
 商户业务类型:虚拟商品销售101001;实物商品销售109001
 */
@property (nonatomic , copy) NSString              * busi_partner;
/**
 商品名称
 */
@property (nonatomic , copy) NSString              * name_goods;
/**
 连连支付异步通过URL
 */
@property (nonatomic , copy) NSString              * notify_url;
/**
 银行卡号
 */
@property (nonatomic , copy) NSString              * card_no;
/**
 银行账号姓名
 */
@property (nonatomic , copy) NSString              * acct_name;
/**
 商户编号
 */
@property (nonatomic , copy) NSString              * oid_partner;
/**
 商户用户唯一编号
 */
@property (nonatomic , copy) NSString              * user_id;
/**
 商户订单时间
 */
@property (nonatomic , copy) NSString              * dt_order;
/**
 风险参数
 */
@property (nonatomic , copy) NSString              * risk_item;
/**
 证件号码
 */
@property (nonatomic , copy) NSString              * id_no;
/**
 请求应用标识
 */
@property (nonatomic , copy) NSString              * app_request;
/**
 交易金额
 */
@property (nonatomic , copy) NSString              * money_order;
/**
 签名方式
 */
@property (nonatomic , copy) NSString              * sign_type;
/**
 商户唯一订单号
 */
@property (nonatomic , copy) NSString              * no_order;
/**
 订单有效期，30分钟
 */
@property (nonatomic , copy) NSString              * valid_order;
/**
 签约号
 */
@property (nonatomic , copy) NSString              * no_agree;
@end
