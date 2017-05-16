//
//  RCDCreateGroupViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/3/21.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "DefaultPortraitView.h"
#import "MBProgressHUD.h"
#import "RCDGroupMemberCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import "SingleChatController.h"
#import "GroupInfoModel.h"

// 是否iPhone5
#define isiPhone5                                                              \
  ([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
       ? CGSizeEqualToSize(CGSizeMake(640, 1136),                              \
                           [[UIScreen mainScreen] currentMode].size)           \
       : NO)
// 是否iPhone4
#define isiPhone4                                                              \
  ([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
       ? CGSizeEqualToSize(CGSizeMake(640, 960),                               \
                           [[UIScreen mainScreen] currentMode].size)           \
       : NO)

#define RCScreenWidth [UIScreen mainScreen].bounds.size.width

@interface CreateGroupViewController () {
  NSData *data;
  UIImage *image;
  //    NSMutableArray *memberIdsList;
  MBProgressHUD *hud;
  CGFloat deafultY;
}
@property (nonatomic,strong) UIView *blueLine;
@end

@implementation CreateGroupViewController

+ (instancetype)createGroupViewController {
    return [[[self class] alloc] init];
}

- (instancetype)init {
    self= [super init];
    if(self){
        self.view.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.DoneBtn.hidden = YES;
    
    //群组头像的UIImageView
    CGFloat groupPortraitWidth = 100;
    CGFloat groupPortraitHeight = groupPortraitWidth;
    CGFloat groupPortraitX = RCScreenWidth/2.0-groupPortraitWidth/2.0;
    CGFloat groupPortraitY = 80;
    self.GroupPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(groupPortraitX, groupPortraitY, groupPortraitWidth, groupPortraitHeight)];
    self.GroupPortrait.image = [UIImage imageNamed:@"AddPhotoDefault"];
    self.GroupPortrait.layer.masksToBounds = YES;
    self.GroupPortrait.layer.cornerRadius = 5.f;
    //为头像设置点击事件
    self.GroupPortrait.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleClick =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(chosePortrait)];
    [self.GroupPortrait addGestureRecognizer:singleClick];
    
    //群组名称的UITextField
    CGFloat groupNameWidth = 200;
    CGFloat groupNameHeight = 17;
    CGFloat groupNameX = RCScreenWidth/2.0-groupNameWidth/2.0;
    CGFloat groupNameY = CGRectGetMaxY(self.GroupPortrait.frame)+90;
    self.GroupName = [[UITextField alloc]initWithFrame:CGRectMake(groupNameX, groupNameY, groupNameWidth, groupNameHeight)];
    self.GroupName.font = [UIFont systemFontOfSize:14];
    self.GroupName.placeholder = @"填写群名称（2-10个字符）";
    self.GroupName.textAlignment = NSTextAlignmentCenter;
    self.GroupName.delegate = self;
    self.GroupName.returnKeyType = UIReturnKeyDone;
    
    
    //底部蓝线
    CGFloat blueLineWidth = 240;
    CGFloat blueLineHeight = 1;
    CGFloat blueLineX = RCScreenWidth/2.0-blueLineWidth/2.0;
    CGFloat blueLineY = CGRectGetMaxY(self.GroupName.frame)+1;
    self.blueLine = [[UIView alloc]initWithFrame:CGRectMake(blueLineX, blueLineY, blueLineWidth, blueLineHeight)];
    self.blueLine.backgroundColor = RGBColor(0, 135, 251);
    
    [self.view addSubview:self.GroupPortrait];
    [self.view addSubview:self.GroupName];
    [self.view addSubview:self.blueLine];
    
    //给整个view添加手势，隐藏键盘
   // UITapGestureRecognizer *resetBottomTapGesture =
   // [[UITapGestureRecognizer alloc] initWithTarget:self
                                           // action:@selector(hideKeyboard:)];
    //[self.view addGestureRecognizer:resetBottomTapGesture];
    
    //创建rightBarButtonItem
    UIBarButtonItem *item =
    [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(ClickDoneBtn:)];
    item.tintColor = [RCIM sharedRCIM].globalNavigationBarTintColor;
    self.navigationItem.rightBarButtonItem = item;
    
    CGFloat navHeight = 44.0f;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    deafultY = navHeight + statusBarHeight;

}

- (void)viewDidLoad {
  [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//  if (isiPhone5) {
//    [self moveView:-40];
//  }
//  if (isiPhone4) {
//    [self moveView:-80];
//  }
  return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([self isContainsTwoEmoji:string]) {
        [textField resignFirstResponder];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
        hud.labelText = @"包含非法字符";
        [hud show:YES];
        [hud hide:YES afterDelay:1.0];
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)isContainsTwoEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         //         NSLog(@"hs++++++++%04x",hs);
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     isEomji = YES;
                 }
                 //                 NSLog(@"uc++++++++%04x",uc);
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3|| ls ==0xfe0f) {
                 isEomji = YES;
             }
             //             NSLog(@"ls++++++++%04x",ls);
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
         
     }];
    return isEomji;
}
- (IBAction)ClickDoneBtn:(id)sender {
  self.navigationItem.rightBarButtonItem.enabled = NO;
  //[self moveView:deafultY];
  [_GroupName resignFirstResponder];

  NSString *nameStr = [self.GroupName.text copy];
  nameStr = [nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

  //群组名称需要大于2位
  if ([nameStr length] == 0) {
    [self Alert:@"群组名称不能为空"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
  }
  //群组名称需要大于2个字
  else if ([nameStr length] < 2) {
    [self Alert:@"群组名称过短"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
  }
  //群组名称需要小于10个字
  else if ([nameStr length] > 10) {
    [self Alert:@"群组名称不能超过10个字"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
  } else {
      self.navigationItem.rightBarButtonItem.enabled = YES;
    BOOL isAddedcurrentUserID = false;
    for (NSString *userId in _GroupMemberIdList) {
      if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        isAddedcurrentUserID = YES;
      } else {
        isAddedcurrentUserID = NO;
      }
    }
    if (isAddedcurrentUserID == NO) {
      [_GroupMemberIdList addObject:[RCIM sharedRCIM].currentUserInfo.userId];
    }

      hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
      hud.labelText = @"创建中...";
      [hud show:YES];
      [self createGroupWithNameStr:nameStr complete:^(NSString * groupId) {
          NSLog(@"新建群组的id:%@ \n description:%@",groupId,[[[RCIM sharedRCIM] getGroupInfoCache:groupId] mj_JSONString]);
      }];
  }
}

-(void)createGroupWithNameStr:(NSString *)nameStr complete:(void (^)(NSString *))groupId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *memeberStr = [_GroupMemberIdList componentsJoinedByString:@","];
    
    [param setObject:[BaseRequest setRSAencryptString:nameStr] forKey:@"group_name"];
    [param setObject:[BaseRequest setRSAencryptString:memeberStr] forKey:@"group_member"];
    NSArray *tokenArr = @[@{@"price":@"group_name",@"vaule":[NSString stringWithFormat:@"group_name%@",nameStr]},
                          @{@"price":@"group_member",@"vaule":[NSString stringWithFormat:@"group_member%@",memeberStr]}];
    
    [param setObject:[BaseRequest setUserTokenStr:tokenArr] forKey:@"token"];
    [BaseRequest post:CREATGROUP parameters:param success:^(id dict) {
        if ([dict[@"code"] isEqualToString:@"0"] ) {
            [hud hide:YES];
            [LCProgressHUD showSuccess:@"创建成功"];
            NSString * idString = dict[@"data"][@"group_id"];
            NSString * nameString = dict[@"data"][@"group_name"];
            GroupInfo * groupInfo = [[GroupInfo alloc] init];
            groupInfo.groupId = groupInfo.group_id = idString;
            groupInfo.groupName = groupInfo.group_name = nameString;
            [[RCIM sharedRCIM] refreshGroupInfoCache:groupInfo withGroupId:idString];
            groupId(idString);
            NSLog(@"%@",[dict mj_JSONString]);
            [self gotoChatView:groupInfo.groupId groupName:groupInfo.groupName];
        }else{
            NSString *msg = dict[@"info"];
            [hud hide:YES];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
            NSLog(@"%@",msg);
        }
    } failure:^(NSError * error) {
        [hud hide:YES afterDelay:1.0];
        [Window makeToast:[error description] duration:1.0 position:CenterPoint];
    }];
    [hud hide:YES afterDelay:1.0];
}

- (void)gotoChatView:(NSString *)groupId groupName:(NSString *)groupName{
  SingleChatController *chatVC = [[SingleChatController alloc] init];
  chatVC.needPopToRootView = YES;
  chatVC.targetId = groupId;
  chatVC.conversationType = ConversationType_GROUP;
  chatVC.navigationItem.title = groupName;
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.navigationController pushViewController:chatVC animated:YES];
  });
}

- (void)Alert:(NSString *)alertContent {

    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message: alertContent preferredStyle:(UIAlertControllerStyleAlert)];
    NSString *cancleStr = @"确定";
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancleStr style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)chosePortrait {
  //[self moveView:deafultY];
  [_GroupName resignFirstResponder];
  //UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消"
                 //   destructiveButtonTitle:@"拍照" otherButtonTitles:@"我的相册", nil];
  //[actionSheet showInView:self.view];
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

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [UIApplication sharedApplication].statusBarHidden = NO;

  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

  if ([mediaType isEqual:@"public.image"]) {
    UIImage *originImage =
        [info objectForKey:UIImagePickerControllerOriginalImage];

    UIImage *scaleImage = [self scaleImage:originImage toScale:0.8];

    //        if (UIImagePNGRepresentation(scaleImage) == nil)
    //        {
    //            data = UIImageJPEGRepresentation(scaleImage, 0.00001);
    //        }
    //        else
    //        {
    //            data = UIImagePNGRepresentation(scaleImage);
    //        }
    data = UIImageJPEGRepresentation(scaleImage, 0.00001);
  }

  image = [UIImage imageWithData:data];
  [self dismissViewControllerAnimated:YES completion:nil];
  dispatch_async(dispatch_get_main_queue(), ^{
    self.GroupPortrait.image = image;
  });
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [_GroupName resignFirstResponder];
  //[self moveView:deafultY];
  return YES;
}

- (void)hideKeyboard:(id)sender {
  //[self moveView:deafultY];
  [_GroupName resignFirstResponder];
}

//移动屏幕
//- (void)moveView:(CGFloat)Y {

  //[UIView beginAnimations:nil context:nil];
 // self.view.frame =
   //   CGRectMake(0, Y, self.view.frame.size.width, self.view.frame.size.height);
  //[UIView commitAnimations];
//}

- (NSString *)createDefaultPortrait:(NSString *)groupId
                          GroupName:(NSString *)groupName {
  DefaultPortraitView *defaultPortrait =
      [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
  [defaultPortrait setColorAndLabel:groupId Nickname:groupName];
  UIImage *portrait = [defaultPortrait imageFromView];

  NSString *filePath = [self
      getIconCachePath:[NSString stringWithFormat:@"group%@.png", groupId]];

  BOOL result =
      [UIImagePNGRepresentation(portrait) writeToFile:filePath atomically:YES];
  if (result == YES) {
    NSURL *portraitPath = [NSURL fileURLWithPath:filePath];
    return [portraitPath absoluteString];
  }
  return nil;
}

- (NSString *)getIconCachePath:(NSString *)fileName {
  NSString *cachPath = [NSSearchPathForDirectoriesInDomains(
      NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  NSString *filePath =
      [cachPath stringByAppendingPathComponent:
                    [NSString stringWithFormat:@"CachedIcons/%@",
                                               fileName]]; // 保存文件的名称

  NSString *dirPath = [cachPath
      stringByAppendingPathComponent:[NSString
                                         stringWithFormat:@"CachedIcons"]];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:dirPath]) {
    [fileManager createDirectoryAtPath:dirPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
  }
  return filePath;
}
@end
