//
//  OrderVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/9/20.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "OrderVC.h"
#import "orderDetailVC.h"
#import "homeModel.h"
#import "MJRefresh.h"
#import "SearchVC.h"
#import "BaseNavigationController.h"
#import "homeTagV.h"

#import "AddOrderController.h"
#import "XOrederController.h"

@interface OrderVC () <UITableViewDelegate,UITableViewDataSource>
{
    int page;
    NSArray *valueArr;
    NSMutableArray *dataArr;
    //权限
    BOOL lim;
    BOOL lim_detail;
    BOOL lim_new;

    //下拉视图
    BOOL sele;
    UIView *dropBackV;
    UITableView *dropV;
    NSArray *stauseArr;
    NSString *soureStr;
    NSString *stauseStr;
    NSString *xiashuStr;

    //
    NSString *ordtag;
    //
    CGFloat cellH;
}
@property (strong, nonatomic) IBOutlet UIImageView *nilImageV;

@property (nonatomic, strong) NSMutableArray *soureArr;
@property (nonatomic, strong) NSMutableArray *soureIDArr;
@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, strong) NSMutableArray *memberIDArray;

@end

@implementation OrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    cellH = 152;
    if ([self getroleClass]==1) {
        ordtag = @"接单后台";
    }else {
        ordtag = @"订单来源";
    }
    
    [self setTableView];
    [self setdropdownView];
    lim = NO;
    soureStr = @"";
    stauseStr = @"";
    for (NSString *str in [self getPermissionsArr]) {
        if ([str isEqualToString:@"order/search/"]) {
            lim = YES;
        }
        if ([str isEqualToString:@"order/detail/"]) {
            lim_detail = YES;
        }
        if ([str isEqualToString:@"order/newrec/"]) {
            lim_new = YES;
            [self initUIButton];
        }
    }
    if (lim==YES) {
        [self setNavRightBtnWithImgName:@"head_icon_search"];
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
        [button setImage:IMGNAME(@"img_apply") forState:(UIControlStateNormal)];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-18);
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-67);
        }];
        [button addTarget:self action:@selector(addOrder:) forControlEvents:(UIControlEventTouchUpInside)];
    }else{}
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
       // [MobClick event:@"shanyinclick"];
        // WKWebViewController * webVC = [[WKWebViewController alloc] init];
        XOrederController * controller = [[XOrederController alloc] init];
        controller.title = @"小时贷产品申请";
        [self.navigationController pushViewController:controller animated:YES];
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
-(NSMutableArray *)memberArray{
    if (!_memberArray) {
        _memberArray = [NSMutableArray array];
    }
    return _memberArray;
}
- (NSMutableArray *)soureArr {
    if (_soureArr==nil) {
        _soureArr = [NSMutableArray array];
    }
    return _soureArr;
}
- (NSMutableArray *)soureIDArr {
    if (_soureIDArr==nil) {
        _soureIDArr = [NSMutableArray array];
    }
    return _soureIDArr;
}
- (NSMutableArray *)memberIDArray {
    if (_memberIDArray==nil) {
        _memberIDArray = [NSMutableArray array];
    }
    return _memberIDArray;
}
- (void)setTableView {
    
    valueArr = @[@"有",@"有",@"无",@"",@"",@"",@"",@""];
    dataArr = [NSMutableArray array];
    stauseArr = @[@"全部",@"准备资料",@"已进件",@"商家同意",@"已签合同",@"已放款",@"已收服务费",@"成功放款",@"商家驳回",@"订单终止",@"已撤销"];
    
    _mainTV.delegate = self;
    _mainTV.dataSource = self;
    _mainTV.backgroundColor = [UIColor clearColor];
    _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSLog(@"订单权限＝%@",[[NSUserDefaults standardUserDefaults] objectForKey:lim_ord]);
    //下拉刷新
    __weak __typeof(&*self)weakSelf = self;
    _mainTV.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof__(&*weakSelf) sself = weakSelf;
        sself->page=0;
        [weakSelf setRequest];
    }];
    //上拉加载
//    _mainTV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self setRequest];
//    }];
    _mainTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setRequest)];
    NSInteger count ;
    NSInteger role_id = [[USER_DEFAULT objectForKey:Role_id] integerValue];
    if (role_id == 2 || role_id == 3 || role_id == 7) {
        count = 2;
    }else{
        count = 3;
    }
    for (int i=0; i<count; i++) {
        //布局状态选项
        UIButton *stausBT;
        if (count == 2) {
            stausBT = [[UIButton alloc] initWithFrame:CGRectMake(12+i*(ScreenWidth)/2, 0, (ScreenWidth)/2, 35)];

        }else if (count == 3){
            stausBT = [[UIButton alloc] initWithFrame:CGRectMake(12+i*(ScreenWidth-24)/3, 0, (ScreenWidth-24)/3, 35)];
        }

        stausBT.titleLabel.font = [UIFont systemFontOfSize:14];
        stausBT.tag = 1000+i;
        [stausBT setTitle:@[@"订单状态",ordtag,@"我的下属"][i] forState:UIControlStateNormal];
        [stausBT setTitleColor:colorValue(0x111111, 1) forState:UIControlStateNormal];
        [stausBT setTitleColor:colorValue(0xff7f1a, 1) forState:UIControlStateSelected];
        [stausBT setImage:[UIImage imageNamed:@"nav_icon_more_norm"] forState:UIControlStateNormal];
        [stausBT setImage:[UIImage imageNamed:@"nav_icon_more_selet"] forState:UIControlStateSelected];
        [stausBT addTarget:self action:@selector(stauseAction:) forControlEvents:UIControlEventTouchUpInside];
        //
        CGFloat w = [XYString WidthForString:@[@"订单状态",ordtag,@"我的下属"][i] withSizeOfFont:14]+2;
        [stausBT setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
        [stausBT setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
        [_titleV addSubview:stausBT];
    }
    [self PixeH:CGPointMake(0, 34) lenght:ScreenWidth add:_titleV];
}
#pragma mark -- 下拉tableView 
- (void)setdropdownView {
    
    dropBackV = [[UIView alloc] initWithFrame:CGRectMake(0, 35, ScreenWidth, ScreenHeight-35)];
    dropBackV.backgroundColor = color(0, 0, 0, 0.6);
    dropBackV.alpha = 0;
    [self.view addSubview:dropBackV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [dropBackV addGestureRecognizer:tap];
    
    dropV = [[UITableView alloc] initWithFrame:CGRectMake(0, -1500, ScreenWidth, kScreen_Height-100-113) style:UITableViewStylePlain];
    dropV.delegate = self;
    dropV.dataSource = self;
    [self.view addSubview:dropV];
    [self.view addSubview:_titleV];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==_mainTV) {
        return dataArr.count;
    }else {
        if (sele==YES) {
            UIButton *sender2 = (UIButton *)[_titleV viewWithTag:1001];
            UIButton *sender3 = (UIButton *)[_titleV viewWithTag:1002];
            if (sender2.selected) {
                return self.soureArr.count;
            }else if (sender3.selected){
                return self.memberArray.count;
            }else{
                return 0;
            }
        }else {
            return [stauseArr count];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_mainTV) {
        return cellH;
    }else {
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_mainTV) {
        if (lim_detail==YES) {
            homeModel *model = dataArr[indexPath.row];
            orderDetailVC *MVC = [[orderDetailVC alloc] init];
            MVC.order_nid = model.order_nid;
            [self.navigationController pushViewController:MVC animated:YES];
        }else {
            [LCProgressHUD showMessage:@"无权限进行当前操作"];
        }
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        UIButton *sender1 = (UIButton *)[_titleV viewWithTag:1000];
        UIButton *sender2 = (UIButton *)[_titleV viewWithTag:1001];
        UIButton *sender3 = (UIButton *)[_titleV viewWithTag:1002];

        [UIView animateWithDuration:0.3 animations:^{
            dropV.Y = -1500;
            dropBackV.alpha=0;
        }];
        page=0;
        NSLog(@"第%ld行",(long)indexPath.row);
        if (sele==YES) {
            if (sender2.selected) {
                if (indexPath.row==0) {
                    [sender2 setTitle:ordtag forState:UIControlStateNormal];
                    CGFloat w = [XYString WidthForString:ordtag withSizeOfFont:14]+2;
                    [sender2 setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
                    [sender2 setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
                }else {
                    [sender2 setTitle:self.soureArr[indexPath.row] forState:UIControlStateNormal];
                    CGFloat w = [XYString WidthForString:self.soureArr[indexPath.row] withSizeOfFont:14]+2;
                    [sender2 setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
                    [sender2 setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
                }
                soureStr = self.soureIDArr[indexPath.row];
            }else if(sender3.selected){
                if (indexPath.row==0) {
                    [sender3 setTitle:LocalizationNotNeeded(@"我的下属") forState:UIControlStateNormal];
                    CGFloat w = [XYString WidthForString:@"我的下属" withSizeOfFont:14]+2;
                    [sender3 setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
                    [sender3 setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
                }else {
                    [sender3 setTitle:self.memberArray[indexPath.row] forState:UIControlStateNormal];
                    CGFloat w = [XYString WidthForString:self.memberArray[indexPath.row] withSizeOfFont:14]+2;
                    [sender3 setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
                    [sender3 setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
                }
                xiashuStr = self.memberIDArray[indexPath.row];
            }

        }else {
            UIButton *sender = (UIButton *)[_titleV viewWithTag:1000];
            if (indexPath.row==0) {
                stauseStr = @"";
                [sender setTitle:LocalizationNotNeeded(@"订单状态") forState:UIControlStateNormal];
                CGFloat w = [XYString WidthForString:@"订单状态" withSizeOfFont:14]+2;
                [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
                [sender setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
            }else {
                stauseStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row+2];
                [sender setTitle:stauseArr[indexPath.row] forState:UIControlStateNormal];
                CGFloat w = [XYString WidthForString:stauseArr[indexPath.row] withSizeOfFont:14]+2;
                [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
                [sender setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
            }
        }
        sender1.selected = NO;
        sender2.selected = NO;
        sender3.selected = NO;
        [self setRequest];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_mainTV) {
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
        UILabel *stauseLB = (UILabel *)[cell viewWithTag:125];
        
        [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:backV];
        [self PixeH:CGPointMake(0, 39) lenght:ScreenWidth add:backV];
        [backV addSubview:tapImg];
        [self PixeV:CGPointMake(ScreenWidth/3, 55) lenght:41 add:backV];
        [self PixeV:CGPointMake(ScreenWidth*2/3, 55) lenght:41 add:backV];
        [self setYuan:storeLB size:3];
        [self setYuan:typeLB size:18];
        [self setBorder:typeLB size:1 withColor:colorValue(0x199cff, 1)];
    
        cellH = 152;
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
        //名字宽度
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
            typeLB.text = LocalizationNotNeeded(@"无");
        }
        
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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        UIButton *sender2 = (UIButton *)[_titleV viewWithTag:1001];
        UIButton *sender3 = (UIButton *)[_titleV viewWithTag:1002];
        if (sele==YES) {
            if (sender2.selected) {
                cell.textLabel.text = _soureArr[indexPath.row];
            }else if (sender3.selected){
                cell.textLabel.text = _memberArray[indexPath.row];
            }
        }else {
            cell.textLabel.text = stauseArr[indexPath.row];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = colorValue(0x111111, 1);
        return cell;
    }
}
#pragma mark -- 网络请求
- (void)setRequest {
    
    page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *key;
    if ([self getroleClass]==1) {
        key = @"department_id_solution";
    }else {
        key = @"department_id_author";
    }

    [param setObject:[self setRSAencryptString:@"2"] forKey:@"list_type"];
    [param setObject:[self setRSAencryptString:stauseStr] forKey:@"order_status"];
    [param setObject:[self setRSAencryptString:soureStr] forKey:key];

    [param setObject:[self setRSAencryptString:[NSString stringWithFormat:@"%d",page]] forKey:@"currentPage"];
    NSArray *tokenArr;
    if(xiashuStr){
        [param setObject:[self setRSAencryptString:avoidNullStr(xiashuStr)] forKey:@"operator_id_subordinate"];
       tokenArr = @[@{@"price":@"list_type",@"vaule":[NSString stringWithFormat:@"list_type%@",@"2"]},
                              @{@"price":@"order_status",@"vaule":[NSString stringWithFormat:@"order_status%@",stauseStr]},
                              @{@"price":key,@"vaule":[NSString stringWithFormat:@"%@%@",key,soureStr]},
                              @{@"price":@"currentPage",@"vaule":[NSString stringWithFormat:@"currentPage%@",[NSString stringWithFormat:@"%d",page]]},
                              @{@"price":@"operator_id_subordinate",@"vaule":[NSString stringWithFormat:@"%@%@",@"operator_id_subordinate",xiashuStr]},
                              ];
    } else{
        tokenArr = @[@{@"price":@"list_type",@"vaule":[NSString stringWithFormat:@"list_type%@",@"2"]},
                     @{@"price":@"order_status",@"vaule":[NSString stringWithFormat:@"order_status%@",stauseStr]},
                     @{@"price":key,@"vaule":[NSString stringWithFormat:@"%@%@",key,soureStr]},
                     @{@"price":@"currentPage",@"vaule":[NSString stringWithFormat:@"currentPage%@",[NSString stringWithFormat:@"%d",page]]},
                     // @{@"price":@"operator_id_subordinate",@"vaule":[NSString stringWithFormat:@"%@%@",@"operator_id_subordinate",xiashuStr]},
                     ];
    }   //
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
                    [LCProgressHUD showMessage:@"无更多数据"];
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
#pragma mark -- 按钮的点击事件
- (void)stauseAction:(UIButton *)sender {
    if (lim==NO) {
        [LCProgressHUD showMessage:@"没有查询订单的权限"];
        return;
    }
    UIButton *sender1 = (UIButton *)[_titleV viewWithTag:1000];
    UIButton *sender2 = (UIButton *)[_titleV viewWithTag:1001];
    UIButton *sender3 = (UIButton *)[_titleV viewWithTag:1002];

    if (sender.selected) {
        sender.selected = NO;
        [UIView animateWithDuration:0.3 animations:^{
            dropV.Y = -1500;
            dropBackV.alpha=0;
        }];
    }else {
        sender.selected = YES;
        [UIView animateWithDuration:0.3 animations:^{
            dropV.Y = 35;
            dropBackV.alpha=1;
        }];
        if (sender.tag==1000) {
            sender2.selected = NO;
            sender3.selected = NO;
            sele = NO;
            [dropV reloadData];
        }else if (sender.tag==1001){
            sender1.selected = NO;
            sender3.selected = NO;
            sele = YES;
            if (self.soureArr.count) {
                [dropV reloadData];
            }else {
                [self setsoureOrder];
            }
        }else if (sender.tag==1002){
            sender1.selected = NO;
            sender2.selected = NO;
            sele = YES;
            if (self.memberArray.count) {
                [dropV reloadData];
            }else {
                [self setDepememList];
            }
        }
    }
}

#pragma mark -- 获取下属筛选的列表
-(void)setDepememList{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString * opreateId = [USER_DEFAULT objectForKey:user_ID];
    [param setObject:[self setRSAencryptString:opreateId] forKey:@"operator_id"];
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    NSString *url;
    url = @"/sysset/subordinate/";//获取指定员工所有下属员工
    [self.memberIDArray removeAllObjects];
    [self.memberArray removeAllObjects];
    [dropV reloadData];
    [LCProgressHUD showLoading:nil];
    [self post:url parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD hide];
            
            NSArray *arr = dic[@"data"];
            if (arr.count) {
                //                [self.soureIDArr removeAllObjects];
                //                [self.soureArr removeAllObjects];
                [self.memberArray addObject:@"全部"];
                [self.memberIDArray addObject:@""];
                for (NSDictionary *dics in arr) {
                    [self.memberArray addObject:dics[@"operator_name"]];
                    [self.memberIDArray addObject:dics[@"operator_id"]];
                }
            }
            [dropV reloadData];
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

#pragma mark -- 背景的点击手势
- (void)tapAction {
    UIButton *sender1 = (UIButton *)[_titleV viewWithTag:1000];
    UIButton *sender2 = (UIButton *)[_titleV viewWithTag:1001];
    UIButton *sender3 = (UIButton *)[_titleV viewWithTag:1002];

    sender1.selected = NO;
    sender2.selected = NO;
    sender3.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        dropV.Y = -1500;
        dropBackV.alpha=0;
    }];
}
#pragma mark -- 订单来源网络请求
- (void)setsoureOrder {

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    NSString *url;
    if ([self getroleClass]==1) {
        url = @"/sysset/solutiondep/";
    }else {
        url = @"/sysset/authordep/";
    }
    [self.soureIDArr removeAllObjects];
    [self.soureArr removeAllObjects];
    [dropV reloadData];
    [LCProgressHUD showLoading:nil];
    [self post:url parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD hide];
        
            NSArray *arr = dic[@"data"];
            if (arr.count) {
//                [self.soureIDArr removeAllObjects];
//                [self.soureArr removeAllObjects];
                [self.soureArr addObject:@"全部"];
                [self.soureIDArr addObject:@""];
                for (NSDictionary *dics in arr) {
                    [self.soureArr addObject:dics[@"department_name"]];
                    [self.soureIDArr addObject:dics[@"department_id"]];
                }
            }
            [dropV reloadData];
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
- (void)rightAction {
  
    SearchVC *MVC = [[SearchVC alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:MVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
