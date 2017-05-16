//
//  XOrederController.m
//  xiaoshidai
//
//  Created by XSD on 2017/1/22.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "XOrederController.h"
#import "XOrderAddController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface XOrederController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray * dataArray;
@end

@implementation XOrederController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataArray];
    [self tableView];
    [self request];
}
-(void)request{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    [self post:SYS_XORDER_TYPE parameters:param success:^(id dict) {
        if ([dict[@"code"] integerValue] == 0) {
            [LCProgressHUD showSuccess:dict[@"msg"]];
            NSArray * data = dict[@"data"];
            for (NSDictionary *model in data) {
                [_dataArray addObject:model[@"value"]];
            }
            [_tableView reloadData];
        }else{
            NSString *msg = dict[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError * error) {
        
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        CGRect frame = CGRectMake(0, 0, 0, CGFLOAT_MIN);
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        [self.view addSubview:_tableView];
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
    
    UITableViewCell *cell;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        UIImageView *image = [[UIImageView alloc] initWithImage:IMGNAME(@"list_icon_enter")];
        cell.accessoryView = image ;
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XOrderAddController *controller = [[XOrderAddController alloc] init];
    controller.title = _dataArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
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
