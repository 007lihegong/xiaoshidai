//
//  ProductionDetailController.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/8.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "SearchResController.h"
#import "ProductModel.h"
#import "ProductCell.h"
#import "MJRefresh.h"
#import "ProductionDetailController.h"
@interface SearchResController ()<UITableViewDelegate,UITableViewDataSource>{
    MBProgressHUD *hud;
    int page;
}
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray * dataArray;
@property (nonatomic) NSMutableDictionary * rsaParam;

@end

@implementation SearchResController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 0;
    [self request];
    [self dataArray];
    [self tableView];
}

-(void)request{
    if (self.param) {
        page ++;
        _rsaParam = [NSMutableDictionary dictionary];
        NSMutableArray * tokenArr = [NSMutableArray array];
        [_param enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
            if(![obj isEqualToString:@""]&& ![obj isEqualToString:@"0"]){
                NSDictionary *opa = @{@"price":key,@"vaule":[NSString stringWithFormat:@"%@%@",key,obj]};
                [tokenArr addObject:opa];
                [_rsaParam setObject:[self setRSAencryptString:obj] forKey:key];
            }
        }];
        [tokenArr addObject:@{@"price":@"currentPage",@"vaule":[NSString stringWithFormat:@"currentPage%@",[NSString stringWithFormat:@"%d",page]]}];
        [_rsaParam setObject:[self setRSAencryptString:[NSString stringWithFormat:@"%d",page]] forKey:@"currentPage"];
        
        [_rsaParam setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
        NSLog(@"%@",[_rsaParam mj_JSONObject]);
        [self fetchFroductWithDict:_rsaParam UrlString:PROSEARCH];
    }
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
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
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
                    NSLog(@"%@",info.product_name);
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cellID"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        UIImageView *image = [[UIImageView alloc] initWithImage:IMGNAME(@"list_icon_enter")];
        cell.accessoryView = image ;
    }
    ProductInfo * info = [ProductInfo mj_objectWithKeyValues:_dataArray[indexPath.row]];
    cell.textLabel.text = info.product_name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductionDetailController *controller = [[ProductionDetailController alloc] init];
    controller.title = LocalizationNotNeeded(@"产品详情");
     ProductInfo * info = [ProductInfo mj_objectWithKeyValues:_dataArray[indexPath.row]];
    controller.idString = info.product_id;
    [self.navigationController pushViewController:controller animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return  cell.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
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
