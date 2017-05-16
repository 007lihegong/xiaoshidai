//
//  PayCell.h
//  xiaoshidai
//
//  Created by XSD on 2016/12/20.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayListModel.h"
@interface PayCell : UITableViewCell
@property (nonatomic,copy) void(^buttonClickBlock)(NSString * str);
-(void)fillCellWithModel:(PayData *)model;
+(instancetype)setupCellWith:(UITableView*)tableView Model:(PayData *)model;
+(CGFloat)cellHeight:(PayData *)model;
@end
