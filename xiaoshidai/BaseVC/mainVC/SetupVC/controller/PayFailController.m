//
//  PayFailController.m
//  xiaoshidai
//
//  Created by XSD on 2017/1/17.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "PayFailController.h"

@interface PayFailController ()

@end

@implementation PayFailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * imageView = [[UIImageView alloc] init];
    [imageView setImage:IMGNAME(@"icon_fail")];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.top.mas_equalTo(self.view.mas_top).mas_equalTo(80);
    }];
    UILabel *failLabel = [UILabel new];
    [self.view addSubview:failLabel];
    [failLabel setText:@"支付失败，请返回重新支付"];
    [failLabel setFont:[UIFont systemFontOfSize:15]];
    [failLabel setTextColor:UIColorFromRGB(0x333333)];
    [failLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).mas_equalTo(25);
        make.centerX.mas_equalTo(imageView.mas_centerX);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
