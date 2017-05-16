//
//  AreaModel.h
//  xiaoshidai
//
//  Created by XSD on 16/10/9.
//  Copyright © 2016年 lihegong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AreaData,AreaChildren;
@interface AreaModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<AreaData *> *data;

@property (nonatomic, copy) NSString *code;

@end
@interface AreaData : NSObject

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *label;

@property (nonatomic, strong) NSArray<AreaChildren *> *children;

@end

@interface AreaChildren : NSObject

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *label;

@end

