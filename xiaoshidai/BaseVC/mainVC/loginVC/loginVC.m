//
//  loginVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/9/22.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "loginVC.h"
#import "RootTabBarController.h"
#import "registeredVC.h"
#import "BaseNavigationController.h"

@interface loginVC ()

@end

@implementation loginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
}
- (void)setup {
    
    if (ScreenHeight==480) {
        _loginImg.y-=20;
    }
    NSString *historyStr = [[NSUserDefaults standardUserDefaults] objectForKey:SSAccount];
    if (![XYString isBlankString:historyStr]) {
        [_historyBT setTitle:historyStr forState:UIControlStateNormal];
    }
    [self setYuan:_loginBT size:4];
    [self PixeHead:CGPointMake(42, 0) lenght:ScreenWidth-42 add:_backV2];
    [self PixeH:CGPointMake(0, 43) lenght:ScreenWidth add:_backV2];
    [self PixeH:CGPointMake(0, 87) lenght:ScreenWidth add:_backV2];
}
#pragma mark -- 注册
- (IBAction)registeredAction {
    [self.view endEditing:YES];
    registeredVC *MVC = [[registeredVC alloc] init];
    BaseNavigationController *NAV = [[BaseNavigationController alloc] initWithRootViewController:MVC];
    [self presentViewController:NAV animated:YES completion:nil];
}
#pragma mark -- 忘记密码
- (IBAction)forgetAction {
    
}
#pragma mark -- 登录
- (IBAction)loginAction {
    [self setLoginRequest];
}
#pragma mark -- 切换历史账号
- (IBAction)qiehuanAction:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        [UIView animateWithDuration:0.2 animations:^{
            _backV2.y = 1;
        }];
    }else {
        sender.selected = YES;
        [UIView animateWithDuration:0.2 animations:^{
            _backV2.y = 44;
        }];
    }
}
#pragma mark -- 密码可视
- (IBAction)eyeAction:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        _passTF.secureTextEntry = YES;
    }else {
        sender.selected = YES;
        _passTF.secureTextEntry = NO;
    }
}
#pragma mark -- 登录的网络请求
- (void)setLoginRequest {
    [self.view endEditing:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *token = [self setApiTokenStr];
    [param setObject:[self setRSAencryptString:_userTF.text] forKey:@"username"];
    [param setObject:[self setRSAencryptString:_passTF.text] forKey:@"password"];
    [param setObject:token forKey:@"token"];
    
    [LCProgressHUD showLoading:@"正在加载"];
    [self post:@"/operator/login/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
     
            NSLog(@"登录成功返回＝%@",dic);
            [LCProgressHUD showSuccess:@"登录成功"];
            [[NSUserDefaults standardUserDefaults] setObject:_userTF.text forKey:SSAccount];
            NSString *loginkeyStr = dic[@"data"][@"login_key"];
            NSString *operatoridStr = dic[@"data"][@"operator_id"];
            NSString *rc_tokenStr = dic[@"data"][@"rc_token"];
            NSString *is_reg = dic[@"data"][@"is_reg"];
            NSString *role_id = dic[@"data"][@"role_id"];
            NSString *realname_status = dic[@"data"][@"realname_status"];
            [USER_DEFAULT setObject:loginkeyStr forKey:login_key];
            [USER_DEFAULT setObject:operatoridStr forKey:user_ID];
            [USER_DEFAULT setObject:rc_tokenStr forKey:Rc_token];
            [USER_DEFAULT setObject:is_reg forKey:Is_reg];
            [USER_DEFAULT setObject:role_id forKey:Role_id];
            [USER_DEFAULT setObject:realname_status forKey:REALNAME_STATUS];

            
            RootTabBarController *root = [[RootTabBarController alloc] init];
            appdelegate.window.rootViewController = root;
            [appdelegate connectRCIMWithtoken:rc_tokenStr];
            [appdelegate.window makeKeyAndVisible];
            // if (self.order_nid) {
            //    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
            //    [pushJudge setObject:@"push" forKey:@"push"];
            //   [pushJudge synchronize];
            //   orderDetailVC * VC = [[orderDetailVC alloc]init];
            //   VC.order_nid = self.order_nid;
            //   [root setSelectedIndex:2];
            //  BaseNavigationController *vc = (BaseNavigationController *)root.childViewControllers[2];
            //  [vc pushViewController:VC animated:YES];
            //}
            //订单操作权限数组
            NSMutableArray *ordLim = [NSMutableArray array];
            NSArray *permissionArr = dic[@"data"][@"permission"];
            for (NSDictionary *dics in permissionArr) {
                NSString *name = dics[@"function_code"];
                if ([name isEqualToString:@"order"]) {
                    [ordLim addObject:dics[@"path_info"]];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:ordLim forKey:lim_ord];
            //角色id
            NSString *roleStr = dic[@"data"][@"role_id"];
            if (roleStr.intValue==1||roleStr.intValue==2||roleStr.intValue==7||roleStr.intValue==8||roleStr.intValue==9) {
                [[NSUserDefaults standardUserDefaults] setObject:@"后台" forKey:role_class];
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:@"前台" forKey:role_class];
            }
            NSString *push_str = dic[@"data"][@"is_push"];
            if ([push_str isEqualToString:@"1"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"JPush_sta"];
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"JPush_sta"];
            }
            //操作人
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"data"][@"operator_id"] forKey:login_Operation];
            appdelegate.OperationStr = dic[@"data"][@"operator_id"];
            //注册推送
            [self pushRequest];
        }else {
            NSString *msg = dic[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 推送传
- (void)pushRequest {
   
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:avoidNullStr(appdelegate.JPushID)] forKey:@"registration_id"];
    NSArray *tokenArr = @[@{@"price":@"registration_id",@"vaule":[NSString stringWithFormat:@"registration_id%@",avoidNullStr(appdelegate.JPushID)]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [self post:@"/operator/setregid/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            
        }else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 历史账号点击事件
- (IBAction)historyAction:(UIButton *)sender {
    if (![sender.titleLabel.text isEqualToString:@"历史账号为空"]) {
        _userTF.text = sender.titleLabel.text;
    }
    [UIView animateWithDuration:0.2 animations:^{
        _backV2.y = 1;
    }];
    _qiehuanBT.selected = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
