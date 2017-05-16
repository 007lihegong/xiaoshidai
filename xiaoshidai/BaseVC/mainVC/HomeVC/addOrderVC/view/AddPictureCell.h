//
//  AddPictureCell.h
//  xiaoshidai
//
//  Created by XSD on 2016/12/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPictureCell : UITableViewCell 
@property (assign) NSInteger flag;
@property (nonatomic) NSMutableArray *imgArr;
@property (nonatomic ,strong) UILabel *titleLabel;               //标题框
@property (nonatomic ,strong) NSIndexPath *indexPath;
@property (nonatomic ,copy)   NSString *title;                     //标题文字
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (nonatomic,copy) void(^pidStrBlock)(NSString *pidStr,NSMutableArray *images,NSMutableArray *ids);
+(CGFloat)cellHeightWith:(NSMutableArray *)arr;
@end
