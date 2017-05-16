//
//  MyBankCardModel.h
//  xiaoshidai
//
//  Created by XSD on 2017/1/6.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BankData;

@interface MyBankCardModel : NSObject
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) NSArray<BankData *> * data;
@property (nonatomic , copy) NSString              * code;
@end

@interface BankData :NSObject
/**
 银行卡账号
 */
@property (nonatomic , copy) NSString              * bank_account;
/**
 开户行
 */
@property (nonatomic , copy) NSString              * branch;
/**
 市id
 */
@property (nonatomic , copy) NSString              * city_id;
/**
 绑定的自增ID
 */
@property (nonatomic , copy) NSString              * id;
/**
 银行名称
 */
@property (nonatomic , copy) NSString              * bank_name;
/**
 省id
 */
@property (nonatomic , copy) NSString              * province_id;
/**
 银行预留手机号
 */
@property (nonatomic , copy) NSString              * phone_reserved;
/**
 通过了认证的真实姓名
 */
@property (nonatomic , copy) NSString              * realname_operator;
/**
 通过了认证的身份证号码
 */
@property (nonatomic , copy) NSString              * id_number;
@end
