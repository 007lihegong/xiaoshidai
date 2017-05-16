//
//  GroupInfoModel.h
//  xiaoshidai
//
//  Created by XSD on 2016/11/25.
//  Copyright © 2016年 XSD. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <RongIMLib/RCGroup.h>
@class GroupInfo;
@interface GroupInfoModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSArray<GroupInfo *> *data;

@property (nonatomic, copy) NSString *msg;

@end

@interface GroupInfo : RCGroup <NSCoding>

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *group_name;

@property (nonatomic, copy) NSString *usersStr;

/** 创建者Id */
@property(nonatomic, copy) NSString *creatorId;
/** 创建日期 */
@property(nonatomic, copy) NSString *creatorTime;
/** 是否加入 */
@property(nonatomic, assign) BOOL isJoin;
/** 是否解散 */
@property(nonatomic, copy) NSString *isDismiss;


@end
