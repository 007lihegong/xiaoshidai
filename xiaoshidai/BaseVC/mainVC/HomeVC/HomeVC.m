//
//  HomeVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/9/20.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "HomeVC.h"
#import "orderDetailVC.h"
#import "homeModel.h"
#import "MJRefresh.h"
#import "AddOrderController.h"
#import "homeTagV.h"
#import "WKWebViewController.h"
#import "RKNotificationHub.h"
#import "XOrederController.h"
@interface HomeVC () <UITableViewDelegate,UITableViewDataSource>
{
    UIView *lineV;
    NSString *orderSta;
    int page;
    NSArray *valueArr;
    NSMutableArray *dataArr;
    //订单明细权限
    BOOL lim_detail;
    BOOL lim_new;
    //
    CGFloat cellH;
    RKNotificationHub *  _hubNO;
    RKNotificationHub *  _hubYES;
    RKNotificationHub *  _hubMAT;
}
@property (strong, nonatomic) IBOutlet UIImageView *nilImageV;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL lim = NO;
    lim_detail = NO;
    orderSta=@"1";
    cellH=152;
    valueArr = @[@"有",@"有",@"无",@"",@"",@"",@"",@""];
    dataArr = [NSMutableArray array];
    
    NSLog(@"权限数组＝%@",[self getPermissionsArr]);
    for (NSString *str in [self getPermissionsArr]) {
        if ([str isEqualToString:@"order/search/"]) {
            lim = YES;
        }
        if ([str isEqualToString:@"order/detail/"]) {
            lim_detail = YES;
        }
        if ([str isEqualToString:@"order/newrec/"]) {
            lim_new = YES;
        }
    }
    if (lim==YES) {
        if ([self getroleClass]==1) {
            [self setupFront];
        }else {
            [self setupAfter];
        }
        [self setTbaleView];
        [self setRequest];
    }else {
        [LCProgressHUD showMessage:@"没有查询订单的权限"];
    }
    
}
-(void)initUIButton{
    NSString * str = [USER_DEFAULT objectForKey:@"is_reg"];
    if ([str isEqualToString:@"0"]) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.view addSubview:button];
        [button setBackgroundImage:IMGNAME(@"img_apply") forState:(UIControlStateNormal)];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-18);
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-67);
        }];
        [button addTarget:self action:@selector(addOrder:) forControlEvents:(UIControlEventTouchUpInside)];
    }else{
    
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (appdelegate.refresh==3) {
        appdelegate.refresh = 0;
        page=0;
        [self setRequest];
    }
}
-(void)getCount{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setUserTokenStr:nil] forKey:@"token"];
    [self post:RedNum parameters:param success:^(id dict) {
        if ([dict[@"code"] integerValue] == 0) {
            NSDictionary *data = dict[@"data"];
            NSString *solutionNo = data[@"solution_no"];
            NSString *solutionYes = data[@"solution_yes"];
            NSString *material  = data[@"material_pre"];
            [_hubNO setCount:[solutionNo intValue]];
            [_hubYES setCount:[solutionYes intValue]];
            [_hubMAT setCount:[material intValue]];
        }
    } failure:^(NSError * errors) {
        
    }];
}

#pragma mark -- 后台导航布局
- (void)setupAfter {
    CGFloat width;
    if (iPhone5s || iPhone4s) {
        width = 80;
    }else{
        width = 100;
    }
    //导航栏背景view
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-width, 44)];
    navView.backgroundColor = [UIColor clearColor];
    [self setNavTitleView:navView];
    
    for (int i=0; i<3; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*(ScreenWidth-width)/3, 0, (ScreenWidth-width)/3, 44)];
        button.tag = 1000+i;
        [button setTitle:@[@"未出方案",@"已出方案",@"准备资料"][i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:mainHuang forState:UIControlStateSelected];
        [button addTarget:self action:@selector(planAfterAction:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:button];
        if (i==0) {
            button.selected = YES;
        }
    }
    lineV = [[UIView alloc] initWithFrame:CGRectMake(((ScreenWidth-100)/3-50)/2, 42, 50, 2)];
    lineV.backgroundColor = mainHuang;
    UIButton *buttonNO  = [self.navigationItem.titleView viewWithTag:1000];
    UIButton *buttonYES = [self.navigationItem.titleView viewWithTag:1001];
    UIButton *buttonMAT = [self.navigationItem.titleView viewWithTag:1002];
    _hubNO = [[RKNotificationHub alloc]initWithView:buttonNO.titleLabel];
    [_hubNO moveCircleByX:74 Y:-2];
    _hubYES = [[RKNotificationHub alloc]initWithView:buttonYES.titleLabel];
    [_hubYES moveCircleByX:74 Y:-2];
    _hubMAT = [[RKNotificationHub alloc]initWithView:buttonMAT.titleLabel];
    [_hubMAT moveCircleByX:74 Y:-2];
    if (iPhone5s) {
        [_hubNO  scaleCircleSizeBy:0.6];
        [_hubYES scaleCircleSizeBy:0.6];
        [_hubMAT scaleCircleSizeBy:0.6];
    }else{
        [_hubNO scaleCircleSizeBy:0.7];
        [_hubYES scaleCircleSizeBy:0.7];
        [_hubMAT scaleCircleSizeBy:0.7];
    }
    [navView addSubview:lineV];
}
#pragma mark -- 前台导航布局
- (void)setupFront {
    
    //导航栏背景view
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-100, 44)];
    navView.backgroundColor = [UIColor clearColor];
    [self setNavTitleView:navView];
    
    for (int i=0; i<2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*(ScreenWidth-100)/2, 0, (ScreenWidth-100)/2, 44)];
        button.tag = 1000+i;
        [button setTitle:@[@"未出方案",@"已出方案"][i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:mainHuang forState:UIControlStateSelected];
        [button addTarget:self action:@selector(planAfterAction:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:button];
        if (i==0) {
            button.selected = YES;
        }
    }
    lineV = [[UIView alloc] initWithFrame:CGRectMake(((ScreenWidth-100)/2-50)/2, 42, 50, 2)];
    lineV.backgroundColor = mainHuang;
    
    UIButton *buttonNO  = [self.navigationItem.titleView viewWithTag:1000];
    UIButton *buttonYES = [self.navigationItem.titleView viewWithTag:1001];
    _hubNO = [[RKNotificationHub alloc]initWithView:buttonNO.titleLabel];
    [_hubNO moveCircleByX:74 Y:-2];
    _hubYES = [[RKNotificationHub alloc]initWithView:buttonYES.titleLabel];
    [_hubYES moveCircleByX:74 Y:-2];
    if (iPhone5s) {
        [_hubNO  scaleCircleSizeBy:0.6];
        [_hubYES scaleCircleSizeBy:0.6];
    }else{
        [_hubNO scaleCircleSizeBy:0.7];
        [_hubYES scaleCircleSizeBy:0.7];
    }
    [navView addSubview:lineV];
    if (lim_new==YES) {
        [self initUIButton];
        //[self initNavigation];
    }
}
#pragma mark - 初始化导航栏
-(void)initNavigation{
    //UIBarButtonItem *tempBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(addOrder:)];
    //self.navigationItem.rightBarButtonItem = tempBar;
}
- (void)planAfterAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    for (int i=0; i<3; i++) {
        UIButton *button = (UIButton *)[self.navigationController.navigationBar viewWithTag:1000+i];
        button.selected = NO;
    }
    sender.selected = YES;
    if (sender.tag==1000) {
        [UIView animateWithDuration:0.2 animations:^{
            lineV.x = (sender.width-50)/2;
        }];
        orderSta=@"1";
        page=0;
        [self setRequest];
    }else if (sender.tag==1001) {
        [UIView animateWithDuration:0.2 animations:^{
            lineV.x = (sender.width-50)/2+sender.width;
        }];
        orderSta=@"2";
        page=0;
        [self setRequest];
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            lineV.x = (sender.width-50)/2+sender.width*2;
        }];
        orderSta=@"3";
        page=0;
        [self setRequest];
    }
}

- (void)setTbaleView {
    
    _mainTV.delegate = self;
    _mainTV.dataSource = self;
    _mainTV.backgroundColor = [UIColor clearColor];
    _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //下拉刷新
    __weak __typeof(&*self)weakSelf = self;
    _mainTV.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof__(&*weakSelf) sself = weakSelf;
        sself->page=0;
        [weakSelf setRequest];
    }];
    //上拉加载
   // _mainTV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //[self setRequest];
    //}];
    _mainTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setRequest)];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (lim_detail==YES) {
        homeModel *model = dataArr[indexPath.row];
        orderDetailVC *MVC = [[orderDetailVC alloc] init];
        MVC.order_nid = model.order_nid;
        [self.navigationController pushViewController:MVC animated:YES];
        if ([orderSta isEqualToString:@"1"] && [model.is_read isEqualToString:@"0"]) {
            appdelegate.refresh = 3;
        }
    }else {
        [LCProgressHUD showMessage:@"无权限进行当前操作"];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    UILabel *gongziLB = (UILabel *)[cell viewWithTag:117];
    //UILabel *stauseLB = (UILabel *)[cell viewWithTag:125];
    
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
    //布局下面的标签
    if (orderSta.intValue==1&&[avoidNullStr(model.is_read) isEqualToString:@"0"]) {
        tapImg.hidden = NO;
    }
    //贷款金额
    //stauseLB.text = model.order_status_txt;

    NSString *moneyStr = [NSString stringWithFormat:@"%@万",[XYString changeFloatWithString:model.apply_amount]];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:avoidNullStr(moneyStr)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, moneyStr.length-1)];
    priceLB.attributedText = attributedString;
    //个人工资
    NSString *wageStr = [NSString stringWithFormat:@"%@元",[XYString changeFloatWithString:model.month_income]];
    NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:avoidNullStr(wageStr)];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, wageStr.length-1)];
    wageLB.attributedText = attributedString2;
    //名字宽度
    nameLB.width = ScreenWidth-237;
    CGFloat wn = [XYString WidthForString:model.realname withSizeOfFont:15];
    if (wn>ScreenWidth-237) {
        timeLB.X = 72+ScreenWidth-237;
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
        typeLB.text = LocalizationNotNeeded(@"无");
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
}
#pragma mark -- 网络请求
- (void)setRequest {
    page++;
    [self getCount];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[self setRSAencryptString:@"1"] forKey:@"list_type"];
    [param setObject:[self setRSAencryptString:orderSta] forKey:@"order_status"];
    [param setObject:[self setRSAencryptString:[NSString stringWithFormat:@"%d",page]] forKey:@"currentPage"];
    NSArray *tokenArr = @[@{@"price":@"list_type",@"vaule":[NSString stringWithFormat:@"list_type%@",@"1"]},
                          @{@"price":@"order_status",@"vaule":[NSString stringWithFormat:@"order_status%@",orderSta]},
                          @{@"price":@"currentPage",@"vaule":[NSString stringWithFormat:@"currentPage%@",[NSString stringWithFormat:@"%d",page]]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/order/search/" parameters:param success:^(id dic) {
        [_mainTV.mj_header endRefreshing];
        [_mainTV.mj_footer endRefreshing];
        if ([dic[@"code"] intValue]==0) {
            NSArray *arr = dic[@"data"];
            if (page==1) {
                [dataArr removeAllObjects];
            }
            if (arr.count) {
                [LCProgressHUD hide];
                _nilImageV.hidden = YES;
                for (NSDictionary *dics in arr) {
                    homeModel *model = [[homeModel alloc] init];
                    [model mj_setKeyValues:dics];
                    [dataArr addObject:model];
                }
            }else {
                if (page==1) {
                    [LCProgressHUD hide];
                    _nilImageV.hidden = NO;
                }else {
                    _nilImageV.hidden = YES;
                    [LCProgressHUD showInfoMsg:@"无更多数据"];
                }
                 page--;
            }
            [_mainTV reloadData];
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
        [_mainTV.mj_header endRefreshing];
        [_mainTV.mj_footer endRefreshing];
    }];
}
-(void)addOrder:(UIBarButtonSystemItem *)item{
    //NSLog(@"新增订单");
    NSString * str = [USER_DEFAULT objectForKey:@"is_reg"];
    if ([str isEqualToString:@"0"]) {
        AddOrderController *controller = [[AddOrderController alloc] init];
        controller.title = LocalizationNotNeeded(@"新增订单");
        [self.navigationController pushViewController:controller animated:YES];
        controller = nil;
    }else{
        //shanyinclick.
        [MobClick event:@"shanyinclick"];
       // WKWebViewController * webVC = [[WKWebViewController alloc] init];
        XOrederController * controller = [[XOrederController alloc] init];
        controller.title = @"小时贷产品申请";
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
