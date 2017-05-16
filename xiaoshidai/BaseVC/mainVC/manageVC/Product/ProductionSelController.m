//
//  ProductionSelController.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/7.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "ProductionSelController.h"
#import "SearchResController.h"
#import "LTPickerView.h"
@interface ProductionSelController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray * dataArray;
@property (nonatomic) NSMutableArray * dataSource;
@property (nonatomic) NSMutableArray * detailArray;
@property (nonatomic) NSMutableArray * keyArray;

@end
@implementation ProductionSelController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataArray];
    [self dataSource];
    [self detailArray];
    [self tableView];
    self.title = @"产品筛选";
}
-(NSMutableArray *)keyArray{
    if (!_keyArray) {
        _keyArray = [NSMutableArray arrayWithObjects:@"car_limit",@"house_limit",@"social_security_limit",@"house_fund_limit",@"job_limit",@"agency_limit", nil];
    }
    return _keyArray;
}
-(NSMutableArray *)detailArray{
    if (!_detailArray) {
        _detailArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
    }
    return _detailArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"是否有车：",@"是否有房：",
                      @"是否有社保：",@"是否有公积金：",@"职业身份：",@"征信情况：", nil];
    }
    return _dataArray;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray
                       arrayWithObjects:@[@"请选择",@"有车",@"无车"],
                       @[@"请选择",@"有房",@"无房"],
                       @[@"请选择",@"有社保",@"无社保"],
                       @[@"请选择",@"有公积金",@"无公积金"],
                       @[@"请选择",@"上班族",@"企业主",@"无固定职业"],
                       @[@"请选择",@"信用良好，无逾期",@"一年内逾期少于三次且少于90天",@"一年内逾期超过3次或超过90天",@"无信用卡或贷款"], nil];
    }
    return _dataSource;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [self.view addSubview:_tableView];
        UIButton *button  = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setTitle:@"开始筛选" forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [button setBackgroundColor:UIColorFromRGB(0xff7f1a)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setFrame:CGRectMake(0, 0, kScreen_Width, 35)];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_tableView setTableFooterView:button];
        CGRect frame = CGRectMake(0, 0, 0, CGFLOAT_MIN);
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
    }
    return _tableView;
}
-(void)buttonClick:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    SearchResController *controller = [[SearchResController alloc] init];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [_detailArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            [param setObject:_detailArray[idx] forKey:self.keyArray[idx]];
        }
    }];
    controller.param = param;
    controller.title = @"筛选结果";
    NSLog(@"%@",[param mj_JSONString]);
    [self.navigationController pushViewController:controller animated:YES];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cellID"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];

        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.detailTextLabel.textColor = UIColorFromRGB(0x333333);
        UIImageView *image = [[UIImageView alloc] initWithImage:IMGNAME(@"list_icon_enter")];
        cell.accessoryView = image ;
        cell.detailTextLabel.text = @"请选择";
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    LTPickerView* pickerView = [LTPickerView new];
    pickerView.dataSource = _dataSource[indexPath.row];
    [self.view endEditing:YES];
    [pickerView show];//显示
    //回调block
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象
        //str:选中的字符串
        //num:选中了第几行
        cell.detailTextLabel.text = str;
        _detailArray[indexPath.row] = [NSString stringWithFormat:@"%i",num];
        NSLog(@"%@",str);
    };
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
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
