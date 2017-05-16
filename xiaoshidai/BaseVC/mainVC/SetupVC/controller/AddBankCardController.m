//
//  AddBankCardController.m
//  xiaoshidai
//
//  Created by XSD on 2017/1/6.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "AddBankCardController.h"
#import "TextFieldCell.h"
#import "VerifyCodeCell.h"
#import "LTPickerView.h"
#import "LianLianBankModel.h"
#import "AreaModel.h"
#import "RealNameController.h"
#import "LLPaySdk.h"
#import "UITextField+RYNumberKeyboard.h"
@interface AddBankCardController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray * dataArray;
@property (nonatomic,copy) NSString * bank_account;
@property (nonatomic) NSMutableArray * detailArr;
@property (nonatomic) NSMutableArray * cityArray;
@property (nonatomic) NSMutableArray * cityIdArray;

@property (nonatomic,copy) NSString * branch;
@property (nonatomic,copy) NSString * phone;
@property (nonatomic,copy) NSString *province_id;
@property (nonatomic,copy) NSString *city_id;
@property (nonatomic,copy) NSString *bank_id;
@property (nonatomic,copy) NSString *realname_card;
@property (nonatomic,copy) NSString *id_number_card;

@property (nonatomic,copy) AreaModel *__block areaModel;
@end

@implementation AddBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataArray];
    [self tableView];
    [self initBottom];
    [self detailArr];
    _bank_id = @"01020000";//银行默认值 工商银行
    _province_id = @"23";//默认省份 四川
    _city_id = @"275";// 默认城市 成都
    _cityIdArray = [NSMutableArray array];
    [self requestBaseData];

}
-(void)requestBaseData{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    [self post:Area parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD hide];
            _areaModel = [AreaModel mj_objectWithKeyValues:dic];
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
-(NSMutableArray *)detailArr{
    if (!_detailArr) {
        _detailArr = [NSMutableArray arrayWithObjects:@"工商银行",@"四川",@"成都", nil];
    }
    return _detailArr;
}
-(void)initBottom{
    UIButton *button  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"确认新增" forState:(UIControlStateNormal)];
    [button setBackgroundColor:mainHuang];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [button setFrame:CGRectMake(10, kScreen_Height - 64 - 49 -20, kScreen_Width-20, 49)];
    [button.layer setCornerRadius:7.0];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}
//1未认证2待审核3已认证4认证失败
-(void)buttonClick:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    if ([[USER_DEFAULT objectForKey:REALNAME_STATUS] isEqualToString:@"1"] ) {
        [self alertWithStr:@"提交" Title:@"您还未实名认证，前往实名认证"];
    }else if ([[USER_DEFAULT objectForKey:REALNAME_STATUS] isEqualToString:@"4"]){
        [self alertWithStr:@"重新提交" Title:@"实名认证失败，请重新提交"];
    }else if ([[USER_DEFAULT objectForKey:REALNAME_STATUS] isEqualToString:@"4"]){
        [self alertWithStr:@"0" Title:@"实名认证待审核"];
    }else{
        [self post];
    }
}
-(void)alertWithStr:(NSString *)buttoStr Title:(NSString *)title{
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
        if (![buttoStr isEqualToString:@"0"]) {
            RealNameController * controller = [[RealNameController alloc] init];
            controller.title = @"实名认证";
            controller.buttonStr = buttoStr;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
    //addAction
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    //present
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)post{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:avoidNullStr(_bank_id)] forKey:@"bank_id"];
    [param setObject:[self setRSAencryptString:avoidNullStr(_bank_account)] forKey:@"bank_account"];
    [param setObject:[self setRSAencryptString:avoidNullStr(_branch)] forKey:@"branch"];
    [param setObject:[self setRSAencryptString:avoidNullStr(_province_id)]  forKey:@"province_id"];
    [param setObject:[self setRSAencryptString:avoidNullStr(_city_id)] forKey:@"city_id"];
    [param setObject:[self setRSAencryptString:avoidNullStr(_phone)] forKey:@"phone_reserved"];
    [param setObject:[self setRSAencryptString:avoidNullStr(_realname_card)] forKey:@"realname_card"];
    [param setObject:[self setRSAencryptString:avoidNullStr(_id_number_card)] forKey:@"id_number_card"];

    NSArray *tokenArr =@[@{@"price":@"bank_account",
                           @"vaule":[NSString stringWithFormat:@"%@%@",@"bank_account",avoidNullStr(_bank_account)]},
                         @{@"price":@"branch",
                           @"vaule":[NSString stringWithFormat:@"branch%@",avoidNullStr(_branch)]},
                         @{@"price":@"province_id",
                           @"vaule":[NSString stringWithFormat:@"province_id%@",avoidNullStr(_province_id)]},
                         @{@"price":@"city_id",
                           @"vaule":[NSString stringWithFormat:@"city_id%@",avoidNullStr(_city_id)]},
                         @{@"price":@"phone_reserved",
                           @"vaule":[NSString stringWithFormat:@"phone_reserved%@",avoidNullStr(_phone)]},
                         @{@"price":@"bank_id",
                           @"vaule":[NSString stringWithFormat:@"bank_id%@",avoidNullStr(_bank_id)]},
                         @{@"price":@"realname_card",
                           @"vaule":[NSString stringWithFormat:@"realname_card%@",avoidNullStr(_realname_card)]},
                         @{@"price":@"id_number_card",
                           @"vaule":[NSString stringWithFormat:@"id_number_card%@",avoidNullStr(_id_number_card)]},
                         ];
    [LCProgressHUD showLoading:@"提交中"];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    [self post:BIND_BEWREC parameters:param success:^(id dict) {
        if ([dict[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:dict[@"data"]];
            appdelegate.refresh = 2;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            NSString *msg = dict[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError * error) {
        [LCProgressHUD showInfoMsg:[error localizedDescription]];
    }];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"姓名",@"身份证号",@"银行名字",@"银行账号",@"开户行",@"所属省份",@"所属城市",@"手机号", nil];
        //,@"验证码"
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-49) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[TextFieldCell class] forCellReuseIdentifier:@"TextFieldCellID"];
        [_tableView registerNib:[UINib nibWithNibName:@"VerifyCodeCell" bundle:nil] forCellReuseIdentifier:@"VerifyCodeCellID"];
        [self.view addSubview:_tableView];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}
#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count) {
        return _dataArray.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString * title = _dataArray[indexPath.row];
    __weak __typeof(&*self)weakSelf = self;
    if ([title isEqualToString:_dataArray[0]] ||[title isEqualToString:_dataArray[1]] ||[title isEqualToString:_dataArray[3]] ||[title isEqualToString:_dataArray[4]]  || [title isEqualToString:_dataArray[7]]) {
        TextFieldCell *cell;
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCellID"];
        }
        cell.titleLabel.text = _dataArray[indexPath.row];
        cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",_dataArray[indexPath.row]];
        if (indexPath.row == 3 || indexPath.row == 7) {
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (indexPath.row == 1) {
            cell.textField.ry_inputType = RYIDCardInputType;
        }
        [cell setBlock:^(NSString *str) {
            if ([title isEqualToString:weakSelf.dataArray[3]]) {
                weakSelf.bank_account = str;
                NSLog(@"bank_account = %@",str);
            }else if ([title isEqualToString:weakSelf.dataArray[4]]){
                weakSelf.branch = str;
                NSLog(@"branch = %@",str);
            }else if ([title isEqualToString:weakSelf.dataArray[7]]){
                weakSelf.phone = str;
                NSLog(@"phone = %@",str);
            }else if ([title isEqualToString:weakSelf.dataArray[1]]){
                weakSelf.id_number_card = str;
                NSLog(@"id_number_card = %@",str);
            }else if ([title isEqualToString:weakSelf.dataArray[0]]){
                weakSelf.realname_card = str;
                NSLog(@"realname_card = %@",str);
            }
        }];
        return cell;
    }else if(indexPath.row == 60){
        VerifyCodeCell * cell;
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"VerifyCodeCellID"];
        }
        [cell.veryButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        [cell.veryButton addTarget:self action:@selector(veriButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    }else{
        static NSString *ID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"setupCell" owner:nil options:nil] lastObject];
        }
        UIImageView *imgV = (UIImageView *)[cell viewWithTag:110];
        UILabel *titleLB = (UILabel *)[cell viewWithTag:111];
        UILabel *detail = (UILabel *)[cell viewWithTag:120];
        detail.textAlignment = NSTextAlignmentRight;
        titleLB.X = imgV.X;
        titleLB.text = _dataArray[indexPath.row];
        titleLB.textColor = UIColorFromRGB(0x333333);
        if ([titleLB.text isEqualToString:@"银行名字"]) {
            detail.text = _detailArr[0];
        }
        if ([titleLB.text isEqualToString:@"所属省份"]) {
            detail.text = _detailArr[1];
        }
        if ([titleLB.text isEqualToString:@"所属城市"]) {
            detail.text = _detailArr[2];
        }
        return cell;
    }
}
-(void)veriButtonClick:(UIButton *)button{
    __block int  timeOut=60;
    //[self getcode];
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t   timer=dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut<=0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [button  setTitle:LocalizationNotNeeded(@"获取验证码") forState:UIControlStateNormal];
                button.userInteractionEnabled=YES;
            });
        }else{
            int  seconds=timeOut%120;
            NSString   *strTime=[NSString  stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [button  setTitle:[NSString  stringWithFormat:@"重新获取(%@s)",strTime] forState:UIControlStateNormal];
                button.userInteractionEnabled=NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(timer);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * title = _dataArray[indexPath.row];
    [self.view endEditing:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([title isEqualToString:_dataArray[2]] || [title isEqualToString:_dataArray[5]] || [title isEqualToString:_dataArray[6]]) {
        tableView.userInteractionEnabled = NO;
    }
    LTPickerView* pickerView = [LTPickerView new];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSMutableArray * proArray = [NSMutableArray array];
    NSMutableArray * keyArray = [NSMutableArray array];

    if ([title isEqualToString:_dataArray[2]] ) {
        NSString * operator_id = [USER_DEFAULT objectForKey:login_Operation];
        [param setObject:[self setRSAencryptString:operator_id] forKey:@"operator_id"];
        [param setObject:[self setApiTokenStr] forKey:@"token"];
        [self fetchFroductWithDict:param UrlString:BANKINFO completion:^(NSArray * arr) {
            tableView.userInteractionEnabled = YES;
            NSMutableArray * valueArray = [NSMutableArray array];
            [arr enumerateObjectsUsingBlock:^(BankCardData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[BankCardData class]]) {
                    [valueArray addObject:obj.value];
                    [keyArray addObject:obj.key];
                }
            }];
            pickerView.dataSource = valueArray;
            [pickerView show];//显示
            //回调block
        }];
    }else if ([title isEqualToString:_dataArray[5]]){
        [param setObject:[self setApiTokenStr] forKey:@"token"];
        [self post:Area parameters:param success:^(id dic) {
            tableView.userInteractionEnabled = YES;
            if ([dic[@"code"] intValue]==0) {
                [LCProgressHUD hide];
                _areaModel = [AreaModel mj_objectWithKeyValues:dic];
                [_areaModel.data enumerateObjectsUsingBlock:^(AreaData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [proArray addObject:obj.label];
                    [keyArray addObject:obj.value];
                }];
                pickerView.dataSource = proArray;
                [pickerView show];//显示
            }else {
                NSString *msg = dic[@"info"];
                if (![XYString isBlankString:msg]) {
                    [LCProgressHUD showInfoMsg:msg];
                }else {
                    [LCProgressHUD hide];
                }
            }
        } failure:^(NSError *error) {
            tableView.userInteractionEnabled = YES;
        }];
    }else if ([title isEqualToString:_dataArray[6]]){
        tableView.userInteractionEnabled = YES;
        if (_cityArray) {
            pickerView.dataSource = _cityArray;
            [pickerView show];//显示
        }else{
            NSMutableArray * arr = [NSMutableArray array];
            [_cityIdArray removeAllObjects];
            AreaData *data = _areaModel.data[22];
            [data.children enumerateObjectsUsingBlock:^(AreaChildren * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arr addObject:obj.label];
                [_cityIdArray addObject:obj.value];
            }];
            pickerView.dataSource = arr;
            [pickerView show];//显示
            //[LCProgressHUD showMessage:@"请选择省份"];
        }

    }
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象 //str:选中的字符串 //num:选中了第几行
        UILabel *detail = (UILabel *)[cell viewWithTag:120];
        detail.text = str;
        if (indexPath.row == 2) {
            [_detailArr replaceObjectAtIndex:0 withObject:str];
            _bank_id = keyArray[num];
        }else if (indexPath.row == 5){
            [_detailArr replaceObjectAtIndex:1 withObject:str];
            _province_id = keyArray[num];
            AreaData *data = _areaModel.data[num];
            NSMutableArray * arr = [NSMutableArray array];
            [_cityIdArray  removeAllObjects];
            [data.children enumerateObjectsUsingBlock:^(AreaChildren * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arr addObject:obj.label];
                [_cityIdArray addObject:obj.value];
            }];
            _cityArray = [NSMutableArray arrayWithArray:arr];
            NSIndexPath *path = [NSIndexPath indexPathForRow:6 inSection:0];
            UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:path];
            UILabel *lb = (UILabel *)[cell1 viewWithTag:120];
            lb.text = _cityArray[0];
            _city_id = _cityIdArray[0];
            [_detailArr replaceObjectAtIndex:2 withObject:_cityArray[0]];

        }else if (indexPath.row == 6){
            _city_id = _cityIdArray[num];
            [_detailArr replaceObjectAtIndex:2 withObject:str];
        }
        NSLog(@"选中的字符串%@,选中了第%i行",str,num);
    };
}

//获取网络
-(void)fetchFroductWithDict:(NSDictionary *)param UrlString:(NSString *)urlString completion:(void (^)(NSArray *))completion{

    [BaseRequest post:urlString parameters:param success:^(id dict) {
        
        if ([dict[@"code"] intValue]==0) {
            LianLianBankModel *model = [LianLianBankModel mj_objectWithKeyValues:dict];
            completion(model.data);
        }else{
            NSString *msg = dict[@"info"];
            completion(@[@{@"key":@"000",@"value":@"获取失败"}]);
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {
        completion(@[@{@"key":@"000",@"value":@"获取失败"}]);
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
