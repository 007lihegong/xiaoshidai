//
//  SetupVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/9/20.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "SetupVC.h"
#import "loginVC.h"
#import "changePassVC.h"
#import "AboutUsVC.h"
#import "BaseNavigationController.h"
#import "AddressBookController.h"
#import "PayListViewController.h"
#import "SettingController.h"
#import "MyBankCardController.h"
#import "RealNameController.h"
@interface SetupVC () <UITableViewDelegate,UITableViewDataSource>//UIAlertViewDelegate
{
    NSArray *cellImg;
    NSArray *cellTitle;
    NSString *phoneStr;
}
@property (strong, nonatomic) IBOutlet UIView *footV;
@property (copy, nonatomic) NSString *status;
@end

@implementation SetupVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBar.hidden = NO;
    phoneStr = @"18684021289";
    [self setTableView];
#if IS_CESHI
    [self post];
#else
    [self post];
#endif
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (appdelegate.refresh == 2) {
        appdelegate.refresh = 0;
        [self post];
    }
}
-(void)post{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSString * operator_id = [USER_DEFAULT objectForKey:login_Operation];
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    [param setObject:[self setRSAencryptString:operator_id] forKey:@"operator_id"];
    [self post:SYSSET_REALNAME_STATUS parameters:param success:^(id dict) {
        [_mainTV.mj_header endRefreshing];
        if ([dict[@"code"] isEqualToString:@"0"]) {
            _status = dict[@"data"][@"realname_status"];
            NSLog(@"实名认证状态--->%@",_status);
            [USER_DEFAULT setObject:_status forKey:REALNAME_STATUS];
            [_mainTV reloadData];
        }else{
            [LCProgressHUD showSuccess:dict[@"info"]];
        }
    } failure:^(NSError * error) {
        [_mainTV.mj_header endRefreshing];
    }];
}
//- (BOOL)prefersStatusBarHidden{
//    
//    return YES; //返回NO表示要显示，返回YES将hiden
//}
- (void)setTableView {
    
    if([[USER_DEFAULT objectForKey:Is_reg] isEqualToString:@"1"]){
        cellTitle = @[@"消息推送",@"修改密码",@"贷款专线",@"关于我们",@"设置"];
        cellImg = @[@"list_icon_news",@"list_icon_revised",@"list_icon_phone",@"list_icon_aboutwe",@"list_icon_setting"];

    }else{
        
        cellTitle = @[@"组织架构",@"待支付列表",@"实名认证",@"我的银行卡",@"贷款专线",@"关于我们",@"设置"];
        cellImg = @[@"ic_group",@"list_icon_receive",@"list_icon_cef",@"list_icon_card",@"list_icon_phone",@"list_icon_aboutwe",@"list_icon_setting"];
//#warning (revise 1 - product item )
//        cellTitle = @[@"组织架构",@"贷款专线",@"关于我们",@"设置"];
//        cellImg = @[@"ic_group",@"list_icon_phone",@"list_icon_aboutwe",@"list_icon_setting"];
    }
    
// cellTitle = @[@"消息推送",@"组织架构",@"待收列表",@"实名认证",@"我的银行卡",@"修改密码",@"贷款专线",@"关于我们"];
// cellImg = @[@"list_icon_news",@"ic_group",@"list_icon_news",@"ic_group",@"list_icon_revised"
    //,@"list_icon_revised",@"list_icon_phone",@"list_icon_aboutwe"];
    _mainTV.delegate = self;
    _mainTV.dataSource = self;
    _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mainTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [_mainTV registerNib:[UINib nibWithNibName:@"setupCell" bundle:nil] forCellReuseIdentifier:@"cellID"];

    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 190*Multiple)];
    headImg.image = [UIImage imageNamed:@"img_bg"];
    _mainTV.tableHeaderView = headImg;
    __weak __typeof(&*self)weakSelf = self;
    
    _mainTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf post];
    }];
    
    //_mainTV.tableFooterView = _footV;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellTitle count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * title = cellTitle[indexPath.row];
    if ([title isEqualToString:@"组织架构"]) {
        AddressBookController *MVC = [[AddressBookController alloc] init];
        MVC.title = cellTitle[indexPath.row];
        [self.navigationController pushViewController:MVC animated:YES];
    }else if ([title isEqualToString:@"待支付列表"]){
        PayListViewController * controller = [[PayListViewController alloc] init];
        controller.title = title;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([title isEqualToString:@"实名认证"]){
        //1未认证2待审核3已认证4认证失败
        if ([_status isEqualToString:@"1"]) {
            RealNameController * controller = [[RealNameController alloc] init];
            controller.title = title;
            controller.buttonStr = @"提交";
            [self.navigationController pushViewController:controller animated:YES];
        }else if ([_status isEqualToString:@"2"]){
        
        }else if ([_status isEqualToString:@"3"]){

        }else if ([_status isEqualToString:@"4"]){
            RealNameController * controller = [[RealNameController alloc] init];
            controller.title = title;
            controller.buttonStr = @"重新提交";
            [self.navigationController pushViewController:controller animated:YES];
        }

    }else if ([title isEqualToString:@"我的银行卡"]){
        MyBankCardController * controller = [[MyBankCardController alloc] init];
        controller.title = title;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([title isEqualToString:@"关于我们"]){
        AboutUsVC *MVC = [[AboutUsVC alloc] init];
        MVC.title = title;
        [self.navigationController pushViewController:MVC animated:YES];
    }else if ([title isEqualToString:@"设置"]){
        SettingController * controller = [[SettingController alloc] init];
        controller.title = title;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([title isEqualToString:@"贷款专线"]){
        [self callAction];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"setupCell" owner:nil options:nil] lastObject];
    }
    [self PixeH:CGPointMake(0, 43) lenght:ScreenWidth add:cell.contentView];
    UIImageView *imgV = (UIImageView *)[cell viewWithTag:110];
    UILabel *titleLB = (UILabel *)[cell viewWithTag:111];
    UILabel *detail = (UILabel *)[cell viewWithTag:120];
    detail.textAlignment = NSTextAlignmentRight;
    imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",cellImg[indexPath.row]]];
    titleLB.text = cellTitle[indexPath.row];
    if ([titleLB.text isEqualToString:@"贷款专线"]) {
        detail.text = phoneStr;
        detail.textColor = UIColorFromRGB(0x666666);
    }
    if ([titleLB.text isEqualToString:@"实名认证"]) {
        //1未认证2待审核3已认证4认证失败
        detail.textColor = UIColorFromRGB(0x666666);
        if (_status) {

        }else{
            _status = [USER_DEFAULT objectForKey:REALNAME_STATUS];
        }
        if ([_status isEqualToString:@"1"]) {
            detail.text = @"请立即实名认证";
        }else if ([_status isEqualToString:@"2"]){
            detail.text = @"实名认证待审核";
        }else if ([_status isEqualToString:@"3"]){
            detail.text = @"实名认证已通过";
        }else if ([_status isEqualToString:@"4"]){
            detail.text = @"实名认证未通过请重新提交";
        }
    }
    return cell;
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
#pragma mark -- 退出登录
- (IBAction)logOutAction {
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
        [[RCIM sharedRCIM] disconnect];
        loginVC *MVC = [[loginVC alloc] init];
        [self presentViewController:MVC animated:YES completion:nil];
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
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}


@end
