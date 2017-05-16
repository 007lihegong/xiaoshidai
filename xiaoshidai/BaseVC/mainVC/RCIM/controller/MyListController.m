//
//  MyListController.m
//  xiaoshidai
//
//  Created by XSD on 16/11/10.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "MyListController.h"
#import "SingleChatController.h"
#import "ContactSelectedTableViewController.h"
@interface MyListController ()<UIPopoverPresentationControllerDelegate>{
    UIViewController *_contentController;
}

@end

@implementation MyListController
-(instancetype)init{
    self = [super init];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_CHATROOM),
                                            @(ConversationType_CUSTOMERSERVICE),
                                            @(ConversationType_SYSTEM)]];
       /// [self setCollectionConversationType:@[@(ConversationType_GROUP)]];
        self.navigationController.navigationBar.translucent = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.flag == 1) {
        
    }else{
        [self initRightBar];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receiveNeedRefreshNotification:)
     name:@"kRCNeedReloadDiscussionListNotification"
     object:nil];
    [self notifyUpdateUnreadMessageCount];
    RCUserInfo *groupNotify = [[RCUserInfo alloc] initWithUserId:@"__system__"
                                                            name:@""
                                                        portrait:nil];
    [[RCIM sharedRCIM] refreshUserInfoCache:groupNotify withUserId:@"__system__"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"kRCNeedReloadDiscussionListNotification"
     object:nil];
    
}
- (void)receiveNeedRefreshNotification:(NSNotification *)status {
    __weak typeof(&*self) __blockSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (__blockSelf.displayConversationTypeArray.count == 1 &&
            [self.displayConversationTypeArray[0] integerValue] ==
            ConversationType_DISCUSSION) {
            [__blockSelf refreshConversationTableViewIfNeeded];
        }
        
    });
}
-(void)initRightBar{
    if([[USER_DEFAULT objectForKey:Is_reg] isEqualToString:@"1"]){

    }else{
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(rightBarClick:)];
        self.navigationItem.rightBarButtonItem = item;
    }

    //[self.tabBarController.selectedViewController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%li",(long)self.conversationListDataSource.count]];
}
-(void)rightBarClick:(UIBarButtonItem *)item{
    [self shoPopFromBarItem:item];
}
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        MyListController *team = [[MyListController alloc] init];
        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [team setDisplayConversationTypes:array];
        [team setCollectionConversationType:nil];
        team.title = model.conversationTitle;
        team.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:team animated:YES ];
    }else if (model.conversationType == ConversationType_PRIVATE){
        SingleChatController *vc = [[SingleChatController alloc] init];
        vc.conversationType = model.conversationType;
        vc.targetId = model.targetId;
        vc.title = model.conversationTitle;
        vc.conversation = model;
        vc.unReadMessage = model.unreadMessageCount;

        [self.navigationController pushViewController:vc animated:YES];
    }else if (model.conversationType == ConversationType_GROUP){
        SingleChatController *vc = [[SingleChatController alloc] init];
        vc.conversationType = model.conversationType;
        vc.targetId = model.targetId;
        vc.title = model.conversationTitle;
        vc.unReadMessage = model.unreadMessageCount;
        vc.conversation = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    if (model.conversationType == ConversationType_PRIVATE) {
        RCConversationCell *ConversationCell = (RCConversationCell*) cell;
        ConversationCell.isShowNotificationNumber = YES;
        ConversationCell.conversationTitle.textColor = UIColorFromRGB(0x333333);
    }
}

-(void)moreItem:(UIBarButtonItem *)item{
    [self shoPopFromBarItem:item];
}
#pragma mark - <UIPopoverPresentationControllerDelegate>
// 如果要想在iPhone上也能弹出泡泡的样式必须要实现下面协议的方法
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
    // return UIModalPresentationFullScreen;
}
- (void)shoPopFromBarItem:(UIBarButtonItem *)item {
    _contentController = [[UIViewController alloc] init];
    _contentController.view.backgroundColor = [UIColor whiteColor];
    NSArray *arr = [NSArray arrayWithObjects:@" 发起单聊",@" 发起群聊", nil];
    NSArray *images = [NSArray arrayWithObjects:@"pop_chat",@"pop_group", nil];

    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton *button = [MyControl creatButtonWithFrame:CGRectMake(5, 35*i+10, 120, 35) target:self sel:@selector(click:) tag:1000+i image:nil title:arr[i]];
        UIImage *image = [UIImage imageNamed:images[i]];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 10);
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [button setImage:image forState:(UIControlStateNormal)];

        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [button setTitleColor:UIColorFromRGB(0x474747) forState:(UIControlStateNormal)] ;
        [_contentController.view addSubview:button];
    }

    _contentController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popController = _contentController.popoverPresentationController;
    _contentController.preferredContentSize = CGSizeMake(120, 80); // Here
    popController.barButtonItem = item;
    popController.delegate = self;
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:_contentController animated:YES completion:nil];
}

-(void)click:(UIButton *)button{
    NSLog(@"%@",button.titleLabel.text);
    if (button.tag == 1000) {
        [self dismissViewControllerAnimated:YES completion:nil];
        ContactSelectedTableViewController *contactSelectedVC = [[ContactSelectedTableViewController alloc]init];
        //contactSelectedVC.forCreatingDiscussionGroup = YES;
        contactSelectedVC.isAllowsMultipleSelection = NO;
        contactSelectedVC.titleStr = @"发起聊天";
        contactSelectedVC.flag = 2;
        [self.navigationController pushViewController:contactSelectedVC animated:YES];
        
    }else if (button.tag == 1001){
        [self dismissViewControllerAnimated:YES completion:nil];
        ContactSelectedTableViewController *contactSelectedVC = [[ContactSelectedTableViewController alloc]init];
        contactSelectedVC.forCreatingGroup = YES;
        contactSelectedVC.isAllowsMultipleSelection = YES;
        contactSelectedVC.titleStr = @"选择联系人";
        contactSelectedVC.flag = 1;
        [self.navigationController pushViewController:contactSelectedVC animated:YES];
    }else{

        [self dismissViewControllerAnimated:YES completion:nil];
        //[self.tabBarController setSelectedIndex:1];
#pragma mark - 可以先找到viewcontrollers 中你要跳转的 controller
        //self.hidesBottomBarWhenPushed = NO;

        //        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:3];
    }
}


#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification{
    //__weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    //RCMessage *message = notification.object;
    [super didReceiveMessageNotification:notification];
    [self notifyUpdateUnreadMessageCount];

}
- (void)notifyUpdateUnreadMessageCount {
    [self updateBadgeValueForTabBarItem];
}
- (void)updateBadgeValueForTabBarItem {
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient]
                     getUnreadCount:self.displayConversationTypeArray];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
