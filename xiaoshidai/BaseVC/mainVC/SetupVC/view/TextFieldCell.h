//
//  TextFieldCell.h
//  xiaoshidai
//
//  Created by XSD on 2016/12/29.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealNameInfoModel.h"
@interface TextFieldCell : UITableViewCell
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITextField *textField;
@property (nonatomic) UIImageView * frontImageView;
@property (nonatomic) UIImageView * backImageView;
@property (nonatomic) RealNameInfoModel *model;
@property (nonatomic,copy) NSString * title;
@property (copy, nonatomic) void(^block)(NSString *);
@end
