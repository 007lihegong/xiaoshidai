//
//  XOrderAddController.m
//  xiaoshidai
//
//  Created by XSD on 2017/1/22.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "XOrderAddController.h"

#import "PictureCell.h"
#import "TextFieldCell.h"
#import "AddPictureCell.h"

#import "OrderDetailModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface XOrderAddController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray * dataArray;
//@property (nonatomic) NSMutableArray * imagesArray;
//@property (nonatomic) NSMutableArray * idsArray;
@property (nonatomic) NSMutableDictionary * imgDict;
@property (nonatomic) NSMutableDictionary * paramDict;


@end

@implementation XOrderAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataArray];
    [self tableView];
    [self setBack:@""];
    _imgDict = [NSMutableDictionary dictionary];
    _paramDict = [NSMutableDictionary dictionary];
    self.fd_interactivePopDisabled = YES;//禁用右划返回

}


-(void)buttonClick:(UIButton *)sender{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSMutableArray * tokenArr = [NSMutableArray array];
    if ([self.title isEqualToString:@"小时贷-按揭房"]) {
        [_paramDict setObject:@"1" forKey:@"product_type"];
    }else if ([self.title isEqualToString:@"小时贷-二抵"]){
        [_paramDict setObject:@"2" forKey:@"product_type"];
    }else if ([self.title isEqualToString:@"小时贷-一抵"]){
        [_paramDict setObject:@"3" forKey:@"product_type"];
    }
    [_paramDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"other_pic"] || [key isEqualToString:@"notes"]) {
            [param setObject:obj forKey:key];
        }else{
            [param setObject:[self setRSAencryptString:obj] forKey:key];
        }
        NSDictionary * dict = @{@"price":key,@"vaule":StrFormatTW(key, obj)};
        [tokenArr addObject:dict];
    }];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    [LCProgressHUD showLoading:nil];
    [self post:XORDER_NEWREC parameters:param success:^(id dict) {
        if ([dict[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:dict[@"data"]];
            [self.navigationController popViewControllerAnimated:YES];
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
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        NSArray * itemArr = @[@"贷款金额",@"个人姓名",@"身份证号",@"身份证",@"户口簿",@"结婚证",@"离婚证",@"购房合同",
                              @"按揭合同/公证书",@"房屋调档信息",@"按揭还款流水",@"银行流水",@"工作证明",@"详版征信",@"房屋照片"];
        NSArray * otherAr = @[@"其他",@"备注"];
        _dataArray = [NSMutableArray arrayWithObjects:itemArr,otherAr, nil];
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        [_tableView registerClass:[PictureCell class] forCellReuseIdentifier:@"PictureCellID"];
        [_tableView registerClass:[TextFieldCell class] forCellReuseIdentifier:@"TextFieldCellID"];
        [_tableView registerClass:[AddPictureCell class] forCellReuseIdentifier:@"Cell011"];

        [self.view addSubview:_tableView];
        
        UIButton *button  = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setTitle:@"确认提交" forState:(UIControlStateNormal)];
        [button setBackgroundColor:mainHuang];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [button setFrame:CGRectMake( 10, 0, kScreen_Width-20, 49)];
        [button.layer setCornerRadius:7.0];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
        [view addSubview:button];
        [view setBackgroundColor:[UIColor clearColor]];
        _tableView.tableFooterView = view;
        
    }
    return _tableView;
}
#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_dataArray[section] count]) {
        return [_dataArray[section] count];
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && (indexPath.row == 0||indexPath.row == 1 ||indexPath.row == 2))||(indexPath.section == 1 && (indexPath.row == 1))) {
        __weak __typeof(&*self)weakSelf = self;
        NSString * identifier = [NSString stringWithFormat:@"TextFieldCellID%zd%zd",indexPath.section,indexPath.row];
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell =[[TextFieldCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:identifier];
        }
        if (indexPath.row == 0){cell.textField.keyboardType = UIKeyboardTypeNumberPad;}
        cell.titleLabel.text = _dataArray[indexPath.section][indexPath.row];
        cell.textField.placeholder = [NSString stringWithFormat:@"%@%@",@"请输入",cell.titleLabel.text];
        [cell setTitle:cell.titleLabel.text];
        [cell setBlock:^(NSString * str) {
            NSLog(@"%@",str);
            NSString * title = weakSelf.dataArray[indexPath.section][indexPath.row];
            if ([title isEqualToString:@"贷款金额"]) {
                [weakSelf.paramDict setObject:str forKey:@"apply_amount"];
            }else if ([title isEqualToString:@"个人姓名"]){
                [weakSelf.paramDict setObject:str forKey:@"realname"];
            }else if ([title isEqualToString:@"身份证号"]){
                [weakSelf.paramDict setObject:str forKey:@"id_number"];
            }else if ([title isEqualToString:@"备注"]){
                [weakSelf.paramDict setObject:str forKey:@"notes"];
            }
        }];
        return cell;
    }else{
        //PictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCellID"];
        AddPictureCell *cell ;//= [tableView dequeueReusableCellWithIdentifier:@"Cell011"];
        __weak __typeof(&*self)weakSelf = self;
        if (!cell) {
            cell = [[AddPictureCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Cell011"];
        }
        cell.titleLabel.text = _dataArray[indexPath.section][indexPath.row];
        cell.titleLabel.font = [UIFont systemFontOfSize:15.f];
        cell.imgArr = [[self.imgDict objectForKey:cell.titleLabel.text] mutableCopy];
        [cell setPidStrBlock:^(NSString * pidStr, NSMutableArray * images, NSMutableArray *ids) {
            NSMutableArray * arr = [NSMutableArray array];
            [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Other_Pic_Show *model = [[Other_Pic_Show alloc] init];
                model.path = obj;
                model.id = ids[idx];
                [arr addObject:model];
            }];
            [weakSelf setKeyForValue:pidStr Key:weakSelf.dataArray[indexPath.section][indexPath.row]];
            [weakSelf.imgDict setObject:arr forKey:weakSelf.dataArray[indexPath.section][indexPath.row]];
        }];

        return cell;
    }
}
-(void)setKeyForValue:(NSString *)pidStr Key:(NSString *)key{
    NSLog(@"key %@ Value %@",key,pidStr);
    if ([key isEqualToString:@"身份证"]) {[_paramDict setObject:pidStr forKey:@"id_card_pic"];}
    if ([key isEqualToString:@"户口簿"]) {[_paramDict setObject:pidStr forKey:@"residence_pic"];}
    if ([key isEqualToString:@"结婚证"]) {[_paramDict setObject:pidStr forKey:@"marry_pic"];}
    if ([key isEqualToString:@"离婚证"]) {[_paramDict setObject:pidStr forKey:@"divorce_pic"];}
    if ([key isEqualToString:@"购房合同"]) {[_paramDict setObject:pidStr forKey:@"house_contract_pic"];}
    if ([key isEqualToString:@"按揭合同/公证书"]) {[_paramDict setObject:pidStr forKey:@"mortgage_pic"];}
    if ([key isEqualToString:@"房屋调档信息"]) {[_paramDict setObject:pidStr forKey:@"house_ownership_pic"];}
    if ([key isEqualToString:@"按揭还款流水"]) {[_paramDict setObject:pidStr forKey:@"repay_flow_pic"];}
    if ([key isEqualToString:@"银行流水"]) {[_paramDict setObject:pidStr forKey:@"bank_flow_pic"];}
    if ([key isEqualToString:@"工作证明"]) {[_paramDict setObject:pidStr forKey:@"job_prove_pic"];}
    if ([key isEqualToString:@"详版征信"]) {[_paramDict setObject:pidStr forKey:@"agency_detail_pic"];}
    if ([key isEqualToString:@"房屋照片"]) {[_paramDict setObject:pidStr forKey:@"house_pic"];}
    if ([key isEqualToString:@"其他"]) { [_paramDict setObject:pidStr forKey:@"other_pic"]; }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && (indexPath.row == 0||indexPath.row == 1 ||indexPath.row == 2))||(indexPath.section == 1 && (indexPath.row == 1))){
        //NSString * identifier = [NSString stringWithFormat:@"TextFieldCellID%zd%zd",indexPath.section,indexPath.row];

        UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return  cell.height;
    }else{
        CGFloat height = [tableView fd_heightForCellWithIdentifier:@"Cell011" configuration:^(AddPictureCell * cell) {
        }];
        return height;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 44;
    }
    return 0.1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"已交房客户，小区大门，单元门及室内照片各一张";
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 29;
    }
    return 20;
}
-(void)selectImage:(UIButton *)sender{
    NSLog(@"...");
    
}

-(void)backAction{
    NSString *title = @"确认是否返回";
    NSString *cancelButtonTitle = NSLocalizedString(@"否", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"是", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"%@",cancelButtonTitle);
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"%@",otherButtonTitle);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -- 控制器销毁
- (void)dealloc {
    NSLog(@"%s",__func__);
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}
@end
