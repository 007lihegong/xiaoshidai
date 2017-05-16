//
//  channelVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/10/9.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "channelVC.h"
#import "channelModel.h"

@interface channelVC () <UITableViewDelegate,UITableViewDataSource>
{
    int indx;
}
@property (nonatomic, strong) NSMutableArray *titleArr;

@end

@implementation channelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增渠道";
    indx=-1;
    [self setTableView];
    [self setChannelRequest];
}
- (NSMutableArray *)titleArr {
    if (_titleArr==nil) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}
- (void)setTableView {
    
    [self setYuan:_confirmBT size:5];
    
    _mainTV.delegate = self;
    _mainTV.backgroundColor = [UIColor clearColor];
    _mainTV.dataSource = self;
    _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    //头视图
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    headV.backgroundColor = [UIColor clearColor];
    _mainTV.tableHeaderView = headV;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indx!=-1) {
        channelModel *model = self.titleArr[indx];
        model.select = NO;
    }
    indx = (int)indexPath.row;
    
    channelModel *model = self.titleArr[indexPath.row];
    model.select = YES;
    [tableView reloadData];
    
    NSLog(@"第%d行",indx);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"channelCell" owner:nil options:nil] lastObject];
    }
    [self PixeH:CGPointMake(0, 43) lenght:ScreenWidth add:cell.contentView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //
    UILabel *titleLB = (UILabel *)[cell viewWithTag:110];
    UIImageView *imgV = (UIImageView *)[cell viewWithTag:111];
    channelModel *model = self.titleArr[indexPath.row];
    titleLB.text = model.product_name;
    if (model.select) {
        imgV.hidden = NO;
    }else {
        imgV.hidden = YES;
    }
    return cell;
}
- (IBAction)addAction {
    if (indx==-1) {
        [LCProgressHUD showInfoMsg:@"请选择渠道"];
    }else {
        [self addChannelRequest];
    }
}

#pragma mark -- 渠道列表网络请求
- (void)setChannelRequest {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/sysset/channel/" parameters:param success:^(id dic) {
        
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD hide];
            NSArray *arr = dic[@"data"];
            [self.titleArr removeAllObjects];
            for (NSDictionary *dics in arr) {
                channelModel *model = [channelModel mj_objectWithKeyValues:dics];
                [self.titleArr addObject:model];
            }
            [_mainTV reloadData];
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
#pragma mark -- 渠道添加网络请求
- (void)addChannelRequest {
    
    channelModel *model = self.titleArr[indx];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:_ordID] forKey:@"order_nid"];
    [param setObject:[self setRSAencryptString:model.product_id] forKey:@"product_id"];
    NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",_ordID]},
                          @{@"price":@"product_id",@"vaule":[NSString stringWithFormat:@"product_id%@",model.product_id]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    [LCProgressHUD showLoading:nil];
    [self post:@"/order/newchannel/" parameters:param success:^(id dic) {
        
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:@"添加成功"];
            appdelegate.refresh = 2;
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
