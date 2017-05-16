//
//  ProductModel.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/2.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [ProductInfo class]};
    
}
@end


@implementation ProductInfo

@end
