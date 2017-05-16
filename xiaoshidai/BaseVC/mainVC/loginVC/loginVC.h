//
//  loginVC.h
//  xiaoshidai
//
//  Created by 名侯 on 16/9/22.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "BaseVC.h"

@interface loginVC : BaseVC

@property (strong, nonatomic) IBOutlet UIView *backV2;
@property (strong, nonatomic) IBOutlet UIView *backV1;
@property (strong, nonatomic) IBOutlet UIButton *loginBT;
@property (strong, nonatomic) IBOutlet UIImageView *loginImg;
@property (strong, nonatomic) IBOutlet UITextField *userTF;
@property (strong, nonatomic) IBOutlet UITextField *passTF;
@property (strong, nonatomic) IBOutlet UIButton *historyBT;
@property (strong, nonatomic) IBOutlet UIButton *qiehuanBT;
//@property (nonatomic, strong) NSString *order_nid;//订单号
@end
