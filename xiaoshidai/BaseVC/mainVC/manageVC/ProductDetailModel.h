//
//  ProductDetailModel.h
//  xiaoshidai
//
//  Created by XSD on 2016/12/8.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProductDetailInfo;
@interface ProductDetailModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) ProductDetailInfo *data;

@property (nonatomic, copy) NSString *msg;

@end


@interface ProductDetailInfo : NSObject

@property (nonatomic, copy) NSString * product_id;

@property (nonatomic, copy) NSString * product_name;

@property (nonatomic, copy) NSString *type_id;

@property (nonatomic, copy) NSString *type_name;

@property (nonatomic, copy) NSString *company_id;

@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSString *interest_rate;
@property (nonatomic, copy) NSString *age_min;
@property (nonatomic, copy) NSString *age_max;
@property (nonatomic, copy) NSString *sex_limit;

@property (nonatomic, copy) NSString *money_min;

@property (nonatomic, copy) NSString *money_max;
@property (nonatomic, copy) NSString *period_min;
@property (nonatomic, copy) NSString *period_max;

@property (nonatomic, copy) NSString *job_limit;

@property (nonatomic, copy) NSString *agency_limit;
@property (nonatomic, copy) NSString *car_limit;
@property (nonatomic, copy) NSString *house_limit;
@property (nonatomic, copy) NSString *advantage;
@property (nonatomic, copy) NSString *disadvantage;
@property (nonatomic, copy) NSString *enter_require;
@property (nonatomic, copy) NSString *prepare_doc;
@property (nonatomic, copy) NSString *suggestion;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *status_txt;
@end
