//
//  DecorateTableViewCell.h
//  网众
//
//  Created by WZ on 16/5/14.
//  Copyright © 2016年 lihegong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ScrollView.h"
@interface DecorateTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic)  UILabel *title;
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (strong, nonatomic)  UIView *leftline;

@property (assign, nonatomic)  CGSize cellSize;
@property (copy, nonatomic) NSMutableArray *dataArray;
@property (assign,nonatomic)NSIndexPath *indexPath;
@property (copy, nonatomic) void(^designButtonClickBlock)(NSInteger m);
@property (nonatomic,assign) NSInteger flag;
+ (CGFloat)cellHeight;
@end
