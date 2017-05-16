//
//  imgLayoutvView.h
//  xiaoshidai
//
//  Created by 名侯 on 16/10/10.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imgLayoutvView : UIView

@property (nonatomic, strong) NSMutableArray *picPathStringsArray;
@property(nonatomic,assign) NSInteger flag;
@property (nonatomic,copy) void(^deleId)(id obj);
@property (nonatomic,copy) void(^presentAlert)(id obj);
@end
