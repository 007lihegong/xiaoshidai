//
//  LianLianBankModel.h
//  xiaoshidai
//
//  Created by XSD on 2017/1/9.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BankCardData;

@interface LianLianBankModel : NSObject
@property (nonatomic , copy)    NSString                   * msg;
@property (nonatomic , strong) NSArray<BankCardData *>     * data;
@property (nonatomic , copy)    NSString                   * code;
@end

@interface BankCardData :NSObject
/**
 银行代码
 */
@property (nonatomic , copy) NSString              * key;
/**
 银行名称
 */
@property (nonatomic , copy) NSString              * value;
@end
