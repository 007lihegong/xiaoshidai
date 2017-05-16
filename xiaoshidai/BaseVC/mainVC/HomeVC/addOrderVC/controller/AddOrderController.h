//
//  AddOrderController.h
//  xiaoshidai
//
//  Created by XSD on 16/9/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"
#import "BaseInfoController.h"
#import "AssetController.h"
#import "CreditInfoController.h"
#import "SCNavTabBarController.h"
#import "BaseVC.h"
@interface AddOrderController : BaseVC
@property (nonatomic) OrderDetailModel *model;
@property (nonatomic) SCNavTabBarController    *navTabBarController;
@property (nonatomic) BaseInfoController *baseInfoVC;
@property (nonatomic) AssetController *assetVC;
@property (nonatomic) CreditInfoController *creditInfoVC;
@end
