//
//  ordRelyCell.h
//  xiaoshidai
//
//  Created by 名侯 on 16/9/29.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ordDetailModel;

@interface ordRelyCell : UITableViewCell

@property (nonatomic, strong) NSArray *modelArr;
@property (nonatomic, strong) ordDetailModel *model;
@property (nonatomic, assign) NSInteger indx;
@property (nonatomic, assign) NSInteger count;

- (CGFloat)setHeaght;

@end
