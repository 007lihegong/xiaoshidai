//
//  RCDGroupSettingsTableViewCell.h
//  RCloudMessage
//
//  Created by Jue on 16/3/22.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDBaseSettingTableViewCell.h"
#import "GroupInfoModel.h"

#define RCDGroupSettingsTableViewCellGroupNameTag 999
#define RCDGroupSettingsTableViewCellGroupPortraitTag 1000
#define SwitchButtonTag  1111

@interface RCDGroupSettingsTableViewCell : RCDBaseSettingTableViewCell
- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath andGroupInfo:(GroupInfo *)groupInfo;
@end