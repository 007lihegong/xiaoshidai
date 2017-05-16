//
//  forwardingVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/10/9.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "forwardingVC.h"
#import "LTPickerView.h"

@interface forwardingVC ()
{
    NSMutableArray *titleArr;
    //
    NSString *operator_idStr;
    NSString *department_idStr;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@end

@implementation forwardingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;
    if ([_titleStr isEqualToString:@"订单转发"]) {
        self.reasonLabel.text = @"转发原因";
        self.nameLabel.text = @"转发人";
    }
    [self setUp];
}
- (void)setUp {
    
    titleArr = [NSMutableArray array];
    
    [self setYuan:_textV size:3];
    [self setYuan:_confirmBT size:4];
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:_backV];
    [self PixeH:CGPointMake(0, 43) lenght:ScreenWidth add:_backV];
    [self PixeH:CGPointMake(0, 175) lenght:ScreenWidth add:_backV];
}

- (IBAction)PersonAction:(UIButton *)sender {
    [self setRequestPerson:sender];
}
- (IBAction)confirmAction {
    if (_textV.text.length&&_personBT.titleLabel.text.length) {
        if ([_titleStr isEqualToString:@"订单转发"]) {
            [self forwardingRequest];
        }else {
            [self assignedRequest];
        }
    }else {
        [LCProgressHUD showInfoMsg:@"请完善信息"];
    }
}

#pragma mark -- 获取指派人网络接口
- (void)setRequestPerson:(UIButton *)sender {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:_ordNum] forKey:@"order_nid"];
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/sysset/operatoracc/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD hide];
            [titleArr removeAllObjects];
            NSArray *dataArr = dic[@"data"];
            
            for (NSDictionary *dics in dataArr) {
                [titleArr addObject:dics[@"operator_name"]];
            }
            LTPickerView* pickerView = [LTPickerView new];
            pickerView.dataSource = titleArr;
            [pickerView show];//显示
            //回调block
            pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
                //obj:LTPickerView对象
                //str:选中的字符串
                //num:选中了第几行
                [sender setTitle:str forState:UIControlStateNormal];
                department_idStr = dataArr[num][@"department_id"];
                operator_idStr = dataArr[num][@"operator_id"];
            };
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
#pragma mark -- 转发确认的接口 
- (void)forwardingRequest {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:_ordNum] forKey:@"order_nid"];
    [param setObject:[self setRSAencryptString:_textV.text] forKey:@"transfer_reason"];
    [param setObject:[self setRSAencryptString:department_idStr] forKey:@"department_id_solution"];
    [param setObject:[self setRSAencryptString:operator_idStr] forKey:@"operator_id_solution"];
    NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",_ordNum]},
                          @{@"price":@"transfer_reason",@"vaule":[NSString stringWithFormat:@"transfer_reason%@",_textV.text]},
                          @{@"price":@"department_id_solution",@"vaule":[NSString stringWithFormat:@"department_id_solution%@",department_idStr]},
                          @{@"price":@"operator_id_solution",@"vaule":[NSString stringWithFormat:@"operator_id_solution%@",operator_idStr]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/order/transfer/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:@"转发成功"];
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
#pragma mark -- 指派确认的接口
- (void)assignedRequest {

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:_ordNum] forKey:@"order_nid"];
    [param setObject:[self setRSAencryptString:_textV.text] forKey:@"dispatch_reason"];
    [param setObject:[self setRSAencryptString:department_idStr] forKey:@"department_id_solution"];
    [param setObject:[self setRSAencryptString:operator_idStr] forKey:@"operator_id_solution"];
    NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",_ordNum]},
                          @{@"price":@"dispatch_reason",@"vaule":[NSString stringWithFormat:@"dispatch_reason%@",_textV.text]},
                          @{@"price":@"department_id_solution",@"vaule":[NSString stringWithFormat:@"department_id_solution%@",department_idStr]},
                          @{@"price":@"operator_id_solution",@"vaule":[NSString stringWithFormat:@"operator_id_solution%@",operator_idStr]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/order/dispatch/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:@"指派成功"];
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
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
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
