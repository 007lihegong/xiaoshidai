//
//  relyVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/9/29.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "relyVC.h"
#import "UIPlaceHolderTextView.h"

@interface relyVC ()
{
    UIPlaceHolderTextView *textV;
}
@end

@implementation relyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回复";
    [self setup];
}
- (void)setup {
    
    [self setYuan:_submitBT size:3];
    //
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 203*Multiple)];
    backV.backgroundColor = [UIColor whiteColor];
    [self setYuan:backV size:5];
    [self setBorder:backV size:1];
    [self.view addSubview:backV];
    
    textV = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-40, 203*Multiple-20)];
    textV.backgroundColor = [UIColor clearColor];
    textV.font = [UIFont systemFontOfSize:12];
    textV.placeholder = @"请谨慎使用回复...";
    [backV addSubview:textV];
    
}
#pragma mark -- 提交回复
- (IBAction)submitAction {

    if (textV.text.length) {
        [self submitRequest];
    }else {
        [LCProgressHUD showInfoMsg:@"请填写回复内容"];
    }
}
- (void)submitRequest {
   
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:_ordNum] forKey:@"order_nid"];
    [param setObject:[self setRSAencryptString:textV.text] forKey:@"reply_content"];
    NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",_ordNum]},
                          @{@"price":@"reply_content",@"vaule":[NSString stringWithFormat:@"reply_content%@",textV.text]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [LCProgressHUD showLoading:@"正在提交"];
    [self post:@"/order/reply/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            appdelegate.refresh = 2;
            [LCProgressHUD showSuccess:@"提交成功"];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayAction) userInfo:nil repeats:NO];
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
- (void)delayAction {
    [self.navigationController popViewControllerAnimated:YES];
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
