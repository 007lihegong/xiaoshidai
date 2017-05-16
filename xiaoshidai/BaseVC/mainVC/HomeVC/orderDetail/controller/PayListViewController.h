//
//  PayListViewController.h
//  xiaoshidai
//
//  Created by XSD on 2016/12/20.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "BaseVC.h"
#import "SCNavTabBarController.h"
@interface PayListViewController : BaseVC
@property (nonatomic) SCNavTabBarController    *navTabBarController;
@property (nonatomic,copy)NSString *channel_id;
@end
