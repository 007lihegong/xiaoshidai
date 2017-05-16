//
//  AddOrderController.m
//  xiaoshidai
//
//  Created by XSD on 16/9/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "AddOrderController.h"


@interface AddOrderController ()<SCNavTabBarDelegate>

//@property (nonatomic)  SCNavTabBarController    *navTabBarController;
@end

@implementation AddOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initNavigationBar];
}

-(void)initNavigationBar{
    self.navigationItem.title = LocalizationNotNeeded(@"新增订单");
    //[self.navigationController.navigationBar setTitleTextAttributes:
    // @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]],
     //  NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title =@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self setBack:@""];
}
-(void)initUI{
    self.view.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    _baseInfoVC = [[BaseInfoController alloc] init];
    _baseInfoVC.title = LocalizationNotNeeded(@"基本资料");
    _baseInfoVC.model = self.model.data.user_base_info;
    _baseInfoVC.detailModel = self.model;
    if ([self.title isEqualToString:@"编辑订单"]) {
        _baseInfoVC.flag = 10;
    }
    _baseInfoVC.view.backgroundColor = MyGrayColor;

    
    _assetVC = [[AssetController alloc] init];
    _assetVC.title = LocalizationNotNeeded(@"资产资料");
    _assetVC.model = _model.data.user_assets_info;
    _assetVC.detailModel = self.model;
    _assetVC.view.backgroundColor = MyGrayColor;
 
    
    _creditInfoVC = [[CreditInfoController alloc] init];
    _creditInfoVC.title = LocalizationNotNeeded(@"信用资料");
    _creditInfoVC.model = _model.data.user_credit_info;
    _creditInfoVC.detailModel = self.model;
    if ([self.title isEqualToString:@"重新提交"]) {
        _creditInfoVC.flagTag = 15;
    }
    _creditInfoVC.view.backgroundColor = MyGrayColor;

    
    NSArray *array = @[self.baseInfoVC,self.assetVC,self.creditInfoVC];
    _navTabBarController = [[SCNavTabBarController alloc] initWithSubViewControllers:array andParentViewController:self showArrowButton:NO];
    _navTabBarController.navTabBar.delegate = self;
    [self.view addSubview:_navTabBarController.navTabBar];
    if (self.model) {
        //_navTabBarController.mainView.scrollEnabled = YES;
        //_navTabBarController.navTabBar.flag = 1;
    }else{
        //_navTabBarController.mainView.scrollEnabled = NO;
    }
    _navTabBarController.mainView.scrollEnabled = NO;
    _navTabBarController.navTabBar.navgationTabBar.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)backAction{
    NSString *title = @"确认是否返回";
    NSString *message = NSLocalizedString(@"确认操作", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"否", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"是", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"%@",cancelButtonTitle);
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"%@",otherButtonTitle);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];

    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)itemDidSelectedWithIndex:(NSInteger)index{
    [self.view endEditing:YES];
    [_navTabBarController.mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, DOT_COORDINATE) animated:YES];
    if (index == 0) {
        
    }else if (index == 1){
        _baseInfoVC.isJump = YES;
        [_baseInfoVC next:_baseInfoVC.nextButton];
    }else if (index == 2){
        _assetVC.isJump = YES;
        [_assetVC next:_assetVC.nextButton];
    }
    _baseInfoVC.isJump = NO;
    _assetVC.isJump = NO;
    NSLog(@"%s %zd",__func__,index);
}
- (void)dealloc
{
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    NSLog(@"%s",__func__);
}
@end
