//
//  TrendModel.m
//  xiaoshidai
//
//  Created by XSD on 16/10/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "TrendModel.h"

@implementation TrendModel

@end
@implementation TrendInfo

+ (NSDictionary *)objectClassInArray{
    return @{@"service_fee" : [TrendService_Fee class], @"deal_rate" : [TrendDeal_Rate class], @"deal_amount" : [TrendDeal_Amount class], @"loan_amount" : [TrendLoan_Amount class], @"enter_amount" : [TrendEnter_Amount class],@"balance":[SerFeeBalance class],@"detail":[SerFeeDetail class],@"trend":[SerFeeTrend class],@"rank":[SerFeeRank class]};
}
@end
@implementation SerFeeRank

@end


@implementation SerFeeTrend

@end


@implementation SerFeeDetail

@end


@implementation SerFeeBalance

@end

@implementation TrendService_Fee

@end


@implementation TrendDeal_Rate

@end


@implementation TrendDeal_Amount

@end


@implementation TrendLoan_Amount

@end


@implementation TrendEnter_Amount

@end


