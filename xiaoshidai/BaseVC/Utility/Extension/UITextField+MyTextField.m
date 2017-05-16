//
//  UITextField+MyTextField.m
//  网众
//
//  Created by WZ on 16/1/5.
//  Copyright © 2016年 ZM. All rights reserved.
//

#import "UITextField+MyTextField.h"

@implementation MyTextField
//改变文字位置
-(CGRect) textRectForBounds:(CGRect)bounds{
    CGRect iconRect=[super textRectForBounds:bounds];
    iconRect.origin.x+=5;
    iconRect.size.width -= 28;
    ///return CGRectInset(bounds, 30, 0);

    return iconRect;
}
//改变编辑时文字位置
-(CGRect) editingRectForBounds:(CGRect)bounds{
    CGRect iconRect=[super editingRectForBounds:bounds];
    iconRect.origin.x+=5;
    iconRect.size.width -= 28;
    return iconRect;
    //return CGRectInset(bounds, 30, 0);
}
//-(CGRect)placeholderRectForBounds:(CGRect)bounds{
//    CGRect iconRect=[super placeholderRectForBounds:bounds];
//    iconRect.origin.x+=5;
//    iconRect.size.width -= 28;
//    return iconRect;
//}

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 15; //像右边偏15
    return iconRect;
}
-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    iconRect.origin.x -=15; //像右边偏15
    return iconRect;
}
@end
