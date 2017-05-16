//
//  RCDMeInfoTableViewController.m
//  RCloudMessage
//
//  Created by litao on 15/11/4.
//  Copyright © 2015年 RongCloud. All rights reserved.
//

#import "RCDMeInfoTableViewController.h"
#import "DefaultPortraitView.h"
#import "MBProgressHUD.h"
#import "SingleChatController.h"
#import "UIImageView+WebCache.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDUIBarButtonItem.h"
#import "RCDBaseSettingTableViewCell.h"
#import "RCDUtilities.h"

@interface RCDMeInfoTableViewController ()

@end

@implementation RCDMeInfoTableViewController {
  NSData *data;
  UIImage *image;
  MBProgressHUD *hud;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.tableFooterView = [UIView new];
  self.tabBarController.navigationItem.rightBarButtonItem = nil;
  self.tabBarController.navigationController.navigationBar.tintColor =
      [UIColor whiteColor];
  self.tableView.backgroundColor = [UIColor colorWithHexString:@"f0f0f6" alpha:1.f];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  self.navigationItem.title = LocalizationNotNeeded(@"个人信息");
  
  RCDUIBarButtonItem *leftBtn =
  [[RCDUIBarButtonItem alloc] initContainImage:[UIImage imageNamed:@"navigator_btn_back"]
                                imageViewFrame:CGRectMake(-6, 4, 10, 17)
                                   buttonTitle:@"我"
                                    titleColor:[UIColor whiteColor]
                                    titleFrame:CGRectMake(9, 4, 85, 17)
                                   buttonFrame:CGRectMake(0, 6, 87, 23)
                                        target:self
                                        action:@selector(cilckBackBtn:)];
  self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reusableCellWithIdentifier = @"RCDBaseSettingTableViewCell";
  RCDBaseSettingTableViewCell *cell = [self.tableView
                                       dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
  if (cell == nil) {
    cell = [[RCDBaseSettingTableViewCell alloc] init];
  }
  switch (indexPath.section) {
    case 0: {
      switch (indexPath.row) {
        case 0: {
          NSString *portraitUrl = @"";

          [cell setImageView:cell.rightImageView
                    ImageStr:portraitUrl
                   imageSize:CGSizeMake(65, 65)
                 LeftOrRight:1];
          cell.rightImageCornerRadius = 5.f;
          cell.leftLabel.text = LocalizationNotNeeded(@"头像");
          return cell;
        }
          break;
          
        case 1: {
          [cell setCellStyle:DefaultStyle_RightLabel];
          cell.leftLabel.text = LocalizationNotNeeded(@"昵称");
          cell.rightLabel.text = @"";
          return cell;
        }
          break;
          
        case 2: {
          [cell setCellStyle:DefaultStyle_RightLabel_WithoutRightArrow];
          cell.leftLabel.text = LocalizationNotNeeded(@"手机号");
          cell.rightLabel.text = @"";
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          return cell;
        }
          break;
        default:
          break;
      }
    }
      break;
      
    default:
      break;
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat height = 44.f;
  switch (indexPath.section) {
    case 0:{
      switch (indexPath.row) {
        case 0:
          height = 88.f;
          break;
          
        default:
          height = 44.f;
          break;
      }
    }
      break;
      
    default:
      break;
  }
  return height;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 15.f;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 取消选中
  
  switch (indexPath.row) {
    case 0: {
      if ([self dealWithNetworkStatus]) {
        [self changePortrait];
      }
    }
      break;
      
    case 1: {
      if ([self dealWithNetworkStatus]) {

      }
    }
      break;
    default:
      break;
  }
}

- (void)changePortrait {
  UIActionSheet *actionSheet =
      [[UIActionSheet alloc] initWithTitle:nil
                                  delegate:self
                         cancelButtonTitle:@"取消"
                    destructiveButtonTitle:@"拍照"
                         otherButtonTitles:@"我的相册", nil];
  [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    didDismissWithButtonIndex:(NSInteger)buttonIndex {
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


- (UIImage *)scaleImage:(UIImage *)tempImage toScale:(float)scaleSize {
  UIGraphicsBeginImageContext(CGSizeMake(tempImage.size.width * scaleSize,
                                         tempImage.size.height * scaleSize));
  [tempImage drawInRect:CGRectMake(0, 0, tempImage.size.width * scaleSize,
                                   tempImage.size.height * scaleSize)];
  UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return scaledImage;
}

-(void)cilckBackBtn:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)dealWithNetworkStatus {
  BOOL isconnected = NO;
  RCNetworkStatus networkStatus = [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];
  if (networkStatus == 0) {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:nil
                               message:@"当前网络不可用，请检查你的网络设置"
                              delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil];
    [alert show];
    return isconnected;
  }
  return isconnected = YES;
}
@end
