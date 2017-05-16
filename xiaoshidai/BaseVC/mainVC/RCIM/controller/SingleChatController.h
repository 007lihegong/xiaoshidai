//
//  SingleChatController.h
//  xiaoshidai
//
//  Created by XSD on 16/11/10.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface SingleChatController : RCConversationViewController
@property(strong, nonatomic) RCConversationModel *conversation;
@property BOOL needPopToRootView;
@end
