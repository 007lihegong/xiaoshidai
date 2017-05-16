//
//  OrderDetailModel.m
//  xiaoshidai
//
//  Created by XSD on 16/10/16.
//  Copyright © 2016年 lihegong. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

@end
@implementation OrderData

+ (NSDictionary *)objectClassInArray{
    return @{@"reply_info" : [Reply_Info class]};
}

@end


@implementation User_Assets_Info

@end


@implementation User_Base_Info

+ (NSDictionary *)objectClassInArray{
    return @{@"other_pic_show" : [Other_Pic_Show class]};
}

@end


@implementation Other_Pic_Show

@end


@implementation User_Credit_Info

@end


@implementation Order_Info

@end


@implementation Reply_Info

@end


