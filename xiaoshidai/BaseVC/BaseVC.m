//
//  BaseVC.m
//  kuangjia
//
//  Created by 名侯 on 16/8/15.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "BaseVC.h"
#import "AFNetworking.h"
    // roll_id 237
#import "loginVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BackGroundColor];
        appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
}

//修改导航返回按钮
-(void)setBack:(NSString *)imgName {
    if ([XYString isBlankString:imgName]) {
        imgName = @"nav_icon_back";
    }
    UIBarButtonItem *barbtnLeft=[[UIBarButtonItem alloc]init];
    UIView *backview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 18, 18)];
    [imageview setImage:[UIImage imageNamed:imgName]];
    [backview addSubview:imageview];
    [barbtnLeft setCustomView:backview];
    UITapGestureRecognizer *tapges=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)];
    [backview addGestureRecognizer:tapges];
    self.navigationItem.leftBarButtonItem=barbtnLeft;
}
- (void)backAction {
    NSLog(@"返回");
}
//修改导航右边按钮
-(void)setNavRightBtnWithImgName:(NSString *)imagename {
    UIBarButtonItem *barbtnLeft=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemSearch) target:self action:@selector(rightAction)];
    //UIView *rightview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60.0, 44.0)];
    //[rightview setBackgroundColor:[UIColor clearColor]];
    //UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(rightview.frame.size.width-20.0, (rightview.frame.size.height-20.0)/2, 20.0, 20.0)];
    //[imageview setImage:[UIImage imageNamed:imagename]];
    //[rightview addSubview:imageview];
    //[barbtnLeft setCustomView:rightview];
    //UITapGestureRecognizer *tapges=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightAction)];
    //[rightview addGestureRecognizer:tapges];
    
    self.navigationItem.rightBarButtonItem=barbtnLeft;
}
//修改导航右边按钮--文字类型
-(void)setNavRightBtnWithString:(NSString *)string{
    UIBarButtonItem *rightbar=[[UIBarButtonItem alloc]init];
    [rightbar setTitle:string];
    [rightbar setTarget:self];
    [rightbar setAction:@selector(rightAction)];
    NSMutableDictionary *textDic=[[NSMutableDictionary alloc]init];
    [textDic setObject:[UIFont systemFontOfSize:15.0] forKey:NSFontAttributeName];
    [textDic setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightbar setTitleTextAttributes:textDic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=rightbar;
}
//修改导航右边按钮---view
-(void)setNarRightBtnWithView:(UIView *)view{
    UIBarButtonItem *barbtnLeft=[[UIBarButtonItem alloc]init];
    [barbtnLeft setCustomView:view];
    UITapGestureRecognizer *tapges=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightAction)];
    [view addGestureRecognizer:tapges];
    self.navigationItem.rightBarButtonItem=barbtnLeft;
}
- (void)rightAction {
    NSLog(@"右边导航栏事件");
}
//修改导航titleview
-(void)setNavTitleView:(UIView *)titleview{
    self.navigationItem.titleView=titleview;
}
//设置边框
-(void)setBorder:(UIView *)view size:(float)size{
    CGFloat width = 1/[UIScreen mainScreen].scale;
    view.layer.borderColor=BorderColor.CGColor;
    view.layer.borderWidth=size*width;
}
//设置边框+颜色
-(void)setBorder:(UIView *)view size:(float)size withColor:(UIColor *)color {
    CGFloat width = 1/[UIScreen mainScreen].scale;
    view.layer.borderColor=color.CGColor;
    view.layer.borderWidth=width*size;
}
//设置成圆形
-(void) setYuan:(UIView *)view size:(double)size{
    view.layer.masksToBounds=YES;
    view.layer.cornerRadius=size;
}
//设置分割线
-(void)addFenGeXian:(UIView *)view andRect:(CGRect)rect{
    UILabel *fengexian=[[UILabel alloc]initWithFrame:rect];
    [fengexian setBackgroundColor:BorderColor];
    [view addSubview:fengexian];
}
//设置分割线
-(void)addFenGeXian:(UIView *)view andRect:(CGRect)rect withColor:(UIColor *)color{
    UILabel *fengexian=[[UILabel alloc]initWithFrame:rect];
    [fengexian setBackgroundColor:color];
    [view addSubview:fengexian];
}
//设置view居中
-(void)setViewInCenterByX:(UIView *)view fatherView:(UIView *)fatherViiew{
    CGRect cellViewRect=view.frame;
    cellViewRect.size.width=fatherViiew.frame.size.width-cellViewRect.origin.x*2;
    [view setFrame:cellViewRect];
}
//
-(void)setViewInCenterByX:(UIView *)view fatherViewWidth:(double)fatherWidth{
    CGRect cellViewRect=view.frame;
    cellViewRect.size.width=fatherWidth-cellViewRect.origin.x*2;
    [view setFrame:cellViewRect];
}

/**
 *  生产一个 1像素的线
 *
 *  @param origin     线的起始位置（传入的点后面不要带小数)
 *  @param length     线的长度
 *  @param isVertical 线的方向是否是垂直的
 *  @param color      线的颜色
 *
 *  @return 返回这根线
 */
- (void)PixeOrigin:(CGPoint)origin length:(CGFloat)length isVertical:(BOOL)isVertical color:(UIColor *)color add:(UIView *)supview {
    CGFloat width = 1/[UIScreen mainScreen].scale;
    CGFloat offset = ((1-[UIScreen mainScreen].scale)/2);
    
    UIView *view;
    if (isVertical) {   // 垂直的线
        view = [[UIView alloc] initWithFrame:CGRectMake(ceil(origin.x) + offset, origin.y, width, length)];
    }
    else {  // 水平的线
        view = [[UIView alloc] initWithFrame:CGRectMake(origin.x, ceil(origin.y)+(1-width), length, width)];
    }
    view.backgroundColor = color;
    [supview addSubview:view];
}
//默认水平线
- (void)PixeH:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview {
    
    CGFloat width = 1/[UIScreen mainScreen].scale;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(origin.x, ceil(origin.y)+(1-width), length, width)];
    view.backgroundColor = BorderColor;
    [supview addSubview:view];
}
//默认水平线（顶部）
- (void)PixeHead:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview {
    
    CGFloat width = 1/[UIScreen mainScreen].scale;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(origin.x, ceil(origin.y), length, width)];
    view.backgroundColor = BorderColor;
    [supview addSubview:view];
}
//默认垂直线
- (void)PixeV:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview {
    CGFloat width = 1/[UIScreen mainScreen].scale;
    CGFloat offset = ((1-[UIScreen mainScreen].scale)/2);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ceil(origin.x) + offset, origin.y, width, length)];
    view.backgroundColor = BorderColor;
    [supview addSubview:view];
}
//
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark -- AFN网络框架
- (void)post:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"%@%@",IP,URLString];
    [parameters setObject:@"plat" forKey:@"roleType"];
    [parameters setObject:@"ios" forKey:@"terminalType"];
    [parameters setObject:@"api" forKey:@"qType"];
    NSLog(@"url=%@",path);
    //NSLog(@"参数=%@",parameters);
   // AFHTTPSessionManager *mar = [AFHTTPSessionManager manager];
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
                    loginVC *MVC = [[loginVC alloc] init];
                    [self presentViewController:MVC animated:YES completion:nil];
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
#pragma mark -- 图片上传
- (void)postImg:(NSString *)URLString parameters:(id)parameters sendImage:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
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

//----------------------------------------  项目中定义  -------------------------------------------------------------


#pragma mark -- RSA加密
- (NSString *)setRSAencryptString:(NSString *)encryptStr {
    
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"market_public_key" ofType:@"pem"];
    NSData *derData = [[NSData alloc] initWithContentsOfFile:publicKeyPath];
    //将key解析出来
    NSString *djj = [[NSString alloc]initWithData:derData encoding:NSUTF8StringEncoding];
    NSString *encryStr = [RSA encryptString:encryptStr publicKey:djj];
    //NSString *decryptString  = [RSA decryptString:encryStr publicKey:djj];
    //NSLog(@"加密：%@  解密%@",encryStr,decryptString);
    return encryStr;
}
#pragma mark -- 未登录口令
- (NSString *)setApiTokenStr {
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
- (NSString *)setUserTokenStr:(NSArray *)pri {
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:user_ID];
    NSString *loginkeyStr = [[NSUserDefaults standardUserDefaults] objectForKey:login_key];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",a];
    //NSLog(@"时间戳＝%@",timeString);
    NSString *EncryptedStr = [Md5_f md5:[NSString stringWithFormat:@"%@_%@",loginkeyStr,timeString]];
    
    //公用参数
    NSMutableArray *arrat = [[NSMutableArray alloc] initWithObjects:@{@"price":@"roleType",@"vaule":@"roleTypeplat"},@{@"price":@"terminalType",@"vaule":@"terminalTypeios"},@{@"price":@"md5timekey",@"vaule":[NSString stringWithFormat:@"md5timekey%@",EncryptedStr]},@{@"price":@"qType",@"vaule":@"qTypeapi"}, nil];
    //私有参数
    for (NSDictionary *dic in pri) {
        [arrat addObject:dic];
    }
    //倒序排列
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"price" ascending:NO comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
         return [obj1 compare:obj2];
    }]];
    [arrat sortUsingDescriptors:sortDescriptors];
    //[arrat sortedArrayUsingSelector:@selector(compare:)];
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
#pragma mark -- 权限数组
- (NSArray *)getPermissionsArr {
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:lim_ord];
    return arr;
}
#pragma mark -- 角色分类
- (NSInteger)getroleClass {
    NSInteger ID;
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:role_class];
    if ([str isEqualToString:@"前台"]) {
        ID = 1;
    }else {
        ID = 2;
    }
    return ID;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
