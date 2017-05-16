//
//  MyGroupListControllerViewController.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/5.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "MyGroupListControllerViewController.h"
#import "RCDGroupTableViewCell.h"
#import "SingleChatController.h"
@interface MyGroupListControllerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray * dataArray;
@property (nonatomic) NSMutableArray * groups;

@end

@implementation MyGroupListControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataArray];
    [self tableView];
    [self request];
}
-(void)request{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString * userId = [RCIM sharedRCIM].currentUserInfo.userId;
    [param setObject:[BaseRequest setRSAencryptString:userId] forKey:@"user_id"];
    NSArray *tokenArr = @[@{@"price":@"user_id",@"vaule":[NSString stringWithFormat:@"user_id%@",userId]}];
    [param setObject:[BaseRequest setUserTokenStr:tokenArr] forKey:@"token"];
    [self fetchGroupInfoWithDict:param];
}

-(void)fetchGroupInfoWithDict:(NSDictionary *)param{
    [BaseRequest post:MYGROUP parameters:param success:^(id dict) {
        if ([dict[@"code"] intValue]==0) {
            NSLog(@"获取所属群信息成功 并开始同步...");
            GroupInfoModel *model = [GroupInfoModel mj_objectWithKeyValues:dict];
            self.groups = [model.data mutableCopy];
            for (NSInteger i = 0; i< _groups.count; i++) {
                NSDictionary *tempDict = [NSDictionary dictionaryWithDictionary:_groups[i]];
                if ([XYString isDicNull:tempDict[@"group_id"]]||[XYString isDicNull:tempDict[@"group_name"]]) {
                    NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:@[@"错误群",@"错误群"] forKeys:@[@"group_id",@"group_name"]];
                    _groups[i] = dict1;
                }
            }
            [USER_DEFAULT setObject:self.groups forKey:@"GROUP"];
            for (NSDictionary *dic in _groups) {
                GroupInfo *obj = [GroupInfo mj_objectWithKeyValues:dic];
                RCGroup * groupInfo = [[RCGroup alloc] init];
                groupInfo.groupId = obj.groupId = obj.group_id;
                groupInfo.groupName = obj.groupName = obj.group_name;
                obj.usersStr = obj.usersStr;
                [[RCIM sharedRCIM] refreshGroupInfoCache:obj withGroupId:obj.group_id];
                [_dataArray addObject:obj];
            }
            [_tableView reloadData];
            NSLog(@"同步完成");
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[RCDGroupTableViewCell class] forCellReuseIdentifier:@"cellID"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count>0) {
        return _dataArray.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RCDGroupCell";
    RCDGroupTableViewCell *cell = (RCDGroupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[RCDGroupTableViewCell alloc]init];
    }
    GroupInfo *group = _dataArray[indexPath.row];
    group.group_name = group.groupName;
    group.group_id = group.groupId;
    //cell.lblGroupId.text = group.groupId;
    [cell setModel:group];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dataArray.count > 0) {
        GroupInfo * model = _dataArray[indexPath.row];
        SingleChatController *vc = [[SingleChatController alloc] init];
        vc.conversationType = ConversationType_GROUP;
        vc.needPopToRootView = YES;
        vc.targetId = model.groupId;
        vc.title = model.groupName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [RCDGroupTableViewCell cellHeight];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
@end
