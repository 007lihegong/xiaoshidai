//
//  RCDPersonDetailViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/4/9.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDPersonDetailViewController.h"
#import "DefaultPortraitView.h"
#import "MBProgressHUD.h"
#import "SingleChatController.h"
#import "UIImageView+WebCache.h"
//#import <RongCallKit/RongCallKit.h>
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RCUserInfo.h>
#import "UserInfoModel.h"
@interface RCDPersonDetailViewController () <UIActionSheetDelegate>
@property(nonatomic) BOOL inBlackList;
@property(nonatomic, strong) NSDictionary *subViews;
@property(nonatomic, strong) UserInfo *friendInfo;
@property(nonatomic, strong) NSArray *constraintNameLabel;
@property(nonatomic, strong) NSArray *constraintdisplayNameLabel;
@property(nonatomic, strong) UILabel *displayNameLabel;
@property(nonatomic, strong) UILabel *phoneNumber;
@property(nonatomic, strong) UILabel *onlineStatusLabel;
@end

@implementation RCDPersonDetailViewController

- (void)viewDidLoad {
    

    
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self setNavigationButtons];
  self.view.backgroundColor = [UIColor colorWithHexString:@"f0f0f6" alpha:1.f];
  
  self.infoView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 85)];
  self.infoView = [[UIView alloc]init];
  self.infoView.backgroundColor = [UIColor whiteColor];
  self.infoView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.infoView];
  
  self.ivAva = [[UIImageView alloc]init];
  self.ivAva.translatesAutoresizingMaskIntoConstraints = NO;
  [self.infoView addSubview:self.ivAva];
  
  self.lblName = [[UILabel alloc]init];
  self.lblName.translatesAutoresizingMaskIntoConstraints = NO;
  [self.infoView addSubview:self.lblName];
  
  self.phoneNumber = [[UILabel alloc]init];
  self.phoneNumber.translatesAutoresizingMaskIntoConstraints = NO;
  [self.infoView addSubview:self.phoneNumber];
  
  self.onlineStatusLabel = [[UILabel alloc] init];
  self.onlineStatusLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [self.infoView addSubview:self.onlineStatusLabel];
  self.onlineStatusLabel.hidden = YES;
  self.onlineStatusLabel.font = [UIFont systemFontOfSize:12.f];
  
  self.bottomLine = [[UIView alloc]init];
  self.bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.bottomLine];
  
  
  self.conversationBtn = [[UIButton alloc]init];
  self.conversationBtn.backgroundColor = [UIColor colorWithHexString:@"0099ff" alpha:1.f];
  self.conversationBtn.translatesAutoresizingMaskIntoConstraints = NO;
  [self.conversationBtn setTitle:@"发起会话" forState:UIControlStateNormal];
  [self.conversationBtn addTarget:self
                           action:@selector(btnConversation:)
                 forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.conversationBtn];
  
  self.audioCallBtn = [[UIButton alloc]init];
  self.audioCallBtn.backgroundColor = [UIColor whiteColor];
  [self.audioCallBtn setTitle:@"语音通话" forState:UIControlStateNormal];
  //    [self.audioCallBtn setTintColor:[UIColor blackColor]];
  [self.audioCallBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.audioCallBtn addTarget:self
                        action:@selector(btnVoIP:)
              forControlEvents:UIControlEventTouchUpInside];
  self.audioCallBtn.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.audioCallBtn];
  
  self.videoCallBtn = [[UIButton alloc]init];
  self.videoCallBtn.backgroundColor = [UIColor whiteColor];
  [self.videoCallBtn setTitle:@"视频通话" forState:UIControlStateNormal];
  [self.videoCallBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.videoCallBtn addTarget:self
                        action:@selector(btnVideoCall:)
              forControlEvents:UIControlEventTouchUpInside];
  self.videoCallBtn.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.videoCallBtn];
  //*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-隐藏这俩傻逼按钮-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*//
  self.videoCallBtn.hidden = YES;
  self.audioCallBtn.hidden = YES;
    
  self.subViews = NSDictionaryOfVariableBindings(_ivAva,_lblName,_onlineStatusLabel);
  [self setLayout];
  
  NSString *portraitUri;
  //if (![self.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
      
    self.friendInfo = (UserInfo *)[[RCIM sharedRCIM] getUserInfoCache:self.userId];
    portraitUri = self.friendInfo.portraitUri;
    [self setLayoutForFriend];
    NSString *remarks = self.friendInfo.display_name;
    self.displayNameLabel = [[UILabel alloc] init];
    if (remarks != nil && ![remarks isEqualToString:@""]) {
      [self setLayoutIsHaveRemarks:YES];
    } else {
      [self setLayoutIsHaveRemarks:NO];
    }
  //} //else {
     //UserInfo *userinfo = (UserInfo *)[[RCIM sharedRCIM] getUserInfoCache:[RCIM sharedRCIM].currentUserInfo.userId];
    //portraitUri = userinfo.portrait_uri;
    //[self setLayoutForSelf];
      //[self setLayoutForFriend];
  //}
  if ([RCIM sharedRCIM].globalConversationAvatarStyle == RC_USER_AVATAR_CYCLE && [RCIM sharedRCIM].globalMessageAvatarStyle == RC_USER_AVATAR_CYCLE) {
    self.ivAva.clipsToBounds = YES;
    self.ivAva.layer.cornerRadius = 30.f;
  } else {
    self.ivAva.clipsToBounds = YES;
    self.ivAva.layer.cornerRadius = 5.f;
  }
  if (portraitUri.length == 0) {
    DefaultPortraitView *defaultPortrait = [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [defaultPortrait setColorAndLabel:self.friendInfo.userId
                             Nickname:self.friendInfo.name];
    UIImage *portrait = [defaultPortrait imageFromView];
    self.ivAva.image = portrait;
  } else {
    [self.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:IMGNAME(@"userimg")];
  }
  
  self.conversationBtn.layer.masksToBounds = YES;
  self.conversationBtn.layer.cornerRadius = 5.f;
  self.conversationBtn.layer.borderWidth = 0.5;
  self.conversationBtn.layer.borderColor = [UIColorFromRGB(0x0181dd) CGColor];
  
  self.audioCallBtn.layer.masksToBounds = YES;
  self.audioCallBtn.layer.cornerRadius = 5.f;
  
  self.videoCallBtn.layer.masksToBounds = YES;
  self.videoCallBtn.layer.cornerRadius = 5.f;
}

- (void)setNavigationButtons
{
  
 // UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
 // backBtn.frame = CGRectMake(0, 6, 87, 23);
  //UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"]];
 // backImg.frame = CGRectMake(0, 0, 30, 0);
  //[backBtn addSubview:backImg];
  //UILabel *backText =
  ////[[UILabel alloc] initWithFrame:CGRectMake(9,4, 85, 17)];
 // backText.text = @"";
  //[backText setBackgroundColor:[UIColor clearColor]];
  //[backText setTextColor:[UIColor whiteColor]];
 // [backBtn addSubview:backText];
  //[backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
  //UIBarButtonItem *leftButton =   [[UIBarButtonItem alloc] initWithCustomView:backBtn];
  //[self.navigationItem setLeftBarButtonItem:leftButton];
  self.navigationItem.title = @"详细资料";
  
}

- (void)clickBackBtn:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self displayOnlineStatus];
  
  if (![self.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
   // self.friendInfo = (UserInfo *)[[RCIM sharedRCIM] getUserInfoCache:self.userId];
   // NSString *remarks = self.friendInfo.display_name;
    //if (remarks != nil && ![remarks isEqualToString:@""]) {
     // [self setLayoutIsHaveRemarks:YES];
   // } else {
     // [self setLayoutIsHaveRemarks:NO];
    //}
  }
    self.friendInfo = (UserInfo *)[[RCIM sharedRCIM] getUserInfoCache:self.userId];
    NSString *remarks = self.friendInfo.display_name;
    if (remarks != nil && ![remarks isEqualToString:@""]) {
        [self setLayoutIsHaveRemarks:YES];
    } else {
        [self setLayoutIsHaveRemarks:NO];
    }
}

- (void)btnConversation:(id)sender {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTabBarIndex" object:@2];
  //创建会话
  SingleChatController *chatViewController = [[SingleChatController alloc] init];
  chatViewController.conversationType = ConversationType_PRIVATE;
  
  chatViewController.targetId = self.userId;
  NSString *title;
  //if ([self.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
    //title = [RCIM sharedRCIM].currentUserInfo.name;
  //} else {
    if (self.friendInfo.display_name.length > 0) {
      title = self.friendInfo.display_name;
    } else {
      title = self.friendInfo.name;
    }
  //}
  chatViewController.title = title;
  chatViewController.needPopToRootView = YES;
  chatViewController.displayUserNameInCell = NO;
  [self.navigationController pushViewController:chatViewController animated:YES];
}

- (void)btnVoIP:(id)sender {
  //语音通话
 // [[RCCall sharedRCCall] startSingleCall:self.friendInfo.userId
                            //   mediaType:RCCallMediaAudio];
}

- (void)btnVideoCall:(id)sender {
  //视频通话
 // [[RCCall sharedRCCall] startSingleCall:self.friendInfo.userId
                           //    mediaType:RCCallMediaVideo];
}

- (void)rightBarButtonItemClicked:(id)sender {
  
  if (self.inBlackList) {
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:nil
                       otherButtonTitles:@"取消黑名单", nil];
    [actionSheet showInView:self.view];
  } else {
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:nil
                       otherButtonTitles:@"加入黑名单", nil];
    [actionSheet showInView:self.view];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)setLayout
{
  self.subViews = NSDictionaryOfVariableBindings(_ivAva,_lblName);
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:[_ivAva(65)]"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:[_ivAva(65)]"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  
  [self.view
   addConstraint:[NSLayoutConstraint
                  constraintWithItem:_ivAva
                  attribute:NSLayoutAttributeCenterY
                  relatedBy:NSLayoutRelationEqual
                  toItem:_infoView
                  attribute:NSLayoutAttributeCenterY
                  multiplier:1
                  constant:0]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_ivAva]-10-[_lblName]-10-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:self.subViews]];
}

- (void)setLayoutForFriend
{  
  //if ([[RCCallClient sharedRCCallClient] isAudioCallEnabled:ConversationType_PRIVATE]) {
  //  self.audioCallBtn.hidden = NO;
 // } else {
  //  self.audioCallBtn.hidden = YES;
 // }
  
  //if ([[RCCallClient sharedRCCallClient] isVideoCallEnabled:ConversationType_PRIVATE]) {
  //  self.videoCallBtn.hidden = NO;
 // } else {
 //   self.videoCallBtn.hidden = YES;
 // }

  
  UIView *remarksView = [[UIView alloc] init];
  remarksView.translatesAutoresizingMaskIntoConstraints = NO;
  remarksView.userInteractionEnabled = YES;
  remarksView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:remarksView];
  
  UITapGestureRecognizer *clickRemarksView = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(gotoRemarksView:)];
  [remarksView addGestureRecognizer:clickRemarksView];
  
  UILabel *remarkLabel = [[UILabel alloc] init];
  remarkLabel.font = [UIFont systemFontOfSize:16.f];
  remarkLabel.textColor = [UIColor colorWithHexString:@"000000" alpha:1.f];
  remarkLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [remarksView addSubview:remarkLabel];
  remarkLabel.text = [NSString stringWithFormat:@"电话：%@",avoidNullStr(self.friendInfo.phone)];
  
  UIImageView *rightArrow = [[UIImageView alloc] init];
  rightArrow.translatesAutoresizingMaskIntoConstraints = NO;
  rightArrow.image = [UIImage imageNamed:@"right_arrow"];
  [remarksView addSubview:rightArrow];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithImage:[UIImage imageNamed:@"config"]
                                            style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(rightBarButtonItemClicked:)];
  
  self.subViews = NSDictionaryOfVariableBindings(_infoView,_conversationBtn,remarksView,_audioCallBtn,_videoCallBtn);
  NSDictionary *remarksSubViews = NSDictionaryOfVariableBindings(remarkLabel,rightArrow);
  
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:|[_infoView(85)]"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:[_conversationBtn(43)]"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:[_audioCallBtn(43)]"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  //=======
  //                                                                      options:0
  //                                                                      metrics:nil
  //                                                                        views:self.subViews]];
  //
  //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_audioCallBtn(43)]"
  //                                                                      options:0
  //                                                                      metrics:nil
  //                                                                        views:self.subViews]];
  //>>>>>>> ReceiptDetails
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:[_videoCallBtn(43)]"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|-10-[_conversationBtn]-10-|"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|-10-[_audioCallBtn]-10-|"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|-10-[_videoCallBtn]-10-|"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  
  
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:[_infoView(85)]-15-[remarksView(43)]-15-[_conversationBtn]"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:[_conversationBtn]-15-[_audioCallBtn]-15-[_videoCallBtn]"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|[_infoView]|"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[remarksView]|"
                               options:0
                               metrics:nil
                               views:self.subViews]];

  
  [self.view
   addConstraint:[NSLayoutConstraint
                  constraintWithItem:remarksView
                  attribute:NSLayoutAttributeWidth
                  relatedBy:NSLayoutRelationEqual
                  toItem:_infoView
                  attribute:NSLayoutAttributeWidth
                  multiplier:1
                  constant:0]];
  
  [remarksView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-10-[remarkLabel]"
                               options:0
                               metrics:nil
                               views:remarksSubViews]];
  [remarksView
   addConstraint:[NSLayoutConstraint
                  constraintWithItem:remarkLabel
                  attribute:NSLayoutAttributeCenterY
                  relatedBy:NSLayoutRelationEqual
                  toItem:remarksView
                  attribute:NSLayoutAttributeCenterY
                  multiplier:1
                  constant:0]];
  
  [remarksView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:[rightArrow]-10-|"
                               options:0
                               metrics:nil
                               views:remarksSubViews]];
  
  [remarksView
   addConstraint:[NSLayoutConstraint
                  constraintWithItem:rightArrow
                  attribute:NSLayoutAttributeCenterY
                  relatedBy:NSLayoutRelationEqual
                  toItem:remarksView
                  attribute:NSLayoutAttributeCenterY
                  multiplier:1
                  constant:0]];
}

- (void)setLayoutForSelf
{
  if (self.constraintNameLabel != nil) {
    [self.infoView removeConstraints:self.constraintNameLabel];
  }
  self.videoCallBtn.hidden = YES;
  self.audioCallBtn.hidden = YES;
  self.subViews = NSDictionaryOfVariableBindings(_infoView,_conversationBtn);
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:|[_infoView(85)]"
                                                                    options:0
                             metrics:nil
                             views:self.subViews]];
  
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:[_conversationBtn(43)]"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|-10-[_conversationBtn]-10-|"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:[_infoView]-15-[_conversationBtn]"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:[_infoView(85)]-15-[_conversationBtn]"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|[_infoView]|"
                             options:0
                             metrics:nil
                             views:self.subViews]];
  
  self.constraintNameLabel =@[[NSLayoutConstraint
                               constraintWithItem:self.lblName
                               attribute:NSLayoutAttributeCenterY
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.infoView
                               attribute:NSLayoutAttributeCenterY
                               multiplier:1
                               constant:0]];
  
  [self.infoView addConstraints:[NSLayoutConstraint
                                 constraintsWithVisualFormat:@"H:[_onlineStatusLabel]-20-|"
                                 options:0
                                 metrics:nil
                                 views:NSDictionaryOfVariableBindings(_onlineStatusLabel)]];
  
  [self.infoView
   addConstraint:[NSLayoutConstraint
                  constraintWithItem:_onlineStatusLabel
                  attribute:NSLayoutAttributeCenterY
                  relatedBy:NSLayoutRelationEqual
                  toItem:self.infoView
                  attribute:NSLayoutAttributeCenterY
                  multiplier:1
                  constant:0]];
  
  self.lblName.text = [RCIM sharedRCIM].currentUserInfo.name;
  [self.infoView
   addConstraints:self.constraintNameLabel];
  [self.view setNeedsUpdateConstraints];
  [self.view updateConstraintsIfNeeded];
  [self.view layoutIfNeeded];
}
- (void)setLayoutIsHaveRemarks:(BOOL)isHaveRemarks
{
    if (self.constraintdisplayNameLabel != nil) {
        [self.infoView removeConstraints:self.constraintdisplayNameLabel];
    }
    
  if (isHaveRemarks == YES) {
    self.displayNameLabel.hidden = NO;
    self.displayNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.displayNameLabel.font = [UIFont systemFontOfSize:16.f];
    self.displayNameLabel.textColor = [UIColor colorWithHexString:@"000000" alpha:1.f];
    self.displayNameLabel.text = self.friendInfo.display_name;
    [self.infoView addSubview:self.displayNameLabel];
    
    
    self.lblName.text = [NSString stringWithFormat:@"部门: %@",self.friendInfo.department_name];
    self.lblName.textColor = [UIColor colorWithHexString:@"999999" alpha:1.f];
    self.lblName.font = [UIFont systemFontOfSize:14.f];
    
    self.phoneNumber.textColor = [UIColor colorWithHexString:@"999999" alpha:1.f];
    self.phoneNumber.font = [UIFont systemFontOfSize:14.f];
    NSString * phoneStr = self.friendInfo.phone == nil?@"--":self.friendInfo.phone;
    self.phoneNumber.text = [NSString stringWithFormat:@"手机号:%@",phoneStr];
    self.subViews = NSDictionaryOfVariableBindings(_displayNameLabel,_phoneNumber,_lblName);
    
      
      [self.infoView
       addConstraint:[NSLayoutConstraint
                      constraintWithItem:self.displayNameLabel
                      attribute:NSLayoutAttributeLeft
                      relatedBy:NSLayoutRelationEqual
                      toItem:self.lblName
                      attribute:NSLayoutAttributeLeft
                      multiplier:1
                      constant:0]];

   
      [self.infoView
       addConstraint:[NSLayoutConstraint
                      constraintWithItem:self.phoneNumber
                      attribute:NSLayoutAttributeLeft
                      relatedBy:NSLayoutRelationEqual
                      toItem:self.lblName
                      attribute:NSLayoutAttributeLeft
                      multiplier:1
                      constant:0]];

      
      self.constraintdisplayNameLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_displayNameLabel]-5-[_phoneNumber]-3-[_lblName]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_displayNameLabel,_phoneNumber,_lblName)];

      [self.infoView addConstraints:self.constraintdisplayNameLabel];

  } else {
    self.displayNameLabel.hidden = YES;
    
    self.lblName.text = self.friendInfo.name;
    self.lblName.font = [UIFont systemFontOfSize:16.f];
    self.lblName.textColor = [UIColor colorWithHexString:@"000000" alpha:1.f];
    
    NSString * phoneStr = self.friendInfo.phone == nil?@"--":self.friendInfo.phone;
    self.phoneNumber.text = [NSString stringWithFormat:@"手机号:%@",phoneStr];
    self.phoneNumber.font = [UIFont systemFontOfSize:14.f];
    self.phoneNumber.textColor = [UIColor colorWithHexString:@"999999" alpha:1.f];
    
    self.subViews = NSDictionaryOfVariableBindings(_displayNameLabel,_phoneNumber,_lblName);
      //self.subViews = NSDictionaryOfVariableBindings(_phoneNumber,_lblName);
    
      [self.infoView
       addConstraint:[NSLayoutConstraint
                      constraintWithItem:self.phoneNumber
                      attribute:NSLayoutAttributeLeft
                      relatedBy:NSLayoutRelationEqual
                      toItem:self.lblName
                      attribute:NSLayoutAttributeLeft
                      multiplier:1
                      constant:0]];

    
      
      self.constraintdisplayNameLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_lblName(16)]-8-[_phoneNumber(14)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_displayNameLabel,_phoneNumber,_lblName)];
      
      
      [self.infoView addConstraints:self.constraintdisplayNameLabel];
    
    
  }
  [self.infoView addConstraints:[NSLayoutConstraint
                                 constraintsWithVisualFormat:@"H:[_phoneNumber]-8-[_onlineStatusLabel]"
                                 options:0
                                 metrics:nil
                                 views:NSDictionaryOfVariableBindings(_phoneNumber,_onlineStatusLabel)]];
  
  [self.infoView
   addConstraint:[NSLayoutConstraint
                  constraintWithItem:_onlineStatusLabel
                  attribute:NSLayoutAttributeCenterY
                  relatedBy:NSLayoutRelationEqual
                  toItem:_phoneNumber
                  attribute:NSLayoutAttributeCenterY
                  multiplier:1
                  constant:0]];

  [self.view setNeedsUpdateConstraints];
  [self.view updateConstraintsIfNeeded];
  [self.view layoutIfNeeded];
 
}


- (void)gotoRemarksView:(id)sender
{
    NSString *string = [NSString stringWithFormat:@"tel://%@",avoidNullStr(_friendInfo.phone)];
    UIApplication *app = [UIApplication sharedApplication];
    if (IOS10_2LATER) {
        [app openURL:[NSURL URLWithString:string]options:@{} completionHandler:^(BOOL success) {
            NSLog(@"%@",@(success));
        }];
    }else{
        NSString *title = avoidNullStr(_friendInfo.phone);
        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"呼叫", nil);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"%@",cancelButtonTitle);
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *string = [NSString stringWithFormat:@"tel://%@",avoidNullStr(_friendInfo.phone)];
            UIApplication *app = [UIApplication sharedApplication];
            [app openURL:[NSURL URLWithString:string]];
            NSLog(@"%@",otherButtonTitle);
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)displayOnlineStatus {
  NSString *isDisplayOnlineStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"isDisplayOnlineStatus"];
  if ([isDisplayOnlineStatus isEqualToString:@"YES"]) {
  }
}

@end
