//
//  BaseInfoController.h
//  xiaoshidai
//
//  Created by XSD on 16/9/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"
@interface BaseInfoController : BaseVC
@property (nonatomic,strong) NSMutableDictionary *subDict;
@property (nonatomic) User_Base_Info * model;
@property (nonatomic) OrderDetailModel * detailModel;
@property (assign) NSInteger flag ;
@property (assign) BOOL isJump ;

@property (nonatomic,strong) UIButton *nextButton;
-(void)next:(UIButton *)button;
@end
