//
//  BaseVC.h
//  kuangjia
//
//  Created by 名侯 on 16/8/15.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "XYString.h"
#import "LCProgressHUD.h"
#import "Defines.h"
#import "UIView+XBExtension.h"
#import "MyControl.h"
#import "MJExtension.h"

@interface BaseVC : UIViewController
{
    AppDelegate *appdelegate;
}

//导航栏返回
-(void)setBack:(NSString *)imgName;
-(void)backAction;
//修改导航右边按钮--图片类型
-(void)setNavRightBtnWithImgName:(NSString *)imagename;
//修改导航右边按钮--文字类型
-(void)setNavRightBtnWithString:(NSString *)string;
//修改导航右边按钮--view
-(void)setNarRightBtnWithView:(UIView *)view;
//右边自定义--单个按钮点击事件
-(void)rightAction;
//修改导航titleview
-(void)setNavTitleView:(UIView *)titleview;
//设置边框
-(void)setBorder:(UIView *)view size:(float)size;
//设置边框+颜色
-(void)setBorder:(UIView *)view size:(float)size withColor:(UIColor *)color;
//设置成圆形
-(void) setYuan:(UIView *)view size:(double)size;
//设置分割线
-(void)addFenGeXian:(UIView *)view andRect:(CGRect)rect;
-(void)addFenGeXian:(UIView *)view andRect:(CGRect)rect withColor:(UIColor *)color;
//设置view居中
-(void)setViewInCenterByX:(UIView *)view fatherView:(UIView *)fatherViiew;
//
-(void)setViewInCenterByX:(UIView *)view fatherViewWidth:(double)fatherWidth;
//自定义一个像素的线
- (void)PixeOrigin:(CGPoint)origin length:(CGFloat)length isVertical:(BOOL)isVertical color:(UIColor *)color add:(UIView *)supview;
//默认水平线
- (void)PixeH:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview;
- (void)PixeHead:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview;
//默认垂直线
- (void)PixeV:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview;
//网络请求AFN
- (void)post:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//上传图片网络请求
- (void)postImg:(NSString *)URLString parameters:(id)parameters sendImage:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//-------------------------------------------------  项目中定义  -----------------------------------------------------------
#pragma mark -- RSA加密
- (NSString *)setRSAencryptString:(NSString *)encryptStr;
#pragma mark -- 未登录口令
- (NSString *)setApiTokenStr;
#pragma mark -- 登录后口令
- (NSString *)setUserTokenStr:(NSArray *)pri;
#pragma mark -- 权限数组
- (NSArray *)getPermissionsArr;
#pragma mark -- 角色分类
- (NSInteger)getroleClass;

@end
