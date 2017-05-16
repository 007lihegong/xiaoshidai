//
//  StatisTabController.m
//  xiaoshidai
//
//  Created by XSD on 16/10/26.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "StatisTabController.h"
#import "StatisticsController.h"
#import "ServiceFeeController.h"
@interface StatisTabController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSArray * dataArray;
@end

@implementation StatisTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    _tableView = [[UITableView alloc] initWithFrame:frame style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _dataArray = @[@"概况统计",@"服务费统计",@"放款额统计",@"进件量统计",@"成单量统计",
                   @"成单率统计",@"客户来源统计",@"渠道产品统计"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    _tableView.rowHeight = 44;
    _tableView.separatorColor = UIColorFromRGB(0xe8e8e8);
    [self.view addSubview:_tableView];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;;
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        StatisticsController *controller = [[StatisticsController alloc] init];
        controller.title = _dataArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 1) {
        ServiceFeeController  *controller = [[ServiceFeeController alloc] init];
        controller.flagStr = @"服务费";
        controller.title = _dataArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 2) {
        ServiceFeeController  *controller = [[ServiceFeeController alloc] init];
        controller.flagStr = @"放款额";
        controller.title = _dataArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 3) {
        ServiceFeeController  *controller = [[ServiceFeeController alloc] init];
        controller.flagStr = @"进件量";
        controller.title = _dataArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 4) {
        ServiceFeeController  *controller = [[ServiceFeeController alloc] init];
        controller.flagStr = @"成单量";
        controller.title = _dataArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 5) {
        ServiceFeeController  *controller = [[ServiceFeeController alloc] init];
        controller.flagStr = @"成单率";
        controller.title = _dataArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 6) {
        ServiceFeeController  *controller = [[ServiceFeeController alloc] init];
        controller.flagStr = @"客户来源";
        controller.title = _dataArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 7) {
        ServiceFeeController  *controller = [[ServiceFeeController alloc] init];
        controller.flagStr = @"渠道产品";
        controller.title = _dataArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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

@end
