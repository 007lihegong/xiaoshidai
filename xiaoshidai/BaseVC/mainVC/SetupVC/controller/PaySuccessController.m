//
//  PaySuccessController.m
//  xiaoshidai
//
//  Created by XSD on 2017/1/17.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "PaySuccessController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "PayListViewController.h"
#import "AllPayController.h"
@interface PaySuccessController ()

@end

@implementation PaySuccessController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.fd_interactivePopDisabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setBack:@""];
}
-(void)backAction{
    NSLog(@"返回");
    PayListViewController *payListController = (PayListViewController *)self.navigationController.childViewControllers[2];
    AllPayController * payList = (AllPayController *)payListController.navTabBarController.subViewControllers[0];
    [payList request];
    [self.navigationController popToViewController:payListController animated:YES];
}
-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * imageView = [[UIImageView alloc] init];
    [imageView setImage:IMGNAME(@"icon_succss")];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-15);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.top.mas_equalTo(self.view.mas_top).mas_equalTo(26);
    }];
    UILabel *statusLabel = [UILabel new];
    [self.view addSubview:statusLabel];
    NSString * str = @"支付状态：成功支付";
    NSMutableAttributedString * attStr = [Common Renderlabel:str start:NSMakeRange(0, 5) start:NSMakeRange(0, 0) font:14 color:UIColorFromRGB(0x666666)];
    [statusLabel setAttributedText:attStr];
    [statusLabel setFont:[UIFont systemFontOfSize:14]];
    [statusLabel setTextColor:UIColorFromRGB(0x333333)];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).mas_equalTo(25);
        make.centerX.mas_equalTo(imageView.mas_centerX);
    }];
    
    UILabel *moneyLabel = [UILabel new];
    [self.view addSubview:moneyLabel];
    NSString * money = avoidNullStr(self.dict[@"money_order"]);
    NSString * moneyStr = [NSString stringWithFormat:@"支付金额：￥%@",money];
    NSMutableAttributedString * moneyAttStr = [Common Renderlabel:moneyStr start:NSMakeRange(0, 5) start:NSMakeRange(0, 0) font:14 color:UIColorFromRGB(0x666666)];
    [moneyLabel setAttributedText:moneyAttStr];
    [moneyLabel setFont:[UIFont systemFontOfSize:14]];
    [moneyLabel setTextColor:UIColorFromRGB(0x333333)];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusLabel.mas_bottom).mas_equalTo(11);
        make.left.mas_equalTo(statusLabel.mas_left);
    }];
    
    
    UILabel *itemLabel = [UILabel new];
    [self.view addSubview:itemLabel];
    
    NSString * item = avoidNullStr(self.dict[@"info_order"]);
    NSString * itemStr = [NSString stringWithFormat:@"支付类目：%@",item];
    
    NSMutableAttributedString * itemAttStr = [Common Renderlabel:itemStr start:NSMakeRange(0, 5) start:NSMakeRange(0, 0) font:14 color:UIColorFromRGB(0x666666)];
    [itemLabel setAttributedText:itemAttStr];
    [itemLabel setFont:[UIFont systemFontOfSize:14]];
    [itemLabel setTextColor:UIColorFromRGB(0x333333)];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(moneyLabel.mas_bottom).mas_equalTo(11);
        make.left.mas_equalTo(moneyLabel.mas_left);
    }];
    
    
    UILabel *timeLabel = [UILabel new];
    [self.view addSubview:timeLabel];
    
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmss"];
    NSDate* date = [formater dateFromString:self.dict[@"dt_order"]];
    NSDateFormatter* my_formater = [[NSDateFormatter alloc] init];
    [my_formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [my_formater stringFromDate: date];
    NSString * timeStr= [NSString stringWithFormat:@"支付时间：%@",time];
    
    NSMutableAttributedString * timeAttStr = [Common Renderlabel:timeStr start:NSMakeRange(0, 5) start:NSMakeRange(0, 0) font:14 color:UIColorFromRGB(0x666666)];
    [timeLabel setAttributedText:timeAttStr];
    [timeLabel setFont:[UIFont systemFontOfSize:14]];
    [timeLabel setTextColor:UIColorFromRGB(0x333333)];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(itemLabel.mas_bottom).mas_equalTo(11);
        make.left.mas_equalTo(itemLabel.mas_left);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
