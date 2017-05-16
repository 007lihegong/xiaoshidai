//
//  PictureCell.h
//  xiaoshidai
//
//  Created by XSD on 2017/1/22.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCell : UITableViewCell
@property (nonatomic) UIButton * backImageView;
@property (nonatomic) UILabel *titleLabel;
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (nonatomic,copy) void(^pidStrBlock)(NSString *pidStr,NSMutableArray *images,NSMutableArray *ids);

@end
