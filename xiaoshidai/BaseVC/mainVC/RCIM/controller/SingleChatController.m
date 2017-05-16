//
//  SingleChatController.m
//  xiaoshidai
//
//  Created by XSD on 16/11/10.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "SingleChatController.h"
#import "UserInfoModel.h"
#import "RCDUIBarButtonItem.h"
#import "RCDPrivateSettingsTableViewController.h"
#import "RCDGroupSettingsTableViewController.h"
#import "GroupInfoModel.h"
@interface SingleChatController ()
@property(nonatomic, strong) GroupInfo *groupInfo;
@end

@implementation SingleChatController
- (instancetype)init
{
    if (self = [super init]) {
        //[RCIM sharedRCIM].userInfoDataSource = self;
        //[RCIM sharedRCIM].groupInfoDataSource = self;
    }
    return self;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.toolbarTintColor = GrayColor;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.enableAutoToolbar = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.enableAutoToolbar = NO;
    if (self.conversationType == ConversationType_GROUP) {
        GroupInfo *group = (GroupInfo *)[[RCIM sharedRCIM] getGroupInfoCache:self.targetId];
        if ([XYString isBlankString:group.groupName]) {
            [Window makeToast:@"该群组已不存在" duration:1.0 position:CenterPoint];
            [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:self.targetId];
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:self.targetId];
            return;
        }
    }else if (self.conversationType == ConversationType_PRIVATE){
        UserInfo *user = (UserInfo *)[[RCIM sharedRCIM] getUserInfoCache:self.targetId];
        if ([XYString isBlankString:user.name]) {
            [Window makeToast:@"用户已不存在" duration:1.0 position:CenterPoint];
            [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE targetId:self.targetId];
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:self.targetId];
            return;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self notifyUpdateUnreadMessageCount];
    //加号区域增加发送文件功能，Kit中已经默认实现了该功能，但是为了SDK向后兼容性，目前SDK默认不开启该入口，可以参考以下代码在加号区域中增加发送文件功能。
    UIImage *imageFile = [RCKitUtility imageNamed:@"actionbar_file_icon"
                                         ofBundle:@"RongCloud.bundle"];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:imageFile
                                                                   title:NSLocalizedStringFromTable(@"File", @"RongCloudKit", nil)
                                                                 atIndex:3
                                                                     tag:PLUGIN_BOARD_ITEM_FILE_TAG];
    if (self.conversationType == ConversationType_GROUP) {
        [self setRightNavigationItem:[UIImage imageNamed:@"icon2_menu"]
                           withFrame:CGRectMake(10, 3.5, 21, 19.5)];
    } else {
        [self setRightNavigationItem:[UIImage imageNamed:@"icon1_menu"]
                           withFrame:CGRectMake(10, 3.5, 21, 19.5)];
    }

}
- (void)setRightNavigationItem:(UIImage *)image withFrame:(CGRect)frame {
    RCDUIBarButtonItem *rightBtn = [[RCDUIBarButtonItem alloc]
                                    initContainImage:image
                                    imageViewFrame:frame
                                    buttonTitle:nil
                                    titleColor:nil
                                    titleFrame:CGRectZero
                                    buttonFrame:CGRectMake(0, 0, 25, 25)
                                    target:self
                                    action:@selector(rightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
- (void)rightBarButtonItemClicked:(id)sender {
    if (self.conversationType == ConversationType_PRIVATE) {
        RCDPrivateSettingsTableViewController *settingsVC = [RCDPrivateSettingsTableViewController privateSettingsTableViewController];
        settingsVC.userId = self.targetId;
        [self.navigationController pushViewController:settingsVC animated:YES];
        NSLog(@"个人信息设置");
    }//群组设置
    else if (self.conversationType == ConversationType_GROUP) {
        RCDGroupSettingsTableViewController *settingsVC = [[RCDGroupSettingsTableViewController alloc] init];
        settingsVC.targetId = self.targetId;
        [self.navigationController pushViewController:settingsVC animated:YES];
        NSLog(@"群组信息设置");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark override
- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
}

- (NSArray<UIMenuItem *> *)getLongTouchMessageCellMenuList:(RCMessageModel *)model {
    NSMutableArray<UIMenuItem *> *menuList = [[super getLongTouchMessageCellMenuList:model] mutableCopy];
    /*
     在这里添加删除菜单。
     [menuList enumerateObjectsUsingBlock:^(UIMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     if ([obj.title isEqualToString:@"删除"] || [obj.title isEqualToString:@"delete"]) {
     [menuList removeObjectAtIndex:idx];
     *stop = YES;
     }
     }];
     
     UIMenuItem *forwardItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(onForwardMessage:)];
     [menuList addObject:forwardItem];
     
     如果您不需要修改，不用重写此方法，或者直接return［super getLongTouchMessageCellMenuList:model]。
     */
    return menuList;
}
- (void)didTapCellPortrait:(NSString *)userId {
    if (self.conversationType == ConversationType_GROUP ||
        self.conversationType == ConversationType_DISCUSSION ||self.conversationType == ConversationType_CHATROOM) {
        if (![userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            [self getUserInfoWithUserId:userId completion:^(UserInfo *userInfo) {
                NSLog(@"%@",StrFormatTW(userInfo.display_name, userInfo.department_name));
            }];
        } else {
            [self getUserInfoWithUserId:userId completion:^(UserInfo *userInfo) {
                NSLog(@"%@",StrFormatTW(userInfo.display_name, userInfo.department_name));
            }];
        }
    }else if (self.conversationType == ConversationType_PRIVATE){
        [self getUserInfoWithUserId:userId completion:^(UserInfo *userInfo) {
            NSLog(@"%@",StrFormatTW(userInfo.display_name, userInfo.department_name));
        }];
    }

}

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(UserInfo *))completion{
    UserInfo *myselfInfo = (UserInfo *)[[RCIM sharedRCIM] getUserInfoCache:userId];
    completion(myselfInfo);
}
-(void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion{
    
}
/**
 *  更新左上角未读消息数
 */
- (void)notifyUpdateUnreadMessageCount {
    __weak typeof(&*self) __weakself = self;
    int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),
          @(ConversationType_DISCUSSION),
          @(ConversationType_APPSERVICE),
          @(ConversationType_PUBLICSERVICE),
          @(ConversationType_GROUP)]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *backString = nil;
        if (count > 0 && count < 1000) {
            backString = [NSString stringWithFormat:@"返回(%d)", count];
        } else if (count >= 1000) {
            backString = @"返回(...)";
        } else {
            backString = @"返回";
        }
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 6, 87, 23);
        [backBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:(UIControlStateNormal)];
        [backBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [backBtn setTitle:backString forState:(UIControlStateNormal)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
        space.width = -20;

        [backBtn addTarget:__weakself action:@selector(leftBarButtonItemPressed:)
          forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn ];
        [__weakself.navigationItem setLeftBarButtonItems:@[space,leftButton]];
    });
}
-(void)leftBarButtonItemPressed:(id)sender{
    [super leftBarButtonItemPressed:nil];
    if (_needPopToRootView == YES) {
        [self.tabBarController setSelectedIndex:3];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{

}
-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
