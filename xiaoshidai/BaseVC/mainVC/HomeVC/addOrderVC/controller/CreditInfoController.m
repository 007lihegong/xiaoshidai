//
//  CreditInformationController.m
//  xiaoshidai
//
//  Created by XSD on 16/9/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "CreditInfoController.h"
#import "FillinViewCell.h"
#import "NIDropDown.h"
#import "AssetController.h"
#import "BaseInfoController.h"
NSString *const SBZ = @"上班族";
NSString *const QYZ = @"企业主";
NSString *const WGDZY = @"无固定职业";
@interface CreditInfoController ()<LJKDatePickerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    int flag[5]; // 0 0 0 0 0
    NSString *tempStr;
    
    NSMutableArray *carArray;
    NSArray *sbzArray;
    NSArray *gjjArray;
    NSArray *bdjArray;
    NSArray *qyzArray;
    NSArray *fzArray;

    NSMutableArray *carPlaceHolders;
    NSArray *sbzPlaceHolders;
    NSArray *gjjPlaceHolders;
    NSArray *qyzPlaceHolders;
    NSArray *bdjPlaceHolders;
    NSArray *fzPlaceHolders;
    NSString * agency_querytimes;
    NSString * salary_money;
    NSString * social_security_money;
    NSString * house_fund_money;
    NSString * guarantee_company;
    NSString * guarantee_years;
    NSString * guarantee_money;
    NSString * industry;
    NSString * month_money;
    NSString * debt_money;
    NSString * gBuytime;

    
    NSString * hassocial;
    NSString * hasfund;
    NSString * hasguarantee;
    NSString * hasDebt;

}
@property (nonatomic,strong) NSMutableArray *assetInfoArray;
@property (nonatomic,strong) UIButton *nextButton;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *placeHolderArray;
@property (nonatomic )  UITextField * currentTextField;

@property (nonatomic) LJKDatePicker    *datePicker;
@end

@implementation CreditInfoController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame  =CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    NSArray *array = @[@"征信情况",@"查询次数",@"职业身份",@"工作单位",@"工资发放",@"工资金额"];
    carArray = [array mutableCopy];
    sbzArray = @[@"是否有社保",@"社保缴纳形式",@"社保缴纳金额"];
    gjjArray = @[@"是否有公积金",@"公积金缴纳金额"];
    bdjArray = @[@"是否有保单",@"投保公司",@"保险购买时间",@"保险年限",@"年缴纳金额"];
    qyzArray = @[@"从事行业",@"生意流水"];
    fzArray  = @[@"是否有负债",@"负债类型",@"负债金额"];
    
    NSArray *array1 =  @[@"征信情况",@"请输入征信的查询次数",@"职业身份",@"工作单位",@"工资发放",@"公资金额"];
    carPlaceHolders = [array1 mutableCopy];
    sbzPlaceHolders = @[@"是否有社保",@"社保缴纳形式",@"月社保缴纳金额"];
    gjjPlaceHolders = @[@"是否有公积金",@"公积金缴纳金额"];
    qyzPlaceHolders = @[@"从事行业",@"请输入月流水"];
    bdjPlaceHolders = @[@"是否有保单",@"请输入投保公司",@"保险购买时间",@"保险年限",@"年缴纳金额"];
    fzPlaceHolders  = @[@"是否有负债",@"负债类型",@"请输入负债金额"];

    flag[1] = 1;flag[2] = 1;flag[3] = 1;flag[4] = 1;
    [self.dataArray addObject:carArray];
    [self.dataArray addObject:sbzArray];
    [self.dataArray addObject:gjjArray];
   // [self.dataArray addObject:qyzArray];
    [self.dataArray addObject:bdjArray];
    [self.dataArray addObject:fzArray];

    self.placeHolderArray = [NSMutableArray array];
    [_placeHolderArray  addObject:carPlaceHolders];
    [_placeHolderArray addObject:sbzPlaceHolders];
    [_placeHolderArray addObject:gjjPlaceHolders];
    //[_placeHolderArray addObject:qyzPlaceHolders];
    [_placeHolderArray addObject:bdjPlaceHolders];
    [_placeHolderArray addObject:fzPlaceHolders];
    if ([_model.has_social_security isEqualToString:@"1"]) {
        flag[1] = 0;
    }else if ([_model.has_social_security isEqualToString:@"2"]){
        flag[1] = 1;
    }
    if ([_model.has_guarantee_slip isEqualToString:@"1"]) {
        flag[3] = 0;
    }else if ([_model.has_guarantee_slip isEqualToString:@"2"]){
        flag[3] = 1;
    }
    if ([_model.has_house_fund isEqualToString:@"1"]) {
        flag[2] = 0;
    }else if ([_model.has_house_fund isEqualToString:@"2"]){
        flag[2] = 1;
    }
    if ([_model.has_debt isEqualToString:@"1"]) {
        flag[4] = 0;

    }else if ([_model.has_debt isEqualToString:@"2"]){
        flag[4] = 1;
    }
    
    
    if ([_model.job_type isEqualToString:@"2"]) {
        //企业主
        carArray = [@[@"征信情况",@"查询次数",@"职业身份"] mutableCopy];
        carPlaceHolders = [@[@"征信情况",@"请输入征信的查询次数",@"职业身份"] mutableCopy];
        if ([_model.has_guarantee_slip isEqualToString:@"1"]) {
            flag[2] = 0;
        }else if ([_model.has_guarantee_slip isEqualToString:@"2"]){
            flag[2] = 1;
        }
        if ([_model.has_debt isEqualToString:@"1"]) {
            flag[3] = 0;
        }else if ([_model.has_debt isEqualToString:@"2"]){
            flag[3] = 1;
        }
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:carArray];
        [self.dataArray addObject:qyzArray];
        [self.dataArray addObject:bdjArray];
        [self.dataArray addObject:fzArray];
        [self.placeHolderArray removeAllObjects];
        [self.placeHolderArray addObject:carPlaceHolders];
        [self.placeHolderArray addObject:qyzPlaceHolders];
        [self.placeHolderArray addObject:bdjPlaceHolders];
        [self.placeHolderArray addObject:fzPlaceHolders];
    }
    if([self.model.job_type isEqualToString:@"3"]){
        //无固定职业
        if ([_model.has_debt isEqualToString:@"1"]) {
            flag[1] = 0;
        }else if ([_model.has_debt isEqualToString:@"2"]){
            flag[1] = 1;
        }
        carArray = [@[@"征信情况",@"查询次数",@"职业身份",@"工资金额"] mutableCopy];
        carPlaceHolders = [@[@"征信情况",@"请输入征信的查询次数",@"职业身份",@"公资金额)"] mutableCopy];
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:carArray];
        [self.dataArray addObject:bdjArray];
        [self.dataArray addObject:fzArray];
        [self.placeHolderArray removeAllObjects];
        [self.placeHolderArray addObject:carPlaceHolders];
        [self.placeHolderArray addObject:bdjPlaceHolders];
        [self.placeHolderArray addObject:fzPlaceHolders];
    }
    
    
    //self.assetInfoArray = [array mutableCopy];
    [self subDict];
    [self tableView];
    _datePicker=[[LJKDatePicker alloc]initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width,200)];
    _datePicker.delegate=self;
    [self.view  addSubview:_datePicker];
    [self.view bringSubviewToFront:_datePicker];
    [_datePicker setHidden:YES];

}
-(NSMutableDictionary *)subDict{
    if (!_subDict) {
        _subDict = [NSMutableDictionary dictionary];
    }
    return _subDict;
}
#pragma mark - 创建tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44, kScreen_Width, kScreen_Height-64-44) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        [_tableView registerClass:[FillinViewCell class] forCellReuseIdentifier:@"FillinViewCell"];
        [self.view addSubview:_tableView];
        [self initNextButton];
        self.tableView.sectionHeaderHeight = 44;
    }
    return _tableView;
}
-(void)initNextButton{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 70)];
    
    _nextButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_nextButton setTitle:LocalizationNotNeeded(@"确认提交") forState:(UIControlStateNormal)];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_nextButton setBackgroundColor:[UIColor orangeColor]];
    [_nextButton addTarget:self action:@selector(next:) forControlEvents:(UIControlEventTouchUpInside)];

    _nextButton.layer.cornerRadius = 5.0f;
    [footView addSubview:_nextButton];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 40));
        make.top.mas_equalTo(footView.mas_top).offset(10);
    }];
    self.tableView.tableFooterView = footView;
}
-(void)next:(UIButton *)button{
    [self.view endEditing:YES];
        @try {
            if ([[_subDict objectForKey:@"agency_type"] length]<=0) {
                if (self.model.agency_type) {
                    [_subDict setObject:self.model.agency_type forKey:@"agency_type"];
                }else{
                    [_subDict setObject:@"1" forKey:@"agency_type"];
                }
            }
            if ([[_subDict objectForKey:@"job_type"] length]<=0){
                if (self.model.job_type) {
                    [_subDict setObject:_model.job_type forKey:@"job_type"];
                }else{
                    [_subDict setObject:@"1" forKey:@"job_type"];
                }
                if ([[_subDict objectForKey:@"job_type"] isEqualToString:@"1"]) {
                    if (self.model) {
                        [_subDict setObject:self.model.has_social_security forKey:@"has_social_security"];
                        [_subDict setObject:self.model.has_house_fund forKey:@"has_house_fund"];
                        [_subDict setObject:self.model.has_guarantee_slip forKey:@"has_guarantee_slip"];
                        [_subDict setObject:self.model.has_debt forKey:@"has_debt"];
                    }
                    if ([self.model.has_guarantee_slip isEqualToString:@"1"]) {
                        [_subDict setObject:self.model.social_security_contribute forKey:@"social_security_contribute"];
                        [_subDict setObject:self.model.guarantee_buytime forKey:@"guarantee_buytime"];
                    }else{
//                        [_subDict removeObjectForKey:@"guarantee_buytime"];
//                        [_subDict removeObjectForKey:@"guarantee_company"];
//                        [_subDict removeObjectForKey:@"guarantee_money"];
//                        [_subDict removeObjectForKey:@"guarantee_years"];
                    }
                    
                    if ([self.model.has_debt isEqualToString:@"1"]) {
                        [_subDict setObject:self.model.debt_type forKey:@"debt_type"];
                    }else{
//                        [_subDict removeObjectForKey:@"debt_type"];
//                        [_subDict removeObjectForKey:@"debt_money"];
                    }
                    
                    if ([[_subDict objectForKey:@"social_security_contribute"] length]>0) {
                        if ([self.model.social_security_contribute isEqualToString:@"0"]) {
                            self.model.social_security_contribute = @"1";
                            [_subDict setObject:@"1" forKey:@"social_security_contribute"];
                        }
                    }else{
//                        [_subDict removeObjectForKey:@"social_security_money"];
//                        [_subDict removeObjectForKey:@"social_security_contribute"];
                        if ([self.model.social_security_contribute isEqualToString:@"0"]) {
                            self.model.social_security_contribute = @"1";
                            [_subDict setObject:@"1" forKey:@"social_security_contribute"];
                        }else{
                            [_subDict setObject:@"1" forKey:@"social_security_contribute"];
                        }
                    }
                    if ([self.model.has_house_fund isEqualToString:@"1"]) {
                        [_subDict setObject:self.model.debt_type forKey:@"debt_type"];
                    }else{
//                        [_subDict removeObjectForKey:@"house_fund_money"];
                    }
                    
                    if ([[_subDict objectForKey:@"company_type"] length]<=0) {
                        if (self.model.company_type) {
                            [_subDict setObject:_model.company_type forKey:@"company_type"];
                        }else{
                            [_subDict setObject:@"5" forKey:@"company_type"];
                        }
                    }
                    if ([[_subDict objectForKey:@"salary_type"] length]<=0){
                        if (self.model.salary_type) {
                            [_subDict setObject:_model.salary_type forKey:@"salary_type"];
                        }else{
                            [_subDict setObject:@"1" forKey:@"salary_type"];
                        }
                    }
                    
                    if ([[_subDict objectForKey:@"salary_money"] length]<=0){
                        if (![self.model.job_type isEqualToString:@"2"]) {
                            [LCProgressHUD showInfoMsg:@"请填写工资发放金额"];
                        }
                    }else{
                        SCNavTabBarController * nav =  (SCNavTabBarController *)self.parentViewController;
                        BaseInfoController *controller1 = (BaseInfoController *)nav.childViewControllers[0];
                        NSLog(@"controller1.date = %@",controller1.subDict);
                        AssetController *controller2 = (AssetController *)nav.childViewControllers[1];
                        NSLog(@"controller2.date = %@",controller2.subDict);
                        NSLog(@"%@",[_subDict mj_JSONObject]);
                        NSMutableDictionary *dict = [NSMutableDictionary new];
                        [dict addEntriesFromDictionary:controller1.subDict];
                        [dict addEntriesFromDictionary:controller2.subDict];
                        [dict addEntriesFromDictionary:_subDict];
                        [self submitWithDict:dict];
                    }
                }
            }else{
                if ([[_subDict objectForKey:@"job_type"] isEqualToString:@"1"]) {
                    if (self.model) {
                        [_subDict setObject:self.model.has_social_security forKey:@"has_social_security"];
                        [_subDict setObject:self.model.has_house_fund forKey:@"has_house_fund"];
                        [_subDict setObject:self.model.has_guarantee_slip forKey:@"has_guarantee_slip"];
                        [_subDict setObject:self.model.has_debt forKey:@"has_debt"];
                    }else{
                    
                    }
                    if ([self.model.has_guarantee_slip isEqualToString:@"1"]) {
                        [_subDict setObject:self.model.social_security_contribute forKey:@"social_security_contribute"];
                        [_subDict setObject:self.model.guarantee_buytime forKey:@"guarantee_buytime"];
                    }else{
//                        [_subDict removeObjectForKey:@"guarantee_buytime"];
//                        [_subDict removeObjectForKey:@"guarantee_company"];
//                        [_subDict removeObjectForKey:@"guarantee_money"];
//                        [_subDict removeObjectForKey:@"guarantee_years"];
                    }
                    
                    if ([self.model.has_debt isEqualToString:@"1"]) {
                        [_subDict setObject:self.model.debt_type forKey:@"debt_type"];
                    }else{
//                        [_subDict removeObjectForKey:@"debt_type"];
//                        [_subDict removeObjectForKey:@"debt_money"];
                    }
                    
                    if ([self.model.has_social_security isEqualToString:@"1"]) {
                        
                    }else{
//                        [_subDict removeObjectForKey:@"social_security_money"];
//                        [_subDict removeObjectForKey:@"social_security_contribute"];
                    }
                    if ([self.model.social_security_contribute isEqualToString:@"0"]) {
                        self.model.social_security_contribute = @"1";
                        [_subDict setObject:@"1" forKey:@"social_security_contribute"];
                    }else{
                        if (![_subDict objectForKey:@"social_security_contribute"]) {
                            [_subDict setObject:@"1" forKey:@"social_security_contribute"];
                        }
                    }
                    if ([self.model.has_house_fund isEqualToString:@"1"]) {
                        [_subDict setObject:self.model.debt_type forKey:@"debt_type"];
                    }else{
                        //[_subDict removeObjectForKey:@"house_fund_money"];
                    }
                    
                    if ([[_subDict objectForKey:@"company_type"] length]<=0) {
                        if (self.model.company_type) {
                            [_subDict setObject:_model.company_type forKey:@"company_type"];
                        }else{
                            [_subDict setObject:@"5" forKey:@"company_type"];
                        }
                    }
                    if ([[_subDict objectForKey:@"salary_type"] length]<=0){
                        if (self.model.salary_type) {
                            [_subDict setObject:_model.salary_type forKey:@"salary_type"];
                        }else{
                            [_subDict setObject:@"1" forKey:@"salary_type"];
                        }
                    }

                    if ([[_subDict objectForKey:@"salary_money"] length]<=0){
                        if (![self.model.job_type isEqualToString:@"2"]) {
                            [LCProgressHUD showInfoMsg:@"请填写工资发放金额"];
                        }
                    }else{
                        SCNavTabBarController * nav =  (SCNavTabBarController *)self.parentViewController;
                        BaseInfoController *controller1 = (BaseInfoController *)nav.childViewControllers[0];
                        NSLog(@"controller1.date = %@",controller1.subDict);
                        AssetController *controller2 = (AssetController *)nav.childViewControllers[1];
                        NSLog(@"controller2.date = %@",controller2.subDict);
                        NSLog(@"%@",[_subDict mj_JSONObject]);
                        NSMutableDictionary *dict = [NSMutableDictionary new];
                        [dict addEntriesFromDictionary:controller1.subDict];
                        [dict addEntriesFromDictionary:controller2.subDict];
                        [dict addEntriesFromDictionary:_subDict];
                        [self submitWithDict:dict];
                    }
                }

                if ([[_subDict objectForKey:@"job_type"] isEqualToString:@"2"]) {
                    //社保
                    [_subDict setObject:@"2" forKey:@"has_social_security"];
                    //公积金
                    [_subDict setObject:@"2" forKey:@"has_house_fund"];
                    if (self.model) {
                        //保单
                        [_subDict setObject:self.model.has_guarantee_slip forKey:@"has_guarantee_slip"];
                        //负债
                        [_subDict setObject:self.model.has_debt forKey:@"has_debt"];
                    }
                    if ([self.model.has_debt isEqualToString:@"2"]) {
                        [_subDict removeObjectForKey:@"debt_money"];
                        [_subDict removeObjectForKey:@"debt_type"];
                    }

                    SCNavTabBarController * nav =  (SCNavTabBarController *)self.parentViewController;
                    BaseInfoController *controller1 = (BaseInfoController *)nav.childViewControllers[0];
                    NSLog(@"controller1.date = %@",controller1.subDict);
                    AssetController *controller2 = (AssetController *)nav.childViewControllers[1];
                    NSLog(@"controller2.date = %@",controller2.subDict);
                    NSLog(@"%@",[_subDict mj_JSONObject]);
                    NSMutableDictionary *dict = [NSMutableDictionary new];
                    [dict addEntriesFromDictionary:controller1.subDict];
                    [dict addEntriesFromDictionary:controller2.subDict];
                    [dict addEntriesFromDictionary:_subDict];
                    [self submitWithDict:dict];
                }
                if ([[_subDict objectForKey:@"job_type"] isEqualToString:@"3"]) {
                    
                    [_subDict removeObjectForKey:@"social_security_contribute"];
                    [_subDict removeObjectForKey:@"social_security_money"];
                    [_subDict removeObjectForKey:@"has_social_security"];
                    [_subDict removeObjectForKey:@"house_fund_money"];
                    [_subDict removeObjectForKey:@"has_house_fund"];

                    if ([[_subDict objectForKey:@"company_type"] length]<=0) {
                        [_subDict setObject:@"1" forKey:@"company_type"];
                    }
                    if ([[_subDict objectForKey:@"salary_type"] length]<=0){
                        [_subDict setObject:@"1" forKey:@"salary_type"];
                    }
                    if ([[_subDict objectForKey:@"salary_money"] length]<=0){
                        [LCProgressHUD showInfoMsg:@"请填写工资发放金额"];
                    }else{
                        SCNavTabBarController * nav =  (SCNavTabBarController *)self.parentViewController;
                        BaseInfoController *controller1 = (BaseInfoController *)nav.childViewControllers[0];
                        NSLog(@"controller1.date = %@",controller1.subDict);
                        AssetController *controller2 = (AssetController *)nav.childViewControllers[1];
                        NSLog(@"controller2.date = %@",controller2.subDict);
                        NSLog(@"_subDict%@",[_subDict mj_JSONObject]);
                        NSMutableDictionary *dict = [NSMutableDictionary new];
                        [dict addEntriesFromDictionary:controller1.subDict];
                        [dict addEntriesFromDictionary:controller2.subDict];
                        [dict addEntriesFromDictionary:_subDict];
                        [self submitWithDict:dict];
                    }
                }

            }
        } @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
            [LCProgressHUD showMessage:exception.description];
        } @finally {
            
        }
    }
//}
//提交个人信息
-(void)submitWithDict:(NSDictionary *)dict{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableArray *array =[NSMutableArray array];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSDictionary *opa = @{@"price":key,@"vaule":[NSString stringWithFormat:@"%@%@",key,obj]};
        [array addObject:opa];
        if ([key isEqualToString:@"notes"]||[key isEqualToString:@"other_pic"]) {
            [param setObject:obj forKey:key];
        }else{
            [param setObject:[self setRSAencryptString:obj] forKey:key];
        }
    }];
    if (self.flagTag == 15 ) {
        NSString *title = @"确认重新提交";
        NSString *message = NSLocalizedString(@"请输入重新提交原因", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"否", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"是", nil);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = LocalizationNotNeeded(@"请输入重新提交原因");
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:)name:UITextFieldTextDidChangeNotification object:textField];
        }];

        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"%@",cancelButtonTitle);
            
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"%@",otherButtonTitle);
            UITextField * textField =  alertController.textFields[0];
            NSString * url ;
            if (self.model) {
                url = ModifyOrder;
                NSDictionary *opa = @{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"%@%@",@"order_nid",self.detailModel.data.order_info.order_nid]};
                [array addObject:opa];
                
                NSDictionary *opa1 = @{@"price":@"resubmit_reason",@"vaule":[NSString stringWithFormat:@"%@%@",@"resubmit_reason",textField.text]};
                [array addObject:opa1];
                [param setObject:textField.text forKey:@"resubmit_reason"];
                [param setObject:[self setRSAencryptString:self.detailModel.data.order_info.order_nid] forKey:@"order_nid"];
            }else{
                url = AddOrder;
            }
            [param setObject:[self setUserTokenStr:array] forKey:@"token"];
            [LCProgressHUD showLoading:@"信息提交中"];
            [self post:url parameters:param success:^(id dic) {
                NSLog(@"%@",[dic mj_JSONString]);
                if ([dic[@"code"] intValue]==0) {
                    [Window makeToast:@"提交成功" duration:1.0 position:CenterPoint];
                    appdelegate.refresh = 3;
                    [self.navigationController popToRootViewControllerAnimated:YES];

                }else {
                    NSString *msg = dic[@"info"];
                    if (![XYString isBlankString:msg]) {
                        [LCProgressHUD showInfoMsg:msg];
                    }else {
                        [LCProgressHUD hide];
                    }
                }
            } failure:^(NSError *error) {
                [LCProgressHUD showLoading:@"失败"];
            }];

        }];
        UITextField * textField =  alertController.textFields[0];
        if (textField.text.length<=0) {
            otherAction.enabled = NO;
        }else{
            otherAction.enabled = YES;
        }
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }else{
        NSString * url ;
        
        if (self.model) {
            url = ModifyOrder;
            NSDictionary *opa = @{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"%@%@",@"order_nid",self.detailModel.data.order_info.order_nid]};
            [array addObject:opa];
            [param setObject:[self setRSAencryptString:self.detailModel.data.order_info.order_nid] forKey:@"order_nid"];
        }else{
            url = AddOrder;
        }
        [param setObject:[self setUserTokenStr:array] forKey:@"token"];
        [LCProgressHUD showLoading:@"信息提交中"];
        [self post:url parameters:param success:^(id dic) {
            NSLog(@"%@",[dic mj_JSONString]);
            if ([dic[@"code"] intValue]==0) {
                appdelegate.refresh = 3;
                [Window makeToast:@"提交成功" duration:1.0 position:CenterPoint];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else {
                NSString *msg = dic[@"info"];
                if (![XYString isBlankString:msg]) {
                    [LCProgressHUD showInfoMsg:msg];
                }else {
                    [LCProgressHUD hide];
                }
            }
        } failure:^(NSError *error) {
            [LCProgressHUD showLoading:@"失败"];
        }];
    }
}
-(void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = login.text.length > 1;
    }
}

-(NSMutableArray *)assetInfoArray{
    if (!_assetInfoArray) {
        _assetInfoArray = [NSMutableArray array];
    }
    return _assetInfoArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)placeHolderArray{
    if (!_placeHolderArray) {
        _placeHolderArray = [NSMutableArray array];
    }
    return _placeHolderArray;
}
#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = _dataArray[section];
    if ([array[0] isEqualToString:@"从事行业"]) {
        flag[section] = 0;
    }
    if (section==0) {
        return flag[section] == 0? array.count : 0;
    }else{
        return flag[section] == 0? array.count-1 : 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(&*self)weakSelf = self;
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%@", self.dataArray[indexPath.section][indexPath.row]];//以indexPath来唯一确定cell
    FillinViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
    if (cell == nil) {
        cell = [[FillinViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.indexPath = indexPath;
        cell.inputTextField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.model) {
        cell.creditModel = self.model;
    }
    if (indexPath.section == 0) {
        cell.title = _dataArray[indexPath.section][indexPath.row];
        cell.inputTextField.placeholder = _placeHolderArray[indexPath.section][indexPath.row];
    }else{
        cell.title = _dataArray[indexPath.section][indexPath.row+1];
        cell.inputTextField.placeholder = _placeHolderArray[indexPath.section][indexPath.row+1];
    }
    if ([cell.title isEqualToString:@"保险购买时间"]) {
        objc_setAssociatedObject(cell.downButton, "firstObject", cell.inputTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [cell.downButton addTarget:self action:@selector(selectDate:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    if (self.model) {
        [self fillCell:cell.inputTextField withModel:_model];
    }
    __weak typeof(cell)weakCell = cell;
    [cell setCallBackHandler:^(NSDictionary * dict) {
        __strong typeof(weakSelf) sself = weakSelf;
        NSDictionary *ddd = [dict allValues][0];
        NSLog(@"*-*-%@-%@-*-*",[ddd allValues][0],[dict allKeys][0]);
        [weakSelf.subDict setObject:[ddd allValues][0] forKey:[dict allKeys][0]];
        NSString * value = [ddd allValues][0];
        if ([[dict allKeys][0] isEqualToString:@"agency_type"]) {
            weakSelf.model.agency_type = value;
        }
        if ([[dict allKeys][0] isEqualToString:@"job_type"]) {
            weakSelf.model.job_type = value;
        }
        if ([[dict allKeys][0] isEqualToString:@"company_type"]) {
            weakSelf.model.company_type = value;
        }
        if ([[dict allKeys][0] isEqualToString:@"salary_type"]) {
            weakSelf.model.salary_type = value;
        }
        if ([[dict allKeys][0] isEqualToString:@"social_security_contribute"]) {
            weakSelf.model.social_security_contribute = value;
        }
        if ([[dict allKeys][0] isEqualToString:@"debt_type"]) {
            weakSelf.model.debt_type = value;
        }
        if ([weakCell.title isEqualToString:@"职业身份"]) {
            if ([[ddd allKeys][0] isEqualToString:SBZ]) {
                if ([weakSelf.dataArray count]!=5) {
                    
                    [weakSelf.dataArray removeAllObjects];
                    [weakSelf.placeHolderArray removeAllObjects];
                    sself->carArray = [@[@"征信情况",@"查询次数",@"职业身份",@"工作单位",@"工资发放",@"工资金额"] mutableCopy];
                    sself->carPlaceHolders = [@[@"征信情况",@"请输入征信的查询次数",@"职业身份",@"工作单位",@"工资发放",@"公资金额"] mutableCopy];
                    
                    sself->flag[1] =  sself->flag[2] =  sself->flag[3] =  sself->flag[4] = 1 ;
                    sself.model.has_debt = @"1";
                    sself.model.has_house_fund = @"1";
                    sself.model.has_guarantee_slip = @"1";
                    sself.model.has_social_security = @"1";

                    [weakSelf.dataArray addObject:sself->carArray];
                    [weakSelf.dataArray addObject:sself->sbzArray];
                    [weakSelf.dataArray addObject:sself->gjjArray];
                    [weakSelf.dataArray addObject:sself->bdjArray];
                    [weakSelf.dataArray addObject:sself->fzArray];
                    
                    [weakSelf.placeHolderArray addObject:sself->carPlaceHolders];
                    [weakSelf.placeHolderArray addObject:sself->sbzPlaceHolders];
                    [weakSelf.placeHolderArray addObject:sself->gjjPlaceHolders];
                    [weakSelf.placeHolderArray addObject:sself->bdjPlaceHolders];
                    [weakSelf.placeHolderArray addObject:sself->fzPlaceHolders];
                    weakSelf.model.job_type = @"1";
                    [weakSelf.tableView reloadData];
                }
                
            }else if ([[ddd allKeys][0] isEqualToString:QYZ]){
                
                if ([weakSelf.dataArray count]!=4) {
                    sself->flag[1] = 0;
                    sself->flag[2] =  sself->flag[3] =  sself->flag[4] = 1 ;
                    sself.model.has_debt = @"1";
                    sself.model.has_house_fund = @"1";
                    sself.model.has_guarantee_slip = @"1";
                    sself.model.has_social_security = @"1";
                    sself->carArray = [@[@"征信情况",@"查询次数",@"职业身份"] mutableCopy];
                    sself->carPlaceHolders = [@[@"征信情况",@"请输入征信的查询次数",@"职业身份"] mutableCopy];
                    
                    [weakSelf.dataArray removeAllObjects];
                    [weakSelf.placeHolderArray removeAllObjects];
                    
                    [weakSelf.dataArray addObject:sself->carArray];
                    [weakSelf.dataArray addObject:sself->qyzArray];
                    [weakSelf.dataArray addObject:sself->bdjArray];
                    [weakSelf.dataArray addObject:sself->fzArray];
                    
                    [weakSelf.placeHolderArray addObject:sself->carPlaceHolders];
                    [weakSelf.placeHolderArray addObject:sself->qyzPlaceHolders];
                    [weakSelf.placeHolderArray addObject:sself->bdjPlaceHolders];
                    [weakSelf.placeHolderArray addObject:sself->fzPlaceHolders];
                    weakSelf.model.job_type = @"2";
                    [weakSelf.tableView reloadData];
                }
                
            }else if ([[ddd allKeys][0] isEqualToString:WGDZY]){
                if ([weakSelf.dataArray count]!=3) {
                    sself->carArray = [@[@"征信情况",@"查询次数",@"职业身份",@"工资金额"] mutableCopy];
                    sself->carPlaceHolders = [@[@"征信情况",@"请输入征信的查询次数",@"职业身份",@"公资金额"] mutableCopy];
                    sself->flag[1] =  sself->flag[2] =  sself->flag[3] =  sself->flag[4] = 1 ;
                    sself.model.has_debt = @"1";
                    sself.model.has_house_fund = @"1";
                    sself.model.has_guarantee_slip = @"1";
                    sself.model.has_social_security = @"1";
                    [weakSelf.dataArray removeAllObjects];
                    [weakSelf.placeHolderArray removeAllObjects];
                    
                    [weakSelf.dataArray addObject:sself->carArray];
                    [weakSelf.dataArray addObject:sself->bdjArray];
                    [weakSelf.dataArray addObject:sself->fzArray];
                    
                    [weakSelf.placeHolderArray addObject:sself->carPlaceHolders];
                    [weakSelf.placeHolderArray addObject:sself->bdjPlaceHolders];
                    [weakSelf.placeHolderArray addObject:sself->fzPlaceHolders];
                    weakSelf.model.job_type = @"3";
                    [weakSelf.tableView reloadData];
                }
            }
            sself->hasguarantee = @"否";
            sself->hassocial = @"否";
            sself->hasfund = @"否";
            sself->hasDebt = @"否";
            weakSelf.model.has_debt = @"2";
            weakSelf.model.has_house_fund = @"2";
            weakSelf.model.has_guarantee_slip = @"2";
            weakSelf.model.has_social_security = @"2";
            [weakSelf.subDict setObject:@"2" forKey:@"has_debt"];
            [weakSelf.subDict setObject:@"2" forKey:@"has_house_fund"];
            [weakSelf.subDict setObject:@"2" forKey:@"has_guarantee_slip"];
            [weakSelf.subDict setObject:@"2" forKey:@"has_social_security"];
        }
    }];
    return cell;
}

-(void)fillCell:(MyTextField *)textField withModel:(User_Credit_Info *)model{
    UILabel *label = (UILabel *)textField.leftView;
    @try {
        if ([label.text isEqualToString:@"查询次数"]) {
            agency_querytimes == nil?(textField.text = model.agency_querytimes):(textField.text = agency_querytimes);
            [self.subDict setObject:textField.text forKey:@"agency_querytimes"];
        }else if ([label.text isEqualToString:@"工资金额"]){
            salary_money == nil?(textField.text = model.salary_money):(textField.text = salary_money);
            [self.subDict setObject:textField.text forKey:@"salary_money"];
        }else if ([label.text isEqualToString:@"社保缴纳金额"]){
            social_security_money == nil?(textField.text = model.social_security_money):(textField.text = social_security_money);
            [self.subDict setObject:textField.text forKey:@"social_security_money"];
        }else if ([label.text isEqualToString:@"公积金缴纳金额"]){
            house_fund_money == nil?(textField.text = model.house_fund_money):(textField.text = house_fund_money);
            [self.subDict setObject:textField.text forKey:@"house_fund_money"];
        }else if ([label.text isEqualToString:@"投保公司"]){
            guarantee_company == nil?(textField.text = model.guarantee_company):(textField.text = guarantee_company);
            [self.subDict setObject:textField.text forKey:@"guarantee_company"];
        }else if ([label.text isEqualToString:@"保险年限"]){
            guarantee_years == nil?(textField.text = model.guarantee_years):(textField.text = guarantee_years);
            [self.subDict setObject:textField.text forKey:@"guarantee_years"];
        }else if ([label.text isEqualToString:@"年缴纳金额"]){
            guarantee_money == nil?(textField.text = model.guarantee_money):(textField.text = guarantee_money);
            [self.subDict setObject:textField.text forKey:@"guarantee_money"];
        }else if ([label.text isEqualToString:@"从事行业"]){
            industry == nil?(textField.text = model.industry):(textField.text = industry);
            [self.subDict setObject:textField.text forKey:@"industry"];
        }else if ([label.text isEqualToString:@"生意流水"]){
            month_money == nil?(textField.text = model.month_money):(textField.text = month_money);
            [self.subDict setObject:textField.text forKey:@"month_money"];
        }else if ([label.text isEqualToString:@"负债金额"]){
            debt_money == nil?(textField.text = model.debt_money):(textField.text = debt_money);
            [self.subDict setObject:textField.text forKey:@"debt_money"];
        }else if ([label.text isEqualToString:@"保险购买时间"]){
            gBuytime == nil?(textField.text = model.guarantee_buytime):(textField.text = gBuytime);
            [self.subDict setObject:textField.text forKey:@"guarantee_buytime"];
        }

    } @catch (NSException *exception) {
        [Window makeToast:exception.description duration:1.0 position:CenterPoint];
    } @finally {
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else {
        cell.backgroundColor = UIColorWithRGBA(248, 248, 248, 1);
    }
}
// tableView头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    
    UIButton *button1 ;
    UIImage *image= [UIImage   imageNamed:@"nav_icon_more_norm"];
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(kScreen_Width-16-image.size.width, 0.0, image.size.width, image.size.height);
    button1.frame = frame;
    [button1 setBackgroundImage:image forState:UIControlStateNormal];
    button1.backgroundColor= [UIColor clearColor];
    [headView addSubview:button1];
    button1.centerY = headView.centerY;
    
    MyTextField *textField = [MyTextField new];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    tempStr == nil ?(textField.text = LocalizationNotNeeded(@"否") ):(textField.text = tempStr);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:13];
    UILabel * titleLabel = [UILabel new];
    titleLabel.textColor =[UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:13];
    textField.tag = 600+section;
    textField.delegate = self;
    textField.leftView = titleLabel;
    titleLabel.text = _dataArray[section][0];
    if ([titleLabel.text isEqualToString:@"是否有社保"]) {
        if (hassocial) {
            textField.text = hassocial;
            if ([hassocial isEqualToString:@"否"]) {
                flag[section] = 1;
            }else{
                flag[section] = 0;
            }
        }else{
            if (self.model) {
                if ([self.model.has_social_security isEqualToString:@"1"]) {
                    textField.text = LocalizationNotNeeded(@"是");
                    [_subDict setObject:@"1" forKey:@"has_social_security"];
                }else{
                    textField.text = LocalizationNotNeeded(@"否");
                    [_subDict setObject:@"2" forKey:@"has_social_security"];
                }
            }else{
                textField.text = LocalizationNotNeeded(@"否");
                [_subDict setObject:@"2" forKey:@"has_social_security"];
            }

        }
        //[tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationNone)];
    }
    if ([titleLabel.text isEqualToString:@"是否有公积金"]) {
        if (hasfund) {
            textField.text = hasfund;
            if ([hasfund isEqualToString:@"否"]) {
                flag[section] = 1;
            }else{
                flag[section] = 0;
            }
        }else{
            if (self.model) {
                if ([self.model.has_house_fund isEqualToString:@"1"]) {
                    textField.text = LocalizationNotNeeded(@"是");
                    [_subDict setObject:@"1" forKey:@"has_house_fund"];
                }else{
                    textField.text = LocalizationNotNeeded(@"否");
                    [_subDict setObject:@"2" forKey:@"has_house_fund"];
                }
            }else{
                textField.text = LocalizationNotNeeded(@"否");
                [_subDict setObject:@"2" forKey:@"has_house_fund"];
            }
            
        }
        //[tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationNone)];
    }
    if ([titleLabel.text isEqualToString:@"是否有保单"]) {
        if (hasguarantee) {
            textField.text = hasguarantee;
            if ([hasguarantee isEqualToString:@"否"]) {
                flag[section] = 1;
            }else{
                flag[section] = 0;
            }
        }else{
            if (self.model) {
                if ([self.model.has_guarantee_slip isEqualToString:@"1"]) {
                    textField.text = LocalizationNotNeeded(@"是");
                    [_subDict setObject:@"1" forKey:@"has_guarantee_slip"];
                }else{
                    textField.text = LocalizationNotNeeded(@"否");
                    [_subDict setObject:@"2" forKey:@"has_guarantee_slip"];
                }
            }else{
                textField.text = LocalizationNotNeeded(@"否");
                [_subDict setObject:@"2" forKey:@"has_guarantee_slip"];
            }
            
        }
       // [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationNone)];
    }
    if ([titleLabel.text isEqualToString:@"是否有负债"]) {
        if (hasDebt) {
            textField.text = hasDebt;
            if ([hasDebt isEqualToString:@"否"]) {
                flag[section] = 1;
            }else{
                flag[section] = 0;
            }

        }else{
            if (self.model) {
                if ([self.model.has_debt isEqualToString:@"1"]) {
                    textField.text = LocalizationNotNeeded(@"是");
                    [_subDict setObject:@"1" forKey:@"has_debt"];
                }else{
                    textField.text = LocalizationNotNeeded(@"否");
                    [_subDict setObject:@"2" forKey:@"has_debt"];
                }
            }else{
                textField.text = LocalizationNotNeeded(@"否");
                [_subDict setObject:@"2" forKey:@"has_debt"];
            }
        }
        //[tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationNone)];
    }
    [headView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headView);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, headView.frame.size.height));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    headView.tag = 100 + section; // tag 值关联哪个section
    if ([titleLabel.text isEqualToString:@"从事行业"]) {
         [button1 removeFromSuperview];
        if (self.model.industry) {
            textField.text = self.model.industry;
        }else{ textField.text = @"";}
        textField.placeholder = @"";
    }else{
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
        [textField addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textField.mas_top);
            make.left.mas_equalTo(textField.mas_left).offset(0);
            make.right.mas_equalTo(textField.mas_right).offset(0);
            make.height.mas_equalTo(textField.mas_height);
        }];
        objc_setAssociatedObject(button, "firstObject", textField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(button, "secondObject", headView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
       if (section == 0) {
        return nil;
       }
    return headView;
}

-(void)click:(UIButton *)buttton{
    UITextField * textField = objc_getAssociatedObject(buttton, "firstObject");
    UIView *headView =  objc_getAssociatedObject(buttton, "secondObject");

    UILabel *label = (UILabel *)textField.leftView;
    NSString *title = label.text;
    NSString *message = NSLocalizedString(@"请选择您的信息", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"是", nil);
    NSString *otherButtonTitle1 = NSLocalizedString(@"否", nil);
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"%@",cancelButtonTitle);
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];

        NSLog(@"%@",otherButtonTitle);
        //是 表示拥有
        textField.text = tempStr = otherButtonTitle;
        NSInteger section = headView.tag - 100;
        flag[section] = 0; // 1->0 0->1
        if ([title isEqualToString:@"是否有社保"]) {
            self.model.has_social_security = @"1";
            hassocial = @"是";
            [_subDict setObject:@"1" forKey:@"has_social_security"];
        }
        if ([title isEqualToString:@"是否有公积金"]) {
            self.model.has_house_fund = @"1";
            hasfund = @"是";
            [_subDict setObject:@"1" forKey:@"has_house_fund"];
        }
        if ([title isEqualToString:@"是否有保单"]) {
            self.model.has_guarantee_slip = @"1";
            hasguarantee = @"是";
            [_subDict setObject:@"1" forKey:@"has_guarantee_slip"];
        }
        if ([title isEqualToString:@"是否有负债"]) {
            self.model.has_debt = @"1";
            hasDebt = @"是";
            [_subDict setObject:@"1" forKey:@"has_debt"];
        }
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    }];
    UIAlertAction *otherAction1 = [UIAlertAction actionWithTitle:otherButtonTitle1 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"%@",otherButtonTitle1);
        textField.text = tempStr = otherButtonTitle1;
        NSInteger section = headView.tag - 100;
        flag[section] = 1; // 1->0 0->1
        if ([title isEqualToString:@"是否有社保"]) {
            self.model.has_social_security = @"2";
            hassocial = @"否";
            [_subDict setObject:@"2" forKey:@"has_social_security"];
        }
        if ([title isEqualToString:@"是否有公积金"]) {
            self.model.has_house_fund = @"2";
            hasfund = @"否";
            [_subDict setObject:@"2" forKey:@"has_house_fund"];
        }
        if ([title isEqualToString:@"是否有保单"]) {
            self.model.has_guarantee_slip = @"2";
            hasguarantee = @"否";
            [_subDict setObject:@"2" forKey:@"has_guarantee_slip"];
        }
        if ([title isEqualToString:@"是否有负债"]) {
            self.model.has_debt = @"2";
            hasDebt = @"否";
            [_subDict setObject:@"2" forKey:@"has_debt"];
        }
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [alertController addAction:otherAction1];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)tap:(UITapGestureRecognizer *)tap {
    // 获取点击的是哪个分区的头视图
    NSInteger section = tap.view.tag - 100;
    flag[section] ^= 1; // 1->0 0->1
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - textField 代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UILabel *label = (UILabel *)textField.leftView;
    if ([label.text isEqualToString:@"征信情况"]||[label.text isEqualToString:@"职业身份"]||[label.text isEqualToString:@"工作单位"]||[label.text isEqualToString:@"工资发放"]||[label.text isEqualToString:@"社保缴纳形式"]||[label.text isEqualToString:@"保险购买时间"]||[label.text isEqualToString:@"负债类型"]||[label.text isEqualToString:@"是否有公积金"]||[label.text isEqualToString:@"是否有社保"]||[label.text isEqualToString:@"是否有保单"]||[label.text isEqualToString:@"是否有负债"]) {
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    UILabel *label = (UILabel *)textField.leftView;
    @try {
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    if ([label.text isEqualToString:@"查询次数"]) {
        agency_querytimes = textField.text;
        self.model.agency_type = textField.text;
        [self.subDict setObject:textField.text forKey:@"agency_querytimes"];
    }else if ([label.text isEqualToString:@"工资金额"]){
        salary_money = textField.text;
        self.model.salary_money = textField.text;
        [self.subDict setObject:textField.text forKey:@"salary_money"];
    }else if ([label.text isEqualToString:@"社保缴纳金额"]){
        social_security_money = textField.text;
        self.model.social_security_money = textField.text;
        [self.subDict setObject:textField.text forKey:@"social_security_money"];
    }else if ([label.text isEqualToString:@"公积金缴纳金额"]){
        house_fund_money = textField.text;
        self.model.house_fund_money = textField.text;

        [self.subDict setObject:textField.text forKey:@"house_fund_money"];
    }else if ([label.text isEqualToString:@"投保公司"]){
        guarantee_company = textField.text;
        self.model.guarantee_company = textField.text;

        [self.subDict setObject:textField.text forKey:@"guarantee_company"];
    }else if ([label.text isEqualToString:@"保险年限"]){
        guarantee_years = textField.text;
        self.model.guarantee_years = textField.text;
        [self.subDict setObject:textField.text forKey:@"guarantee_years"];
    }else if ([label.text isEqualToString:@"年缴纳金额"]){
        guarantee_money = textField.text;
        self.model.guarantee_money = textField.text;
        [self.subDict setObject:textField.text forKey:@"guarantee_money"];
    }else if ([label.text isEqualToString:@"从事行业"]){
        industry = textField.text;
        self.model.industry = textField.text;

        [self.subDict setObject:textField.text forKey:@"industry"];
    }else if ([label.text isEqualToString:@"生意流水"]){
        month_money = textField.text;
        self.model.month_money = textField.text;

        [self.subDict setObject:textField.text forKey:@"month_money"];
    }else if ([label.text isEqualToString:@"负债金额"]){
        debt_money = textField.text;
        self.model.debt_money = textField.text;
        [self.subDict setObject:textField.text forKey:@"debt_money"];
    }
    return YES;
}

#pragma mark - datepicker 代理方法
-(void)selectDate:(UIButton *)button{
    
    _currentTextField = objc_getAssociatedObject(button, "firstObject");
    
    [self freechoseTime];
}
-(void)ljkBtnClick:(UIButton *)button{
    if (button==_datePicker.lconfirm) {
        [UIView   animateWithDuration:0.8 animations:^{
            [_datePicker   setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 200)];
        }];
        _currentTextField.text = [NSString stringWithFormat:@"%@-%@-%@",_datePicker.year,_datePicker.month,_datePicker.day];
        UILabel *label = (UILabel *)_currentTextField.leftView;
        if ([label.text isEqualToString:@"保险购买时间"]) {
            _model.guarantee_buytime = _currentTextField.text;
            [_subDict setObject: _currentTextField.text forKey:@"guarantee_buytime"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_datePicker  setHidden:YES];
        });
    }
    
}
//选择时间
-(void)freechoseTime{
    [_datePicker  setHidden:NO];
    [self.view endEditing:YES];
    [UIView   animateWithDuration:0.8 animations:^{
        [_datePicker   setFrame:CGRectMake(0, kScreen_Height-200-64-0.08*kScreen_Height, kScreen_Width,200)];
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
