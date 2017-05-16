//
//  ToPayController.m
//  xiaoshidai
//
//  Created by XSD on 2017/1/5.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "ToPayController.h"
#import "PayCell.h"
#import "PayListModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZYInputAlertView.h"
#import "MyBankCardController.h"
@interface ToPayController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
}
@property (strong, nonatomic) UIImageView *errorImageV;
@end

@implementation ToPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    page=0;
   // [self request];
   // [self dataArray];
   // [self tableView];
    _errorImageV = [[UIImageView alloc] initWithImage:IMGNAME(@"nav_img_order")];
    [self.view addSubview:_errorImageV];
    [_errorImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
}
-(void)request{
    page++;
    NSString *key ;
    if ([self getroleClass] == 1) {//前台 operator_id_author 订单提交人
        key = @"operator_id_author";
    }else if ([self getroleClass] == 2){//后台 operator_id_solution 后台接单人
        key = @"operator_id_solution";
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString * id_solution = [USER_DEFAULT objectForKey:@"login_Operation"];
    [param setObject:[self setRSAencryptString:id_solution] forKey:key];
    //pay_status：支付状态，可选。有效取值：1待支付 2待审核 3已驳回 4支付失败 5已完成
    [param setObject:[self setRSAencryptString:@"1"] forKey:@"pay_status"];
    [param setObject:[self setRSAencryptString:[NSString stringWithFormat:@"%d",page]] forKey:@"currentPage"];

    NSArray * tokenArr;
    if (self.channel_id) {
        [param setObject:[self setRSAencryptString:self.channel_id] forKey:@"channel_id"];
        tokenArr = @[@{@"price":key,@"vaule":[NSString stringWithFormat:@"%@%@",key,id_solution]},
                     @{@"price":@"currentPage",@"vaule":[NSString stringWithFormat:@"currentPage%@",[NSString stringWithFormat:@"%d",page]]                        },
                     @{@"price":@"channel_id",@"vaule":[NSString stringWithFormat:@"channel_id%@",self.channel_id]},
                     @{@"price":@"pay_status",@"vaule":[NSString stringWithFormat:@"pay_status%@",@"1"]}
                     ];
    }else{
        tokenArr = @[@{@"price":key,@"vaule":[NSString stringWithFormat:@"%@%@",key,id_solution]},
                     @{@"price":@"currentPage",@"vaule":[NSString stringWithFormat:@"currentPage%@",[NSString stringWithFormat:@"%d",page]]},
                     @{@"price":@"pay_status",@"vaule":[NSString stringWithFormat:@"pay_status%@",@"1"]}
                     ];
    }
    
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    [self fetchFroductWithDict:param UrlString:RECEIPTSEARCH];
}
//获取产品数据
-(void)fetchFroductWithDict:(NSDictionary *)param UrlString:(NSString *)urlString{

    [LCProgressHUD showLoading:nil];
    [BaseRequest post:urlString parameters:param success:^(id dict) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([dict[@"code"] intValue]==0) {
            NSArray *arr = dict[@"data"];
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            if (arr.count) {
                [LCProgressHUD hide];
                _errorImageV.hidden = YES;
                PayListModel *model = [PayListModel mj_objectWithKeyValues:dict];
                [_dataArray addObjectsFromArray:model.data];
            }else{
                if (page==1) {
                    _errorImageV.hidden = NO;
                    [LCProgressHUD hide];
                }else {
                    _errorImageV.hidden = YES;
                    [LCProgressHUD showInfoMsg:@"无更多数据"];
                }
                page--;
            }
            [_tableView reloadData];
            [self.view bringSubviewToFront:_errorImageV];
        }else{
            page--;
            _errorImageV.hidden = NO;
            [self.view bringSubviewToFront:_errorImageV];
            NSString *msg = dict[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError * error) {
        _errorImageV.hidden = NO;
        [self.view bringSubviewToFront:_errorImageV];
        page--;
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
    }];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, kScreen_Width, kScreen_Height-64-45) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.tableView.estimatedRowHeight = 171;
        CGRect frame = CGRectMake(0, 0, 0, CGFLOAT_MIN);
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        //[_tableView registerNib:[UINib nibWithNibName:@"PayCell" bundle:nil] forCellReuseIdentifier:@"PayCellID"];
        __weak __typeof(&*self)weakSelf = self;
        _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof__(&*weakSelf) sself = weakSelf;
            sself->page=0;
            [weakSelf request];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(request)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count) {
        return 1;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayData *model = _dataArray[indexPath.section];
    __weak typeof(self) weakSelf = self;
    PayCell * cell = [PayCell setupCellWith:tableView Model:model];
    [cell fillCellWithModel:model];
    [cell setButtonClickBlock:^(NSString * str) {
        NSLog(@"%@",str);
        if ([str isEqualToString:@"编辑"]) {
            [weakSelf alertWith:model Title:@"编辑金额" placeholder:@"请输入原因"];
        }else if ([str isEqualToString:@"线下支付"]){
            [weakSelf alertWith:model Title:@"线下支付" placeholder:@"请输入备注"];
        }else if ([str isEqualToString:@"直接支付"]){
            [weakSelf pushtWith:model];
        }
    }];
    return cell;
}
-(void)pushtWith:(PayData *)model{
    MyBankCardController * controller = [[MyBankCardController alloc] init];
    controller.model = model;
    controller.title = @"支付";
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)alertWith:(PayData *)model Title:(NSString *)title placeholder:(NSString *)placeholder{
    __weak typeof(self) weakSelf = self;
    ZYInputAlertView *alertView = [ZYInputAlertView alertView];
    alertView.placeholder = placeholder;
    alertView.textField.text = model.money;
    alertView.textField.keyboardType = UIKeyboardTypeDecimalPad;
    alertView.titleLabel.text = title;
    if ([title isEqualToString:@"线下支付"]) {
        alertView.textField.userInteractionEnabled = NO;
        [alertView.inputTextView becomeFirstResponder];
    }
    [alertView confirmBtnClickBlock:^(NSString *inputString ,NSString *textStr ) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSMutableArray * tokenArr = [NSMutableArray array];
        [param setObject:[self setRSAencryptString:model.receipt_id] forKey:@"receipt_id"];
        
        if ([title isEqualToString:@"编辑金额"]) {
            
            [param setObject:[self setRSAencryptString:textStr] forKey:@"money"];
            [param setObject:[self setRSAencryptString:inputString] forKey:@"modify_notes"];
            [tokenArr addObject:@{@"price":@"receipt_id",@"vaule":StrFormatTW(@"receipt_id", model.receipt_id)}];
            [tokenArr addObject:@{@"price":@"money",@"vaule":StrFormatTW(@"money", textStr)}];
            [tokenArr addObject:@{@"price":@"modify_notes",@"vaule":StrFormatTW(@"modify_notes", inputString)}];
            [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
            [weakSelf editOrOfflineWithDict:param UrlString:RECEIPT_MODIFY_REC];
            
        }else if ([title isEqualToString:@"线下支付"]){
            [param setObject:[self setRSAencryptString:textStr] forKey:@"money"];
            [param setObject:[self setRSAencryptString:inputString] forKey:@"pay_notes"];
            [tokenArr addObject:@{@"price":@"receipt_id",@"vaule":StrFormatTW(@"receipt_id", model.receipt_id)}];
            [tokenArr addObject:@{@"price":@"money",@"vaule":StrFormatTW(@"money", textStr)}];
            [tokenArr addObject:@{@"price":@"pay_notes",@"vaule":StrFormatTW(@"pay_notes", inputString)}];
            [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
            [weakSelf editOrOfflineWithDict:param UrlString:RECEIPT_OFFLINE_PAY];
            
        }
        NSLog(@"inputString = %@**** textStr = %@",inputString,textStr);
    }];
    [alertView show];
}

-(void)editOrOfflineWithDict:(NSDictionary *)param UrlString:(NSString *)urlString{
    
    [LCProgressHUD showLoading:nil];
    [self post:urlString parameters:param success:^(id dict) {
        if ([dict[@"code"] integerValue] == 0) {
            [LCProgressHUD showSuccess:dict[@"data"]];
            page = 0;
            [self request];
        }else{
            [LCProgressHUD showSuccess:dict[@"info"]];
        }
    } failure:^(NSError * error) {
        [LCProgressHUD showSuccess:[error localizedDescription]];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [PayCell cellHeight:_dataArray[indexPath.section]];
}
//- (void)configureCell:(PayCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
//}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}


@end
