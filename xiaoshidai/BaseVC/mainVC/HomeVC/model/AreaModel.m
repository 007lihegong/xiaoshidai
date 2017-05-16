//
//  AreaModel.m
//  xiaoshidai
//
//  Created by XSD on 16/10/9.
//  Copyright © 2016年 lihegong. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel


+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [AreaData class]};
}
@end

@implementation AreaData

+ (NSDictionary *)objectClassInArray{
    return @{@"children" : [AreaChildren class]};
}

@end


@implementation AreaChildren

@end


