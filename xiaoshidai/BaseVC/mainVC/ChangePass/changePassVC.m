//
//  changePassVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/10/14.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "changePassVC.h"

@interface changePassVC ()

@property (strong, nonatomic) IBOutlet UIButton *nextBT;
@property (strong, nonatomic) IBOutlet UIView *backV;
@property (strong, nonatomic) IBOutlet UITextField *oldPassTF;
@property (strong, nonatomic) IBOutlet UITextField *twoPassTF;
@property (strong, nonatomic) IBOutlet UITextField *passTF;

@end

@implementation changePassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationNotNeeded(@"重置登录密码");
    //[self setNavRightBtnWithString:@"关闭"];
    [self setup];
}
- (void)setup {
    
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:_backV];
    [self PixeH:CGPointMake(0, 43) lenght:ScreenWidth add:_backV];
    [self PixeH:CGPointMake(0, 87) lenght:ScreenWidth add:_backV];
    [self PixeH:CGPointMake(0, 131) lenght:ScreenWidth add:_backV];
    [self setYuan:_nextBT size:4];
    
}

- (IBAction)nextAction {
    
    if (_oldPassTF.text.length&&_passTF.text.length&&_twoPassTF.text.length) {
        if ([_passTF.text isEqualToString:_twoPassTF.text]) {
            [self changePassRequest];
        }else {
            [LCProgressHUD showInfoMsg:@"两次密码不一致"];
        }
    }else {
        [LCProgressHUD showInfoMsg:@"请填写密码"];
    }
}
#pragma mark -- 修改密码网络请求
- (void)changePassRequest {

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:_oldPassTF.text] forKey:@"pwd_old"];
    [param setObject:[self setRSAencryptString:_passTF.text] forKey:@"pwd_new"];
    
    NSArray *tokenArr = @[@{@"price":@"pwd_old",@"vaule":[NSString stringWithFormat:@"pwd_old%@",_oldPassTF.text]},
                          @{@"price":@"pwd_new",@"vaule":[NSString stringWithFormat:@"pwd_new%@",_passTF.text]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/operator/editpwd/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:@"修改成功"];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rightAction) userInfo:nil repeats:NO];
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
- (void)rightAction {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    
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
