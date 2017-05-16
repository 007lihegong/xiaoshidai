//
//  ProductModel.h
//  xiaoshidai
//
//  Created by XSD on 2016/12/2.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  ProductInfo;
@interface ProductModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSArray<ProductInfo *> *data;

@property (nonatomic, copy) NSString *msg;

@end


@interface ProductInfo : NSObject

@property (nonatomic, copy) NSString *product_id;

@property (nonatomic, copy) NSString *product_name;

@property (nonatomic, copy) NSString *interest_rate;

@property (nonatomic, copy) NSString *money_min;

@property (nonatomic, copy) NSString *money_max;

@property (nonatomic, copy) NSString *car_limit;

@property (nonatomic, copy) NSString *house_limit;

@property (nonatomic, copy) NSString *agency_limit;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *status_txt;

@end
