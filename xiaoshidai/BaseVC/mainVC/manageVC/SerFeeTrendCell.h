//
//  SerFeeTrendCell.h
//  xiaoshidai
//
//  Created by XSD on 16/10/30.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendModel.h"

@interface SerFeeTrendCell : UITableViewCell
@property (nonatomic) TrendModel *model;
- (void)configUI:(NSIndexPath *)indexPath;
@end
