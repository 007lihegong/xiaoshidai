//
//  RCDAddFriendViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/4/16.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDAddFriendViewController.h"
#import "DefaultPortraitView.h"
#import "SingleChatController.h"
#import "UIImageView+WebCache.h"
#import "UserInfoModel.h"
@interface RCDAddFriendViewController ()

@end

@implementation RCDAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = UIColorFromRGB(0xf0f0f6);
    self.tableView.separatorColor =  UIColorFromRGB(0xdfdfdf);
    self.navigationItem.title = @"添加好友";
    
    [self setHeaderView];
    [self setFooterView];
}

- (void)setHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 86)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    self.ivAva = [[UIImageView alloc]init];
    if ([RCIM sharedRCIM].globalConversationAvatarStyle == RC_USER_AVATAR_CYCLE &&
        [RCIM sharedRCIM].globalMessageAvatarStyle == RC_USER_AVATAR_CYCLE) {
        self.ivAva.clipsToBounds = YES;
        self.ivAva.layer.cornerRadius = 30.f;
    } else {
        self.ivAva.clipsToBounds = YES;
        self.ivAva.layer.cornerRadius = 5.f;
    }
    if ([self.targetUserInfo.portraitUri isEqualToString:@""]) {
        DefaultPortraitView *defaultPortrait =
        [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [defaultPortrait setColorAndLabel:self.targetUserInfo.userId
                                 Nickname:self.targetUserInfo.name];
        UIImage *portrait = [defaultPortrait imageFromView];
        self.ivAva.image = portrait;
    } else {
        [self.ivAva
         sd_setImageWithURL:[NSURL URLWithString:self.targetUserInfo.portraitUri]
         placeholderImage:IMGNAME(@"userimg")];
    }
    [headerView addSubview:self.ivAva];
    self.ivAva.layer.masksToBounds = YES;
    self.ivAva.layer.cornerRadius = 5.f;
    self.ivAva.contentMode = UIViewContentModeScaleAspectFill;
    [_ivAva setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.lblName = [[UILabel alloc] init];
    self.lblName.text = self.targetUserInfo.name;
    [headerView addSubview:self.lblName];
    [_lblName setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_ivAva,_lblName);
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_ivAva(65)]"
                                                                       options:kNilOptions
                                                                       metrics:nil
                                                                         views:views]];
    
    [headerView
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"H:|-10-[_ivAva(65)]-8-[_lblName(184)]"
                     options:kNilOptions
                     metrics:nil
                     views:views]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_ivAva
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0f
                                                            constant:0]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_lblName
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0f
                                                            constant:0]];
    
}

- (void)setFooterView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 500)];
    self.startChat = [[UIButton alloc]initWithFrame:CGRectMake(10,30,self.view.bounds.size.width, 86)];
    [self.startChat setTitle:@"发起会话" forState:UIControlStateNormal];
    [self.startChat setTintColor:[UIColor blackColor]];
    [self.startChat setBackgroundColor:[UIColor colorWithHexString:@"0099ff" alpha:1.0]];
    self.startChat.layer.masksToBounds = YES;
    self.startChat.layer.cornerRadius = 5.f;
    
    [view addSubview:self.startChat];
    [self.startChat  setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.startChat addTarget:self
                       action:@selector(actionStartChat:)
             forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tableView.tableFooterView = view;
    

    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:_startChat
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0]];
        _startChat.hidden = NO;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)actionStartChat:(id)sender {
  SingleChatController *conversationVC = [[SingleChatController alloc] init];
  conversationVC.conversationType = ConversationType_PRIVATE;
  conversationVC.targetId = self.targetUserInfo.userId;
  conversationVC.title = self.targetUserInfo.name;
  conversationVC.displayUserNameInCell = NO;
  [self.navigationController pushViewController:conversationVC animated:YES];
}

@end
