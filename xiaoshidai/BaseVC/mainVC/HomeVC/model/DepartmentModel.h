//
//  DepartmentModel.h
//  xiaoshidai
//
//  Created by XSD on 16/9/30.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DepTs;
@interface DepartmentModel : NSObject
@property (nonatomic ,copy)   NSString *msg;
@property (nonatomic ,strong) NSArray <DepTs *> * data;
@property (nonatomic ,copy)   NSString *code;
@end
@interface DepTs : NSObject
@property (nonatomic, copy) NSString * department_id;
@property (nonatomic, copy) NSString * department_name;
@property (nonatomic, copy) NSString * operator_id;
@property (nonatomic, copy) NSString * operator_name;
@end
