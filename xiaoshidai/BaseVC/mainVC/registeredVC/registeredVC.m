//
//  registeredVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/10/14.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "registeredVC.h"

@interface registeredVC ()

@property (strong, nonatomic) IBOutlet UIButton *determineBT;
@property (strong, nonatomic) IBOutlet UITextField *teleTF;
@property (strong, nonatomic) IBOutlet UITextField *passTF;
@property (strong, nonatomic) IBOutlet UIView *backV;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@end

@implementation registeredVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationNotNeeded(@"注册");
    [self setNavRightBtnWithString:@"关闭"];
    [self setUp];
}

- (void)setUp {
    
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:_backV];
    [self PixeH:CGPointMake(0, 43) lenght:ScreenWidth add:_backV];
    [self PixeH:CGPointMake(0, 87) lenght:ScreenWidth add:_backV];
    self.teleTF.keyboardType = UIKeyboardTypeNumberPad;
    [self setYuan:_determineBT size:4];
    
}
- (IBAction)determineAction {
    [self setRequest];
}

#pragma mark -- 设置提交的网络请求
- (void)setRequest {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:_teleTF.text] forKey:@"phone"];
    [param setObject:[self setRSAencryptString:_passTF.text] forKey:@"password"];
    
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/operator/reg/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:@"注册成功"];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rightAction) userInfo:nil repeats:NO];
        }else {
            NSString *msg = dic[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error){
        
    }];
}
- (void)rightAction {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
