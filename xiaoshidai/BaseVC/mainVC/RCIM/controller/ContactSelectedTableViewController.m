//
//  RCDContactSelectedTableViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/3/17.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "ContactSelectedTableViewController.h"
#import "DefaultPortraitView.h"
#import "MBProgressHUD.h"
#import "SingleChatController.h"
#import "RCDContactSelectedTableViewCell.h"
#import "CreateGroupViewController.h"
//#import "RCDHttpTool.h"
//#import "RCDRCIMDataSource.h"
#import "GroupInfoModel.h"
//#import "RCDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import "pinyin.h"
#import "UserInfoModel.h"
//#import "UIColor+RCColor.h"
//#import "RCDUserInfoManager.h"
#import "RCDUtilities.h"
#import "RCDUIBarButtonItem.h"
#import "MyGroupListControllerViewController.h"

@interface ContactSelectedTableViewController ()<UISearchBarDelegate>{
    NSString * currentUserId;
    NSString * currentUserName;
}
@property(nonatomic, strong) NSMutableArray *friends;
@property(strong, nonatomic) NSMutableArray *friendsArr;
@property(nonatomic, strong) NSMutableArray *tempOtherArr;
@property (nonatomic, strong) RCDUIBarButtonItem *rightBtn;

@property(nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, strong) NSMutableArray *discussionGroupMemberIdList;

@property (strong, nonatomic)  UISearchBar *searchView;
@end

@implementation ContactSelectedTableViewController
MBProgressHUD *hud;
-(void)muGroupQuery:(UIButton *)sender{
    RCUserInfo *groupNotify = [[RCUserInfo alloc] initWithUserId:@"__system__" name:@"" portrait:nil];
    [[RCIM sharedRCIM] refreshUserInfoCache:groupNotify withUserId:@"__system__"];
    MyGroupListControllerViewController *team = [[MyGroupListControllerViewController alloc] init];
    team.title = @"我的群";
    [self.navigationController pushViewController:team animated:YES ];
    NSLog(@"%@",sender.titleLabel.text);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentUserId = [RCIM sharedRCIM].currentUserInfo.userId;
    UserInfo *info = (UserInfo *)[[RCIM sharedRCIM] getUserInfoCache:currentUserId];
    currentUserName = info.name;
    if (self.flag == 1 ) {
        UIButton *headButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [headButton setFrame:CGRectMake(0, 0, kScreen_Width, 70)];
        [headButton setTitle:@"我的群组" forState:(UIControlStateNormal)];
        headButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        headButton.titleEdgeInsets = UIEdgeInsetsMake(0, 52, 0, 0);
        headButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 52);

        [headButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [headButton setImage:IMGNAME(@"default_group_portrait") forState:(UIControlStateNormal)];
        [headButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [headButton addTarget:self action:@selector(muGroupQuery:) forControlEvents:(UIControlEventTouchUpInside)];
        self.tableView.tableHeaderView = headButton;
    }else if(self.flag == 2){
        //初始化搜索控制器
        _searchView = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
        _searchView.placeholder = LocalizationNotNeeded(@"搜索");
        [_searchView setBarTintColor:[UIColor colorWithWhite:0.863 alpha:1.000]];
        [_searchView setBarStyle:(UIBarStyleBlack)];
        [_searchView setTranslucent:YES];
        _searchView.delegate = self;
        [[[[_searchView.subviews objectAtIndex:0] subviews] objectAtIndex:0]removeFromSuperview];
        [ _searchView setBackgroundColor:[UIColor colorWithWhite:0.863 alpha:1.000]];
        self.tableView.tableHeaderView = _searchView;
    }
    
  _friendsArr = [[NSMutableArray alloc] init];
  self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
  self.navigationItem.title = _titleStr;
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

  //控制多选
  self.tableView.allowsMultipleSelection = YES;
  if (_isAllowsMultipleSelection == NO) {
    self.tableView.allowsMultipleSelection = NO;
  }

  self.tableView.tableFooterView = [UIView new];
  //自定义rightBarButtonItem
  self.rightBtn =   [[RCDUIBarButtonItem alloc] initWithbuttonTitle:@"确定"
                                       titleColor:[UIColor colorWithHexString:@"000000" alpha:1.0]
                                      buttonFrame:CGRectMake(0, 0, 90, 30)
                                           target:self
                                           action:@selector(clickedDone:)];
  self.rightBtn.button.titleLabel.font = [UIFont systemFontOfSize:16];
  [self.rightBtn.button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
  [self.rightBtn buttonIsCanClick:NO
                      buttonColor:[UIColor colorWithHexString:@"9fcdfd" alpha:1.0]
                    barButtonItem:self.rightBtn];
  self.navigationItem.rightBarButtonItems = [self.rightBtn
                                             setTranslation:self.rightBtn
                                             translation:-11];
  //当是讨论组加人的情况，先生成讨论组用户的ID列表
  if (_addDiscussionGroupMembers.count > 0) {
    self.discussionGroupMemberIdList = [NSMutableArray new];
    for (RCUserInfo *memberInfo in _addDiscussionGroupMembers) {
      [self.discussionGroupMemberIdList addObject:memberInfo.userId];
    }
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if ([_allFriends count] <= 0) {
    [self getAllData];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
    if (self.flag == 1) {
        [self.rightBtn buttonIsCanClick:YES
                            buttonColor:[UIColor whiteColor]
                          barButtonItem:self.rightBtn];
    }else if (self.flag == 2){
        [self.rightBtn buttonIsCanClick:NO
                            buttonColor:[UIColor colorWithHexString:@"9fcdfd" alpha:1.0]
                          barButtonItem:self.rightBtn];
    }

  [hud hide:YES];
}

// clicked done
- (void)clickedDone:(id)sender {
  [self.rightBtn buttonIsCanClick:NO buttonColor:[UIColor colorWithHexString:@"9fcdfd" alpha:1.0] barButtonItem:self.rightBtn];
  hud = [MBProgressHUD showHUDAddedTo:Window animated:YES];
  hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
  hud.labelText = @"请稍等";
  [hud show:YES];
  NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];

  // get seleted users
  NSMutableArray *seletedUsers = [NSMutableArray new];
  NSMutableArray *seletedUsersId = [NSMutableArray new];
  NSMutableArray *seletedUsersName = [NSMutableArray new];

  for (NSIndexPath *indexPath in indexPaths) {
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [self.allFriends objectForKey:key];
    UserInfo *user = arrayForKey[indexPath.row];
    RCUserInfo *userInfo = [RCUserInfo new];
    userInfo.userId = user.userId;
    userInfo.name = user.name;
    userInfo.portraitUri = user.portraitUri;
    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userInfo.userId];
    [seletedUsersId addObject:user.userId];
    [seletedUsersName addObject:user.name];
    [seletedUsers addObject:user];
  }
  if (_selectUserList) {
    NSArray<RCUserInfo *> *userList = [NSArray arrayWithArray:seletedUsers];
    _selectUserList(userList);
    return;
  }

  if (_addGroupMembers.count > 0) {
      //添加成员
      if (seletedUsersId.count >30) {
          hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
          hud.labelText = @"单次添加群成员不能超过30个";
          [hud hide:YES afterDelay:1.0];
      }else{
          NSLog(@"添加成员");
          @try {
              GroupInfo *group = (GroupInfo *)[[RCIM sharedRCIM] getGroupInfoCache:self.groupId];
              NSMutableDictionary *param = [NSMutableDictionary dictionary];
              NSString * usersStr = [seletedUsersId componentsJoinedByString:@","];
              [param setObject:[BaseRequest setRSAencryptString:self.groupId] forKey:@"group_id"];
              [param setObject:[BaseRequest setRSAencryptString:usersStr] forKey:@"user_id"];
              [param setObject:[BaseRequest setRSAencryptString:group.groupName] forKey:@"group_name"];
              
              NSArray *tokenArr = @[@{@"price":@"group_id",@"vaule":[NSString stringWithFormat:@"group_id%@",self.groupId]},
                                    @{@"price":@"user_id",@"vaule":[NSString stringWithFormat:@"user_id%@",usersStr]},
                                    @{@"price":@"group_name",@"vaule":[NSString stringWithFormat:@"group_name%@",group.groupName]}
                                    ];
              [param setObject :[BaseRequest setUserTokenStr:tokenArr] forKey:@"token"];
              [BaseRequest post:ADDMEMBER parameters:param success:^(id dict) {
                  if ([dict[@"code"] intValue]==0) {
                      NSLog(@"获取当前群信息成功");
                      hud.labelText = @"添加成功";
                      [hud hide:YES afterDelay:0.5];
                      GroupInfo *groupInfo = [[GroupInfo alloc] init];
                      groupInfo.group_name = groupInfo.groupName = group.groupName;
                      groupInfo.group_id = groupInfo.groupId = group.groupId;
                      groupInfo.usersStr =  [NSString stringWithFormat:@"%@,%@",[_addGroupMembers componentsJoinedByString:@","],usersStr];
                      [[RCIM sharedRCIM]refreshGroupInfoCache:groupInfo withGroupId:group.groupId];
                      NSLog(@"拉人入群之后同步完成");
                      @try {
                          UIViewController *controller = self.navigationController.childViewControllers[1];
//                          NSMutableDictionary * dataDict = [NSMutableDictionary dictionary];
//                          [dataDict setObject:currentUserName forKey:@"operatorNickname"];
//                          [dataDict setObject:seletedUsersId     forKey:@"targetUserIds"];
//                          [dataDict setObject:seletedUsersName    forKey:@"targetUserDisplayNames"];
//                          NSString * dataJsonString = [dataDict mj_JSONString];
//                          RCGroupNotificationMessage * message =  [RCGroupNotificationMessage notificationWithOperation:GroupNotificationMessage_GroupOperationAdd operatorUserId:currentUserId  data:dataJsonString message:@"解散" extra:@"132145"];
//                          
//                          [[RCIM sharedRCIM] sendMessage:(ConversationType_GROUP) targetId:self.groupId content:message pushContent:nil pushData:nil success:^(long messageId) {
//                              NSLog(@"messageId = %ld",messageId);
//                          } error:^(RCErrorCode nErrorCode, long messageId) {
//                              NSLog(@"messageId = %ld",messageId);
//
//                          }];
                          [self.navigationController popToViewController:controller animated:YES];
                      } @catch (NSException *exception) {
                          [Window makeToast:exception.description duration:1.0 position:CenterPoint];
                      } @finally {
                          
                      }
                  }else{
                      [hud hide:YES];
                      
                      [self.rightBtn buttonIsCanClick:YES buttonColor:[UIColor whiteColor] barButtonItem:self.rightBtn];
                      NSString *msg = dict[@"info"];
                      if (![XYString isBlankString:msg]) {
                          [LCProgressHUD showInfoMsg:msg];
                      }else {
                          [LCProgressHUD hide];
                      }
                  }
              } failure:^(NSError * error) {
                  hud.labelText = @"获取失败";
                  [hud hide:YES afterDelay:0.5];
              }];
              
          } @catch (NSException *exception) {
              
          } @finally {
              
          }
      }
    return;
  }
  if (_delGroupMembers.count > 0) {
    //删除成员
      if (seletedUsersId.count >30) {
          hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
          hud.labelText = @"单次移除群成员不能超过30个";
          [hud hide:YES afterDelay:1.0];
          [self.rightBtn buttonIsCanClick:YES buttonColor:[UIColor whiteColor] barButtonItem:self.rightBtn];
      }else{
          @try {
              GroupInfo *group = (GroupInfo *)[[RCIM sharedRCIM] getGroupInfoCache:self.groupId];
              NSMutableDictionary *param = [NSMutableDictionary dictionary];
              NSString * usersStr = [seletedUsersId componentsJoinedByString:@","];
              [param setObject:[BaseRequest setRSAencryptString:self.groupId] forKey:@"group_id"];
              [param setObject:[BaseRequest setRSAencryptString:usersStr] forKey:@"user_id"];
              [param setObject:[BaseRequest setRSAencryptString:group.groupName] forKey:@"group_name"];
              
              NSArray *tokenArr = @[@{@"price":@"group_id",@"vaule":[NSString stringWithFormat:@"group_id%@",self.groupId]},
                                    @{@"price":@"user_id",@"vaule":[NSString stringWithFormat:@"user_id%@",usersStr]},
                                    @{@"price":@"group_name",@"vaule":[NSString stringWithFormat:@"group_name%@",group.groupName]}
                                    ];
              [param setObject :[BaseRequest setUserTokenStr:tokenArr] forKey:@"token"];
              [BaseRequest post:DELMEMBER parameters:param success:^(id dict) {
                  if ([dict[@"code"] intValue]==0) {
                      NSLog(@"获取当前群信息成功");
                      hud.labelText = @"删除成功";
                      [hud hide:YES afterDelay:0.5];
                      GroupInfo *groupInfo = [[GroupInfo alloc] init];
                      groupInfo.group_name = groupInfo.groupName = group.groupName;
                      groupInfo.group_id = groupInfo.groupId = group.groupId;
                      [[RCIM sharedRCIM]refreshGroupInfoCache:groupInfo withGroupId:group.groupId];
                      NSLog(@"踢人出群之后同步完成");
                      UIViewController *controller = self.navigationController.childViewControllers[1];
                      [self.navigationController popToViewController:controller animated:YES];
                  }else{
                      [hud hide:YES];
                      [self.rightBtn buttonIsCanClick:YES buttonColor:[UIColor whiteColor] barButtonItem:self.rightBtn];
                      NSString *msg = dict[@"info"];
                      if (![XYString isBlankString:msg]) {
                          [LCProgressHUD showInfoMsg:msg];
                      }else {
                          [LCProgressHUD hide];
                      }
                  }
              } failure:^(NSError * error) {
                  hud.labelText = @"获取失败";
                  [hud hide:YES afterDelay:0.5];
              }];
              
          } @catch (NSException *exception) {
              
          } @finally {
              
          }
      }
      NSLog(@"删除成员");
      return;
  }
  if (_addDiscussionGroupMembers.count > 0) {
    if (_discussiongroupId.length > 0) {
      [[RCIMClient sharedRCIMClient] addMemberToDiscussion:_discussiongroupId
          userIdList:seletedUsersId
          success:^(RCDiscussion *discussion) {
            NSLog(@"成功");
            [[NSNotificationCenter defaultCenter]
                postNotificationName:@"addDiscussiongroupMember"
                              object:seletedUsers];
            dispatch_async(dispatch_get_main_queue(), ^{
              [self.navigationController popViewControllerAnimated:YES];
            });
          }
          error:^(RCErrorCode status){
              
          }];
      return;
    } else {
      NSMutableString *discussionTitle = [NSMutableString string];
      NSMutableArray *userIdList = [NSMutableArray new];
      RCUserInfo *member = _addDiscussionGroupMembers[0];
      [seletedUsers addObject:member];
      for (RCUserInfo *user in seletedUsers) {
        [discussionTitle
            appendString:[NSString stringWithFormat:@"%@%@", user.name, @","]];
        [userIdList addObject:user.userId];
      }
      [discussionTitle
          deleteCharactersInRange:NSMakeRange(discussionTitle.length - 1, 1)];

      [[RCIMClient sharedRCIMClient] createDiscussion:discussionTitle
          userIdList:userIdList
          success:^(RCDiscussion *discussion) {
            NSLog(@"create discussion ssucceed!");
            dispatch_async(dispatch_get_main_queue(), ^{
              SingleChatController *chat =
                  [[SingleChatController alloc] init];
              chat.targetId = discussion.discussionId;
              //chat.userName = discussion.discussionName;
              chat.conversationType = ConversationType_DISCUSSION;
              chat.title = @"讨论组";
              chat.needPopToRootView = YES;
              [self.navigationController pushViewController:chat animated:YES];
            });
          }
          error:^(RCErrorCode status) {
            NSLog(@"create discussion Failed > %ld!", (long)status);
          }];
      return;
    }
  }
  if (self.forCreatingGroup) {
      if (seletedUsersId.count <2) {
          hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
          hud.labelText = @"至少选择两个群成员";
          [hud hide:YES afterDelay:1.0];
          [self.rightBtn buttonIsCanClick:YES buttonColor:[UIColor whiteColor] barButtonItem:self.rightBtn];
      }else{
          CreateGroupViewController *createGroupVC = [CreateGroupViewController createGroupViewController];
          createGroupVC.GroupMemberIdList = seletedUsersId;
          createGroupVC.title = @"填写群名称";
          [self.navigationController pushViewController:createGroupVC animated:YES];
      }
      return;
  }
  //    if (self.forCreatingDiscussionGroup) {
  if (seletedUsers.count == 1) {
    RCUserInfo *user = seletedUsers[0];
    SingleChatController *chat = [[SingleChatController alloc] init];
    chat.targetId = user.userId;
    //chat.userName = user.name;
    chat.conversationType = ConversationType_PRIVATE;
    chat.title = user.name;
    chat.needPopToRootView = YES;
    chat.displayUserNameInCell = NO;

    //跳转到会话页面
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.navigationController pushViewController:chat animated:YES];
    });
    return;
  }
  if (self.forCreatingDiscussionGroup) {
    NSMutableString *discussionTitle = [NSMutableString string];
    NSMutableArray *userIdList = [NSMutableArray new];
    for (RCUserInfo *user in seletedUsers) {
      [discussionTitle appendString:[NSString stringWithFormat:@"%@%@", user.name,@","]];
      [userIdList addObject:user.userId];
    }
    [discussionTitle deleteCharactersInRange:NSMakeRange(discussionTitle.length - 1, 1)];
    
    [[RCIMClient sharedRCIMClient] createDiscussion:discussionTitle userIdList:userIdList success:^(RCDiscussion *discussion) {
      NSLog(@"create discussion ssucceed!");
      dispatch_async(dispatch_get_main_queue(), ^{
        SingleChatController *chat =[[SingleChatController alloc]init];
        chat.targetId                      = discussion.discussionId;
        //chat.userName                    = discussion.discussionName;
        chat.conversationType              = ConversationType_DISCUSSION;
        chat.title                         = @"讨论组";
        chat.needPopToRootView = YES;
        [self.navigationController pushViewController:chat animated:YES];
      });
    } error:^(RCErrorCode status) {
      NSLog(@"create discussion Failed > %ld!", (long)status);
    }];
    return;
  }
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [_allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  NSString *key = [_allKeys objectAtIndex:section];
  NSArray *arr = [_allFriends objectForKey:key];
  return [arr count];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RCDContactSelectedTableViewCell cellHeight];
}

// pinyin index
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  return _allKeys;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString *key = [_allKeys objectAtIndex:section];
  return key;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellReuseIdentifier = @"RCDContactSelectedTableViewCell";
    
  RCDContactSelectedTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if(!cell){
        cell = [[RCDContactSelectedTableViewCell alloc]init];
    }

  [cell setUserInteractionEnabled:YES];
  [cell.nicknameLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
  NSString *key = [self.allKeys objectAtIndex:indexPath.section];
  NSArray *arrayForKey = [self.allFriends objectForKey:key];

  UserInfo *user = arrayForKey[indexPath.row];
  //给控件填充数据
  [cell setModel:user];
  
  //设置选中状态
  for (RCUserInfo *userInfo in self.seletedUsers) {
    if ([user.userId isEqualToString:userInfo.userId]) {
      [tableView selectRowAtIndexPath:indexPath
                             animated:NO
                       scrollPosition:UITableViewScrollPositionBottom];
      [cell setUserInteractionEnabled:NO];
    }
  }
  
    if(_isHideSelectedIcon){
        cell.selectedImageView .hidden = YES;
    }
    if ([self isContain:user.userId] == YES ) {
      dispatch_async(dispatch_get_main_queue(), ^{
        cell.selectedImageView.image = [UIImage imageNamed:@"nav_icon_selet_noclik"];
      });
      cell.userInteractionEnabled = NO;
    }
    if ([user.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.selectedImageView.image = [UIImage imageNamed:@"nav_icon_selet_noclik"];
        });
        cell.userInteractionEnabled = NO;
    }
  return cell;
}
// override delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.flag == 2){
        NSString *key = [self.allKeys objectAtIndex:indexPath.section];
        NSArray *arrayForKey = [self.allFriends objectForKey:key];
        UserInfo *user = arrayForKey[indexPath.row];
        SingleChatController *chat = [[SingleChatController alloc] init];
        chat.targetId = user.userId;
        //chat.userName = user.name;
        chat.conversationType = ConversationType_PRIVATE;
        chat.title = user.name;
        chat.needPopToRootView = YES;
        chat.displayUserNameInCell = NO;
        //跳转到会话页面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:chat animated:YES];
        });
        return;
    }
    [self.rightBtn buttonIsCanClick:YES buttonColor:[UIColor whiteColor] barButtonItem:self.rightBtn];
    RCDContactSelectedTableViewCell *cell = (RCDContactSelectedTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
    //  if (self.selectIndexPath && self.selectIndexPath.row == indexPath.row) {
    if(self.selectIndexPath && [self.selectIndexPath compare:indexPath]==NSOrderedSame){
        [cell setSelected:NO];
        [self.rightBtn buttonIsCanClick:NO buttonColor:[UIColor colorWithHexString:@"9fcdfd" alpha:1.0] barButtonItem:self.rightBtn];
        self.selectIndexPath = nil;
    } else {
        self.selectIndexPath = indexPath;
    }
    if (_selectUserList && self.isHideSelectedIcon) {
        NSMutableArray *seletedUsers = [NSMutableArray new];
        NSString *key = [self.allKeys objectAtIndex:indexPath.section];
        NSArray *arrayForKey = [self.allFriends objectForKey:key];
        UserInfo *user = arrayForKey[indexPath.row];
        //转成RCDUserInfo
        RCUserInfo *userInfo = [RCUserInfo new];
        userInfo.userId = user.userId;
        userInfo.name = user.name;
        userInfo.portraitUri = user.portraitUri;
        [[RCIM sharedRCIM] refreshUserInfoCache:userInfo
                                     withUserId:userInfo.userId];
        [seletedUsers addObject:userInfo];
        
        NSArray<RCUserInfo *> *userList = [NSArray arrayWithArray:seletedUsers];
        _selectUserList(userList);
        return;
    }
    
    if(self.isAllowsMultipleSelection){
        NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
        NSString *titleStr = [NSString stringWithFormat:@"确定(%zd)",[indexPaths count]];
        titleStr = [indexPaths count] == 0 ? titleStr = @"确定":titleStr;
        [self.rightBtn.button setTitle:titleStr forState:UIControlStateNormal];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

    RCDContactSelectedTableViewCell *cell = (RCDContactSelectedTableViewCell *)[tableView
                                                                                cellForRowAtIndexPath:indexPath];
    if ([tableView.indexPathsForSelectedRows count] == 0) {
        [self.rightBtn buttonIsCanClick:NO
                            buttonColor:[UIColor colorWithHexString:@"9fcdfd" alpha:1.0]
                          barButtonItem:self.rightBtn];
    }
    [cell setSelected:NO];
    
    self.selectIndexPath = nil;
    if(self.isAllowsMultipleSelection){
        NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
        NSString *titleStr = [NSString stringWithFormat:@"确定(%zd)",[indexPaths count]];
        titleStr = [indexPaths count] == 0 ? titleStr = @"确定":titleStr;
        [self.rightBtn.button setTitle:titleStr forState:UIControlStateNormal];
    }
}

#pragma mark - 获取好友并且排序
/**
 *  initial data
 */
- (void)getAllData {
 
    _allFriends = [NSMutableDictionary new];
    _allKeys = [NSMutableArray new];
    _friends = [NSMutableArray array];
    if ([USER_DEFAULT objectForKey:@"TelBook"]) {
        NSMutableArray * array = [USER_DEFAULT objectForKey:@"TelBook"];
        for (NSDictionary *dic in array) {
            UserInfo *obj = [UserInfo mj_objectWithKeyValues:dic];
            RCUserInfo * userInfo = [[RCUserInfo alloc] init];
            userInfo.userId = obj.userId = obj.user_id;
            userInfo.name = obj.name =  obj.user_name;
            userInfo.portraitUri = obj.portraitUri = obj.portrait_uri;
            [_friends addObject:obj];
        }
    }
    
  if (_friends == nil || _friends.count < 1) {
       [self dealWithFriendList];
  } else {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      [self dealWithFriendList];
    });
  }
}
-(void)dealWithFriendList{
  
  for (int i = 0; i < _friends.count; i++) {
      UserInfo *user = _friends[i];
      UserInfo *friend = (UserInfo *)[[RCIM sharedRCIM] getUserInfoCache:user.user_id];
      if (friend) {
          [_friendsArr addObject:friend];
      }
  }
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [self deleteGroupMembers];
    NSMutableDictionary *resultDic = [RCDUtilities sortedArrayWithPinYinDic:_friendsArr];
    dispatch_async(dispatch_get_main_queue(), ^{
      _allFriends = resultDic[@"infoDic"];
      _allKeys = resultDic[@"allKeys"];
      [self.tableView reloadData];
    });
  });
}

- (void)deleteGroupMembers {
  if (_delGroupMembers.count > 0) {
    _friendsArr = _delGroupMembers;
  }
}

- (BOOL)isContain:(NSString*)userId {
  BOOL contain = NO;
  NSArray *userList;
  if (_addGroupMembers.count > 0) {
    userList = _addGroupMembers;
  }
  if (_addDiscussionGroupMembers.count > 0) {
    userList = self.discussionGroupMemberIdList;
  }
  for (NSString *memberId in userList) {
    if ([userId isEqualToString:memberId]) {
      contain = YES;
      break;
    }
  }
  return contain;
}

#pragma mark - searchBar 代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"search : %@",searchBar.text);
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
   // NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
   // NSLog(@"count = %zd",indexPaths.count);
    NSMutableArray * array = [NSMutableArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    if (searchText.length <= 0) {
        array = [[NSMutableArray alloc] initWithArray:_friends]; // 如果搜索框上的内容为空，显示全部
    } else {
        for (UserInfo *info  in _friends ){
            if([predicate evaluateWithObject:info.display_name]){
                [array addObject:info];
            }
        }
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *resultDic = [RCDUtilities sortedArrayWithPinYinDic:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            _allFriends = resultDic[@"infoDic"];
            _allKeys = resultDic[@"allKeys"];
            [self.tableView reloadData];
        });
    });
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *resultDic = [RCDUtilities sortedArrayWithPinYinDic:_friends];
        dispatch_async(dispatch_get_main_queue(), ^{
            _allFriends = resultDic[@"infoDic"];
            _allKeys = resultDic[@"allKeys"];
            [self.tableView reloadData];
        });
    });
    [searchBar setShowsCancelButton:NO animated:YES];
    NSLog(@"结束搜索");
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"cancel button click !!!");
    [searchBar setText:@""];
    [searchBar endEditing:YES];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:LocalizationNotNeeded(@"取消")];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName:MyBlueColor,NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:(UIControlStateNormal)];
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0){

    return YES;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
