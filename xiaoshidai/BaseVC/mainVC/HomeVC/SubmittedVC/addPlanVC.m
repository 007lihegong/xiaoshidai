//
//  addPlanVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/9/28.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "addPlanVC.h"
#import "HMDatePickView.h"
#import "LTPickerView.h"

@interface addPlanVC () //<UIActionSheetDelegate>
{
    NSMutableArray *titleArr;
    NSMutableArray *productidArr;
    //渠道id
    NSString *produId;
    //贷款类型id
    NSString *typeId;
}
@end

@implementation addPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加方案";
    [self setup];
}
- (void)setup {
    
    titleArr = [NSMutableArray array];
    productidArr = [NSMutableArray array];
    //_interestLB.keyboardType = UIKeyboardTypeDecimalPad;
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:_backV];
    [self PixeH:CGPointMake(0, 83) lenght:ScreenWidth add:_backV];
    [self PixeH:CGPointMake(0, 127) lenght:ScreenWidth add:_backV];
    [self PixeH:CGPointMake(0, 171) lenght:ScreenWidth add:_backV];
    [self PixeH:CGPointMake(0, 215) lenght:ScreenWidth add:_backV];
    [self PixeH:CGPointMake(0, 259) lenght:ScreenWidth add:_backV];
    [self setYuan:_determineBT size:3];
    [self setYuan:_planTV size:3];
}

- (IBAction)channelAction {
    [self setChannelRequest];
}

- (IBAction)timeAction {
    /** 自定义日期选择器 */
    [self.view endEditing:YES];
    HMDatePickView *datePickVC = [[HMDatePickView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    //距离当前日期的年份差（设置最大可选日期）
    datePickVC.maxYear = -10;
    //设置最小可选日期(年分差)
    datePickVC.minYear = 0;
    datePickVC.date = [NSDate date];
    //设置字体颜色
    datePickVC.fontColor = [UIColor blackColor];
    //日期回调
    datePickVC.completeBlock = ^(NSString *selectDate) {
        _timeLB.text = selectDate;
    };
    //配置属性
    [datePickVC configuration];
    
    [self.view addSubview:datePickVC];
}
- (IBAction)typeAction {
    [self.view endEditing:YES];
   // UIActionSheet *actionSheet1 = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"信用",@"车抵",@"房抵", nil];
    //[actionSheet1 showInView:self.view];
    
    UIAlertController * actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"信用" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        _typeLB.text = @"信用";
        typeId=@"1";
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"车抵" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        _typeLB.text = @"车抵";
        typeId=@"2";
    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"房抵" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        _typeLB.text = @"房抵";
        typeId=@"3";
    }];
    UIAlertAction * action4 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    [actionSheet addAction:action4];
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}
- (IBAction)determineAction {
    
    if (_planTV.text.length&&_channelLB.text.length&&_timeLB.text.length&&_interestLB.text.length&&_typeLB.text.length) {
        if ([XYString stringContainsEmoji:_planTV.text]==YES) {
            [LCProgressHUD showInfoMsg:@"方案内容不能有表情"];
            return;
        }
        if (_planTV.text.length>100) {
            [LCProgressHUD showInfoMsg:@"方案内容不能超过100个字符"];
            return;
        }
        NSDictionary *dic = @{@"comment":_planTV.text,@"channel":_channelLB.text,@"interest":_interestLB.text,@"type":_typeLB.text,@"time":_timeLB.text};
        NSDictionary *param = @{@"solution_detail":_planTV.text,@"product_id":produId,@"loan_prerate":_interestLB.text,@"loan_type":typeId,@"loan_pretime":_timeLB.text};
        self.plan(dic,param);
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [LCProgressHUD showInfoMsg:@"请完善信息"];
    }
}
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex==0) {
//        _typeLB.text = @"信用";
//        typeId=@"1";
//    }else if (buttonIndex==1) {
//        _typeLB.text = @"车抵";
//        typeId=@"2";
//    }else if (buttonIndex==2) {
//        _typeLB.text = @"房抵";
//        typeId=@"3";
//    }
//}
- (void)setChannelRequest {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/sysset/channel/" parameters:param success:^(id dic) {
        
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD hide];
            NSArray *arr = dic[@"data"];
            [titleArr removeAllObjects];
            [productidArr removeAllObjects];
            for (NSDictionary *dics in arr) {
                [titleArr addObject:dics[@"product_name"]];
                [productidArr addObject:dics[@"product_id"]];
            }
            LTPickerView* pickerView = [LTPickerView new];
            pickerView.dataSource = titleArr;
            [self.view endEditing:YES];
            [pickerView show];//显示
            //回调block
            pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
                //obj:LTPickerView对象
                //str:选中的字符串
                //num:选中了第几行
                _channelLB.text = str;
                produId = productidArr[num];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
