//
//  BaseRequest.m
//  xiaoshidai
//
//  Created by XSD on 16/11/15.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "BaseRequest.h"
#import "loginVC.h"
@interface BaseRequest (){
    
    
}
@end
@implementation BaseRequest
#pragma mark -- 图片上传
+ (void)postImg:(NSString *)URLString parameters:(id)parameters sendImage:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSString *path = [NSString stringWithFormat:@"%@%@",IP,URLString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"pp%@%@.png", str,image];
    
    NSLog(@"文件名＝%@",fileName);
    // NSLog(@"url=%@",path);
    //NSLog(@"param=%@",parameters);
    
    [parameters setObject:@"plat" forKey:@"roleType"];
    [parameters setObject:@"ios" forKey:@"terminalType"];
    [parameters setObject:@"api" forKey:@"qType"];
    [parameters setObject:[self setRSAencryptString:@"order"] forKey:@"modelname"];
    [parameters setObject:[self setRSAencryptString:@"uploadedfile"] forKey:@"filename"];
    
    //    AFHTTPSessionManager *mar = [AFHTTPSessionManager manager];
    //这句没加 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *mar = [app sharedHTTPSession];
    mar.responseSerializer = [AFHTTPResponseSerializer serializer];
    mar.requestSerializer = [AFHTTPRequestSerializer serializer];
    mar.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    mar.requestSerializer.timeoutInterval = 30.f;
    
    [mar POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //        NSData *data = UIImagePNGRepresentation(image);
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:data name:@"uploadedfile" fileName:fileName mimeType:@"image/png"]; //可能image/png
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"进度:%f",uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"请求成功＝%@",dic[@"msg"]);
        if (success) {
            if (![XYString isDicNull:dic]) {
                success(dic);
            }else {
                [LCProgressHUD showMessage:@"服务器异常，稍后重试"];
                success(dic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败＝%@",error);
        if (app.network == YES) {
            [LCProgressHUD showFailure:@"服务器异常,请稍后重试"];
        }else{
            [LCProgressHUD showFailure:@"网络异常,请检查网络"];
        }
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)post:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"%@%@",IP,URLString];
    [parameters setObject:@"plat" forKey:@"roleType"];
    [parameters setObject:@"ios" forKey:@"terminalType"];
    [parameters setObject:@"api" forKey:@"qType"];
    NSLog(@"url=%@",path);
    //NSLog(@"参数=%@",parameters);
    
    //AFHTTPSessionManager *mar = [AFHTTPSessionManager manager];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *mar = [app sharedHTTPSession];
    //这句没加 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    mar.responseSerializer = [AFHTTPResponseSerializer serializer];
    mar.requestSerializer.timeoutInterval = 30.f;
    
    [mar POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //        NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"请求成功＝%@",dic[@"msg"]);
        if (success) {
            if (![XYString isDicNull:dic]) {
                if ([dic[@"code"] intValue]==1006||[dic[@"code"] intValue]==1005) {
                    [LCProgressHUD showMessage:@"登录状态失效，重新登录"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:user_ID];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:login_key];
                    BaseRequest *resquest = [[BaseRequest alloc] init];
                    UIViewController * vc = [resquest getCurrentVC];
                    loginVC *MVC = [[loginVC alloc] init];
                    [vc presentViewController:MVC animated:YES completion:nil];
                }else {
                    success(dic);
                }
            }else {
                [LCProgressHUD showMessage:@"服务器异常，稍后重试"];
                success(dic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败＝%@",error);
       AppDelegate * appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        if (appdelegate.network == YES) {
            [LCProgressHUD showFailure:@"服务器异常,请稍后重试"];
        }else{
            [LCProgressHUD showFailure:@"网络异常,请检查网络"];
        }
        if (failure) {
            failure(error);
        }
    }];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
#pragma mark -- 未登录口令
+ (NSString *)setApiTokenStr {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",a];
    NSString *JoinStr = [NSString stringWithFormat:@"%@XSDMARKET",timeString];
    // NSLog(@"没加密是＝%@",JoinStr);
    NSString *EncryptedStr = [Md5_f md5:JoinStr];
    NSString *token = [NSString stringWithFormat:@"%@_0_%@",EncryptedStr,timeString];
    
    return token;
}
#pragma mark -- 登录后口令
+ (NSString *)setUserTokenStr:(NSArray *)pri {
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:user_ID];
    NSString *loginkeyStr = [[NSUserDefaults standardUserDefaults] objectForKey:login_key];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",a];
    NSLog(@"时间戳＝%@",timeString);
    NSString *EncryptedStr = [Md5_f md5:[NSString stringWithFormat:@"%@_%@",loginkeyStr,timeString]];
    
    //公用参数
    NSMutableArray *arrat = [[NSMutableArray alloc] initWithObjects:@{@"price":@"roleType",@"vaule":@"roleTypeplat"},@{@"price":@"terminalType",@"vaule":@"terminalTypeios"},@{@"price":@"md5timekey",@"vaule":[NSString stringWithFormat:@"md5timekey%@",EncryptedStr]},@{@"price":@"qType",@"vaule":@"qTypeapi"}, nil];
    //私有参数
    for (NSDictionary *dic in pri) {
        [arrat addObject:dic];
    }
    //倒序排列
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"price" ascending:NO]];
    [arrat sortUsingDescriptors:sortDescriptors];
    //NSLog(@"排序后的数组%@",arrat);
    NSString *allocStr;
    for (NSDictionary *dic in arrat) {
        NSString *str = dic[@"vaule"];
        if (allocStr) {
            allocStr = [NSString stringWithFormat:@"%@%@",allocStr,str];
        }else {
            allocStr = [NSString stringWithFormat:@"%@",str];
        }
    }
    //NSLog(@"结果%@",allocStr);
    NSString *userStr = [Md5_f md5:allocStr];
    NSString *use = [NSString stringWithFormat:@"%@_%@_%@",userStr,userID,timeString];
    
    return use;
}
#pragma mark -- RSA加密
+ (NSString *)setRSAencryptString:(NSString *)encryptStr {
    
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"market_public_key" ofType:@"pem"];
    NSData *derData = [[NSData alloc] initWithContentsOfFile:publicKeyPath];
    //将key解析出来
    NSString *djj = [[NSString alloc]initWithData:derData encoding:NSUTF8StringEncoding];
    NSString *encryStr = [RSA encryptString:encryptStr publicKey:djj];
    
    return encryStr;
}
@end
