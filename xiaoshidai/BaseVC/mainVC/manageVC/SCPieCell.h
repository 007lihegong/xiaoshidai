//
//  SCPieCell.h
//  SCChart
//
//  Created by 2014-763 on 15/3/24.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendModel.h"
@interface SCPieCell : UITableViewCell
@property (nonatomic) TrendModel *model;
- (void)configUI:(NSIndexPath *)indexPath;
@end
