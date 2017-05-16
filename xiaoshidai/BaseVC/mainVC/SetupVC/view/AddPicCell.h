//
//  AddPicCell.h
//  xiaoshidai
//
//  Created by XSD on 2017/1/3.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealNameInfoModel.h"

@interface AddPicCell : UITableViewCell
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITextField *textField;
@property (nonatomic) UIButton * frontImageView;
@property (nonatomic) UIButton * backImageView;
@property (nonatomic) RealNameInfoModel *model;
@end
