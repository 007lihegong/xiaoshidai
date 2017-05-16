//
//  AddressBookController.m
//  
//
//  Created by XSD on 16/11/16.
//
//

#import "AddressBookController.h"
#import "UserInfoModel.h"
#import "BookCell.h"

#import "PersonalInfoController.h"

#import "RCDUtilities.h"
@interface AddressBookController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *addressBook;
@property (nonatomic) NSMutableArray *dataArray;
//@property (nonatomic, strong) NSMutableArray *usersArr;
@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) NSMutableDictionary *allFriendSectionDic;
@property (strong, nonatomic)  UISearchBar *searchView;
@end

@implementation AddressBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addressBook = [NSMutableArray array];
    _values = [NSMutableDictionary dictionary];
    _dataArray = [NSMutableArray array];
    //_usersArr = [NSMutableArray array];
    _allFriendSectionDic = [NSMutableDictionary dictionary];
    if ([USER_DEFAULT objectForKey:@"TelBook"]) {
        NSMutableArray * array = [USER_DEFAULT objectForKey:@"TelBook"];
        for (NSDictionary *dic in array) {
            UserInfo *obj = [UserInfo mj_objectWithKeyValues:dic];
            RCUserInfo * userInfo = [[RCUserInfo alloc] init];
            userInfo.userId = obj.userId = obj.user_id;
            userInfo.name = obj.name =  obj.user_name;
            userInfo.portraitUri = obj.portraitUri = obj.portrait_uri;
            [_addressBook addObject:obj];
            [_dataArray addObject:userInfo.name];
            //[_usersArr addObject:userInfo];
        }
    }
    self.navigationItem.title = StrFormatTh(@"组织机构(",@(_addressBook.count),@")");
    [self sortAndRefreshWithList:_addressBook];
    [self tableView];
}
- (void)sortAndRefreshWithList:(NSArray *)friendList {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.values = [RCDUtilities sortedArrayWithPinYinDic:friendList];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.allFriendSectionDic = self.values[@"infoDic"];
            [self.tableView reloadData];
        });
    });
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height -64) style:(UITableViewStylePlain)];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[BookCell class] forCellReuseIdentifier:@"cellID"];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexColor = MyBlueColor;
        //初始化搜索控制器
        _searchView = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
        _searchView.placeholder = LocalizationNotNeeded(@"搜索");
        [_searchView setBarTintColor:[UIColor colorWithWhite:0.863 alpha:1.000]];
        [_searchView setBarStyle:(UIBarStyleBlack)];
        [_searchView setTranslucent:YES];
        _searchView.delegate = self;
        [[[[_searchView.subviews objectAtIndex:0] subviews] objectAtIndex:0]removeFromSuperview];
        [ _searchView setBackgroundColor:[UIColor colorWithWhite:0.863 alpha:1.000]];
        _tableView.tableHeaderView = _searchView;

    }
    return _tableView;
}

#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    bgView.backgroundColor = RGBColor(242, 242, 242);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *key = self.values[@"allKeys"][section];
    titleLabel.text = key;
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.values[@"allKeys"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.values[@"allKeys"] count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count ;
    NSString *letter = self.values[@"allKeys"][section];
    count = [self.allFriendSectionDic[letter] count];
    return count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    }
    
    NSString *letter = self.values[@"allKeys"][indexPath.section];
    UserInfo *user = self.allFriendSectionDic[letter][indexPath.row];
    //UserInfo *user = [UserInfo mj_objectWithKeyValues:[_allFriendSectionDic objectForKey:_values[@"allKeys"][indexPath.section]]];
    cell.textLabel.text = user.display_name;
    cell.detailTextLabel.text = user.department_name;

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.portrait_uri] placeholderImage:IMGNAME(@"userimg")];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //UserInfo *user = _addressBook[indexPath.row];
    //NSLog(@"%@",[suer mj_JSONString]);
    NSString *letter = self.values[@"allKeys"][indexPath.section];
    UserInfo *user = self.allFriendSectionDic[letter][indexPath.row];
    PersonalInfoController *controller = [[PersonalInfoController alloc] init];
    controller.model = user;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - searchBar 代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"search : %@",searchBar.text);
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    NSLog(@"结束搜索");
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"cancel button click !!!");
    [searchBar endEditing:YES];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:LocalizationNotNeeded(@"取消")];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName:MyBlueColor,NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:(UIControlStateNormal)];
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0){
    NSMutableArray * array = [NSMutableArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", text];
    if (text.length <= 0) {
        array = [[NSMutableArray alloc] initWithArray:self.addressBook]; // 如果搜索框上的内容为空，显示全部
    } else {
        for (UserInfo *info  in _addressBook ){
            if([predicate evaluateWithObject:info.display_name]){
                [array addObject:info];
            }
        }
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.values = [RCDUtilities sortedArrayWithPinYinDic:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.allFriendSectionDic = self.values[@"infoDic"];
            [self.tableView reloadData];
        });
    });
    //[self.tableView reloadData];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
