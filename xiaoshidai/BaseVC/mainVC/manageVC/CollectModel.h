//
//  CollectModel.h
//  xiaoshidai
//
//  Created by XSD on 16/10/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CollectInfo;
@interface CollectModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSArray<CollectInfo *> *data;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *total;

@end



@interface CollectInfo : NSObject

@property (nonatomic, copy) NSString *collect_title;

@property (nonatomic, copy) NSString *collect_value;

@property (nonatomic, copy) NSString *collect_name;

@end

