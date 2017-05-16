//
//  PayListViewController.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/20.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "PayListViewController.h"
#import "AllPayController.h"
#import "ToPayController.h"
#import "ToCheckController.h"
#import "RejectedController.h"
#import "FinishedController.h"
@interface PayListViewController ()<SCNavTabBarDelegate>
@property (nonatomic) AllPayController * allPayController;
@property (nonatomic) ToPayController * toPayController;
@property (nonatomic) ToCheckController * toCheckController;
@property (nonatomic) RejectedController * rejectedController;
@property (nonatomic) FinishedController * finishedController;

@end

@implementation PayListViewController
-(AllPayController *)allPayController{
    if (!_allPayController) {
        _allPayController = [[AllPayController alloc] init];
        if (self.channel_id) {
            _allPayController.channel_id = self.channel_id;
        }
        _allPayController.title = LocalizationNotNeeded(@"全部");
    }
    return _allPayController;
}
-(ToPayController *)toPayController{
    if (!_toPayController) {
        _toPayController = [[ToPayController alloc] init];
        if (self.channel_id) {
            _toPayController.channel_id = self.channel_id;
        }
        _toPayController.title = LocalizationNotNeeded(@"待支付");
    }
    return _toPayController;
}
-(ToCheckController *)toCheckController{
    if (!_toCheckController) {
        _toCheckController = [[ToCheckController alloc] init];
        if (self.channel_id) {
            _toCheckController.channel_id = self.channel_id;
        }
        _toCheckController.title = LocalizationNotNeeded(@"待审核");
    }
    return _toCheckController;
}
-(RejectedController *)rejectedController{
    if (!_rejectedController) {
        _rejectedController = [[RejectedController alloc] init];
        if (self.channel_id) {
            _rejectedController.channel_id = self.channel_id;
        }
        _rejectedController.title = LocalizationNotNeeded(@"已驳回");
    }
    return _rejectedController;
}
-(FinishedController *)finishedController{
    if (!_finishedController) {
        _finishedController = [[FinishedController alloc] init];
        if (self.channel_id) {
            _finishedController.channel_id = self.channel_id;
        }
        _finishedController.title = LocalizationNotNeeded(@"已完成");
    }
    return _finishedController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self initUI];
    [self initData];
}
-(void)initData{
    [self.allPayController request];
    [self.allPayController dataArray];
    [self.allPayController tableView];
}
-(void)initNavigationBar{
    self.navigationItem.title = LocalizationNotNeeded(@"待支付列表");
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title =@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
}

-(void)initUI{
    self.view.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
 
    NSArray *array = @[self.allPayController,self.toPayController,self.toCheckController,self.rejectedController,self.finishedController];
    _navTabBarController = [[SCNavTabBarController alloc] initWithSubViewControllers:array andParentViewController:self showArrowButton:NO];
    _navTabBarController.navTabBar.navgationTabBar.backgroundColor = [UIColor whiteColor];
    _navTabBarController.navTabBar.flag = 1;
    _navTabBarController.navTabBar.delegate = self;
    [self.view addSubview:_navTabBarController.navTabBar];
}
-(void)itemDidSelectedWithIndex:(NSInteger)index{
    [_navTabBarController.mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, DOT_COORDINATE) animated:YES];
    if (index == 0) {
        [self.allPayController dataArray];
        [self.allPayController tableView];
        [self.allPayController request];

    }else if (index == 1){
        [self.toPayController dataArray];
        [self.toPayController tableView];
        [self.toPayController request];

    }else if (index == 2){
        [self.toCheckController dataArray];
        [self.toCheckController tableView];
        [self.toCheckController request];

    }else if (index == 3){
        [self.rejectedController dataArray];
        [self.rejectedController tableView];
        [self.rejectedController request];

    }else if (index == 4){
        [self.finishedController dataArray];
        [self.finishedController tableView];
        [self.finishedController request];

    }
    NSLog(@"%s %zd",__func__,index);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
