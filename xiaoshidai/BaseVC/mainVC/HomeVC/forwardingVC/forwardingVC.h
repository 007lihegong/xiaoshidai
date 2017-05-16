//
//  forwardingVC.h
//  xiaoshidai
//
//  Created by 名侯 on 16/10/9.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "BaseVC.h"

@interface forwardingVC : BaseVC


@property (strong, nonatomic) IBOutlet UITextView *textV;
@property (strong, nonatomic) IBOutlet UIButton *personBT;
@property (strong, nonatomic) IBOutlet UIView *backV;
@property (strong, nonatomic) IBOutlet UIButton *confirmBT;

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *ordNum;

@end
