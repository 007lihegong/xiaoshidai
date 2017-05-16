//
//  relycellView.h
//  xiaoshidai
//
//  Created by 名侯 on 16/9/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ordDetailModel.h"

@interface relycellView : UIView

@property (nonatomic, strong) ordDetailModel *model;

- (CGFloat)setHeaght;

@end
