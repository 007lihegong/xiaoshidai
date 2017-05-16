//
//  AppDelegate.h
//  xiaoshidai
//
//  Created by 名侯 on 16/9/20.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfo;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic ,assign) NSInteger refresh;//用户反向页面刷新 2.表示详情页需要刷新 3.表示未读已读刷新(所有列表)
@property (strong, nonatomic) NSString *JPushID;//推送设备编号
@property (strong, nonatomic) NSString *OperationStr;//操作人
@property (assign) BOOL network;
-(AFHTTPSessionManager *)sharedHTTPSession;
-(AFURLSessionManager *)sharedURLSession;
-(void)connectRCIMWithtoken:(NSString *)token;
-(void)syncGroupWithUserID:(UserInfo *)userInfo;
@end

