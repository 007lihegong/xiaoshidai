//
//  ChartFormCell.h
//  xiaoshidai
//
//  Created by XSD on 16/10/31.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendModel.h"
@interface ChartFormCell : UITableViewCell
@property (nonatomic) TrendModel *model;
@property (nonatomic,copy) NSString * title;
@end
