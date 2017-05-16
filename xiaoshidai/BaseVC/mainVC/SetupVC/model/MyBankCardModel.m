//
//  MyBankCardModel.m
//  xiaoshidai
//
//  Created by XSD on 2017/1/6.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "MyBankCardModel.h"

@implementation MyBankCardModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"data" : [BankData class]};
    
}
@end

@implementation BankData

@end
