//
//  ProductController.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/1.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "ProductController.h"
#import "ProductModel.h"
#import "ProductCell.h"
#import "SearchVC.h"
#import "MJRefresh.h"
#import "BaseNavigationController.h"
#import "ProductionSelController.h"
#import "ProductionDetailController.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface ProductController ()<UITableViewDelegate,UITableViewDataSource>{
    MBProgressHUD *hud;
    int page;
}
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray * dataArray;
@end

@implementation ProductController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self initNavigationBar];
    page=0;
    [self request];
    [self dataArray];
    [self tableView];
}
-(void)initNavigationBar{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemSearch) target:self action:@selector(search:)];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)search:(UIBarButtonItem *)item{
    
    SearchVC *MVC = [[SearchVC alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:MVC];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)request{
    page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:@"0"] forKey:@"is_match"];
    [param setObject:[self setRSAencryptString:[NSString stringWithFormat:@"%d",page]] forKey:@"currentPage"];

    NSArray * tokenArr = @[@{@"price":@"is_match",@"vaule":[NSString stringWithFormat:@"%@%@",@"is_match",@"0"]},
                           @{@"price":@"currentPage",@"vaule":[NSString stringWithFormat:@"currentPage%@",[NSString stringWithFormat:@"%d",page]]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    [self fetchFroductWithDict:param UrlString:PROSEARCH];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.tableView.estimatedRowHeight = 138;
        __weak __typeof(&*self)weakSelf = self;
        _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof__(&*weakSelf) sself = weakSelf;
            sself->page=0;
            [weakSelf request];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(request)];

        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        [_tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"ProductCellID"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
//获取产品数据
-(void)fetchFroductWithDict:(NSDictionary *)param UrlString:(NSString *)urlString{
    hud = [MBProgressHUD showHUDAddedTo:Window animated:YES];
    hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
    hud.labelText = @"请稍等";
    [hud show:YES];
    [BaseRequest post:urlString parameters:param success:^(id dict) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([dict[@"code"] intValue]==0) {
            NSArray *arr = dict[@"data"];
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            if (arr.count) {
                hud.labelText = @"获取成功";
                [hud hide:YES afterDelay:0.5];
                ProductModel *model = [ProductModel mj_objectWithKeyValues:dict];
                for (NSDictionary * dict  in model.data) {
                    ProductInfo * info = [ProductInfo mj_objectWithKeyValues:dict];
                    [_dataArray addObject:info];
                }
            }else{
                if (page==1) {
                    [hud hide:YES afterDelay:0.5];
                }else {
                    hud.labelText = @"无更多数据";
                    [hud hide:YES afterDelay:0.5];
                }
                page--;
            }
            [_tableView reloadData];
        }else{
             page--;
            [hud hide:YES afterDelay:0.5];
            NSString *msg = dict[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError * error) {
        page--;
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        hud.labelText = @"获取失败";
        [hud hide:YES afterDelay:0.5];
    }];
    [hud hide:YES afterDelay:0.5];
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

    ProductCell *cell;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCellID"];
    }
    ProductInfo * info = _dataArray[indexPath.row];
    cell.model = info;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductionDetailController *controller = [[ProductionDetailController alloc] init];
    ProductInfo * info = [ProductInfo mj_objectWithKeyValues:_dataArray[indexPath.row]];
    controller.idString = info.product_id;
    controller.title = @"产品详情";
    [self.navigationController pushViewController:controller animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    ProductInfo * info = _dataArray[indexPath.row];
    return [ProductCell cellHeight:info];
}
- (void)configureCell:(ProductCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *button  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"筛选" forState:(UIControlStateNormal)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(mySelect:) forControlEvents:(UIControlEventTouchUpInside)];
    return button;
}
-(void)mySelect:(UIButton * )button{
    ProductionSelController * controller = [[ProductionSelController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
