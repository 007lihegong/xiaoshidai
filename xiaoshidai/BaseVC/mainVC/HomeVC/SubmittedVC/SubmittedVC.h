//
//  SubmittedVC.h
//  xiaoshidai
//
//  Created by 名侯 on 16/9/28.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "BaseVC.h"

@interface SubmittedVC : BaseVC

@property (strong, nonatomic) IBOutlet UITableView *mainTV;
@property (strong, nonatomic) IBOutlet UIView *toolV;
@property (strong, nonatomic) IBOutlet UIButton *sendBT;
@property (strong, nonatomic) IBOutlet UIView *headV;
@property (strong, nonatomic) IBOutlet UIView *addBackV;

@property (nonatomic, strong) NSString *ordNum;

@end
