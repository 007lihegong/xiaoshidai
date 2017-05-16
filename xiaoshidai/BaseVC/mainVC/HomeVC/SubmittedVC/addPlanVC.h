//
//  addPlanVC.h
//  xiaoshidai
//
//  Created by 名侯 on 16/9/28.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "BaseVC.h"

@interface addPlanVC : BaseVC


@property (strong, nonatomic) IBOutlet UIView *backV;
@property (strong, nonatomic) IBOutlet UIButton *determineBT;
@property (strong, nonatomic) IBOutlet UITextView *planTV;
//
@property (strong, nonatomic) IBOutlet UILabel *channelLB;
@property (strong, nonatomic) IBOutlet UILabel *timeLB;
@property (strong, nonatomic) IBOutlet UILabel *typeLB;
@property (strong, nonatomic) IBOutlet UITextField *interestLB;

@property (nonatomic,strong) void (^plan)(NSDictionary *dic,NSDictionary *param);

@end
