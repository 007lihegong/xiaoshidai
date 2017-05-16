//
//  ManageVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/9/20.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "ManageVC.h"
#import "StatisTabController.h"
#import "SetupVC.h"
#import "BaseNavigationController.h"
#import "ProductController.h"

#import "XOrederController.h"
@interface ManageVC ()

@end

@implementation ManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
   // [self initRightBar];
}
-(void)initRightBar{
 
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:IMGNAME(@"icon_setting") style:(UIBarButtonItemStylePlain) target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = item;

}
-(void)rightItemClick:(UIBarButtonItem *)item{
    SetupVC * setting = [[SetupVC alloc] init];
    setting.title = @"我的";
    [self.navigationController pushViewController:setting animated:YES];
}
- (void)setup {
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/2*0.7)];//*2+1
    backV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backV];
    UIButton *button;
    if ([[USER_DEFAULT objectForKey:Is_reg] isEqualToString:@"1"]) {
        backV.width/=2;
        backV.height = ScreenWidth/2*0.7;
        button = [[UIButton alloc] initWithFrame:CGRectMake(0*ScreenWidth/2, 0, ScreenWidth/2, ScreenWidth/2*0.7)];
    }else{
#if 0
        button = [[UIButton alloc] initWithFrame:CGRectMake(1*ScreenWidth/2, ScreenWidth/2*0.7+1, ScreenWidth/2, ScreenWidth/2*0.7)];
#else
        button = [[UIButton alloc] initWithFrame:CGRectMake(0*ScreenWidth/2, ScreenWidth/2*0.7+1, ScreenWidth/2, ScreenWidth/2*0.7)];
#endif
        for (int i=0; i<2; i++) {
            UIButton *button;
            button = [[UIButton alloc] initWithFrame:CGRectMake(i*ScreenWidth/2, 0, ScreenWidth/2, ScreenWidth/2*0.7)];
            if (i==2) {
                button = [[UIButton alloc] initWithFrame:CGRectMake(0*ScreenWidth/2, ScreenWidth/2*0.7+1, ScreenWidth/2, ScreenWidth/2*0.7)];
            }
            button.tag=1000+i;
#if 0
            [button setImage:[UIImage imageNamed:@[@"nav_icon_logo",@"nav_icon_total",@"nav_icon_product"][i]] forState:UIControlStateNormal];
            [button setTitle:@[@"小时贷产品申请",@"统计",@"产品库"][i] forState:UIControlStateNormal];
#else
            [button setImage:[UIImage imageNamed:@[@"nav_icon_total",@"nav_icon_product"][i]] forState:UIControlStateNormal];
            [button setTitle:@[@"统计",@"产品库"][i] forState:UIControlStateNormal];
#endif

            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitleColor:colorValue(0x111111, 1) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [backV addSubview:button];
#if 0
            CGFloat w = [XYString WidthForString:@[@"小时贷产品申请",@"统计",@"产品库"][i] withSizeOfFont:13];
#else
            CGFloat w = [XYString WidthForString:@[@"统计",@"产品库"][i] withSizeOfFont:13];
#endif
            [button setTitleEdgeInsets:UIEdgeInsetsMake(30, -25, -30, 25)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(-10, w/2, 10, -w/2)];
        }
        
    }
        [button setImage:[UIImage imageNamed:@"nav_icon_setting"] forState:UIControlStateNormal];
#if 0
    button.tag=1000+3;
#else
    button.tag=1000+2;
#endif
        [button setTitle:@"我的" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:colorValue(0x111111, 1) forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        CGFloat w = [XYString WidthForString:@"我的" withSizeOfFont:13];
    
        [button setTitleEdgeInsets:UIEdgeInsetsMake(30, -25, -30, 25)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(-10, w/2, 10, -w/2)];
    [self PixeV:CGPointMake(ScreenWidth/2, 0) lenght:ScreenWidth/2*0.7 add:backV];
    [self PixeV:CGPointMake(ScreenWidth/2, button.height) lenght:ScreenWidth/2*0.7 add:backV];
    [self PixeH:CGPointMake(0, button.height) lenght:ScreenWidth add:backV];


}
- (void)buttonAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"统计"]) {
        StatisTabController *controller =  [[StatisTabController alloc] init];
        controller.title = sender.titleLabel.text;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:controller animated:YES];
        });
    }else if([sender.titleLabel.text isEqualToString:@"产品库"]){
        ProductController *controller =  [[ProductController alloc] init];
        controller.title = sender.titleLabel.text;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:controller animated:YES];
        });
    }else if ([sender.titleLabel.text isEqualToString:@"我的"]){
        SetupVC *controller =  [[SetupVC alloc] init];
        controller.title = sender.titleLabel.text;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:controller animated:YES];
        });
    }else if ([sender.titleLabel.text isEqualToString:@"小时贷产品申请"]){
        XOrederController *controller = [[XOrederController alloc] init];
        controller.title = sender.titleLabel.text;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:controller animated:YES];
        });
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
