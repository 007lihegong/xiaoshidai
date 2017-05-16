//
//  CreditInformationController.h
//  xiaoshidai
//
//  Created by XSD on 16/9/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"
@interface CreditInfoController : BaseVC
@property (nonatomic,strong) NSMutableDictionary *subDict;
@property (nonatomic) User_Credit_Info * model;
@property (nonatomic) OrderDetailModel * detailModel;
@property (nonatomic,strong) UITableView *tableView;
@property (assign) NSInteger  flagTag;
@end
