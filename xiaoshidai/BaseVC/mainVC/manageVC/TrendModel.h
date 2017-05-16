//
//  TrendModel.h
//  xiaoshidai
//
//  Created by XSD on 16/10/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  SerFeeRank,SerFeeTrend,SerFeeDetail,SerFeeBalance,TrendInfo,TrendService_Fee,TrendDeal_Rate,TrendDeal_Amount,TrendLoan_Amount,TrendEnter_Amount;
@interface TrendModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) TrendInfo *data;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *total;

@end
@interface TrendInfo : NSObject

@property (nonatomic, strong) NSArray<TrendService_Fee *> *service_fee;

@property (nonatomic, strong) NSArray<TrendDeal_Rate *> *deal_rate;

@property (nonatomic, strong) NSArray<TrendDeal_Amount *> *deal_amount;

@property (nonatomic, strong) NSArray<TrendLoan_Amount *> *loan_amount;

@property (nonatomic, strong) NSArray<TrendEnter_Amount *> *enter_amount;

@property (nonatomic, strong) NSArray<SerFeeBalance *> *balance;

@property (nonatomic, strong) NSArray<SerFeeDetail *> *detail;

@property (nonatomic, strong) NSArray<SerFeeTrend *> *trend;

@property (nonatomic, strong) NSArray<SerFeeRank *> *rank;


@end

@interface SerFeeDetail : NSObject

@property (nonatomic, copy) NSString *x_axis;

@property (nonatomic, copy) NSString *y_axis;

@end

@interface SerFeeBalance : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *value;

@end

@interface SerFeeTrend : NSObject

@property (nonatomic, copy) NSString *x_axis;

@property (nonatomic, copy) NSString *y_axis;

@end

@interface SerFeeRank : NSObject

@property (nonatomic, copy) NSString *x_axis;

@property (nonatomic, copy) NSString *y_axis;

@end

@interface TrendService_Fee : NSObject

@property (nonatomic, copy) NSString *x_axis;

@property (nonatomic, copy) NSString *y_axis;

@end

@interface TrendDeal_Rate : NSObject

@property (nonatomic, copy) NSString *x_axis;

@property (nonatomic, copy) NSString *y_axis;

@end

@interface TrendDeal_Amount : NSObject

@property (nonatomic, copy) NSString *x_axis;

@property (nonatomic, copy) NSString *y_axis;

@end

@interface TrendLoan_Amount : NSObject

@property (nonatomic, copy) NSString *x_axis;

@property (nonatomic, copy) NSString *y_axis;

@end

@interface TrendEnter_Amount : NSObject

@property (nonatomic, copy) NSString *x_axis;

@property (nonatomic, copy) NSString *y_axis;

@end

