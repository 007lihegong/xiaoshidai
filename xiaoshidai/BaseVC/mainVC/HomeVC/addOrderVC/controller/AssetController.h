//
//  AssetController.h
//  xiaoshidai
//
//  Created by XSD on 16/9/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"
@interface AssetController : BaseVC
@property (nonatomic,strong) NSMutableDictionary *subDict;
@property (nonatomic) User_Assets_Info * model;
@property (nonatomic) OrderDetailModel * detailModel;
@property (nonatomic,strong) UIButton *nextButton;
@property (assign) BOOL isJump ;
-(void)next:(UIButton *)button;
@end
