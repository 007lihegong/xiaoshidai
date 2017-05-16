//
//  orderDetailVC.h
//  xiaoshidai
//
//  Created by 名侯 on 16/9/23.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "BaseVC.h"

@interface orderDetailVC : BaseVC


@property (strong, nonatomic) IBOutlet UIScrollView *mainSV;
@property (strong, nonatomic) IBOutlet UIView *titleV;
@property (strong, nonatomic) IBOutlet UITableView *mainOneTV;
@property (strong, nonatomic) IBOutlet UITableView *mainTV;

@property (strong, nonatomic) IBOutlet UIView *headV;

@property (strong, nonatomic) IBOutlet UIView *footuser;
@property (strong, nonatomic) IBOutlet UIView *footcarHous;
@property (strong, nonatomic) IBOutlet UIView *footletter;
@property (strong, nonatomic) IBOutlet UIView *footorder;

@property (nonatomic, strong) NSString *order_nid;//订单号
@property (strong, nonatomic) IBOutlet UIView *whyView;
@property (strong, nonatomic) IBOutlet UIView *lendingView;
@property (strong, nonatomic) IBOutlet UIView *serviceView;
@property (strong, nonatomic) IBOutlet UIButton *submitBT1;
@property (strong, nonatomic) IBOutlet UIButton *submitBT2;
@property (strong, nonatomic) IBOutlet UIButton *submitBT3;

@end
