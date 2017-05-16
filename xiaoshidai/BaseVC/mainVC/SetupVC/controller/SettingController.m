//
//  SettingController.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/29.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "SettingController.h"
#import "changePassVC.h"
#import "loginVC.h"
@interface SettingController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *cellImg;
    NSArray *cellTitle;
    BOOL swch;
    NSString *phoneStr;
}
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray * dataArray;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self dataArray];
    [self tableView];
}
-(void)initData{
    cellTitle = @[@"消息推送",@"修改密码"];//,@"贷款专线"
    cellImg = @[@"list_icon_news",@"list_icon_revised"];//,@"list_icon_phone"
    phoneStr = @"18684021289";

}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        [_tableView registerNib:[UINib nibWithNibName:@"setupCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        _tableView.tableFooterView = [self quitButton];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(UIButton *)quitButton{
    
    UIButton *button  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"退出登录" forState:(UIControlStateNormal)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button setFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    return button;
}
-(void)buttonClick:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:LocalizationNotNeeded(@"提示") message:@"是否确定退出当前登录" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self setLogoutRequest];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- 登出的网络请求
- (void)setLogoutRequest {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setUserTokenStr:nil] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/operator/logout/" parameters:param success:^(id dic) {
        [LCProgressHUD hide];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:user_ID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:login_key];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:login_Operation];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:lim_ord];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:role_class];
        [NSUserDefaults resetStandardUserDefaults];
        //[[RCIM sharedRCIM] disconnect];
        [[RCIM sharedRCIM] logout];
        loginVC *MVC = [[loginVC alloc] init];
        [self presentViewController:MVC animated:YES completion:nil];
    } failure:^(NSError *error) {
        
    }];
}
//        if ([dic[@"code"] intValue]==0) {
//            [LCProgressHUD hide];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:user_ID];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:login_key];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:login_Operation];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:lim_ord];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:role_class];
//            loginVC *MVC = [[loginVC alloc] init];
//            [self presentViewController:MVC animated:YES completion:nil];
//        }else {
//            NSString *msg = dic[@"info"];
//            if (![XYString isBlankString:msg]) {
//                [LCProgressHUD showInfoMsg:msg];
//            }else {
//                [LCProgressHUD hide];
//            }
//        }
#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (cellTitle.count) {
        return cellTitle.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"setupCell" owner:nil options:nil] lastObject];
    }
    UIImageView *imgV = (UIImageView *)[cell viewWithTag:110];
    UILabel *titleLB = (UILabel *)[cell viewWithTag:111];
    UILabel *detail = (UILabel *)[cell viewWithTag:120];

    UIImageView *imgDetV = (UIImageView *)[cell viewWithTag:112];
    UISwitch *swich = (UISwitch *)[cell viewWithTag:113];
    imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",cellImg[indexPath.row]]];
    titleLB.text = cellTitle[indexPath.row];
    if (indexPath.row==0) {
        imgDetV.hidden = YES;
        swich.hidden = NO;
        [swich addTarget:self action:@selector(swichAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *jpush = [[NSUserDefaults standardUserDefaults] objectForKey:@"JPush_sta"];
        if ([jpush isEqualToString:@"1"]) {
            swich.on = YES;
            swch = YES;
        }else {
            swich.on = NO;
            swch = NO;
        }
    }
    if ([titleLB.text isEqualToString:@"贷款专线"]) {
        detail.text = phoneStr;
        detail.textColor = UIColorFromRGB(0x666666);
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * title = cellTitle[indexPath.row];
    if ([title isEqualToString:@"修改密码"]){
        changePassVC *MVC = [[changePassVC alloc] init];
        MVC.title = title;
        [self.navigationController pushViewController:MVC animated:YES];
    }else if ([title isEqualToString:@"贷款专线"]){
        [self callAction];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return  cell.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 35;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
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
- (void)swichAction:(UISwitch *)swich {
    [self pushSwich:swich];
}
#pragma mark -- 消息推送开关
- (void)pushSwich:(UISwitch *)swich {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (swch == YES) {
        [param setObject:[self setRSAencryptString:@"0"] forKey:@"is_push"];
        NSArray *tokenArr = @[@{@"price":@"is_push",@"vaule":[NSString stringWithFormat:@"is_push%@",@"0"]}];
        [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    }else {
        [param setObject:[self setRSAencryptString:@"1"] forKey:@"is_push"];
        NSArray *tokenArr = @[@{@"price":@"is_push",@"vaule":[NSString stringWithFormat:@"is_push%@",@"1"]}];
        [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    }
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/operator/editpush/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD hide];
            if (swch==YES) {
                [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"JPush_sta"];
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"JPush_sta"];
            }
        }else {
            if (swch==YES) {
                swich.on = YES;
            }else {
                swich.on = NO;
            }
            NSString *msg = dic[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {
        if (swch==YES) {
            swich.on = YES;
        }else {
            swich.on = NO;
        }
    }];
}
#pragma mark --  拨打电话
-(void)callAction{
    NSString *string = [NSString stringWithFormat:@"tel://%@",@"18684021289"];
    UIApplication *app = [UIApplication sharedApplication];
    if (IOS10_2LATER) {
        [app openURL:[NSURL URLWithString:string]options:@{} completionHandler:^(BOOL success) {
            NSLog(@"%@",@(success));
        }];
    }else{
        NSString *title = @"18684021289";
        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"呼叫", nil);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"%@",cancelButtonTitle);
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIApplication *app = [UIApplication sharedApplication];
            [app openURL:[NSURL URLWithString:string]];
            NSLog(@"%@",otherButtonTitle);
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
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
