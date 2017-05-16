//
//  SubmittedVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/9/28.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "SubmittedVC.h"
#import "addPlanVC.h"

@interface SubmittedVC () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArr;
    NSMutableArray *paramArr;
    CGFloat cellHeight;
}
@end

@implementation SubmittedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交方案";
    
    [self setTableView];
}
- (void)setTableView {
    
    dataArr = [NSMutableArray array];
    paramArr = [NSMutableArray array];
    
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:_toolV];
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:_addBackV];
    [self PixeH:CGPointMake(0, 43) lenght:ScreenWidth add:_addBackV];
    [self setYuan:_sendBT size:3];
    
    _mainTV.delegate = self;
    _mainTV.dataSource = self;
    _mainTV.backgroundColor = [UIColor clearColor];
    _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTV.tableFooterView = _headV;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"submittedCell" owner:nil options:nil] lastObject];
    }
    UIView *commentV = (UIView *)[cell viewWithTag:110];
    UIView *otherV = (UIView *)[cell viewWithTag:111];
    UILabel *commentLB = (UILabel *)[cell viewWithTag:112];
    UILabel *channelLB = (UILabel *)[cell viewWithTag:113];
    UILabel *timeLB = (UILabel *)[cell viewWithTag:114];
    UILabel *interestLB = (UILabel *)[cell viewWithTag:115];
    UILabel *typeLB = (UILabel *)[cell viewWithTag:116];
    UILabel *planLB = (UILabel *)[cell viewWithTag:117];
    UIButton *deleBT = (UIButton *)[cell viewWithTag:118];
    deleBT.tag=500+indexPath.row;
    [deleBT addTarget:self action:@selector(deleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:commentV];
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:otherV];
    [self PixeH:CGPointMake(0, 43) lenght:ScreenWidth add:otherV];
    [self PixeH:CGPointMake(0, 87) lenght:ScreenWidth add:otherV];
    [self PixeH:CGPointMake(0, 131) lenght:ScreenWidth add:otherV];
    [self PixeH:CGPointMake(0, 175) lenght:ScreenWidth add:otherV];
    [self PixeH:CGPointMake(0, 220) lenght:ScreenWidth add:otherV];
    
    NSDictionary *dic = dataArr[indexPath.row];
    planLB.text = [NSString stringWithFormat:@"方案%ld",(long)indexPath.row+1];
    commentLB.text = dic[@"comment"];
    channelLB.text = dic[@"channel"];
    timeLB.text = dic[@"time"];
    interestLB.text = dic[@"interest"];
    typeLB.text = dic[@"type"];
    
    cellHeight = 260;
    CGFloat H = [XYString HeightForText:commentLB.text withSizeOfLabelFont:15 withWidthOfContent:ScreenWidth-92];
    NSLog(@"高度＝%.2f",H);
    if (H>18) {
        commentV.height+=H-18;
        commentLB.y+=2;
        commentLB.textAlignment = NSTextAlignmentLeft;
        [commentLB sizeToFit];
        otherV.y+=H-18;
        cellHeight +=H-18;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)deleAction:(UIButton *)sender {
    
    [dataArr removeObjectAtIndex:sender.tag-500];
    [paramArr removeObjectAtIndex:sender.tag-500];
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indx = [_mainTV indexPathForCell:cell];
    [_mainTV deleteRowsAtIndexPaths:@[indx] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_mainTV reloadData];
}
- (IBAction)addPlanAction {
    NSLog(@"点击了添加");
    addPlanVC *MVC = [[addPlanVC alloc] init];
    [MVC setPlan:^(NSDictionary *dic,NSDictionary *param) {
        [dataArr addObject:dic];
        [paramArr addObject:param];
        [_mainTV reloadData];
    }];
    [self.navigationController pushViewController:MVC animated:YES];
}

- (IBAction)SubmittedAction {
    if (paramArr.count==0) {
        [LCProgressHUD showMessage:@"请添加方案"];
    }else {
        [self submitRequest];
    }
}
#pragma mark -- 提交的网络请求
- (void)submitRequest {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:_ordNum] forKey:@"order_nid"];
    NSDictionary *paramDic = @{@"solution":paramArr};
    NSString *str = [self dictionaryToJson:paramDic];
    [param setObject:str forKey:@"json_solution"];
    NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",_ordNum]},
                          @{@"price":@"json_solution",@"vaule":[NSString stringWithFormat:@"json_solution%@",str]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];

    [LCProgressHUD showLoading:@"正在提交"];
    [self post:@"/order/solution/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            appdelegate.refresh = 2;
            [LCProgressHUD showSuccess:@"提交成功"];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayAction) userInfo:nil repeats:NO];
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
- (void)delayAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 字典转字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
