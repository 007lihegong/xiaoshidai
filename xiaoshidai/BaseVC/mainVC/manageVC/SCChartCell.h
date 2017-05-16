//
//  TableViewCell.h
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendModel.h"
@interface SCChartCell : UITableViewCell
@property (nonatomic) TrendModel *model;
- (void)configUI:(NSIndexPath *)indexPath;

@end
