//
//  ProductCell.h
//  xiaoshidai
//
//  Created by XSD on 2016/12/2.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface ProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *carLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *agencyLimitLabel;
@property (nonatomic) ProductInfo *model;
+ (CGFloat)cellHeight:(ProductInfo *)model;
-(CGFloat)cellHeight;
@end
