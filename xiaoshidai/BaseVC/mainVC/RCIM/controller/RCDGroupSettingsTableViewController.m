//
//  RCDGroupSettingsTableViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/3/22.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDGroupSettingsTableViewController.h"
#import "DefaultPortraitView.h"
#import "MBProgressHUD.h"
#import "RCDAddFriendViewController.h"
#import "ContactSelectedTableViewController.h"
#import "RCDConversationSettingTableViewHeaderItem.h"
#import "RCDGroupMembersTableViewController.h"
#import "RCDPersonDetailViewController.h"
#import "UIImageView+WebCache.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDUtilities.h"
#import "RCDGroupSettingsTableViewCell.h"
static NSString *CellIdentifier = @"RCDBaseSettingTableViewCell";

@interface RCDGroupSettingsTableViewController ()
//开始会话
@property(strong, nonatomic) UIButton *btChat;
//加入或退出群组
@property(strong, nonatomic) UIButton *btJoinOrQuitGroup;
//解散群组
@property(strong, nonatomic) UIButton *btDismissGroup;

@end

@implementation RCDGroupSettingsTableViewController {
  NSInteger numberOfSections;
  RCConversation *currentConversation;
  BOOL enableNotification;
  NSMutableArray *collectionViewResource;
  UICollectionView *headerView;
  NSString *groupId;
  NSString *creatorId;
  BOOL isCreator;
  UIImage *image;
  NSData *data;
  NSInteger numbers;
  MBProgressHUD *hud;

  NSMutableArray *groupMemberList;
    
}

+ (instancetype)groupSettingsTableViewController {
    return [[[self class] alloc]init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)initSubViews {
    
}

- (void)setGroup:(GroupInfo *)Group {
    _Group = Group;
    if (_Group) {
        groupId = _Group.groupId = _Group.group_id;
        if (creatorId == nil) {
            creatorId = _Group.creatorId;
            if ([creatorId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                isCreator = YES;
            }
        }
    }
}

-(void)fetchSingleGroupInfoWithDict:(NSDictionary *)param  completion:(void (^)(GroupInfo *))completion{
    hud = [MBProgressHUD showHUDAddedTo:Window  animated:YES];
    hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
    hud.labelText = @"数据获取中";
    [hud show:YES];
    [BaseRequest post:GROUPINFO parameters:param success:^(id dict) {
        if ([dict[@"code"] intValue]==0) {
            NSLog(@"获取当前群信息成功");
            hud.labelText = @"获取成功";
            [hud hide:YES afterDelay:0.5];
            GroupInfo *groupInfo = [[GroupInfo alloc] init];
            groupInfo.group_name = groupInfo.groupName = dict[@"data"][@"group_name"];
            groupInfo.group_id = groupInfo.groupId = self.targetId;
            groupInfo.usersStr =  dict[@"data"][@"users"];
            NSArray *arr = [groupInfo.usersStr componentsSeparatedByString:@","];
            if (![arr containsObject:[RCIM sharedRCIM].currentUserInfo.userId]) {
                hud.labelText = @"您已不在此群组";
                [hud hide:YES afterDelay:1.0];
                [[RCIMClient sharedRCIMClient] removeConversation:(ConversationType_GROUP) targetId:self.targetId];
                [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:self.targetId];
                UIViewController * VC = self.navigationController.childViewControllers[1];
                [self.navigationController popToViewController:VC animated:YES];
            }
            [[RCIM sharedRCIM]refreshGroupInfoCache:groupInfo withGroupId:groupInfo.groupId];
            completion(groupInfo);
            //groupInfo.groupId = groupInfo.group_id = model.da
            NSLog(@"同步完成");
        }else{
            [hud hide:YES afterDelay:1.0];
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
}
- (void)viewDidLoad {

  [super viewDidLoad];
    RCGroup *group =[[RCIM sharedRCIM] getGroupInfoCache:self.targetId];
    if ([XYString isBlankString:group.groupName]) {
        [Window makeToast:@"该群组已不存在" duration:1.0 position:CenterPoint];
        [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:self.targetId];
        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:self.targetId];
        UIViewController * VC = self.navigationController.childViewControllers[1];
        [self.navigationController popToViewController:VC animated:YES];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[BaseRequest setRSAencryptString:self.targetId] forKey:@"group_id"];
    NSArray *tokenArr = @[@{@"price":@"group_id",@"vaule":[NSString stringWithFormat:@"group_id%@",self.targetId]}];
    [param setObject:[BaseRequest setUserTokenStr:tokenArr] forKey:@"token"];
    [self fetchSingleGroupInfoWithDict:param completion:^(GroupInfo * groupInfo) {
        self.Group = groupInfo;
        [self initInfo];
    }];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.tableFooterView = [UIView new];
  self.tableView.backgroundColor = UIColorFromRGB(0xf0f0f6);
  self.tableView.separatorColor = UIColorFromRGB(0xdfdfdf);
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  numberOfSections = 0;

   // UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   // backBtn.frame = CGRectMake(0, 6, 87, 23);
  //  [backBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:(UIControlStateNormal)];
  //  [backBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
  //  [backBtn setTitle:@"" forState:(UIControlStateNormal)];
  //  UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
   // space.width = -15;
    //[backBtn addTarget:self action:@selector(backBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
   // [self.navigationItem setLeftBarButtonItem:leftButton];

    
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:) name:RCKitDispatchMessageNotification object:nil];

  CGRect tempRect = CGRectMake(
      0, 0, [UIScreen mainScreen].bounds.size.width,
      headerView.collectionViewLayout.collectionViewContentSize.height);
  UICollectionViewFlowLayout *flowLayout =
      [[UICollectionViewFlowLayout alloc] init];
  flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
  headerView = [[UICollectionView alloc] initWithFrame:tempRect
                                  collectionViewLayout:flowLayout];
  headerView.delegate = self;
  headerView.dataSource = self;
  headerView.scrollEnabled = NO;
  headerView.backgroundColor = [UIColor whiteColor];
  [headerView registerClass:[RCDConversationSettingTableViewHeaderItem class]
      forCellWithReuseIdentifier:@"RCDConversationSettingTableViewHeaderItem"];
  [headerView registerClass:[RCDConversationSettingTableViewHeaderItem class]
 forCellWithReuseIdentifier:@"RCDConversationSettingTableViewHeaderItemForSigns"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
-(void)initInfo{
    if (![XYString isBlankString:self.Group.usersStr]) {
        NSArray *arr = [self.Group.usersStr componentsSeparatedByString:@","];
        numbers = [arr count];
        groupMemberList = [NSMutableArray array];
        for (NSString *userId in arr) {
            UserInfo * userInfo = (UserInfo *)[[RCIM sharedRCIM] getUserInfoCache:userId];
            if (!userInfo) {
                UserInfo * userInfo1 = [[UserInfo alloc] init];
                userInfo1.name = userInfo1.display_name = userInfo1.user_name = @"错误";
                userInfo1.user_id = userInfo1.userId = @"错误";
                userInfo1.portraitUri = userInfo1.portrait_uri = @"";
                userInfo = userInfo1;
            }
            [groupMemberList addObject:userInfo];
        }
        if (collectionViewResource.count < 1) {
            [self startLoad];
        }
        if(numbers > 0 ){
            self.title = [NSString stringWithFormat:@"%@(%zd)",_Group.groupName,numbers];
        }else{
            self.title = @"群组信息";
        }
    }
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - 本类的私有方法
- (void)clickNotificationBtn:(id)sender {
  UISwitch *swch = sender;
  [[RCIMClient sharedRCIMClient]
      setConversationNotificationStatus:ConversationType_GROUP
      targetId:groupId
      isBlocked:swch.on
      success:^(RCConversationNotificationStatus nStatus) {
        NSLog(@"成功");

      }
      error:^(RCErrorCode status) {
        NSLog(@"失败");
      }];
}

- (void)clickIsTopBtn:(id)sender {
  UISwitch *swch = sender;
  [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_GROUP
                                             targetId:groupId
                                                isTop:swch.on];
}

- (void)backBarButtonItemClicked:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)startLoad {
  currentConversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_GROUP targetId:groupId];
  if (currentConversation.targetId == nil) {
    numberOfSections = 1;
    [self.tableView reloadData];
  } else {
    numberOfSections = 1;
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:groupId success:^(RCConversationNotificationStatus nStatus) {
          enableNotification = NO;
          if (nStatus == NOTIFY) {
            enableNotification = YES;
          }
          dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
          });
        }
        error:^(RCErrorCode status){

        }];
  }
    
  //NSMutableArray *groupMemberList = [[RCDataBaseManager shareInstance] getGroupMember:groupId];
 // groupMemberList = [self moveCreator:groupMemberList];
  //NSArray *resultList = [[RCDUserInfoManager shareInstance] getFriendInfoList:groupMemberList];
 // groupMemberList = [[NSMutableArray alloc] initWithArray:resultList];
    for (UserInfo *user in groupMemberList) {
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
  if ([groupMemberList count] > 0) {
    /******************添加headerview*******************/
    collectionViewResource = [NSMutableArray arrayWithArray:groupMemberList];
    [self setHeaderView];
  }
   // __weak typeof(self) weakSelf = self;
  //  [RCDHTTPTOOL getGroupMembersWithGroupId:groupId Block:^(NSMutableArray *result) {
     //  if ([result count] > 0) {
      //     dispatch_async(dispatch_get_main_queue(), ^{
         //      weakSelf.title = [NSString stringWithFormat:@"群组信息(%lu)",(unsigned long)result.count];
             //  RCDBaseSettingTableViewCell *cell =
             //  (RCDBaseSettingTableViewCell *)
             //  [self.tableView viewWithTag:RCDGroupSettingsTableViewCellGroupNameTag];
            //   cell.leftLabel.text = [NSString stringWithFormat:@"全部群成员(%lu)", (unsigned long)result.count];
          // });
        // collectionViewResource = [NSMutableArray new];
        // NSMutableArray *tempArray = result;
      //   tempArray = [self moveCreator:tempArray];
      //   NSArray *resultList = [[RCDUserInfoManager shareInstance] getFriendInfoList:tempArray];
       //  NSMutableArray *groupMemberList = [[NSMutableArray alloc] initWithArray:resultList];
       ////  collectionViewResource = [groupMemberList mutableCopy];
       //  [self setHeaderView];
       //  [[RCDataBaseManager shareInstance]
       //   insertGroupMemberToDB:result
       //   groupId:groupId
          //complete:^(BOOL results) {
      //
      //    }];
      //   for (RCDUserInfo *user in result) {
       ////    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
       //  }
      // }
    // }];

  
  /******************添加footerview*******************/
  UIView *view = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];

  //删除并退出按钮
  //UIImage *quitImage = [UIImage imageNamed:@"group_quit"];
  //UIImage *quitImageSelected = [UIImage imageNamed:@"group_quit_hover"];
  _btJoinOrQuitGroup = [[UIButton alloc] init];
  [_btJoinOrQuitGroup setBackgroundColor:[UIColor redColor]];
  [_btJoinOrQuitGroup setBackgroundColor:[UIColor redColor]];
  [_btJoinOrQuitGroup setTitle:@"退出群组" forState:UIControlStateNormal];
  [_btJoinOrQuitGroup setCenter:CGPointMake(view.bounds.size.width / 2,
                                            view.bounds.size.height / 2)];
  [_btJoinOrQuitGroup addTarget:self
                         action:@selector(btnJOQAction:)
               forControlEvents:UIControlEventTouchUpInside];
  _btJoinOrQuitGroup.layer.cornerRadius = 5.f;
  _btJoinOrQuitGroup.layer.borderWidth = 0.5f;
  _btJoinOrQuitGroup.layer.borderColor = [UIColorFromRGB(0xcc4445) CGColor];
  [view addSubview:_btJoinOrQuitGroup];

  //解散群组按钮
  _btDismissGroup = [[UIButton alloc] init];
  [_btDismissGroup setBackgroundColor:[UIColor redColor]];
  [_btDismissGroup setBackgroundColor:[UIColor redColor]];
  [_btDismissGroup setTitle:@"解散群组" forState:UIControlStateNormal];
  [_btDismissGroup setBackgroundColor:[UIColor redColor]];
  [_btDismissGroup setCenter:CGPointMake(view.bounds.size.width / 2,
                                         view.bounds.size.height / 2)];
  [_btDismissGroup addTarget:self
                      action:@selector(btnJOQAction:)
            forControlEvents:UIControlEventTouchUpInside];
  _btDismissGroup.layer.cornerRadius = 5.f;
 // [_btDismissGroup setHidden:YES];
  _btDismissGroup.layer.borderWidth = 0.5f;
  _btDismissGroup.layer.borderColor = [UIColorFromRGB(0xcc4445) CGColor];
  [view addSubview:_btDismissGroup];

  //自动布局
  [_btChat setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_btJoinOrQuitGroup setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_btDismissGroup setTranslatesAutoresizingMaskIntoConstraints:NO];

  NSDictionary *views = NSDictionaryOfVariableBindings(_btJoinOrQuitGroup, _btDismissGroup);

  if (isCreator == YES) {
    [_btDismissGroup setHidden:NO];
    [_btJoinOrQuitGroup setHidden:YES];
    [view
        addConstraints:[NSLayoutConstraint
                           constraintsWithVisualFormat:@"V:|-29-[_" @"btDismissGroup(42)]"
                                               options:0
                                               metrics:nil
                                                views:views]];
    
    [view addConstraints:[NSLayoutConstraint
                            constraintsWithVisualFormat:@"H:|-10-[_btDismissGroup]-10-|"
                                               options:0
                                               metrics:nil
                                               views:views]];
  } else {
    [view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-29-[_" @"btJoinOrQuitGroup(42)]"
                                               options:0
                                               metrics:nil
                                                 views:views]];
    [view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat: @"H:|-10-[_btJoinOrQuitGroup]-10-|"
                                              options:0
                                              metrics:nil
                                              views:views]];
      
    [view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-86-[_" @"btDismissGroup(42)]"
                                              options:0
                                              metrics:nil
                                              views:views]];
      
   [view addConstraints:[NSLayoutConstraint
                         constraintsWithVisualFormat:@"H:|-10-[_btDismissGroup]-10-|"
                                             options:0
                                             metrics:nil
                                             views:views]];
  }

  self.tableView.tableFooterView = view;
}

- (void)buttonChatAction:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnJOQAction:(UIButton *)sender {
    NSString *title = [NSString stringWithFormat:@"确定%@？",sender.titleLabel.text];
    NSString *message = NSLocalizedString(@"确认操作", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"否", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"是", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"%@",cancelButtonTitle);
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"%@",otherButtonTitle);
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        if ([sender.titleLabel.text isEqualToString:@"退出群组"]) {
            NSString * userId = [RCIM sharedRCIM].currentUserInfo.userId;
            [param setObject:[BaseRequest setRSAencryptString:userId] forKey:@"user_id"];
            [param setObject:[BaseRequest setRSAencryptString:self.targetId] forKey:@"group_id"];
            
            NSArray *tokenArr = @[@{@"price":@"group_id",@"vaule":[NSString stringWithFormat:@"group_id%@",self.targetId]},
                                  @{@"price":@"user_id",@"vaule":[NSString stringWithFormat:@"user_id%@",userId]}];
            [param setObject:[BaseRequest setUserTokenStr:tokenArr] forKey:@"token"];
            [self operationGroupWithDict:param UrlString:QUITGROUP];
        }else if ([sender.titleLabel.text isEqualToString:@"解散群组"]){
            [param setObject:[BaseRequest setRSAencryptString:self.targetId] forKey:@"group_id"];
            NSArray *tokenArr = @[@{@"price":@"group_id",@"vaule":[NSString stringWithFormat:@"group_id%@",self.targetId]}];
            [param setObject:[BaseRequest setUserTokenStr:tokenArr] forKey:@"token"];
            [self operationGroupWithDict:param UrlString:DISMISSGROUP];
        }
       
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)operationGroupWithDict:(NSDictionary *)param UrlString:(NSString *)url{
    hud = [MBProgressHUD showHUDAddedTo:Window  animated:YES];
    hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
    hud.labelText = @"数据获取中";
    [hud show:YES];
    [BaseRequest post:url parameters:param success:^(id dict) {
        if ([dict[@"code"] intValue]==0) {
            NSLog(@"操作群成功");
            hud.labelText = dict[@"data"];
            [hud hide:YES afterDelay:1.0];
            [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:groupId];
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:groupId];
            NSLog(@"%@",dict[@"data"]);
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [hud hide:YES afterDelay:1.0];
            NSString *msg = dict[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        
        }
    } failure:^(NSError * error) {
        hud.labelText = @"获取失败";
        [hud hide:YES afterDelay:1.0];
    }];

}
- (void)btnDismissAction:(id)sender {
  UIActionSheet *actionSheet =
      [[UIActionSheet alloc] initWithTitle:LocalizationNotNeeded(@"确定解散群组？")
                                  delegate:self
                         cancelButtonTitle:@"取消"
                    destructiveButtonTitle:@"确定"
                         otherButtonTitles:nil];

  [actionSheet showInView:self.view];
  actionSheet.tag = 102;
}

- (UIImage *)scaleImage:(UIImage *)Image toScale:(float)scaleSize {
  UIGraphicsBeginImageContext(
      CGSizeMake(Image.size.width * scaleSize, Image.size.height * scaleSize));
  [Image drawInRect:CGRectMake(0, 0, Image.size.width * scaleSize,
                               Image.size.height * scaleSize)];
  UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return scaledImage;
}

- (void)chosePortrait {
  UIActionSheet *actionSheet =
      [[UIActionSheet alloc] initWithTitle:nil
                                  delegate:self
                         cancelButtonTitle:@"取消"
                    destructiveButtonTitle:@"拍照"
                         otherButtonTitles:@"我的相册", nil];
  actionSheet.tag = 200;
  [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (actionSheet.tag == 200) {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;

    switch (buttonIndex) {
    case 0:
      if ([UIImagePickerController
              isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
      } else {
        NSLog(@"模拟器无法连接相机");
      }
      [self presentViewController:picker animated:YES completion:nil];
      break;

    case 1:
      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      [self presentViewController:picker animated:YES completion:nil];
      break;

    default:
      break;
    }
  }
}


- (void)clearCacheAlertMessage:(NSString *)msg {
  //UIAlertView *alertView =   [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
  //[alertView show];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (actionSheet.tag == 100) {
    if (buttonIndex == 0) {
      NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      RCDBaseSettingTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
      UIActivityIndicatorView *activityIndicatorView =
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
      float cellWidth = cell.bounds.size.width;
      UIView *loadingView = [[UIView alloc]initWithFrame:CGRectMake(cellWidth - 50, 10, 40, 40)];
      [loadingView addSubview:activityIndicatorView];
      dispatch_async(dispatch_get_main_queue(), ^{
        [activityIndicatorView startAnimating];
        [cell addSubview:loadingView];
      });
      
      [[RCIMClient sharedRCIMClient]deleteMessages:ConversationType_GROUP targetId:groupId success:^{
        [self performSelectorOnMainThread:@selector(clearCacheAlertMessage:)
                               withObject:@"清除聊天记录成功！"
                            waitUntilDone:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ClearHistoryMsg" object:nil];
         dispatch_async(dispatch_get_main_queue(), ^{
           [loadingView removeFromSuperview];
         });
        
      } error:^(RCErrorCode status) {
        [self performSelectorOnMainThread:@selector(clearCacheAlertMessage:)
                               withObject:@"清除聊天记录失败！"
                            waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
          [loadingView removeFromSuperview];
        });
      }];
      
    }
  }
  if (actionSheet.tag == 101) {
    if (buttonIndex == 0) {
      //判断如果当前群组已经解散，直接删除消息和会话，并跳转到会话列表页面。
     // if ([_Group.isDismiss isEqualToString:@"YES"]) {
      //  [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:groupId];
      //   [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:groupId];
        //[[RCDataBaseManager shareInstance] deleteGroupToDB:groupId];
      //  [self.navigationController popToRootViewControllerAnimated:YES];
       // return;
      }

      //[RCDHTTPTOOL quitGroupWithGroupId:groupId complete:^(BOOL isOk) {

                    //    dispatch_async(dispatch_get_main_queue(), ^{
                     //     if (isOk) {
                      //      [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:groupId];

                            //[[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:groupId];

                            //[[RCDataBaseManager shareInstance] deleteGroupToDB:groupId];
                          //  [self.navigationController popToRootViewControllerAnimated:YES];
                         // } else {
                         //   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"退出失败！"
                              //           delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            //[alertView show];
                         // }
                        //});
                     // }];
    //}
  //}

  if (actionSheet.tag == 102) {
    //if (buttonIndex == 0) {
      //[RCDHTTPTOOL
       //   dismissGroupWithGroupId:groupId
           //              complete:^(BOOL isOk) {

             //              dispatch_async(dispatch_get_main_queue(), ^{
               //              if (isOk) {
                 //              [[RCIMClient sharedRCIMClient]
                   //                clearMessages:ConversationType_GROUP
                     //                   targetId:groupId];
//
  //                             [[RCIMClient sharedRCIMClient]
    //                               removeConversation:ConversationType_GROUP
      //                                       targetId:groupId];
        //                       [[RCDataBaseManager shareInstance] deleteGroupToDB:groupId];
          //                     [self.navigationController
            //                     popToRootViewControllerAnimated:YES];
             //                } else {
             //                  UIAlertView *alertView = [[UIAlertView alloc]
               //                        initWithTitle:nil
                 //                            message:@"解散群组失败！"
                   //                         delegate:nil
                     //              cancelButtonTitle:@"确定"
                       //            otherButtonTitles:nil, nil];
                         //      [alertView show];
                           //  }
             //              });
               //          }];
    }
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (numberOfSections > 0) {
    return numberOfSections;
  }
  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  NSInteger rows = 0;
  switch (section) {
  case 0:
    rows = 1;
    break;

  case 1:
    rows = 3;
    break;

  case 2:
    rows = 1;
    break;
      
  case 3:
    rows = 3;
    break;
      
  default:
    break;
  }
  return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCDGroupSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
            cell = [[RCDGroupSettingsTableViewCell alloc]initWithIndexPath:indexPath andGroupInfo:_Group];
    }
    //设置switchbutton的开关状态
    if(indexPath.section == 3 && indexPath.row == 0){
        cell.switchButton.on = !enableNotification;
    }else if (indexPath.section ==3 && indexPath.row == 1){
        cell.switchButton.on = currentConversation.isTop;
    }
    cell.baseSettingTableViewDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return 0;
  }
  return 14.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44.f;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0:{
     // RCDGroupMembersTableViewController *GroupMembersVC =
     // [[RCDGroupMembersTableViewController alloc] init];
      //groupMemberList = [self moveCreator:groupMemberList];
     //GroupMembersVC.GroupMembers = groupMemberList;
     // [self.navigationController pushViewController:GroupMembersVC animated:YES];
    }break;
      
    case 1:{
      switch (indexPath.row) {
        case 0:
        {
          if (isCreator == YES) {
            [self chosePortrait];
          }
          else
          {
            [self showAlert:@"只有群主可以修改群组头像"];
          }
        }break;
         
        case 1:
        {
          
          if (isCreator == YES) {
              //如果是创建者，进入修改群名称页面
              //RCDEditGroupNameViewController *editGroupNameVC = [RCDEditGroupNameViewController editGroupNameViewController];
             // editGroupNameVC.groupInfo = _Group;
           // [self.navigationController pushViewController:editGroupNameVC animated:YES];
          }
          else
          {
            [self showAlert:@"只有群主可以修改群组名称"];
          }
        }break;
         
          case 2:
        {

          /*
          if (isCreator == YES) {
            RCDGroupAnnouncementViewController *vc = [[RCDGroupAnnouncementViewController alloc] init];
            vc.GroupId = _Group.groupId;
            [self.navigationController pushViewController:vc animated:YES];
          }
          else
          {
            [self showAlert:@"只有群主可以发布群公告"];
          }
           */
        }break;
          
        default:
          break;
      }
    }break;
    case 2:{
    
    }
      break;
      case 3:
    {
      switch (indexPath.row) {
        case 2:
        {
          UIActionSheet *actionSheet =
          [[UIActionSheet alloc] initWithTitle:@"确定清除聊天记录？"
                                      delegate:self
                             cancelButtonTitle:@"取消"
                        destructiveButtonTitle:@"确定"
                             otherButtonTitles:nil];
          
          [actionSheet showInView:self.view];
          actionSheet.tag = 100;
        }break;
          
        default:
          break;
      }
    }break;
      
    default:
      break;
  }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  float width = 55;
  float height = width + 15 + 9;

  return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;//12;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
  UICollectionViewFlowLayout *flowLayout =
      (UICollectionViewFlowLayout *)collectionViewLayout;
  flowLayout.minimumInteritemSpacing = 20;
  flowLayout.minimumLineSpacing = 12;
  return UIEdgeInsetsMake(15, 10, 10, 10);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [collectionViewResource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  RCDConversationSettingTableViewHeaderItem *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:
                          @"RCDConversationSettingTableViewHeaderItem"
                                                forIndexPath:indexPath];
    @try {
        if (collectionViewResource.count > 0) {
            if (indexPath.row == 0) {
               // collectionViewResource = [self moveCreator:collectionViewResource];
            }
            if (![collectionViewResource[indexPath.row] isKindOfClass:[UIImage class]]) {
                UserInfo *user = collectionViewResource[indexPath.row];
                if ([user.userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                    [cell.btnImg setHidden:YES];
                }
                [cell setUserModel:user];
            } else {
                RCDConversationSettingTableViewHeaderItem *cellForSigns = [collectionView dequeueReusableCellWithReuseIdentifier: @"RCDConversationSettingTableViewHeaderItemForSigns"forIndexPath:indexPath];
                UIImage *Image = collectionViewResource[indexPath.row];
                cellForSigns.ivAva.image = nil;
                cellForSigns.ivAva.image = Image;
                cellForSigns.titleLabel.text = @"";
                return cellForSigns;
            }
        }
        cell.ivAva.contentMode = UIViewContentModeScaleAspectFill;
    } @catch (NSException *exception) {
        [Window makeToast:exception.description duration:1.0 position:CenterPoint];
    } @finally {
        
    }

  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ContactSelectedTableViewController * contactSelectedVC= [[ContactSelectedTableViewController alloc]init];
  contactSelectedVC.groupId = _Group.groupId;
  contactSelectedVC.isAllowsMultipleSelection = YES;
  NSMutableArray *membersId = [NSMutableArray new];
  for (id user in collectionViewResource) {
    if ([user isKindOfClass:[RCUserInfo class]]) {
      NSString *userId = ((RCUserInfo*)user).userId;
      [membersId addObject:userId];
    }
  }
  //判断如果是创建者
  if (isCreator == NO) {
    //点加号
    if (indexPath.row == collectionViewResource.count - 2) {
      contactSelectedVC.titleStr = @"选择联系人";
      NSLog(@"点加号");
      contactSelectedVC.addGroupMembers = membersId;
      [self.navigationController pushViewController:contactSelectedVC animated:YES];
      return;
    }
    //点减号
    if (indexPath.row == collectionViewResource.count - 1) {
      if (collectionViewResource.count == 3) {
        return;
      }
      contactSelectedVC.titleStr = @"移除成员";
      NSLog(@"点加号");
      NSMutableArray *members = [NSMutableArray new];
      for (id user in collectionViewResource) {
        if ([user isKindOfClass:[RCUserInfo class]]) {
          if (![((RCUserInfo *)user).userId isEqualToString:creatorId]) {
            [members addObject:user];
          }
        }
      }
      contactSelectedVC.delGroupMembers = members;
      [self.navigationController pushViewController:contactSelectedVC
                                           animated:YES];
      return;
    }
  } else {
    if (indexPath.row == collectionViewResource.count - 1) {
      NSLog(@"点加号");
      contactSelectedVC.titleStr = @"选择联系人";
      contactSelectedVC.addGroupMembers = membersId;
      [self.navigationController pushViewController:contactSelectedVC
                                           animated:YES];
      return;
    }
  }
    UserInfo *selectedUser = [collectionViewResource objectAtIndex:indexPath.row];
    RCDPersonDetailViewController *detailViewController = [[RCDPersonDetailViewController alloc]init];
    detailViewController.userId = selectedUser.userId;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
  RCMessage *message = notification.object;
  if ([message.content isMemberOfClass:[RCGroupNotificationMessage class]]) {
    RCGroupNotificationMessage *groupNotification = (RCGroupNotificationMessage *)message.content;
    if ([groupNotification.operation isEqualToString:@"Dismiss"]) {
      return;
    } else if ([groupNotification.operation isEqualToString:@"Quit"] || [groupNotification.operation isEqualToString:@"Add"] || [groupNotification.operation isEqualToString:@"Kicked"]) {
     // [RCDHTTPTOOL getGroupMembersWithGroupId:message.targetId
                         //               Block:^(NSMutableArray *result) {
                               //           [[RCDataBaseManager shareInstance]
                                //           insertGroupMemberToDB:result
                                 ////          groupId:message.targetId
                                   //        complete:^(BOOL results) {
                                     //        dispatch_async(dispatch_get_main_queue(), ^{
                                      //         self.title = [NSString stringWithFormat:@"群组信息(%lu)",(unsigned long)result.count];
                                      //         [self refreshHeaderView];
                                        //       [self refreshTabelViewInfo];
                                       //      });
                                        //   }];
                                        //}];
    } else if ([groupNotification.operation isEqualToString:@"Rename"]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshTabelViewInfo];
      });

    }
  }
}


- (void)refreshTabelViewInfo {
 // [RCDHTTPTOOL getGroupByID:groupId
    //      successCompletion:^(RCDGroupInfo *group) {
     //       dispatch_async(dispatch_get_main_queue(), ^{
      //        _Group = group;
        //      [self.tableView reloadData];
        ///    });
       //   }];
}

- (void)refreshHeaderView {
    //NSMutableArray *groupMemberList = [NSMutableArray array];
    //[[RCDataBaseManager shareInstance] getGroupMember:groupId];
  collectionViewResource =   [[NSMutableArray alloc] initWithArray:groupMemberList];
  [self setHeaderView];
}

- (void)limitDisplayMemberCount {
  if (isCreator == YES && [collectionViewResource count] > 18) {
    NSRange rang = NSMakeRange(18, [collectionViewResource count] - 18);
    [collectionViewResource removeObjectsInRange:rang];
  } else if ([collectionViewResource count] > 19) {
    NSRange rang = NSMakeRange(19, [collectionViewResource count] - 19);
    [collectionViewResource removeObjectsInRange:rang];
  }
}

-(void)showAlert:(NSString *)alertContent
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:alertContent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
  [alert show];
}

//将创建者挪到第一的位置
-(NSMutableArray *) moveCreator:(NSMutableArray *)GroupMemberList
{
  if (GroupMemberList ==nil || GroupMemberList.count == 0) {
    return nil;
  }
  NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:GroupMemberList];
  int index = 0;
  RCUserInfo *creator;
  for (int i = 0; i < [temp count]; i++) {
    RCUserInfo *user = [temp objectAtIndex:i];
      if (![user isKindOfClass:[UIImage class]]) {
          if ([@"83" isEqualToString:user.userId]) {
              index = i;
              creator = user;
              break;
          }
      }
  }
  if (creator == nil) {
    return nil;
      }
  [temp insertObject:creator atIndex:0];
  [temp removeObjectAtIndex:index+1];
  return temp;
}

- (void)setHeaderView
{
  //[self limitDisplayMemberCount];
  UIImage *addImage = [UIImage imageNamed:@"myadd_members"];
  [collectionViewResource addObject:addImage];
  //判断如果是创建者，添加踢人按钮
  //if (isCreator == YES) {
    UIImage *delImage = [UIImage imageNamed:@"mydelete_members"];
    [collectionViewResource addObject:delImage];
  //}
  dispatch_async(dispatch_get_main_queue(), ^{
    [headerView reloadData];
    headerView.frame = CGRectMake(
                                  0, 0, [UIScreen mainScreen].bounds.size.width,
                                  headerView.collectionViewLayout.collectionViewContentSize.height);
    CGRect frame = headerView.frame;
    frame.size.height += 14;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    [self.tableView.tableHeaderView addSubview:headerView];
      
      UIView *separatorLine = [[UIView alloc]initWithFrame:CGRectMake(10, frame.size.height-1, frame.size.width-10, 1)];
      separatorLine.backgroundColor = [UIColor DisplayP3Red:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
      [self.tableView.tableHeaderView addSubview:separatorLine];
  });
}

#pragma mark - RCDBaseSettingTableViewCellDelegate
- (void)onClickSwitchButton:(id)sender {
    UISwitch *switchBtn = (UISwitch *)sender;
    //如果是“消息免打扰”的switch点击
    if(switchBtn.tag == SwitchButtonTag){
        [self clickNotificationBtn:sender];
    }else { //否则是“会话置顶”的switch点击
        [self clickIsTopBtn:sender];
    }
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
