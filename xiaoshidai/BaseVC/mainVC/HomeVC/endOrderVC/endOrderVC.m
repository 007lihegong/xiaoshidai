//
//  endOrderVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/10/9.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "endOrderVC.h"
#import "UIPlaceHolderTextView.h"

@interface endOrderVC ()
{
    UIPlaceHolderTextView *textV;
}
@end

@implementation endOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _titleStr;
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
    if ([_titleStr isEqualToString:@"订单终止"]) {
        textV.placeholder = @"请填写终止原因...";
    }else if ([_titleStr isEqualToString:@"订单撤销"]) {
        textV.placeholder = @"请填写撤销原因...";
    }
    [backV addSubview:textV];
    
}
#pragma mark -- 提交回复
- (IBAction)submitAction {
    if (textV.text.length) {
        if ([_titleStr isEqualToString:@"订单终止"]) {
            [self submitRequest];
        }else if ([_titleStr isEqualToString:@"订单撤销"]) {
            [self orderUndo];
        }
    }else {
        [LCProgressHUD showInfoMsg:@"请填写原因"];
    }
}
#pragma mark -- 订单终止网络请求
- (void)submitRequest {

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:_ordNum] forKey:@"order_nid"];
    [param setObject:[self setRSAencryptString:textV.text] forKey:@"terminate_reason"];
    NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",_ordNum]},
                          @{@"price":@"terminate_reason",@"vaule":[NSString stringWithFormat:@"terminate_reason%@",textV.text]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [LCProgressHUD showLoading:@"正在提交"];
    [self post:@"/order/terminate/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:@"提交成功"];
            appdelegate.refresh = 2;
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
#pragma mark -- 订单撤销的网络请求
- (void)orderUndo {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:_ordNum] forKey:@"order_nid"];
    [param setObject:[self setRSAencryptString:textV.text] forKey:@"cancel_reason"];
    NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",_ordNum]},
                          @{@"price":@"cancel_reason",@"vaule":[NSString stringWithFormat:@"cancel_reason%@",textV.text]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [LCProgressHUD showLoading:@"正在提交"];
    [self post:@"/order/cancel/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:@"提交成功"];
            appdelegate.refresh = 2;
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
-(void)dealloc{
    NSLog(@"%s",__func__);
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];

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
