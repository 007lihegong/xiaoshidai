//
//  BaseRequest.h
//  xiaoshidai
//
//  Created by XSD on 16/11/15.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface BaseRequest : NSObject
+ (void)post:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)postImg:(NSString *)URLString parameters:(id)parameters sendImage:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;
- (UIViewController *)getCurrentVC;
#pragma mark -- 未登录口令
+ (NSString *)setApiTokenStr;
#pragma mark -- 登录后口令
+ (NSString *)setUserTokenStr:(NSArray *)pri;
+ (NSString *)setRSAencryptString:(NSString *)encryptStr;
@end
