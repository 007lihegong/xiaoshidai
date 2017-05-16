//
//  RootTabBarController.m
//  WMVideoPlayer
//
//  Created by 郑文明 on 15/12/14.
//  Copyright © 2015年 郑文明. All rights reserved.
//

#import "RootTabBarController.h"
#import "BaseNavigationController.h"
#import "Defines.h"
#import "HomeVC.h"
#import "OrderVC.h"
#import "ManageVC.h"
//#import "SetupVC.h"
#import "MyListController.h"
#import "TabProductController.h"
@interface RootTabBarController ()
{
    
}
@property NSUInteger previousIndex;
@end

@implementation RootTabBarController
-(void)changeSelectedIndex:(NSNotification *)notify {
    NSInteger index = [notify.object integerValue];
    self.selectedIndex = index;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSUInteger index = tabBarController.selectedIndex;
    self.selectedTabBarIndex = index;
    switch (index) {
        case 0:
            self.previousIndex = index;
            break;
            
        case 1:
            self.previousIndex = index;
            break;
            
        case 2:
        {
            if (self.previousIndex == index) {
                //判断如果有未读数存在，发出定位到未读数会话的通知
                //int count = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
               // if (count > 0) {
               //     UITabBarItem *item = self.tabBar.items[2];
              //      [item setBadgeValue:[NSString stringWithFormat:@"%i",count]];
             //   } else {
                    //[__weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:0];
             //       UITabBarItem *item = self.tabBar.items[2];
             //       [item setBadgeValue:nil];
             //   }
               // self.previousIndex = index;
            }
            self.previousIndex = index;
        }
            break;
            
        case 3:
            self.previousIndex = index;
            break;
            
        default:
            break;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeSelectedIndex:)
                                                 name:@"ChangeTabBarIndex"
                                               object:nil];
    TabProductController *tabProVC = [[TabProductController alloc] init];
    tabProVC.title =  LocalizationNotNeeded(@"产品");
    BaseNavigationController *tabProNav = [[BaseNavigationController alloc]initWithRootViewController:tabProVC];
    tabProNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:LocalizationNotNeeded(@"产品") image:[[UIImage imageNamed:@"tab_product_nor"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] selectedImage:[[UIImage imageNamed:@"tab_product_sel"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    
    HomeVC *tencentVC = [[HomeVC alloc]init];
    tencentVC.title = LocalizationNotNeeded(@"抢单");
    BaseNavigationController *tencentNav = [[BaseNavigationController alloc]initWithRootViewController:tencentVC];
    tencentNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:LocalizationNotNeeded(@"抢单") image:[UIImage imageNamed:@"tab_rush_nor"] selectedImage:[UIImage imageNamed:@"tab_rush_seled"]];

    OrderVC *sinaVC = [[OrderVC alloc]init];
    sinaVC.title = LocalizationNotNeeded(@"订单");
    BaseNavigationController *sinaNav = [[BaseNavigationController alloc]initWithRootViewController:sinaVC];
    sinaNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:LocalizationNotNeeded(@"订单") image:[UIImage imageNamed:@"tab_order_nor"] selectedImage:[UIImage imageNamed:@"tab_order_seled"]];
    
    ManageVC *netEaseVC = [[ManageVC alloc]init];
    netEaseVC.title = LocalizationNotNeeded(@"管理");
    BaseNavigationController *netEaseNav = [[BaseNavigationController alloc]initWithRootViewController:netEaseVC];
    netEaseNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:LocalizationNotNeeded(@"管理") image:[UIImage imageNamed:@"tab_mg_sel"] selectedImage:[UIImage imageNamed:@"tab_mg_seled"]];
    
    //SetupVC *pcenterVC = [[SetupVC alloc]init];
    //pcenterVC.title = @"设置";
    //BaseNavigationController *pcenterNav = [[BaseNavigationController alloc]initWithRootViewController:pcenterVC];
   // pcenterNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"设置" image:[UIImage imageNamed:@"tab_set_seled"] selectedImage:[UIImage imageNamed:@"tab_set_seled"]];
    
    MyListController *chartVC = [[MyListController alloc]init];
    chartVC.title = LocalizationNotNeeded(@"消息中心");
    BaseNavigationController *chartNav = [[BaseNavigationController alloc]initWithRootViewController:chartVC];
    chartNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:LocalizationNotNeeded(@"消息") image:[UIImage imageNamed:@"tab_mesag_sel"] selectedImage:[UIImage imageNamed:@"tab_mesag_seled"]];

    //[[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 0)];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:(UIControlStateNormal)];
    self.viewControllers = @[tabProNav,tencentNav,sinaNav,chartNav,netEaseNav];
    
    self.tabBar.tintColor = mainHuang;
    //背景色
    self.tabBar.barTintColor = [UIColor whiteColor];
    //改变线色
    CGFloat width = 1/[UIScreen mainScreen].scale;
    [self.tabBar setClipsToBounds:YES];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, width)];
    line.backgroundColor = BorderColor;
    [self.tabBar addSubview:line];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
