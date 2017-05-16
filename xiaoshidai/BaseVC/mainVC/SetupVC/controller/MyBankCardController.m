//
//  MyBankCardController.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/29.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "MyBankCardController.h"
#import "MyBankCardCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MyBankCardModel.h"
#import "AddBankCardController.h"
#import "RealNameController.h"

#import "LianPayModel.h"
#import "LLPayUtil.h"
#import "LLPaySdk.h"

#import "PayFailController.h"
#import "PaySuccessController.h"
#import "RSA.h"
@interface MyBankCardController ()<UITableViewDelegate,UITableViewDataSource,LLPaySdkDelegate>
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray * dataArray;
@property (nonatomic) NSMutableDictionary *bankDict;
@property (nonatomic) LianPayModel * payData;
@property (nonatomic) BankData * bankData;

@end

@implementation MyBankCardController
static NSString * public_key = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDIJN6Fdsci3vWs+hBhVGvXA9WB\nIwcdgvJ/DC4y4ILt98MaOMEhEFRlLOCvg/yQoHJwvHqFcemhiGeHeZMQFAgRoBFC\nmuSKh8SU1BUQ3LP96LAvhxC4aYGdx08t2K6uksGL5RJzEdh3Ni3W0IHrKxTaeOz7\nIoM0MtVxDLs6PzBWyQIDAQAB\n-----END PUBLIC KEY-----";
static NSString * private_key = @"";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self request];
    [self dataArray];
    [self tableView];
    [self initBottom];
    [self bankDict];

}
-(NSMutableDictionary *)bankDict{
    if (!_bankDict) {
        NSArray * bankArray = @[@"工商银行",@"农业银行",@"中国银行",@"建设银行",@"交通银行",
                                @"邮政储蓄银行",@"中信银行",@"光大银行",@"华夏银行",@"民生银行",
                                @"平安银行",@"招商银行",@"上海银行",@"成都银行",@"兴业银行"];
        
        NSArray * bankImgArray = @[@"img_gongshang",@"img_nongye",@"img_zhanghang",@"img_jianshe",@"img_jiaotong",
                                   @"img_youzheng",@"img_zhongxin",@"img_guangda",@"img_huaxia-",@"img_mingsheng",
                                   @"img_pingan",@"img_zhaoshang",@"img_shanghai",@"img_chengdu",@"img_xingye"];
        _bankDict = [NSMutableDictionary dictionary];
        [bankArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_bankDict setObject:bankImgArray[idx] forKey:bankArray[idx]];
        }];
    }
    return _bankDict;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (appdelegate.refresh==2) {
        appdelegate.refresh = 0;
        [self request];
    }
}
-(void)request{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setUserTokenStr:nil] forKey:@"token"];
    [LCProgressHUD showLoading:nil];
    [self post:BINDCARD_SEARCH parameters:param success:^(id dict) {
        if ([dict[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:dict[@"msg"]];
            MyBankCardModel *model = [MyBankCardModel mj_objectWithKeyValues:dict];
            _dataArray = [model.data mutableCopy];
            [_tableView reloadData];
        }else {
            NSString *msg = dict[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)initBottom{
    UIButton *button  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"新增银行卡" forState:(UIControlStateNormal)];
    [button setBackgroundColor:mainHuang];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [button setFrame:CGRectMake(10, kScreen_Height - 64 - 49 -20, kScreen_Width-20, 49)];
    [button.layer setCornerRadius:7.0];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}
-(void)buttonClick:(UIButton *)sender{
    NSString * realNameStatus = [USER_DEFAULT objectForKey:REALNAME_STATUS];
    if ([realNameStatus isEqualToString:@"1"] ) {
        [self alertWithStr:@"提交" Title:@"您还未实名认证,前往实名认证"];
    }else if ([realNameStatus isEqualToString:@"4"]){
        [self alertWithStr:@"重新提交" Title:@"实名认证失败,请重新提交"];
    }else if ([realNameStatus isEqualToString:@"2"]){
        [self alertWithStr:@"0" Title:@"实名认证已提交正在等待审核"];
    }else if ([realNameStatus isEqualToString:@"3"]){
        AddBankCardController *controller = [[AddBankCardController alloc] init];
        controller.title = @"新增银行卡";
        [self.navigationController pushViewController:controller animated:YES];
    }
    NSLog(@"%@",sender.titleLabel.text);
}
-(void)alertWithStr:(NSString *)buttoStr Title:(NSString *)title{
    NSString *cancelButtonTitle = NSLocalizedString(@"否", nil);
    NSString *otherButtonTitle;
    if (![buttoStr isEqualToString:@"0"]){
        otherButtonTitle = NSLocalizedString(@"确定", nil);
    }else{
        otherButtonTitle = NSLocalizedString(@"是", nil);
    }
    //UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertAction
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"%@",cancelButtonTitle);
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"%@",otherButtonTitle);
        if (![buttoStr isEqualToString:@"0"]) {
            RealNameController * controller = [[RealNameController alloc] init];
            controller.title = @"实名认证";
            controller.buttonStr = buttoStr;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
    //addAction
    if (![buttoStr isEqualToString:@"0"]){
        [alertController addAction:cancelAction];
    }
    [alertController addAction:otherAction];
    //present
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UITableView *)tableView{
    if (!_tableView) {
        if (self.model) {
            UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
            moneyLabel.text = [NSString stringWithFormat:@"    支付金额：￥%@",self.model.money];
            moneyLabel.backgroundColor = [UIColor whiteColor];
            moneyLabel.font = [UIFont systemFontOfSize:15];
            [self.view addSubview:moneyLabel];
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, kScreen_Width, kScreen_Height-64-49-60) style:(UITableViewStyleGrouped)];

        }else{
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-49) style:(UITableViewStyleGrouped)];

        }

        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MyBankCardCell class] forCellReuseIdentifier:@"MyBankCardCellID"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataArray.count) {
        return _dataArray.count;
    }else{
        return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBankCardCellID"];
    if (!cell) {
        cell = [[MyBankCardCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MyBankCardCellID"];
    }
    @try {
        BankData *model = _dataArray[indexPath.section];
        NSString * account = [model.bank_account substringFromIndex:model.bank_account.length-4];
        NSString * phone = [model.phone_reserved substringFromIndex:model.phone_reserved.length-4];

        cell.bankNameLabel.text = model.bank_name;
        cell.bankCardNumLabel.text = [NSString stringWithFormat:@"**** **** **** ***%@",account];
        cell.phoneNumLabel.text = [NSString stringWithFormat:@"手机尾号%@",phone];
        NSString *imgName = [self.bankDict objectForKey:model.bank_name];
        cell.headImageView.image = IMGNAME(imgName);
        if (self.model) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.model) {
        BankData *model = _dataArray[indexPath.section];
        _bankData = model;
        [self alertWith:self.model bank:model];
    }
}
-(void)alertWith:(PayData *)pay bank:(BankData *)bank{
    NSString * account = [bank.bank_account substringFromIndex:bank.bank_account.length-4];
    NSString *title = [NSString stringWithFormat:@"您确定使用尾号为%@的银行卡支付？",account];
    NSString *cancelButtonTitle = NSLocalizedString(@"否", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"是", nil);
    //UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertAction
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"%@",cancelButtonTitle);
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"%@",otherButtonTitle);
        [self lianlianPrepay:pay Bank:bank];
    }];
    //addAction
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    //present
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)lianlianPrepay:(PayData *)pay Bank:(BankData *)bank{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString * operator_id = [USER_DEFAULT objectForKey:login_Operation];
    [param setObject:[self setRSAencryptString:operator_id] forKey:@"operator_id"];
    [param setObject:[self setRSAencryptString:pay.receipt_id] forKey:@"receipt_id"];
    [param setObject:[self setRSAencryptString:bank.id] forKey:@"bind_id"];
    [param setObject:[self setRSAencryptString:bank.bank_account] forKey:@"bank_account"];
    [param setObject:[self setRSAencryptString:pay.money] forKey:@"money"];
    
    NSMutableArray *tokenArr = [NSMutableArray array];
    [tokenArr addObject:@{@"price":@"operator_id",@"vaule":StrFormatTW(@"operator_id", operator_id)}];
    [tokenArr addObject:@{@"price":@"receipt_id",@"vaule":StrFormatTW(@"receipt_id", pay.receipt_id)}];
    [tokenArr addObject:@{@"price":@"bind_id",@"vaule":StrFormatTW(@"bind_id", bank.id)}];
    [tokenArr addObject:@{@"price":@"bank_account",@"vaule":StrFormatTW(@"bank_account", bank.bank_account)}];
    [tokenArr addObject:@{@"price":@"money",@"vaule":StrFormatTW(@"money", pay.money)}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [self post:LIANLIAN_PAY_PRE parameters:param success:^(id dict) {
        if ([dict[@"code"] intValue]==0) {
            NSLog(@"%@",[dict mj_JSONString]);
            _payData = [LianPayModel mj_objectWithKeyValues:dict];
            NSArray * arr = dict[@"data"][@"block_data"];
            NSMutableString * paramStr = [NSMutableString string];
            for (NSString *str in arr) {
                [paramStr appendString:[RSA decryptString:str publicKey:public_key]];
            }
            LianPaData *data = [LianPaData mj_objectWithKeyValues:[paramStr mj_keyValues]];
            [self signWithModel:data];
        }else {
            NSString *msg = dict[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError * error) {
        
    }];
    
}
-(void)signWithModel:(LianPaData *)model{
    static LLPayType payType = LLPayTypeQuick;

    [LLPaySdk sharedSdk].sdkDelegate = self;
    NSDictionary *param = [model mj_keyValues];
    NSLog(@"%@",param);
    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:self
                                              withPayType:payType
                                            andTraderInfo:param];
}
#pragma - mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
// TODO: 开发人员需要根据实际业务调整逻辑
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSLog(@" resultCode = %d  dic  = %@",resultCode,[dic mj_JSONString]);
    NSString *msg = @"异常";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"成功";
        } break;
        case kLLPayResultFail: {
            msg = @"失败";
        } break;
        case kLLPayResultCancel: {
            msg = @"取消";
        } break;
        case kLLPayResultInitError: {
            msg = @"sdk初始化异常";
        } break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
        } break;
        default:
            break;
    }
    
    if (resultCode == 0) {
        PaySuccessController * controller = [[PaySuccessController alloc] init];
        controller.title = @"支付成功";
        controller.dict = dic;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        PayFailController * controller = [[PayFailController alloc] init];
        controller.title = @"支付失败";
        [self.navigationController pushViewController:controller animated:YES];
    }
    
   // NSString *showMsg =
    //[msg stringByAppendingString:[LLPayUtil jsonStringOfObj:dic]];

    //UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg
                                                                   //message:showMsg
                                                            //preferredStyle:UIAlertControllerStyleAlert];
    
   // [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                              //style:UIAlertActionStyleDefault
                                            //handler:nil]];
   // [self presentViewController:alert animated:YES completion:nil];
#pragma mark - 注销同步
    //[self synFollowWithDict:dic resultCode:resultCode];
}
-(void)synFollowWithDict:(NSDictionary *)dict resultCode:(LLPayResult)resultCode{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString * operator_id = [USER_DEFAULT objectForKey:login_Operation];
    PayData *pay = self.model;
    LianPayModel *lianPay = _payData;
    NSString * result_pay ;
    if (resultCode == kLLPayResultCancel) {
        result_pay = @"CANCEL";
    }else{
        result_pay = dict[@"result_pay"];
    }
    [param setObject:[self setRSAencryptString:operator_id] forKey:@"operator_id_pay"];
    [param setObject:[self setRSAencryptString:pay.receipt_id] forKey:@"receipt_id"];
    
    [param setObject:[self setRSAencryptString:lianPay.data.no_order] forKey:@"no_order"];
    [param setObject:[self setRSAencryptString:dict[@"oid_paybill"]] forKey:@"oid_paybill"];
    [param setObject:[self setRSAencryptString:result_pay] forKey:@"result_pay"];
    [param setObject:[dict mj_JSONString] forKey:@"llpay_return"];

    
    NSMutableArray *tokenArr = [NSMutableArray array];
    [tokenArr addObject:@{@"price":@"operator_id_pay",@"vaule":StrFormatTW(@"operator_id_pay", operator_id)}];
    [tokenArr addObject:@{@"price":@"receipt_id"     ,@"vaule":StrFormatTW(@"receipt_id", pay.receipt_id)}];
    [tokenArr addObject:@{@"price":@"no_order"       ,@"vaule":StrFormatTW(@"no_order", lianPay.data.no_order)}];
    [tokenArr addObject:@{@"price":@"oid_paybill"    ,@"vaule":StrFormatTW(@"oid_paybill",avoidNullStr(dict[@"oid_paybill"]))}];
    [tokenArr addObject:@{@"price":@"result_pay"     ,@"vaule":StrFormatTW(@"result_pay", avoidNullStr(result_pay))}];
    [tokenArr addObject:@{@"price":@"llpay_return"   ,@"vaule":StrFormatTW(@"llpay_return",avoidNullStr([dict mj_JSONString]))}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    [self post:LIANLIAN_PAY_SYN parameters:param success:^(id dict) {
        if ([dict[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:dict[@"data"]];
        }else {
            NSString *msg = dict[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError * error) {
        
    }];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"MyBankCardCellID" configuration:^(id cell) {
    }];
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && self.model) {
        return 30;
    }else{
        return 10;
    }
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0 && self.model) {
        return @"请选择银行卡";
    }else{
        return nil;
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.model) {
        return NO;
    }else{
        return NO;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"解绑";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self alertWithIndexPath:indexPath tableView:tableView];
}
-(void)alertWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    NSString *title = @"是否解绑该银行卡";
    NSString *cancelButtonTitle = NSLocalizedString(@"否", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"是", nil);
    //UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertAction
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"%@",cancelButtonTitle);
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"%@",otherButtonTitle);
        
        BankData *model = _dataArray[indexPath.section];
        [self unBindWith:(BankData *)model Completion:^(BOOL isOk) {
            if (isOk) {
                // 从数据源中删除
                [_dataArray removeObjectAtIndex:indexPath.section];
                // 从列表中删除
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
                [tableView deleteSections:set withRowAnimation:(UITableViewRowAnimationFade)];
            }
        }];
        
    }];
    //addAction
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    //present
    [self presentViewController:alertController animated:YES completion:nil];
    
}
//解绑银行卡
-(void)unBindWith:(BankData *)model Completion:(void(^)(BOOL isOk)) completion{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:model.id] forKey:@"id"];
    NSArray *tokenArr =@[@{@"price":model.id,@"vaule":StrFormatTW(@"id", model.id)}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];

    [LCProgressHUD showLoading:nil];
    [self post:BINDCARD_UNBIND parameters:param success:^(id dict) {
        if ([dict[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:dict[@"data"]];
            completion(1);
        }else {
            NSString *msg = dict[@"info"];
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
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
