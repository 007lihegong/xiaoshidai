//
//  UserInfoModel.h
//  xiaoshidai
//
//  Created by XSD on 16/11/15.
//  Copyright © 2016年 XSD. All rights reserved.
//
#import <Foundation/Foundation.h>
@class UserInfo;
@interface UserInfoModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSArray<UserInfo *> *data;

@property (nonatomic, copy) NSString *msg;

@end

@interface UserInfo : RCUserInfo <NSCoding>

@property (nonatomic, copy) NSString *portrait_uri;

@property (nonatomic, copy) NSString *display_name;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *department_name;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *user_id;
@end
