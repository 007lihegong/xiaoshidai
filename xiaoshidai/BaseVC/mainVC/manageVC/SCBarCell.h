//
//  DCBarCell.h
//  UUChart
//
//  Created by 2014-763 on 15/3/13.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendModel.h"
@interface SCBarCell : UITableViewCell
@property (nonatomic) TrendModel *model;
//@property (nonatomic,copy) NSString *flag;
- (void)configUI:(NSIndexPath *)indexPath;
@end
