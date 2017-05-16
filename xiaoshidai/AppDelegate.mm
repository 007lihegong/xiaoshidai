//
//  AppDelegate.m
//  xiaoshidai
//
//  Created by XSD on 16/9/20.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "AppDelegate.h"
#import "XYString.h"
#import "Defines.h"
#import "RootTabBarController.h"
#import "loginVC.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>
#import "AFNetworkReachabilityManager.h"
#import "BaseNavigationController.h"
#import "orderDetailVC.h"

#import "GroupInfoModel.h"
#import "UserInfoModel.h"

static NSString *UmengAppKey = @"5787451f67e58efe7d000151";
static NSString *JPushAppKey = @"5cf7c5fec27c084f534b8187";
static NSString *JPushChannel = @"Publish channel";
// static BOOL JPushIsProduction = NO;

static NSString * APPKEY = @"e35652a4e60c28deb6fdfaf440db732c";



#ifdef DEBUG
// 开发 极光FALSE为开发环境
static BOOL const JPushIsProduction = FALSE;
static NSString *cername = @"develop";
#else
// 生产 极光TRUE为生产环境
static BOOL const JPushIsProduction = TRUE;
static NSString *cername = @"dis";
#endif
//[objc] view plain copy 在CODE上查看代码片派生到我的代码片
#define BUGLY_APP_ID @"900033507"

@interface AppDelegate () <JPUSHRegisterDelegate,BuglyDelegate,RCIMUserInfoDataSource,RCIMGroupMemberDataSource,RCIMGroupInfoDataSource,RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate>{
    loginVC *_MVC;
}
@property (nonatomic) NSMutableArray *friends;
@property (nonatomic) NSMutableArray *groups;
@property (nonatomic, strong) NSString *order_nid;//订单号

@end

@implementation AppDelegate
-(NSMutableArray *)friends{
    if (!_friends) {
        _friends = [NSMutableArray array];
    }
    return _friends;
}
-(NSMutableArray *)groups{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}
-(void)initNav{
    //统一导航条样式
    UIFont *font = [UIFont systemFontOfSize:19.f];
    NSDictionary *textAttributes = @{ NSFontAttributeName : font,
                                      NSForegroundColorAttributeName : [UIColor whiteColor]                                      };
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:colorValue(0x3a424d, 1)];
    [[UINavigationBar appearance] setTranslucent:NO];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //本地登录返回的key
    [self initNav];
#pragma mark -- 判断是否第一次登陆进入不同的页面
    [self isloginFirst];
#pragma mark -- 极光
    [self registerJpushWithDict:launchOptions];
#pragma mark - 腾讯Bugly
    //腾讯bugly
    [self setupBugly];
#pragma mark - 融云IM
    [self imInit];
#pragma mark - Umeng统计
    [self umengMobClickInit];
    
    [self initIQkeyBoardAndNetStatus];
    return YES;
    
}
#pragma mark -- IMINIT
-(void)imInit{
    //cpj2xarlcspen

#if IS_CESHI
    [[RCIM sharedRCIM] initWithAppKey:@"6tnym1br65tv7"];//测式
#else
    [[RCIM sharedRCIM] initWithAppKey:@"cpj2xarlcspen"];//正试
#endif
    //测试token
    NSString * rcToken = [USER_DEFAULT objectForKey:@"rc_token"];
    if (rcToken) {
        if ([self.window.rootViewController isKindOfClass:[RootTabBarController class]]) {
            [self connectRCIMWithtoken:rcToken];
            //开启用户信息和群组信息的持久化
            [RCIM sharedRCIM].receiveMessageDelegate = self;
            [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
        }
    }else{
        
    }
}
#pragma mark -- 友盟统计
-(void)umengMobClickInit{
#if DEBUG
    [MobClick setLogEnabled:YES];
#else
    [MobClick setLogEnabled:NO];
#endif
    UMConfigInstance.appKey = UmengAppKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
}
#pragma mark -- 是否初次登陆
-(void)isloginFirst{
    NSString *userKey = [[NSUserDefaults standardUserDefaults] objectForKey:login_key];
    //判断是否第一次登陆
    if ([XYString isBlankString:userKey]) {
        _MVC = [[loginVC alloc] init];
        self.window.rootViewController = _MVC;
        [self.window makeKeyAndVisible];
    }else {
        
        RootTabBarController *root = [[RootTabBarController alloc] init];
        [self.window setBackgroundColor:[UIColor whiteColor]];
        self.window.rootViewController = root;
        [self.window makeKeyAndVisible];
    }
    //获取操作人和部门
    self.OperationStr = [[NSUserDefaults standardUserDefaults] objectForKey:login_Operation];
    NSLog(@"操作人＝%@",self.OperationStr);
}
#pragma mark -- 注册极光
-(void)registerJpushWithDict:(NSDictionary *)launchOptions{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) // iOS10
    {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = (UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound);
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        // categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPushAppKey
                          channel:JPushChannel
                 apsForProduction:JPushIsProduction];
    
    //NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    //NSLog(@"remoteNotification = %@",remoteNotification);
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // 2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            // iOS10获取registrationID放到这里了, 可以存到缓存里, 用来标识用户单独发送推送
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
}

#pragma mark -- 检测网络状态 & IQKeyboardManager初始化
-(void)initIQkeyBoardAndNetStatus{
    NSLog(@"...........................................");

    //初始化IQKeyboardManager
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = YES;
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.toolbarTintColor = GrayColor;
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"%@",documentsDirectory);
    // Preloads keyboard so there's no lag on initial keyboard appearance.
    // 解决键盘弹出延迟
    UITextField *lagFreeField = [[UITextField alloc] init];
   // [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
    
    AFNetworkReachabilityManager *mar = [AFNetworkReachabilityManager sharedManager];
    [mar setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //当网络状态发生变化时会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                _network = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机网络");
                _network = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                _network = NO;
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                _network = NO;
                break;
            default:
                break;
        }
    }];
    [mar startMonitoring];
}
#pragma mark -- IM初始化
-(void)RCIMLoginSuccessInit{
    //开启用户信息和群组信息的持久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupMemberDataSource:self];
    //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    //开启消息撤回功能
    [RCIM sharedRCIM].enableMessageRecall = YES;
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_RECTANGLE;
}
-(void)connectRCIMWithtoken:(NSString *)token{
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        //测试登陆成功。当前登录的用户ID： a17400649635af1cea9076a96cb4751a
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        [self RCIMLoginSuccessInit];//初始化
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[BaseRequest setUserTokenStr:nil] forKey:@"token"];
        [self fetchAddressBookWithDict:param];
        [param setObject:[BaseRequest setRSAencryptString:userId] forKey:@"user_id"];
        NSArray *tokenArr = @[@{@"price":@"user_id",@"vaule":[NSString stringWithFormat:@"user_id%@",userId]}];
        [param setObject:[BaseRequest setUserTokenStr:tokenArr] forKey:@"token"];
        [self fetchGroupInfoWithDict:param];
        
    } error:^(RCConnectErrorCode status) {
        //[Window makeToast:[NSString stringWithFormat:@"登陆的错误码为:%ld",(long)status] duration:1.0 position:CenterPoint];
        [self RCIMLoginSuccessInit];
        NSLog(@"***登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token错误");
       // [Window makeToast:[NSString stringWithFormat:@"token错误"] duration:1.0 position:CenterPoint];
    }];

}

-(void)fetchAddressBookWithDict:(NSDictionary *)param{
    [BaseRequest post:MyAddBook parameters:param success:^(id dict) {
        if ([dict[@"code"] intValue]==0) {
            NSLog(@"获取通讯录成功 并开始同步...");
            UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:dict];
            self.friends = [model.data mutableCopy];
            [USER_DEFAULT setObject:self.friends forKey:@"TelBook"];
            for (NSDictionary *dic in _friends) {
                UserInfo *obj = [UserInfo mj_objectWithKeyValues:dic];
                RCUserInfo * userInfo = [[RCUserInfo alloc] init];
                userInfo.userId = obj.userId = obj.user_id;
                userInfo.name = obj.name = obj.user_name;
                NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"userimg@3x" ofType:@"png"];
                [XYString isBlankString:obj.portrait_uri] == YES?userInfo.portraitUri = obj.portraitUri  = imagePath:userInfo.portraitUri = obj.portraitUri = obj.portrait_uri;
                [[RCIM sharedRCIM] refreshUserInfoCache:obj withUserId:obj.user_id];
            }
            NSLog(@"同步完成");
        }else{
            NSString *msg = dict[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError * error) {
        
    }];
}
- (void)getAllMembersOfGroup:(NSString *)groupId
                      result:(void (^)(NSArray<NSString *> *userIdList))resultBlock{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[BaseRequest setRSAencryptString:groupId] forKey:@"group_id"];
    NSArray *tokenArr = @[@{@"price":@"group_id",@"vaule":[NSString stringWithFormat:@"group_id%@",groupId]}];
    [param setObject:[BaseRequest setUserTokenStr:tokenArr] forKey:@"token"];
    [self fetchSingleGroupInfoWithDict:param completion:^(GroupInfo * groupInfo) {
        groupInfo.groupId = groupInfo.group_id = groupId;
        groupInfo.groupName = groupInfo.group_name;
        groupInfo.usersStr = groupInfo.usersStr;
        NSArray *array = [groupInfo.usersStr componentsSeparatedByString:@","];
        return resultBlock(array);
    }];
}
-(void)fetchGroupInfoWithDict:(NSDictionary *)param{
    [BaseRequest post:MYGROUP parameters:param success:^(id dict) {
        if ([dict[@"code"] intValue]==0) {
            NSLog(@"获取所属群信息成功 并开始同步...");
            GroupInfoModel *model = [GroupInfoModel mj_objectWithKeyValues:dict];
            self.groups = [model.data mutableCopy];
            for (NSInteger i = 0; i< _groups.count; i++) {
                NSDictionary *tempDict = [NSDictionary dictionaryWithDictionary: _groups[i]];
                [tempDict class];
                if ([XYString isDicNull:tempDict[@"group_id"]]||[XYString isDicNull:tempDict[@"group_name"]]) {
                     NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:@[@"错误群",@"错误群"] forKeys:@[@"group_id",@"group_name"]];
                    _groups[i] = dict1;
                }
            }
            [USER_DEFAULT setObject:self.groups forKey:@"GROUP"];
            for (NSDictionary *dic in _groups) {
                GroupInfo *obj = [GroupInfo mj_objectWithKeyValues:dic];
                RCGroup * groupInfo = [[RCGroup alloc] init];
                groupInfo.groupId = obj.groupId = obj.group_id;
                groupInfo.groupName = obj.groupName = obj.group_name;
                obj.usersStr = obj.usersStr;
                [[RCIM sharedRCIM] refreshGroupInfoCache:obj withGroupId:obj.group_id];
            }
            NSLog(@"同步完成");
        }else{
            NSString *msg = dict[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError * error) {
        
    }];
}
-(void)fetchSingleGroupInfoWithDict:(NSDictionary *)param  completion:(void (^)(GroupInfo *))completion{
    [BaseRequest post:GROUPINFO parameters:param success:^(id dict) {
        if ([dict[@"code"] intValue]==0) {
            NSLog(@"获取当前群信息成功");
            GroupInfo *groupInfo = [[GroupInfo alloc] init];
            groupInfo.group_name = groupInfo.groupName = dict[@"data"][@"group_name"];
            groupInfo.usersStr=  dict[@"data"][@"users"];
            [[RCIM sharedRCIM]refreshGroupInfoCache:groupInfo withGroupId:groupInfo.groupId];
            completion(groupInfo);
            //groupInfo.groupId = groupInfo.group_id = model.da
            NSLog(@"同步完成");
        }else{
            NSString *msg = dict[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    //每次启动会从服务器获取最新的通信录 并缓存到融云一份 存储到本地一份
    if ([[RCIM sharedRCIM] getUserInfoCache:userId]) {
        //融云的Cache
       return completion([[RCIM sharedRCIM] getUserInfoCache:userId]);
    }else{
       return completion(nil);
    }
    return completion(nil);
}
-(void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion{
    if ([[RCIM sharedRCIM] getGroupInfoCache:groupId]) {
        return completion([[RCIM sharedRCIM] getGroupInfoCache:groupId]);
    }else{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[BaseRequest setRSAencryptString:groupId] forKey:@"group_id"];
        NSArray *tokenArr = @[@{@"price":@"group_id",@"vaule":[NSString stringWithFormat:@"group_id%@",groupId]}];
        [param setObject:[BaseRequest setUserTokenStr:tokenArr] forKey:@"token"];
        [self fetchSingleGroupInfoWithDict:param completion:^(GroupInfo * groupInfo) {
            groupInfo.groupId = groupInfo.group_id = groupId;
            groupInfo.groupName = groupInfo.group_name;
            groupInfo.usersStr = groupInfo.usersStr;
            return completion(groupInfo);
        }];
    }
    NSLog(@"群组信息 -- %@",groupId);
    return completion(nil);
}
//同步个人群组信息
-(void)syncGroupWithUserID:(UserInfo *)userInfo{
    NSLog(@"当前用户RCID= %@",userInfo.userId);
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[BaseRequest setRSAencryptString:userInfo.userId] forKey:@"user_id"];
    NSArray *tokenArr = @[@{@"price":@"user_id",@"vaule":[NSString stringWithFormat:@"user_id%@",userInfo.userId]}];
    [param setObject:[BaseRequest setUserTokenStr:tokenArr] forKey:@"token"];
    [BaseRequest post:SYNCGROUP parameters:param success:^(id dict) {
        if ([dict[@"code"] intValue]==0) {
            NSLog(@"同步群组信息成功 %@",[dict mj_JSONString]);
        }else{
            NSString *msg = dict[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError * error) {
        
    }];

}
#pragma mark - RCIMConnectionStatusDelegate

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message: @"您的帐号在别的设备上登录，"
                                      @"您被迫下线！" preferredStyle:(UIAlertControllerStyleAlert)];
        NSString *cancleStr = @"知道了";
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancleStr style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancleAction];
        [Window.rootViewController presentViewController:alert animated:YES completion:nil];

    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
       // NSString * rcToken = [USER_DEFAULT objectForKey:@"rc_token"];
        //[self connectRCIMWithtoken:rcToken];
    }else if (status == ConnectionStatus_Connected){
    
    }
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    
    if ([message.content isMemberOfClass:[RCGroupNotificationMessage class]]) {
        RCGroupNotificationMessage *msg = (RCGroupNotificationMessage *)message.content;
//        && [msg.operatorUserId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]
        if ([msg.operation isEqualToString:@"Dismiss"] ) {
                [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP
                                                    targetId:message.targetId];
                [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP
                                                         targetId:message.targetId];
            } else if ([msg.operation isEqualToString:@"Quit"] ||
                       [msg.operation isEqualToString:@"Add"] ||
                       [msg.operation isEqualToString:@"Kicked"] ||
                       [msg.operation isEqualToString:@"Rename"]) {
                if ([msg.operation isEqualToString:@"Rename"]) {

                }else if([msg.operation isEqualToString:@"Kicked"]){
                    NSArray *arr = [msg.data mj_JSONObject][@"targetUserIds"];
                    if([arr containsObject:[RCIM sharedRCIM].currentUserInfo.userId
                        ]){
                        [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:message.targetId];
                        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:message.targetId];
                    }
                }

            }
    }
}

static AFHTTPSessionManager *manager ;
static AFURLSessionManager *urlsession ;

-(AFHTTPSessionManager *)sharedHTTPSession{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 10;
    });
    return manager;
}

-(AFURLSessionManager *)sharedURLSession{
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        urlsession = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return urlsession;
}
#pragma mark -- 收到通知的透传消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
  //  NSDictionary * userInfo = [notification userInfo];
    //NSString *haha = userInfo[@"content"];
   // NSString *kak = userInfo[@"content_type"];
   // NSLog(@"dict = %@ %@ %@",userInfo,haha,kak);
}
#pragma mark -- 注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required -    DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    NSString * registrationIDStr = [JPUSHService registrationID];
    self.JPushID = registrationIDStr;
    NSLog(@"RID=----%@",registrationIDStr);
}
#pragma mark -- 实现注册APNs失败接口(可选)
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error { //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark -- 接收
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // apn 内容获取：
    // 取得 APNs 标准信息内容
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到内容＝%@",userInfo);
}
#pragma mark -- iOS10以下版本
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"2-1 didReceiveRemoteNotification remoteNotification = %@", userInfo);
    // apn 内容获取：
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"2-2 didReceiveRemoteNotification remoteNotification = %@", userInfo);
    if ([userInfo isKindOfClass:[NSDictionary class]])
    {
//        NSDictionary *dict = userInfo[@"aps"];
//        NSString *content = dict[@"alert"];
//        NSLog(@"content = %@", content);
    }
    if (application.applicationState == UIApplicationStateActive)
    {
        // 程序当前正处于前台
        NSLog(@"程序处于前台");
    }
    else if (application.applicationState == UIApplicationStateInactive)
    { 
        // 程序处于后台
        NSLog(@"程序处于后台");
    } 
}
#pragma mark - iOS10: 收到推送消息调用(iOS10是通过Delegate实现的回调)
#pragma mark- JPUSHRegisterDelegate
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// 当程序在前台时, 收到推送弹出的通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"这是通知内容前台＝%@",userInfo);
    }
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
     completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
// 程序关闭后, 通过点击推送弹出的通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"这是通知内容后台＝%@",userInfo);
        if (userInfo[@"order_nid"]) {
            [self goToMssageViewControllerWith:userInfo];
        }
        
    }
    completionHandler(); // 系统要求执行这个方法
}

#endif
- (void)goToMssageViewControllerWith:(NSDictionary*)msgDic{
    
    self.window.backgroundColor = [UIColor whiteColor];
    if ([self.window.rootViewController isKindOfClass:[RootTabBarController class]]) {
        //将字段存入本地，在要跳转的页面用它来判断
        
        NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:@"push" forKey:@"push"];
        [pushJudge synchronize];
        orderDetailVC * VC = [[orderDetailVC alloc]init];
        VC.order_nid = msgDic[@"order_nid"];
        RootTabBarController *tabbar = (RootTabBarController *)self.window.rootViewController;
        [tabbar setSelectedIndex:1];
       // BaseNavigationController *vc = (BaseNavigationController *)tabbar.childViewControllers[2];
       // [vc pushViewController:VC animated:YES];
    }else{
      // _MVC.order_nid =  msgDic[@"order_nid"];
        return;
    }
   // [self.window.rootViewController.navigationController pushViewController:VC animated:YES];
    
}
// 绑定别名（注意：1 登录成功或者自动登录后；2 去除绑定-退出登录后）
+ (void)JPushTagsAndAliasInbackgroundTags:(NSSet *)set alias:(NSString *)name
{
    // 标签分组（表示没有值）
    NSSet *tags = set;
    // 用户别名（自定义值，nil是表示没有值）
    NSString *alias = name;
   // NSLog(@"tags = %@, alias = %@(registrationID = %@)", tags, alias, [self registrationID]);
    // tags、alias均无值时表示去除绑定
    [JPUSHService setTags:tags aliasInbackground:alias];
}

#pragma mark -- 腾讯bug统计
- (void)setupBugly {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#if DEBUG
    config.debugMode = YES;
#else
    config.debugMode = NO;
#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    config.consolelogEnable = NO; 
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    config.appTransportSecurityEnable = YES;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    // NOTE: This is only TEST code for BuglyLog , please UNCOMMENT it in your code.
    //[self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
}

/**
 *    @brief TEST method for BuglyLog
 */
- (void)testLogOnBackground {
    int cnt = 0;
    while (1) {
        cnt++;
        
        switch (cnt % 5) {
            case 0:
                BLYLogError(@"Test Log Print %d", cnt);
                break;
            case 4:
                BLYLogWarn(@"Test Log Print %d", cnt);
                break;
            case 3:
                BLYLogInfo(@"Test Log Print %d", cnt);
                BLYLogv(BuglyLogLevelWarn, @"BLLogv: Test", NULL);
                break;
            case 2:
                BLYLogDebug(@"Test Log Print %d", cnt);
                BLYLog(BuglyLogLevelError, @"BLLog : %@", @"Test BLLog");
                break;
            case 1:
            default:
                BLYLogVerbose(@"Test Log Print %d", cnt);
                break;
        }
        
        // print log interval 1 sec.
        sleep(1);
    }
}

#pragma mark - BuglyDelegate
- (NSString *)attachmentForException:(NSException *)exception {
    NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
    
    return @"This is an attachment";
}
// 接收到内存警告的时候调用
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 停止所有的下载
    [[SDWebImageManager sharedManager] cancelAll];
    // 删除缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    //[JPUSHService setBadge:0];
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
