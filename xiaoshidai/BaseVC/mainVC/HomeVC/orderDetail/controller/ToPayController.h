//
//  ToPayController.h
//  xiaoshidai
//
//  Created by XSD on 2017/1/5.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "AllPayController.h"

@interface ToPayController : BaseVC
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray * dataArray;
@property (nonatomic,copy) NSString * pageStr;
@property (nonatomic,copy)NSString *channel_id;

-(void)request;
@end
