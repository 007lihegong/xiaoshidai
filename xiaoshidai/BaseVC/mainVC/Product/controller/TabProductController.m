//
//  TabProductController.m
//  xiaoshidai
//
//  Created by XSD on 2017/2/9.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "TabProductController.h"
#import "TabProDetController.h"

#import "ItemCell.h"

#import "UITableView+FDTemplateLayoutCell.h"
@interface TabProductController ()<UITableViewDelegate,UITableViewDataSource>{
 AppDelegate *appdelegate;
}
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray * dataArray;
@property (nonatomic) NSArray *array;
@property (nonatomic) NSArray *titleArray;

@end

@implementation TabProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataArray];
    [self tableView];
    [self updateAPPVersion];
}
//检测版本更新
- (void)updateAPPVersion{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *mar = [app sharedHTTPSession];
    mar.responseSerializer = [AFHTTPResponseSerializer serializer];
    mar.requestSerializer.timeoutInterval = 30.f;
    NSString *urlString = @"https://itunes.apple.com/lookup?id=1147077824";
    [mar POST:urlString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = [dic objectForKey:@"results"];
        [self initRedCount];
        if (array.count) {
            NSDictionary *model = array[0];
            NSString *versionStr = [NSString stringWithFormat:@"%@",model[@"version"]];
            NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *ver = [versionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *cuver = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            if ([ver doubleValue] > [cuver doubleValue]) {
                [self alertWihtStr:versionStr];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
}
-(void)alertWihtStr:(NSString *)versionStr{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *currentVsersionStr = [NSString stringWithFormat:@"当前版本：V%@",version];
    NSString *message = [NSString stringWithFormat:@"系统检测到有新版本：V%@请立即升级",versionStr];
    NSString *title = NSLocalizedString(currentVsersionStr, nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"否", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"是", nil);
    //UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertAction
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"%@",cancelButtonTitle);
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"%@",otherButtonTitle);
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/xiao-shi-dai/id1147077824?mt=8"];
        [[UIApplication sharedApplication] openURL:url];
    }];
    //addAction
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    //present
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)initRedCount{
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        if (count > 0) {
            __weakSelf.tabBarItem.badgeValue =
            [[NSString alloc] initWithFormat:@"%d", count];
            //[__weakSelf.tabBarController.tabBar showBadgeOnItemIndex:0 badgeValue:count];
            UITabBarItem *item = __weakSelf.tabBarController.tabBar.items[3];
            [item setBadgeValue:[NSString stringWithFormat:@"%i",count]];
            
        } else {
            __weakSelf.tabBarItem.badgeValue = nil;
            //[__weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:0];
            UITabBarItem *item = __weakSelf.tabBarController.tabBar.items[3];
            [item setBadgeValue:nil];
        }
    });
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray * pledged1 = @[@"利息1分2；",@"全款房、按揭房再贷款；无需结清上笔贷款；",@"贷款额度高、利息低、申请简便、网评高、抵押率高达80%、见回执放款、还款方式灵活；"];
        NSArray * pledged2 = @[@"利息1分2；",@"全款房、按揭房再贷款；无需结清上笔贷款；",@"贷款额度高、利息低、申请简便、网评高、抵押率高达80%、见回执放款、还款方式灵活；"];
        NSArray * pledged3 = @[@"贷款利率低，可做成数高；"];
        _array = [NSArray arrayWithObjects:pledged1,pledged2,pledged3, nil];
        _titleArray = [NSArray arrayWithObjects:@"小时贷-一抵",@"小时贷-二抵",@"小时贷-按揭房", nil];
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        [_tableView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:nil] forCellReuseIdentifier:@"ItemCellID"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataArray.count) {
        return _dataArray.count;
    }else{
        return 3;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:nil options:nil] lastObject];;
    }
    [self configureCell:cell atIndexPath:indexPath];
    cell.nameLabel.text = _titleArray[indexPath.section];
    return cell;
}
- (void)configureCell:(ItemCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    cell.model = self.array[indexPath.section];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TabProDetController * detController = [[TabProDetController alloc] init];
    detController.title =_titleArray[indexPath.section];
    detController.flag = indexPath.section;
    [self.navigationController pushViewController:detController animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"ItemCellID" configuration:^(ItemCell * cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    return  height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
