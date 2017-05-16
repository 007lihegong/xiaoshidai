//
//  permissionsModel.h
//  xiaoshidai
//
//  Created by 名侯 on 16/10/10.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface permissionsModel : NSObject

@property (nonatomic, assign) BOOL lim_addChannel;//新增渠道
@property (nonatomic, assign) BOOL lim_channel;//渠道操作
@property (nonatomic, assign) BOOL lim_forwarding;//订单转发
@property (nonatomic, assign) BOOL lim_reply;//回复
@property (nonatomic, assign) BOOL lim_endOrder;//结单
@property (nonatomic, assign) BOOL lim_receiveOrder;//接单
@property (nonatomic, assign) BOOL lim_stopOrder;//终止订单
@property (nonatomic, assign) BOOL lim_Submitted;//提交方案
@property (nonatomic, assign) BOOL lim_assigned;//指派订单
@property (nonatomic, assign) BOOL lim_editorOrder;//编辑订单
@property (nonatomic, assign) BOOL lim_addOrder;//新增订单
@property (nonatomic, assign) BOOL lim_undo;//撤销订单

@end
