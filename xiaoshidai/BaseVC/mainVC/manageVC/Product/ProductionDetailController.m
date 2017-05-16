//
//  ProductionDetailController.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/8.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "ProductionDetailController.h"
#import "ProductDetailModel.h"
#import "LeftView.h"
@interface ProductionDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    MBProgressHUD *hud;
}
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray * dataArray;
@property (nonatomic) NSMutableArray * sectionArray;
@property (nonatomic) NSMutableArray * dataSource;

@property (nonatomic) ProductDetailInfo * model;

@end

@implementation ProductionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataArray];
    [self tableView];
 
    NSMutableDictionary * param = [NSMutableDictionary dictionary];

    if (!_idString) {
        _idString = @"";
    }
    [param setObject:[self setRSAencryptString:self.idString] forKey:@"product_id"];
    NSArray * tokenArr = @[@{@"price":@"product_id",@"vaule":[NSString stringWithFormat:@"product_id%@",self.idString]} ];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    [self fetchFroductWithDict:param UrlString:PRODETAIL];
}

-(NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray arrayWithObjects:@"产品属性",@"优势",@"劣势",@"进件要求",@"资料准备",@"建议", nil];
    }
    return _sectionArray;
}


-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        CGRect frame = CGRectMake(0, 0, 0, CGFLOAT_MIN);
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        [_tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"ProductCellID"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
//获取产品数据
-(void)fetchFroductWithDict:(NSDictionary *)param UrlString:(NSString *)urlString{
    hud = [MBProgressHUD showHUDAddedTo:Window animated:YES];
    hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
    hud.labelText = @"请稍等";
    [hud show:YES];
     [BaseRequest post:urlString parameters:param success:^(id dict) {
         if ([dict[@"code"] intValue]==0) {
             NSArray *arr = dict[@"data"];
             if (arr.count) {
                 hud.labelText = @"获取成功";
                 [hud hide:YES afterDelay:0.5];
                 ProductDetailModel *model = [ProductDetailModel mj_objectWithKeyValues:dict];
                 self.model  = model.data;
                 [self initDataWithModel:self.model];
             }else{
                 hud.labelText = @"加载完成";
                 [hud hide:YES afterDelay:0.5];
             }
             [_tableView reloadData];
         }else{
             [hud hide:YES afterDelay:0.5];
             NSString *msg = dict[@"info"];
             if (![XYString isBlankString:msg]) {
                 [LCProgressHUD showInfoMsg:msg];
             }else {
                 [LCProgressHUD hide];
             }
         }
     } failure:^(NSError *error) {
         hud.labelText = @"获取失败";
         [hud hide:YES afterDelay:0.5];
     }];
    [hud hide:YES afterDelay:0.5];
}
-(void)initDataWithModel:(ProductDetailInfo *)info{
    NSDictionary * sex_limit = [NSDictionary dictionaryWithObjects
                                :@[@"无",@"无要求",@"男",@"女"] forKeys
                                :@[@"0",@"1",@"2",@"3"]];
    NSDictionary * job_limit = [NSDictionary
                                dictionaryWithObjects
                                :@[@"无",@"无要求",@"上班族",@"企业主",@"无固定职业"] forKeys
                                :@[@"0",@"1",@"2",@"3",@"4"]];
    NSDictionary * agency_limit = [NSDictionary dictionaryWithObjects
                                :@[@"无",@"无要求",@"无信用卡或贷款",@"信用良好，无逾期",@"一年内逾期少于三次且少于90天",@"一年内逾期超过3次或超过90天"] forKeys
                                :@[@"0",@"1",@"2",@"3",@"4",@"5"]];
    NSDictionary * car_limit = [NSDictionary dictionaryWithObjects
                                :@[@"无",@"无要求",@"要求有车",@"要求无车"] forKeys
                                :@[@"0",@"1",@"2",@"3"]];
    NSDictionary * house_limit = [NSDictionary dictionaryWithObjects
                                :@[@"无",@"无要求",@"要求有房",@"要求无房"] forKeys
                                :@[@"0",@"1",@"2",@"3"]];
    //NSDictionary * status_txt = [NSDictionary dictionaryWithObjects
                                //:@[@"无",@"已上架",@"已下架",@"已删除"] forKeys
                               // :@[@"0",@"1",@"2",@"3"]];
    
    NSArray *titles = @[@"产品名称：",@"产品分类：",@"所属公司：",@"年龄要求：",@"性别要求：",@"贷款利率：",@"贷款金额："
                        ,@"贷款期限：",@"职业身份：",@"征信要求：",@"是否要求有车：",@"是否要求有房："];
    NSArray *shuxing = [NSArray arrayWithObjects:info.product_name, info.type_name, info.company_name, StrFormatTh(info.age_min, @"~", info.age_max),
                        [sex_limit objectForKey:info.sex_limit]==nil?@"":[sex_limit objectForKey:info.sex_limit],
                        StrFormatTW(avoidNullStr(info.interest_rate),@"%"),
                        [NSString stringWithFormat:@"%@万元~%@万元",avoidNullStr(info.money_min),avoidNullStr(info.money_max)],
                        StrFormatTh(avoidNullStr(info.period_min), @"~", avoidNullStr(info.period_max)),
                        [job_limit objectForKey:info.job_limit] == nil?@"": [job_limit objectForKey:info.job_limit],
                        [agency_limit objectForKey:info.agency_limit]==nil?@"":[agency_limit objectForKey:info.agency_limit],
                        [car_limit objectForKey:info.car_limit]==nil?@"":[car_limit objectForKey:info.car_limit],
                        [house_limit objectForKey:info.house_limit]==nil?@"":[house_limit objectForKey:info.house_limit],
                        nil];
    NSMutableArray * shuxingArr = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [shuxingArr addObject:[NSString stringWithFormat:@"%@%@",titles[idx],shuxing[idx]]];
    }];
    NSArray * advantage        =  @[info.advantage == nil?@"":info.advantage];
    NSArray * disadvantage     =  @[info.disadvantage == nil?@"":info.disadvantage];
    NSArray * enter_require    =  @[info.enter_require == nil?@"":info.enter_require];
    NSArray * prepare_doc      =  @[info.prepare_doc == nil?@"":info.prepare_doc];
    NSArray * suggestion       =  @[info.suggestion == nil?@"":info.suggestion];
    _dataSource = [NSMutableArray arrayWithObjects:shuxingArr,advantage,disadvantage,enter_require,prepare_doc,suggestion, nil];
}
#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectionArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataSource) {
        return [_dataSource[section] count];
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        return  33;
    }else{
        NSString * str = avoidNullStr(_dataSource[indexPath.section][indexPath.row]);
        CGFloat height = [Common stringHeight:str font:15];
        return  height;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 40);
    LeftView *view = [[LeftView alloc] initWithFrame:frame];
    view.title.textAlignment = NSTextAlignmentLeft;
    view.title.text = _sectionArray[section];
    [view.title setFont:[UIFont boldSystemFontOfSize:15]];
    return view;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
