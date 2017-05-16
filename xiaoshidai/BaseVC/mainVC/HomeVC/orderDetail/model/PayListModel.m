//
//  PayListModel.m
//  xiaoshidai
//
//  Created by XSD on 2017/1/5.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "PayListModel.h"
@class PayData ;
@implementation PayListModel
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [PayData class]};
}

@end

@implementation PayData

@end
