//
//  SearchVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/6/14.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "SearchVC.h"
#import "HZTextField.h"
#import "homeModel.h"
#import "orderDetailVC.h"
#import "MJRefresh.h"
#import "homeTagV.h"

@interface SearchVC () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *dataModel;
    UIView *navBackV;
    NSString *seachParam;
    
    int page;
    UITableView *historyTV;
    NSMutableArray *seachArray;
    //
    NSArray *valueArr;
    NSMutableArray *dataArr;
    //
    BOOL lim_detail;
    //
    CGFloat cellH;
}
@property (strong, nonatomic) IBOutlet UIImageView *nilImageV;

@end

@implementation SearchVC
@synthesize mainTV,headView,footView;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self setTableView];
   
    for (NSString *str in [self getPermissionsArr]) {
        if ([str isEqualToString:@"order/detail/"]) {
            lim_detail = YES;
        }
    }
}
- (void)setNav {
    valueArr = @[@"有",@"有",@"无",@"",@"",@"",@"",@""];
    dataArr = [NSMutableArray array];
    
    HZTextField *seachTF = [[HZTextField alloc] initWithFrame:CGRectMake(12, 7, ScreenWidth-65, 30)];
    seachTF.tag = 4212;
    seachTF.delegate = self;
    seachTF.placeholder = LocalizationNotNeeded(@"请输入客户姓名");
    seachTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    seachTF.backgroundColor = BorderColor;
    seachTF.returnKeyType = UIReturnKeySearch;
    [self setYuan:seachTF size:3];
    
    UIButton *cancelBT = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-53, 0, 53, 44)];
    [cancelBT setTitle:LocalizationNotNeeded(@"取消") forState:UIControlStateNormal];
    [cancelBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBT.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBT addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    navBackV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [self.navigationController.navigationBar addSubview:navBackV];
    [navBackV addSubview:seachTF];
    [navBackV addSubview:cancelBT];
    
    historyTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 220) style:UITableViewStylePlain];
    historyTV.delegate = self;
    historyTV.dataSource = self;
    historyTV.hidden = YES;
    historyTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:historyTV];
    [self PixeH:CGPointMake(0, 39) lenght:ScreenWidth add:headView];
    [self PixeH:CGPointMake(0, 219) lenght:ScreenWidth add:historyTV];
    historyTV.tableFooterView = footView;
    historyTV.tableHeaderView = headView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    navBackV.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBackV.hidden = YES;
}
- (void)setTableView {
    
    dataModel = [NSMutableArray array];
    
    mainTV.delegate = self;
    mainTV.dataSource = self;
    mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //下拉刷新
//    mainTV.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        page=0;
//        [self webSeach:seachParam];
//    }];
    
    mainTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
}
- (void)loadLastData {
    [self webSeach:seachParam];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    seachArray = [[NSUserDefaults standardUserDefaults] objectForKey:history_seach];
    [historyTV reloadData];
    historyTV.hidden = NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
//    historyTV.hidden = YES;
}
- (IBAction)deleHiden {
    historyTV.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==historyTV) {
        return seachArray.count;
    }else {
        return dataArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==historyTV) {
        return 44;
    }else {
        return cellH;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==mainTV) {
        if (lim_detail==YES) {
            homeModel *model = dataArr[indexPath.row];
            orderDetailVC *MVC = [[orderDetailVC alloc] init];
            MVC.order_nid = model.order_nid;
            [self.navigationController pushViewController:MVC animated:YES];
        }else {
            [LCProgressHUD showMessage:@"无权限进行当前操作"];
        }
    }else {
        page=0;
        seachParam = seachArray[indexPath.row];
        historyTV.hidden = YES;
        [self.navigationController.navigationBar endEditing:YES];
        [self webSeach:seachArray[indexPath.row]];
        HZTextField *text = (HZTextField *)[navBackV viewWithTag:4212];
        text.text = seachArray[indexPath.row];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==mainTV) {
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"orderCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *backV = (UIView *)[cell viewWithTag:109];
        UILabel *storeLB = (UILabel *)[cell viewWithTag:110];
        UILabel *nameLB = (UILabel *)[cell viewWithTag:111];
        UILabel *timeLB = (UILabel *)[cell viewWithTag:112];
        UIImageView *tapImg = (UIImageView *)[cell viewWithTag:113];
        UILabel *typeLB = (UILabel *)[cell viewWithTag:114];
        UILabel *priceLB = (UILabel *)[cell viewWithTag:115];
        UILabel *wageLB = (UILabel *)[cell viewWithTag:116];
        UILabel *stauseLB = (UILabel *)[cell viewWithTag:125];
        UILabel *gongziLB = (UILabel *)[cell viewWithTag:117];
        
        [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:backV];
        [self PixeH:CGPointMake(0, 39) lenght:ScreenWidth add:backV];
        [backV addSubview:tapImg];
        [self PixeV:CGPointMake(ScreenWidth/3, 55) lenght:41 add:backV];
        [self PixeV:CGPointMake(ScreenWidth*2/3, 55) lenght:41 add:backV];
        [self setYuan:storeLB size:3];
        [self setYuan:typeLB size:18];
        [self setBorder:typeLB size:1 withColor:colorValue(0x199cff, 1)];
        
        //赋值
        homeModel *model = dataArr[indexPath.row];
        //贷款金额
        NSString *moneyStr = [NSString stringWithFormat:@"%@万",[XYString changeFloatWithString:model.apply_amount]];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:avoidNullStr(moneyStr)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, moneyStr.length-1)];
        priceLB.attributedText = attributedString;
        //个人工资
        NSString *wageStr = [NSString stringWithFormat:@"%@元",[XYString changeFloatWithString:model.month_income]];
        NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:avoidNullStr(wageStr)];
        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, wageStr.length-1)];
        wageLB.attributedText = attributedString2;
        //
        tapImg.hidden = YES;
        stauseLB.text = model.order_status_txt;
        //名字
        nameLB.width = ScreenWidth-270;
        CGFloat wn = [XYString WidthForString:model.realname withSizeOfFont:15];
        if (wn>ScreenWidth-270) {
            timeLB.X = 72+ScreenWidth-270;
        }else if (wn<50){
            timeLB.X = 122;
        }else {
            timeLB.X = wn+72;
        }
        
        storeLB.text = model.department_name_author;
        nameLB.text = model.realname;
        timeLB.text = model.addtime;
        if (model.loan_type.intValue==1) {
            typeLB.text = LocalizationNotNeeded(@"信用");
        }else if (model.loan_type.intValue==2) {
            typeLB.text = LocalizationNotNeeded(@"车抵");
        }else if (model.loan_type.intValue==3) {
            typeLB.text = LocalizationNotNeeded(@"房抵");
        }else {
            typeLB.text =LocalizationNotNeeded( @"无");
        }
        
        cellH = 152;
        gongziLB.text = model.month_income_type;
        if (model.job_type.intValue==2||model.job_type.intValue==3) {
            
            homeTagV *zicanLB = [[homeTagV alloc] initWithFrame:CGRectMake(12, 117, 80, 12)];
            zicanLB.type = 2;
            zicanLB.title = [NSString stringWithFormat:@"%@房%@车",valueArr[model.has_house.intValue],valueArr[model.has_car.intValue]];
            [backV addSubview:zicanLB];
            
            homeTagV *baoLB = [[homeTagV alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zicanLB.frame)+10, 117, 80, 12)];
            baoLB.type = 3;
            if (model.has_guarantee_slip.intValue==1) {
                baoLB.title = @"有保单";
            }else if (model.has_guarantee_slip.intValue==2) {
                baoLB.title = @"无保单";
            }else {
                baoLB.title = @"未知";
            }
            [backV addSubview:baoLB];
            
            homeTagV *yuLB = [[homeTagV alloc] initWithFrame:CGRectMake(CGRectGetMaxX(baoLB.frame)+10, 117, 80, 12)];
            yuLB.type = 4;
            if (model.agency_type.intValue==1) {
                yuLB.title = @"无信用卡或贷款";
            }else if (model.agency_type.intValue==2) {
                yuLB.title = @"信用良好，无逾期";
            }else if (model.agency_type.intValue==3) {
                yuLB.title = @"一年内逾期少于三次且少于90天";
            }else if (model.agency_type.intValue==4) {
                yuLB.title = @"一年内逾期超过3次或超过90天";
            }else {
                yuLB.title = @"情况不明";
            }
            [backV addSubview:yuLB];
            
            if (CGRectGetMaxX(yuLB.frame)>ScreenWidth-12) {
                backV.height+=18;
                yuLB.X = 12;
                yuLB.y +=20;
                cellH = 170;
            }
        }else {
            homeTagV *jinLB = [[homeTagV alloc] initWithFrame:CGRectMake(12, 117, 80, 12)];
            jinLB.type = 1;
            jinLB.title = [NSString stringWithFormat:@"%@公积金%@社保",valueArr[model.has_house_fund.intValue],valueArr[model.has_social_security.intValue]];
            [backV addSubview:jinLB];
            
            homeTagV *zicanLB = [[homeTagV alloc] initWithFrame:CGRectMake(CGRectGetMaxX(jinLB.frame)+10, 117, 80, 12)];
            zicanLB.type = 2;
            zicanLB.title = [NSString stringWithFormat:@"%@房%@车",valueArr[model.has_house.intValue],valueArr[model.has_car.intValue]];
            [backV addSubview:zicanLB];
            
            homeTagV *baoLB = [[homeTagV alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zicanLB.frame)+10, 117, 80, 12)];
            baoLB.type = 3;
            if (model.has_guarantee_slip.intValue==1) {
                baoLB.title = @"有保单";
            }else if (model.has_guarantee_slip.intValue==2) {
                baoLB.title = @"无保单";
            }else {
                baoLB.title = @"未知";
            }
            [backV addSubview:baoLB];
            
            homeTagV *yuLB = [[homeTagV alloc] initWithFrame:CGRectMake(CGRectGetMaxX(baoLB.frame)+10, 117, 80, 12)];
            yuLB.type = 4;
            if (model.agency_type.intValue==1) {
                yuLB.title = @"无信用卡或贷款";
            }else if (model.agency_type.intValue==2) {
                yuLB.title = @"信用良好，无逾期";
            }else if (model.agency_type.intValue==3) {
                yuLB.title = @"一年内逾期少于三次且少于90天";
            }else if (model.agency_type.intValue==4) {
                yuLB.title = @"一年内逾期超过3次或超过90天";
            }else {
                yuLB.title = @"情况不明";
            }
            [backV addSubview:yuLB];
            
            if (CGRectGetMaxX(yuLB.frame)>ScreenWidth-12) {
                backV.height+=18;
                yuLB.X = 12;
                yuLB.y +=20;
                cellH = 170;
            }
        }
        
        return cell;
    }else {
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"searchCell" owner:nil options:nil] lastObject];
        }
        [self PixeH:CGPointMake(0, 43) lenght:ScreenWidth add:cell.contentView];
        UILabel *titleLB = (UILabel *)[cell viewWithTag:210];
        titleLB.text = seachArray[indexPath.row];
        return cell;
    }
}
#pragma mark -- 上拉加载更多
- (void)footerRereshing {
    [self webSeach:seachParam];
}
#pragma mark -- 点击搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    page=0;
    seachParam = textField.text;
    historyTV.hidden = YES;
    if (![XYString isBlankString:seachParam]) {
        [self webSeach:seachParam];
        NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:history_seach];
        if (array.count) {
            NSLog(@"有值");
            if (array.count>9) {
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:textField.text];
                for (NSString *str in array) {
                    [arr addObject:str];
                }
                [arr removeObjectAtIndex:10];
                [[NSUserDefaults standardUserDefaults] setObject:arr forKey:history_seach];
            }else {
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:textField.text];
                for (NSString *str in array) {
                    [arr addObject:str];
                }
                NSLog(@"==%@",array);
                [[NSUserDefaults standardUserDefaults] setObject:arr forKey:history_seach];
            }
        }else {
            NSLog(@"为空");
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:textField.text];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:history_seach];
        }
    }
    return NO;
}
#pragma mark -- 搜索的网络请求
- (void)webSeach:(NSString *)seachStr {
    
    page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:[NSString stringWithFormat:@"%d",page]] forKey:@"currentPage"];
    [param setObject:[self setRSAencryptString:@"2"] forKey:@"list_type"];
    [param setObject:[self setRSAencryptString:seachStr] forKey:@"realname"];
    NSArray *tokenArr = @[@{@"price":@"realname",@"vaule":[NSString stringWithFormat:@"realname%@",seachStr]},
                          @{@"price":@"list_type",@"vaule":[NSString stringWithFormat:@"list_type%@",@"2"]},
                            @{@"price":@"currentPage",@"vaule":[NSString stringWithFormat:@"currentPage%@",[NSString stringWithFormat:@"%d",page]]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/order/search/" parameters:param success:^(id dic) {
        [mainTV.mj_header endRefreshing];
        [mainTV.mj_footer endRefreshing];
        if ([dic[@"code"] intValue]==0) {
            
            NSArray *arr = dic[@"data"];
            if (page==1) {
                [dataArr removeAllObjects];
            }
            if (arr.count) {
                _nilImageV.hidden = YES;
                [LCProgressHUD hide];
                for (NSDictionary *dics in arr) {
                    homeModel *model = [[homeModel alloc] init];
                    [model mj_setKeyValues:dics];
                    [dataArr addObject:model];
                }
            }else {
                if (page==1) {
                    _nilImageV.hidden = NO;
                    [LCProgressHUD hide];
                }else {
                    _nilImageV.hidden = YES;
                    [LCProgressHUD showMessage:@"无更多数据"];
                }
                page--;
            }
            [mainTV reloadData];
        }else {
            page--;
            NSString *msg = dic[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {
        page--;
        [mainTV.mj_header endRefreshing];
        [mainTV.mj_footer endRefreshing];
    }];
}
- (IBAction)emptyAction {
    historyTV.hidden = YES;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:history_seach];

}

- (void)cancelAction {
    [self.navigationController.navigationBar endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
