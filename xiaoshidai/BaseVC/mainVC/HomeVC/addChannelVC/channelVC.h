//
//  channelVC.h
//  xiaoshidai
//
//  Created by 名侯 on 16/10/9.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "BaseVC.h"

@interface channelVC : BaseVC

@property (strong, nonatomic) IBOutlet UITableView *mainTV;
@property (strong, nonatomic) IBOutlet UIButton *confirmBT;

@property (nonatomic, strong) NSString *ordID;

@end
