//
//  TagsCell.h
//  xiaoshidai
//
//  Created by XSD on 2016/12/21.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagsCell : UITableViewCell
@property (nonatomic) UILabel * companyLabel;
@property (nonatomic) UILabel * statusLabel;
@property (nonatomic) UIButton * payButton;
@property (nonatomic) UIButton * editButton;

-(void)fillCellWithArray:(NSMutableArray *)array;
@end
